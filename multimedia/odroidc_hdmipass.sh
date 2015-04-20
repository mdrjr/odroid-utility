#!/bin/bash


odroidc1_hdmipass() {
	CC=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "ODROID-C1 HDMI Passthrough" 0 0 1 --cancel-button "Exit" --ok-button "Select" \
		"1" "Enable Passthrough (Cause issues on USB Audio) (Only enable it if you use it)" \
		"2" "Disable Passthrough" \
		3>&1 1>&2 2>&3)

	ret=$?

	if [ $ret -eq 1 ]; then
		return 0
	elif [ $ret -eq 0 ]; then
		case "$CC" in
			1)
				enable_c1_pass
				REBOOT=1
				;;
			2)
				disable_c1_pass
				REBOOT=1
				;;
			*) ;;
		esac
	fi

}

enable_c1_pass() {
	cat > /etc/asound.conf << __EOF__
pcm.!default {
       type hw
        card 0
        device 1
        format S16_LE
}

ctl.!default {
        type hw
        card 0
}
__EOF__

	msgbox "HDMI Audio Passthrough is now enabled. Please reboot to take effect"
}

disable_c1_pass() {
	cat > /etc/asound.conf << __EOF__
pcm.!default {
  type plug
  slave {
    pcm "hw:0,1"
  }
}
ctl.!default {
  type hw
  card 0
}
__EOF__

	msgbox "HDMI Audio Passthrough is now disabled. Please reboot to take effect"
}

