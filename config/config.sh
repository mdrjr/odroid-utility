#!/bin/bash

# Some variables.
REBOOT=0
DATE=`date +%Y.%m.%d-%H.%M`

# Load the scripts

# Config
source $_B/config/extras.sh

# Multimedia
source $_B/multimedia/hdmi.sh
source $_B/multimedia/xbmc_setup.sh
source $_B/multimedia/lirc_setup.sh
source $_B/multimedia/odroidc_hdmipass.sh
source $_B/multimedia/pulseaudio_control.sh

# Administration
source $_B/administration/armsoc.sh
source $_B/administration/fs_resize.sh
source $_B/administration/kernel_update.sh
source $_B/administration/xorg_config.sh
source $_B/administration/change_hostname.sh
source $_B/administration/change_password.sh
source $_B/administration/change_locale.sh
source $_B/administration/change_timezone.sh
source $_B/administration/configure_keyboard.sh

# Menu
source $_B/menu/internationalization_menu.sh
source $_B/menu/administration_menu.sh
source $_B/menu/multimedia_menu.sh
source $_B/menu/desktop_environment_menu.sh


# Get the board here
get_board

# mainmenu should be the last one :)
source $_B/menu/mainmenu.sh
