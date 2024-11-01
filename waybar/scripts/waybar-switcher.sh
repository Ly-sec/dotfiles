#!/bin/bash

# Set Waybar themes directory and current theme file
THEMES_DIR="$HOME/.config/waybar/themes"
CURRENT_THEME_FILE="$HOME/.config/waybar/current_theme"

# Function to apply the theme
apply_theme() {
    local theme="$1"
    if [[ -d "$THEMES_DIR/$theme" ]]; then
        cp "$THEMES_DIR/$theme/style.css" "$HOME/.config/waybar/style.css"
        cp "$THEMES_DIR/$theme/config" "$HOME/.config/waybar/config"
        echo "$theme" > "$CURRENT_THEME_FILE"
        
        pkill -x waybar

        sleep 1

        nohup waybar >/dev/null 2>&1 &

        echo "Waybar has been restarted."

        
        echo "Applied theme: $theme"
    else
        echo "Theme directory for $theme not found."
    fi
}

# If called with --select, open Rofi to select a theme
if [[ "$1" == "--select" ]]; then
    selected_theme=$(ls "$THEMES_DIR" | rofi -dmenu -p "Select Waybar Theme:")
    if [[ -n "$selected_theme" ]]; then
        apply_theme "$selected_theme"
    else
        echo "No theme selected."
    fi
else
    # Load saved theme if no argument is provided
    if [[ -f "$CURRENT_THEME_FILE" ]]; then
        saved_theme=$(cat "$CURRENT_THEME_FILE")
        apply_theme "$saved_theme"
    else
        echo "No theme is currently saved."
    fi
fi
