#!/bin/bash

THEME_DIR="$HOME/.config/waybar/themes"
LAST_THEME_FILE="$HOME/.config/waybar/last_theme.txt"
LOG_FILE="$HOME/.config/waybar/theme_debug.log"

exec >> "$LOG_FILE" 2>&1
echo "Script run at $(date) with args: $*"

restore_theme() {
    if [ -f "$LAST_THEME_FILE" ]; then
        selected_theme=$(cat "$LAST_THEME_FILE" | tr -d '\n')
        echo "Restoring theme: $selected_theme"

        if [ -d "$THEME_DIR/$selected_theme" ]; then
            echo "Killing existing Waybar instances..."
            pkill -9 -x "waybar"

            sleep 1

            echo "Launching Waybar with theme: $selected_theme"
            WAYBAR_PATH=$(which waybar)
            "$WAYBAR_PATH" -c "$THEME_DIR/$selected_theme/config" -s "$THEME_DIR/$selected_theme/style.css" &

            sleep 1

            if pgrep -x "waybar" > /dev/null; then
                echo "Waybar launched successfully."
            else
                echo "Waybar failed to launch."
            fi
        else
            echo "Theme directory not found: $THEME_DIR/$selected_theme"
        fi
    else
        echo "No theme saved. Exiting."
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
