#!/bin/bash

# Program Version
_REV="1"

# Some variables.
REBOOT=0

# Load the scripts
source $_B/extras.sh
source $_B/fs_resize.sh
source $_B/hdmi.sh
source $_B/kernel_update.sh
source $_B/xbmc_setup.sh
source $_B/xorg_config.sh
source $_B/armsoc.sh

# mainmenu should be the last one :)
source $_B/mainmenu.sh


dlf() {
	# $1 is the URL
	# $2 is the name of what is downloading to show on the window
	# $3 is the output file name
	
	wget "$1" 2>&1 -O $3 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | whiptail --gauge "$2" 0 0 100
}
