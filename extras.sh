#!/bin/bash

do_exit() {
	if [ $REBOOT -eq 1 ]; then
		whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --msgbox \
		"You need to reboot your board to the new modifications take effects" 0 0
	fi
	sync
	exit 0
}
