#!/bin/bash


pulseaudio_control_onoff() {
	CC=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Pulse Audio control (On/Off)" 0 0 1 --cancel-button "Back" --ok-button "Select" \
		"1" "Enable Pulseaudio (default)" \
		"2" "Disable Pulseaudio" \
		3>&1 1>&2 2>&3)

	ret=$?
	
	if [ $ret -eq 1 ]; then
		return 0
	elif [ $ret -eq 0 ]; then
		case "$CC" in
			1)
				enable_pulse
				;;
			2)
				disable_pulse
				;;
			*) ;;
		esac
	fi
	
}

enable_pulse() {
	mv $HOME/pulse.conf $HOME/.config/pulse/client.conf
	/usr/bin/pulseaudio --start --log-target=syslog
	msgbox "Pulseaudio is now enabled"
}

disable_pulse() {
	mv $HOME/.config/pulse/client.conf $HOME/pulse.conf
	echo "autospawn = no" > $HOME/.config/pulse/client.conf
	pactl exit
	msgbox "Pulseaudio is now disabled"
}

