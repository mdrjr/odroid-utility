#!/bin/bash

internationalization_menu() {

	while true; do
		IO=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Internationalization/Configuration" 0 0 0 --cancel-button "Back" --ok-button "Select"\
		"1" "Change locale" \
		"2" "Change timezone" \
		"3" "Change keyboard layout" \
		3>&1 1>&2 2>&3)

		IR=$?

		if [ $IR -eq 1 ]; then
			return 0
		else
			case "$IO" in 
				"1") change_locale ;;
				"2") change_timezone ;;
				"3") configure_keyboard ;;
				*) msgbox "Internationalization: Error. You shouldn't be here. Value $IO please report this on the forums" ;;
			esac
		fi

	done
}