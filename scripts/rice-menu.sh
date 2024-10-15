#!/bin/bash

editor="nano"  # Change this to your preferred editor (e.g., vim, nvim, code)

options=" Dotfiles\n   󱞩  Waybar\n   󱞩  Hyprland\n   󱞩  Rofi\n   󱞩  Dunst"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu:")

case "$chosen" in
    "   󱞩  Waybar")
        waybar_dir=~/.config/waybar/themes/custom/
        waybar_options=$(find "$waybar_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sed 's/^/   /') # Add spaces for indentation

        waybar_choice=$(echo -e "$waybar_options" | rofi -dmenu -i -p "Waybar Options:")

        if [ -n "$waybar_choice" ]; then
            # Remove leading spaces to get the actual folder name
            folder_name=$(echo "$waybar_choice" | sed 's/^   //')
            alacritty -e zsh -c "cd \"$waybar_dir$folder_name\" && exec zsh"
        fi
        ;;
    "   󱞩  Hyprland")
        hyprland_dir=~/.config/hypr/conf/custom/
        hyprland_options=$(find "$hyprland_dir" -maxdepth 1 -name "*.conf" -exec basename {} \; | sed 's/^/   /') # Add spaces for indentation

        hyprland_choice=$(echo -e "$hyprland_options" | rofi -dmenu -i -p "Hyprland Options:")

        if [ -n "$hyprland_choice" ]; then
            file_name=$(echo "$hyprland_choice" | sed 's/^   //')
            alacritty -e zsh -c "$editor \"$hyprland_dir$file_name\" && exec zsh"
        fi
        ;;
    "   󱞩  Rofi")
        alacritty -e zsh -c "cd ~/.config/rofi/ && exec zsh"
        ;;
    "   󱞩  Dunst")
        alacritty -e zsh -c "cd ~/.config/dunst/ && exec zsh"
        ;;
    *)
        ;;
esac

