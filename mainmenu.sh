#!/bin/bash

while true; do

	CC=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Main Menu" 0 0 1 --cancel-button "Exit" --ok-button "Select" \
		"1" "HDMI Configuration" \
		"2" "Update your Kernel/Firmware" \
		"3" "Install/Update XBMC (Ubuntu Only)" \
		"4" "Resize your root partition" \
		"5" "Xorg On/Off" \
		"6" "Rebuild Xorg armsoc DDX (fixes ABI errors) "\
		"7" "Change Hostname" \
		3>&1 1>&2 2>&3)
	
	RET=$?
	
	if [ $RET -eq 1 ]; then
		do_exit
	elif [ $RET -eq 0 ]; then
		case "$CC" in
		"1") setup_hdmi ;;
		"2") kernel_update ;;
		"3") xbmc_setup ;;
		"4") fs_resize ;;
		"5") xorg_config ;;
		"6") rebuild_armsoc  ;;
		"7") change_hostname ;;
		*) msgbox "Error 001. Please report on the forums" && exit 0 ;;
		esac || msgbox "I don't know how you got here! >> $CC <<  Report on the forums"
		exit 0
		
	fi
done
