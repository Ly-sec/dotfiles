#!/bin/bash

# Define the options
options="Shutdown\nReboot\nLogout\nSuspend\nHibernate\nLock\nExit"

# Use rofi to show the menu and capture the selected option
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu")

# Perform the corresponding action
case $chosen in
  "Shutdown")
    systemctl poweroff
    ;;
  "Reboot")
    systemctl reboot
    ;;
  "Logout")
    hyprctl dispatch exit
    ;;
  "Suspend")
    systemctl suspend
    ;;
  "Hibernate")
    systemctl hibernate
    ;;
  "Lock")
    hyprctl dispatch lock
    ;;
  "Exit")
    exit 0
    ;;
  *)
    exit 1
    ;;
esac
