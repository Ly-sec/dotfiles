#!/bin/bash

# Set default editor
editor="nano"  # Change this to your preferred editor (e.g., vim, nvim, code)

# Main menu options
options=" Dotfiles\n   󱞩  Waybar\n   󱞩  Hyprland\n   󱞩  Rofi\n   󱞩  Dunst"

# Get user's choice using rofi
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu:")

case "$chosen" in
    "   󱞩  Waybar")
        # Dynamically list .css files in the Waybar themes directory
        waybar_dir=~/rice/dotfiles/waybar/themes/
        waybar_options=$(find "$waybar_dir" -maxdepth 1 -name "*.css" -exec basename {} \; | sed 's/^/   /') # Add spaces for indentation

        # Get submenu choice
        waybar_choice=$(echo -e "$waybar_options" | rofi -dmenu -i -p "Select a CSS File to Edit:")

        # Check if a choice was made and open the selected .css file
        if [ -n "$waybar_choice" ]; then
            # Remove leading spaces to get the actual file name
            css_file=$(echo "$waybar_choice" | sed 's/^   //')
            alacritty -e zsh -c "$editor \"$waybar_dir$css_file\" && exec zsh"
        fi
        ;;
    "   󱞩  Hyprland")
        # Dynamically list .conf files in the Hyprland config directory
        hyprland_dir=~/rice/dotfiles/hyprland/
        hyprland_options=$(find "$hyprland_dir" -maxdepth 1 -name "*.conf" -exec basename {} \; | sed 's/^/   /') # Add spaces for indentation

        # Get submenu choice
        hyprland_choice=$(echo -e "$hyprland_options" | rofi -dmenu -i -p "Hyprland Options:")

        # Check if a choice was made and open the selected .conf file
        if [ -n "$hyprland_choice" ]; then
            # Remove leading spaces to get the actual file name
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
        # Do nothing if nothing is chosen or invalid input (failsafe)
        ;;
esac

