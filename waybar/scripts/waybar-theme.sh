#!/bin/bash

THEME_DIR="$HOME/.config/waybar/themes"
LAST_THEME_FILE="$HOME/.config/waybar/last_theme.txt"

restore_theme() {
    if [ -f "$LAST_THEME_FILE" ]; then
        selected_theme=$(cat "$LAST_THEME_FILE" | tr -d '\n')

        if [ -d "$THEME_DIR/$selected_theme" ]; then
            pkill -9 -x "waybar"

            sleep 1

            WAYBAR_PATH=$(which waybar)
            "$WAYBAR_PATH" -c "$THEME_DIR/$selected_theme/config" -s "$THEME_DIR/$selected_theme/style.css" &

            sleep 1
        fi
    fi
}

select_theme() {
    themes=$(find "$THEME_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)
    selected_theme=$(echo "$themes" | rofi -dmenu -p "Select Waybar Theme:")
    if [ -n "$selected_theme" ]; then
        echo "$selected_theme" > "$LAST_THEME_FILE"
        restore_theme
    fi
}

if [[ "$1" == "--restore" ]]; then
    restore_theme
else
    select_theme
fi
