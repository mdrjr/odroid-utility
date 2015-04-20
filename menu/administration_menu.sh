#!/bin/bash

administration_menu() {
	
	while true; do
		AO=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Administration/Configuration" 0 0 1 --cancel-button "Back" --ok-button "Select"\
		"1" "Change hostname" \
		"2" "Change password" \
		"3" "Resize root partition" \
		"4" "Xorg on/off" \
		"5" "Rebuild Xorg DDX (fixes ABI errors)" \
		"6" "Kernel Update" \
		"7" "Internationalization" \
		"8" "Desktop Environments" \
		3>&1 1>&2 2>&3)
	
		AR=$?
	
		if [ $AR -eq 1 ]; then
			return 0
		else
			case "$AO" in 
				"1") change_hostname ;;
				"2") change_password ;;
				"3") fs_resize ;;
				"4") xorg_config ;;
				"5") rebuild_armsoc ;;
				"6") kernel_update ;;
				"7") internationalization_menu ;;
				"8") desktop_environment_menu ;;
				*) msgbox "Administration: Error. You shouldn't be here. Value $AO please report this on the forums" ;;
			esac
		fi
	
	done
}
