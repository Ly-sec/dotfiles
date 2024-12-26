#!/bin/bash

# Read the wallpaper path from the Waypaper configuration
wallpaper=$(grep '^wallpaper' ~/.config/waypaper/config.ini | cut -d '=' -f 2 | xargs)

# Expand the ~ to the home directory if present
wallpaper=$(eval echo "$wallpaper")

# Run the wal command with the updated wallpaper
wal -i "$wallpaper"
