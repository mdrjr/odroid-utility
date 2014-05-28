#!/bin/bash

setup_hdmi() {
	HM=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "HDMI Configuration" 0 0 0 \
	"1" "Automatic Configuration" \
	"2" "1920x1080 (1080P) Using your monitor timings (EDID)" \
	"3" "1920x1080 (1080P) Using generic timings (NO-EDID)" \
	"4" "1280x720 (720P) Using your monitor timings (EDID)" \
	"5" "1280x720 (720P) Using generic timings (NO-EDID)" \
	"6" "1024x768 Using generic timings (NO-EDID) (Failsafe)" \
	3>&1 1>&2 2>&3)
	
	HR=$?
	
	if [ $HR -eq 1 ]; then
		return 0
	else
		do_change_hdmi $HM
	fi
}

do_change_hdmi() {
	if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "ubuntu-server" ]; then
		BASE=/media/boot
	elif [ "$DISTRO" = "debian" ]; then
		BASE=/boot
	else
		msgbox "HDMI: Your distro $DISTRO isn't supported yet. Please report on the forums"
		return 0
	fi
	
	case "$1" in 
		"1") cp $BASE/boot-auto_edid.scr $BASE/boot.scr ;;
		"2") cp $BASE/boot-1080p-edid.scr $BASE/boot.scr ;;
		"3") cp $BASE/boot-1080p-noedid.scr $BASE/boot.scr ;;
		"4") cp $BASE/boot-720p-edid.scr $BASE/boot.scr ;;
		"5") cp $BASE/boot-720p-noedid.scr $BASE/boot.scr ;;
		"6") cp $BASE/boot-1024x768-noedid.scr $BASE/boot.scr ;;

		*) msgbox "HDMI: Error. You shouldn't be here. Report on the forums. Error HDMI-$1" ;;
	esac
			
	msgbox "HDMI Configuration changed. Please reboot"
	REBOOT=1
		
}
