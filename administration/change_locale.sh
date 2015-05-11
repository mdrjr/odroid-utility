#!/bin/bash

change_locale() {
  #using cmdline
 echo "Please select one of the following available locales:"

 #sleep 1 second
 sleep 1

 #show all locales
 locale -a

 echo "Locale:"
 #read locale
 read selected_locale

 #update
 rm /etc/locale.gen
 
 dpkg-reconfigure -f noninteractive locales
    
 update-locale LANG="$selected_locale"
 
 msgbox "Please restart!"
}
