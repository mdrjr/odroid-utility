#!/bin/bash

do_exit() {
	if [ $REBOOT -eq 1 ]; then
		whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --msgbox \
		"You need to reboot your board to the new modifications take effects" 0 0
	fi
	sync
	exit 0
}

dlf() {
	# $1 is the URL
	# $2 is the name of what is downloading to show on the window
	# $3 is the output file name
	wget "$1" 2>&1 -O $3 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | whiptail --gauge "$2" 0 0 100
}

dlf_fast() {
	# $1 is the URL
	# $2 is the name of what is downloading to show on the window
	# $3 is the output file name

	axel -n 5 "$1" -o $3 2>&1 | stdbuf -o0 awk '/[0-9][0-9]?%+/ { print substr($0,2,3) }' | whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --gauge "$2" 0 0 100
}

msgbox() {
	# $1 is the msg
	whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --msgbox "$1" 0 0 0 
}

get_board() {
        B=`cat /proc/cpuinfo  | grep -i odroid | awk {'print $3'}`
        case "$B" in
                "ODROIDXU")
                        export BOARD="odroidxu"
                        echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                        ;;
                "ODROIDX") export BOARD="odroidx" ;;
                "ODROIDX2") export BOARD="odroidx2" ;;
                "ODROID-U2/U3") export BOARD="odroidu2" ;;
                "ODROIDU2") export BOARD="odroidu2" ;;
                "ODROID-XU3") export BOARD="odroidxu3" ;;
                "ODROIDC") export BOARD="odroidc" ;;
                *)
                        msgbox "GET-BOARD: Couldn't identify your board $B please report on the forums"
                        ;;
        esac 
}
