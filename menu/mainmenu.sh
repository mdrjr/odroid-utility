#!/bin/bash

while true; do

	menu_items[0]="1"; menu_items[1]="HDMI Configuration"
	menu_items[2]="2"; menu_items[3]="Update your Kernel/Firmware"
	menu_items[4]="3"; menu_items[5]="Install/Update XBMC (Ubuntu Only)"
	menu_items[6]="4"; menu_items[7]="Resize your root partition"
	menu_items[8]="5"; menu_items[9]="Xorg On/Off"
	menu_items[10]="6"; menu_items[11]="Rebuild Xorg DDX (fixes ABI errors)"
	menu_items[12]="7"; menu_items[13]="Change Hostname"
	menu_items[18]="10"; menu_items[19]="Pulse Audio Control (on/off)"
	
	if [ "$BOARD" = "odroidc" ]; then
		# LIRC Menu
		menu_items[14]="8"; menu_items[15]="Install LIRC"
		# HDMI Passthru Configuration
		menu_items[16]="9"; menu_items[17]="HDMI Passthrough (On/Off)"
	fi
	
	
	CC=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Main Menu" 0 0 1 --cancel-button "Exit" --ok-button "Select" \
		"${menu_items[@]}" \
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
		"8") lirc_setup ;;
		"9") odroidc1_hdmipass ;;
		"10") pulseaudio_control_onoff ;;
		*) msgbox "Error 001. Please report on the forums" && exit 0 ;;
		esac || msgbox "I don't know how you got here! >> $CC <<  Report on the forums"
		
		
	fi
done
