#!/bin/bash

change_hostname() {
	
	whiptail --msgbox "The RFC requires that the hostname contains only:
letters 'a' to 'z'
numbers '0' to '9'
and hyphen (-)
Note that a hostname cannot beggin or end with a hyphen.
	
No other char/symbol/punctuation or white-spaces are allowed." 0 0 0
	
	CH=`cat /etc/hostname | tr -d " \t\n\r"`
	NH=$(whiptail --inputbox "Hostname" 0 0 "$CH" 3>&1 1>&2 2>&3)
	
	if [ $? -eq 0 ]; then
		echo $NH > /etc/hostname
		echo "127.0.0.1 $NH" >> /etc/hosts
		REBOOT=1
	fi
}
