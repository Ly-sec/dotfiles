#!/bin/bash

DOTFILES_DIR=~/dotfiles
CONFIG_DIR=~/.config

# List of folders to symlink
FOLDERS=("hypr" "waybar" "waypaper" "swaync" "rofi")

for folder in "${FOLDERS[@]}"; do
    TARGET="$CONFIG_DIR/$folder"
    SOURCE="$DOTFILES_DIR/$folder"

    # Check if the target exists and is not a symlink
    if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo "Found existing directory: $TARGET"

        # Prompt for backup
        read -p "Do you want to back up the existing directory? [y/N]: " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            BACKUP_DIR="${TARGET}_backup_$(date +%Y%m%d%H%M%S)"
            echo "Backing up $TARGET to $BACKUP_DIR"
            mv "$TARGET" "$BACKUP_DIR"
        else
            echo "Skipping backup."
        fi

        # Remove the original directory
        echo "Removing existing directory: $TARGET"
        rm -rf "$TARGET"
    fi

    # Create the symlink
    echo "Creating symlink: $TARGET -> $SOURCE"
    ln -sf "$SOURCE" "$TARGET"
done

echo "Dotfiles have been successfully symlinked!"
