#!/bin/bash

setup_hdmi() {

	get_board
	
	if [ "$BOARD" = "odroidc" ]; then
		do_odroidc_hdmi
		return 0
	fi

	if [ "$BOARD" = "odroidxu" ] || [ "$BOARD" = "odroidxu3" ]; then
		msgbox "For ODROID-XU and ODROID-XU3 please check the /media/boot/boot.ini file instead. There are instructions there"
		return 0
	fi

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

do_odroidc_hdmi() {
	# Defines
	export oIFS="$IFS"
	export IFS="/"
	export R_VALUE=()
	export R_NAME=()
	export COUNT=0

	# Read boot.ini to get the current selected resolution
	# Also populate the array with the valid options found on the boot.ini
	while read line; do

		if [[ $line =~ "setenv m \"" ]]; then
		
			if [[ ${line:0:1} == "s" ]]; then
				export selected=`echo $line | awk '{print $3}' | sed s/"\""//g`
			fi

			lt=`echo $line | sed s/"# "//g | sed s/"setenv m "//g | awk '{print $1}' | sed s/"\""//g`
			la=`echo $line | sed s/"# "//g | sed s/"setenv m "//g | awk '{$1=""; print $0}'`

			R_VALUE[$COUNT]=$lt
			R_NAME[$COUNT]=$la
		
			((COUNT++))
		fi
	done < /media/boot/boot.ini

	# Create the variable that we'll pass over to whiptail
	for ((C=0; C<$COUNT; C++)); do
		export HDMI_MENU+="${R_VALUE[$C]}/${R_NAME[$C]}/"
	done

	# Call whiptail
	NR=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "HDMI Configuration" 0 0 0 --default-item $selected $HDMI_MENU 3>&1 1>&2 2>&3)

	# Sanity check, just to make sure that the user selected something
	RT=$?
	if [ $RT -eq 1 ]; then 
		return
	fi

	# Same as before? Stop here
	if [ "$NR" == "$selected" ]; then
		msgbox "You didn't changed the resolution. Keeping $selected"
		return
	fi

	# First Pass, disable all setenv's
	while read line; do
		if [[ $line =~ "setenv m \"" ]]; then
			if [[ ${line:0:1} == "s" ]]; then
				nl=`echo $line | sed s/"setenv m"/"# setenv m"/g`
				line=$nl
			fi
		fi
		echo $line >> /tmp/tmp1.ini
	done < /media/boot/boot.ini

	# Second pass, enable just the selected resolution :) 
	while read line; do
		if [[ $line =~ "setenv m \"" ]]; then
			p=`echo $line | awk '{print $4}' | sed s/\"//g`
			if [ "$p" == "$NR" ]; then
				nl=`echo $line | sed s/"# setenv m"/"setenv m"/g`
				echo "NL: $nl  -> P: $p  -> NR: $NR"
				line=$nl
			fi
		fi
		echo $line >> /tmp/new.ini
	done < /tmp/tmp1.ini

	# Copy the new boot.ini
	mv /tmp/new.ini /media/boot/boot.ini
	rm -fr /tmp/tmp1.ini
	sync
	
	msgbox "Changed screen resolution from $selected to $NR. Please reboot"
	
	# For the sake of sanity
	export HDMI_MENU=""; export p=""; export NR=""; export COUNT=""; export selected=""; export R_VALUE=""; export R_NAME=""
	
	REBOOT=1
}
