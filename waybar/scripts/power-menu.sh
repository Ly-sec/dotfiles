#!/bin/bash

# Path to your custom Rofi config (expanded correctly)
rofi_config="$HOME/.config/rofi/config.rasi"

# Power menu options
options="  Shutdown\n  Reboot\n  Lock\n  Logout\n⏾  Suspend"

# Launch Rofi with the specified config
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu:" -config "$rofi_config")

# Handle the selected option
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

