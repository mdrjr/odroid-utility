#!/bin/bash

xbmc_setup() {
	get_board
	if [ "$BOARD" = "odroidc" ]; then
		msgbox "Use apt-get install kodi   or   apt-get update && apt-get dist-upgrade"
		return
	fi
	msgbox "Not supported yet"
}
