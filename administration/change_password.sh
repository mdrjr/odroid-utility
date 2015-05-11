#!/bin/bash

change_password() {
  msgbox "Please enter your new password"
  passwd odroid &&
  msgbox "Password changed successfully"
}
