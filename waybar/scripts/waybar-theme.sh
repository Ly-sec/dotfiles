#!/bin/bash

# Set the Waybar theme directory and last theme file path
THEME_DIR="$HOME/.config/waybar/themes"
LAST_THEME_FILE="$HOME/.config/waybar/last_theme.txt"

# Function to restore the last used theme
restore_theme() {
    if [ -f "$LAST_THEME_FILE" ]; then
        selected_theme=$(cat "$LAST_THEME_FILE")
        echo "Restoring last used theme: $selected_theme"
        # Kill the existing Waybar instance
        pkill -x "waybar"

        # Give Waybar a little time to shut down properly
        sleep 1

        # Full path to Waybar, ensure it's correctly pointed out
        WAYBAR_PATH=$(which waybar)

        if [ -z "$WAYBAR_PATH" ]; then
            echo "Error: Waybar is not found in your PATH."
            exit 1
        fi

        # Launch Waybar with the selected theme's config and style.css
        echo "Launching Waybar with config: $THEME_DIR/$selected_theme/config and style: $THEME_DIR/$selected_theme/style.css"
        "$WAYBAR_PATH" -c "$THEME_DIR/$selected_theme/config" -s "$THEME_DIR/$selected_theme/style.css" &
        
        # Ensure Waybar is properly launched
        if pgrep -x "waybar" > /dev/null; then
            echo "Waybar successfully launched."
        else
            echo "Failed to launch Waybar."
        fi
    else
        echo "No previous theme found. Please select a theme."
        select_theme
    fi
}

# Function to display the Rofi menu and select a theme
select_theme() {
    themes=$(find "$THEME_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)

    selected_theme=$(echo "$themes" | rofi -dmenu -p "Select Waybar Theme:")

    # If a theme is selected
    if [ -n "$selected_theme" ]; then
        # Save the selected theme to the last theme file
        echo "$selected_theme" > "$LAST_THEME_FILE"
        # Kill the existing Waybar instance
        pkill -x "waybar"

        # Full path to Waybar, ensure it's correctly pointed out
        WAYBAR_PATH=$(which waybar)

        if [ -z "$WAYBAR_PATH" ]; then
            echo "Error: Waybar is not found in your PATH."
            exit 1
        fi

        # Launch Waybar with the selected theme's config and style.css
        echo "Launching Waybar with config: $THEME_DIR/$selected_theme/config and style: $THEME_DIR/$selected_theme/style.css"
        "$WAYBAR_PATH" -c "$THEME_DIR/$selected_theme/config" -s "$THEME_DIR/$selected_theme/style.css" &
        
        # Ensure Waybar is properly launched
        if pgrep -x "waybar" > /dev/null; then
            echo "Waybar successfully launched."
        else
            echo "Failed to launch Waybar."
        fi
    fi
}

# Check for --restore flag
if [[ "$1" == "--restore" ]]; then
    restore_theme
else
    select_theme
fi
