#!/bin/bash

while true; do
	
	CC=$(whiptail --backtitle "Hardkernel ODROID Utility v$_REV" --menu "Main Menu" 15 54 0 --cancel-button "Exit" --ok-button "Select" \
		"1" "Administration" \
		"2" "Multimedia" \
		3>&1 1>&2 2>&3)
	
	RET=$?
	
	if [ $RET -eq 1 ]; then
		do_exit
	elif [ $RET -eq 0 ]; then
		case "$CC" in
		"1") administration_menu ;;
		"2") multimedia_menu ;;
		*) msgbox "Error 001. Please report on the forums" && exit 0 ;;
		esac || msgbox "I don't know how you got here! >> $CC <<  Report on the forums"		
	fi
done
