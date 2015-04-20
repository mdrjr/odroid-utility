#!/bin/bash


xorg_config() {
	CC=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Xorg Config" 0 0 1 --cancel-button "Exit" --ok-button "Select" \
		"1" "Enable Xorg" \
		"2" "Disable Xorg" \
		3>&1 1>&2 2>&3)

	ret=$?

	if [ $ret -eq 1 ]; then
		return 0
	elif [ $ret -eq 0 ]; then
		case "$CC" in
			1)
				enable_xorg_at_boot
				REBOOT=1
				;;
			2)
				disable_xorg_at_boot
				REBOOT=1
				;;
			*) ;;
		esac
	fi

}

enable_xorg_at_boot() {

	if [ "$DISTRO" = "ubuntu" ]; then
		rm -fr /etc/init/lightdm.override
	elif [ "$DISTRO" = "debian" ]; then
		update-rc.d lightdm enable 2 3 4 5
	else

		xorg_err_not_supportted

	fi
}

disable_xorg_at_boot() {

	if [ "$DISTRO" = "ubuntu" ]; then
		echo "manual" > /etc/init/lightdm.override
	elif [ "$DISTRO" = "debian" ]; then
		update-rc.d lightdm disable 2 3 4 5
	else

		xorg_err_not_supportted

	fi
}


xorg_err_not_supportted() {
	whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --msgbox "XORG: Your distro isn't supportted. Report this on the forums" 0 0 0
}
