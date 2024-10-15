#!/bin/bash

themes_path="$HOME/rice/dotfiles/waybar/themes"

css_files=$(find "$themes_path" -maxdepth 1 -name "*.css" -exec basename {} \;)

if [ -z "$css_files" ]; then
    notify-send "No CSS themes found!" "Please add CSS theme files to $themes_path."
    exit 1
fi

selected_theme=$(echo -e "$css_files" | rofi -dmenu -i -p "Select a Waybar Theme:")

# Check if a theme was selected
if [ -n "$selected_theme" ]; then
    echo "Switching to Waybar theme: $selected_theme"
    
    pkill -x waybar
    sleep 0.5

    waybar -c $HOME/rice/dotfiles/waybar/config -s "$themes_path/$selected_theme" &

    notify-send "Waybar Theme Changed" "Now using theme: $selected_theme"
else
    echo "No theme selected."
fi

