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

# mainmenu should be the last one :)
source $_B/mainmenu.sh
