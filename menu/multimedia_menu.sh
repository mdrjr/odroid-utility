#!/bin/bash

multimedia_menu() {

	while true; do
	menu_items[0]="1"; menu_items[1]="HDMI Configuration"
	menu_items[2]="2"; menu_items[3]="Install/Update XBMC (Ubuntu Only)"
	menu_items[4]="3"; menu_items[5]="Pulse Audio Control (on/off)"

	if [ "$BOARD" = "odroidc" ]; then
		# LIRC Menu
		menu_items[6]="4"; menu_items[7]="Install LIRC"
		# HDMI Passthru Configuration
		menu_items[8]="5"; menu_items[9]="HDMI Passthrough (On/Off)"
	fi
		IO=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Multimedia/Configuration" 0 0 0 --cancel-button "Back" --ok-button "Select"\
		"${menu_items[@]}" \
		3>&1 1>&2 2>&3)

		IR=$?

		if [ $IR -eq 1 ]; then
			return 0
		else
			case "$IO" in 
				"1") setup_hdmi ;;
				"2") xbmc_setup ;;
				"3") pulseaudio_control_onoff ;;
				"4") lirc_setup ;;
				"5") odroidc1_hdmipass ;;
				*) msgbox "Multimedia: Error. You shouldn't be here. Value $IO please report this on the forums" ;;
			esac
		fi

	done
}
