#!/bin/bash
set -e

# Ensure the directory exists
mkdir -p "$HOME/.config/spicetify/Themes/Pywal"

# Copy and rename file
cp -r "$HOME/.cache/wal/colors-spicetify.ini" "$HOME/.config/spicetify/Themes/Pywal/"
cd "$HOME/.config/spicetify/Themes/Pywal" || exit
mv colors-spicetify.ini color.ini 

# Apply Spicetify theme with full path
spicetify apply