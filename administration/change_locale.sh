#!/bin/bash

change_locale() {
 
 locales=$(locale -a)
  
 selected_locale=$(whiptail --inputbox "$locales" 20 54 3>&1 1>&2 2>&3)
 
 update-locale LANG=$selected_locale
 
 dpkg-reconfigure locales
}
