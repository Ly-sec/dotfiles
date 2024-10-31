#!/bin/bash

# The directory where Waypaper stores wallpapers
WALLPAPER_DIR=~/.cache/waypaper

# Keep track of the last wallpaper file applied
LAST_WALLPAPER=""

while true; do
    # Find the most recently modified wallpaper file
    CURRENT_WALLPAPER=$(find "$WALLPAPER_DIR" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)

    # Check if the wallpaper has changed
    if [[ "$CURRENT_WALLPAPER" != "$LAST_WALLPAPER" ]]; then
        # Apply the new wallpaper colors with wal
        wal -i "$CURRENT_WALLPAPER"
        
        # Set the wallpaper with Hyprpaper
        hyprctl hyprpaper wallpaper "$CURRENT_WALLPAPER"
        
        # Update the last wallpaper
        LAST_WALLPAPER="$CURRENT_WALLPAPER"
    fi

    # Check every few seconds
    sleep 2
done
