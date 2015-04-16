#!/bin/bash

change_locale() {
 
 #bad implementation:
 #locales=$(locale -a)  
 #selected_locale=$(whiptail --inputbox "$locales" 20 54 3>&1 1>&2 2>&3)
 
 #using cmdline
 echo "Please select one of the following locales:"

 #sleep 1 second
 sleep 1

 #show all locales
 locale -a

 echo "Locale:"
 #read locale
 read selected_locale

 #update
 update-locale LANG=$selected_locale
 
 dpkg-reconfigure locales
 
 msgbox "Please restart!"
}
