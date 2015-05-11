#!/bin/bash

desktop_environment_menu() {
	msgbox "Changing your desktop environment can be dangerous. Be careful!"

	while true; do
		DEO=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Desktop Environment/Configuration" 0 0 1 --cancel-button "Back" --ok-button "Select"\
		"1" "Install KDE" \
		"2" "Install XFCE" \
		"3" "Install LXDE" \
		"4" "Fully remove KDE" \
		"5" "Fully remove XFCE" \
		"6" "Fully remove LXDE" \
		3>&1 1>&2 2>&3)

		DER=$?

		if [ $DER -eq 1 ]; then
			return 0
		else
			case "$DEO" in 
				"1") install_kde ;;
				"2") install_xfce ;;
				"3") install_lxde ;;
				"4") remove_kde ;;
				"5") remove_xfce ;;
				"6") remove_lxde ;;
				*) msgbox "Desktop Environment: Error. You shouldn't be here. Value $DEO please report this on the forums" ;;
			esac
		fi
		msgbox "Logout and change the desktop environment in login manager."

	done
}

install_kde() {
	apt-get update -y
	apt-get install -y kubuntu-desktop
}

install_xfce() {
	apt-get update -y
	apt-get install -y xubuntu-desktop
}

install_lxde() {
	apt-get update -y
	apt-get install -y lubuntu-desktop
}

remove_kde() {
	apt-get autoremove -y --purge kubuntu-desktop
}

remove_xfce() {
	apt-get autoremove -y --purge xubuntu-desktop
}

remove_lxde() {
	apt-get autoremove -y --purge lxde
	apt-get autoremove -y --purge lubuntu-desktop
}