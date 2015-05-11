#!/bin/bash

configure_keyboard() {
  dpkg-reconfigure keyboard-configuration && msgbox "Please logout to take effect!" 
}
