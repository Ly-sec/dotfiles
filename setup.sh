#!/bin/bash

# Set the border character and length for the box
BORDER_TOP="┌─────────────────────────────────────────────────────────────────┐"
BORDER_BOTTOM="└─────────────────────────────────────────────────────────────────┘"

# Function to print a bordered message
print_bordered_message() {
    echo "$BORDER_TOP"
    echo "│ Welcome to the Dotfiles Setup Script!                           │"
    echo "│ These are my personal dotfiles, and this script will manage     │"
    echo "│ symlinks for the configuration files.                           │"
    echo "│ It will remove any existing symlinks and recreate them pointing │"
    echo "│ to the correct sources.                                         │"
    echo "│ GitHub: https://github.com/Ly-sec/dotfiles                      │"
    echo "$BORDER_BOTTOM"
    echo ""
}

# Introduction message with border
print_bordered_message

# Set the directories
DOTFILES_DIR=~/dotfiles
CONFIG_DIR=~/.config

# List of folders to symlink
FOLDERS=("hypr" "waybar" "waypaper" "swaync" "rofi" "ghostty")

# Array to store symlink removal prompts
SYMLINKS_TO_REMOVE=()

# Check if any symlinks already exist
for folder in "${FOLDERS[@]}"; do
    TARGET="$CONFIG_DIR/$folder"
    SOURCE="$DOTFILES_DIR/$folder"

    if [ -L "$TARGET" ]; then
        SYMLINKS_TO_REMOVE+=("$TARGET -> $SOURCE")
    fi
done

# If there are symlinks to remove, ask for confirmation
if [ ${#SYMLINKS_TO_REMOVE[@]} -gt 0 ]; then
    echo "The following symlinks exist and will be removed (they will be readded after):"
    for symlink in "${SYMLINKS_TO_REMOVE[@]}"; do
        echo "  $symlink"
    done

    read -p "Do you want to remove these symlinks and proceed with re-adding them? [y/N]: " response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Exiting without making changes."
        exit 1
    fi
fi

# Proceed to remove the symlinks and create new ones
for folder in "${FOLDERS[@]}"; do
    TARGET="$CONFIG_DIR/$folder"
    SOURCE="$DOTFILES_DIR/$folder"

    # If the symlink exists, remove it and create a new one
    if [ -L "$TARGET" ]; then
        echo "Removing existing symlink: $TARGET"
        rm "$TARGET"
    fi

    # Create the new symlink
    if [ -d "$SOURCE" ]; then
        echo "Creating symlink: $TARGET -> $SOURCE"
        ln -sf "$SOURCE" "$TARGET"
        echo "Symlink created successfully!"
    else
        echo "Error: Source directory $SOURCE does not exist!"
    fi
done

echo "Dotfiles have been successfully symlinked!"
