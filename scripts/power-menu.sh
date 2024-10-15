#!/bin/bash

options="  Shutdown\n  Reboot\n  Lock\n  Logout\n⏾  Suspend"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu:")

case "$chosen" in
    "  Shutdown")
        systemctl poweroff
        ;;
    "  Reboot")
        systemctl reboot
        ;;
    "  Lock")
        hyprlock
        ;;
    "  Logout")
        hyprctl dispatch exit
        ;;
    "⏾  Suspend")
        systemctl suspend
        ;;
    *)
        ;;
esac
