#!/bin/bash

# Some variables.
REBOOT=0
DATE=`date +%Y.%m.%d-%H.%M`

# Load the scripts
source $_B/extras.sh
source $_B/fs_resize.sh
source $_B/hdmi.sh
source $_B/kernel_update.sh
source $_B/xbmc_setup.sh
source $_B/xorg_config.sh
source $_B/armsoc.sh
source $_B/change_hostname.sh
source $_B/lirc_setup.sh

# mainmenu should be the last one :)
source $_B/mainmenu.sh
