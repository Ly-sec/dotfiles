#!/usr/bin/env bash

set -euo pipefail

# ─── CONFIG ────────────────────────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config_backup"

# ─── STYLING ───────────────────────────────────────────────────────────────

YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RED="\033[1;31m"
BLUE="\033[1;34m"
RESET="\033[0m"
INFO="➜"
CHECK="✔"
CROSS="✖"
WARN="⚠"

# ─── FLAGS ─────────────────────────────────────────────────────────────────

DRY_RUN=false

# ─── FUNCTIONS ─────────────────────────────────────────────────────────────

print_header() {
    local width=90
    printf "${BLUE}${RESET} Dotfiles Symlink Setup Script${RESET}"
    printf "%*s${BLUE}${RESET}\n" $((width - 27)) ""

    printf "${BLUE}${RESET} Safely replaces configs in ~/.config with links from: ${DOTFILES_DIR}${RESET}"
    printf "%*s${BLUE}${RESET}\n" $((width - 53)) ""

    printf "${BLUE}${RESET} GitHub: https://github.com/Ly-sec/dotfiles${RESET}"
    printf "%*s${BLUE}${RESET}\n" $((width - 44)) ""
}

parse_flags() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run) DRY_RUN=true ;;
            *) echo -e "${RED}${CROSS}${RESET} Unknown option: $1" && exit 1 ;;
        esac
        shift
    done
}

is_git_clean() {
    if git -C "$DOTFILES_DIR" diff --quiet && git -C "$DOTFILES_DIR" diff --cached --quiet && ! git -C "$DOTFILES_DIR" ls-files --others --exclude-standard | grep -q '.'; then
        return 0
    fi
    return 1
}

is_git_behind_remote() {
    local behind
    behind=$(git -C "$DOTFILES_DIR" rev-list --left-right --count origin/HEAD...HEAD 2>/dev/null || echo "")
    if [[ "$behind" =~ ^([0-9]+)[[:space:]]([0-9]+)$ ]]; then
        local behind_count=${BASH_REMATCH[1]}
        if (( behind_count > 0 )); then
            return 0
        fi
    fi
    return 1
}

prompt_pull() {
    while true; do
        read -rp "Local branch is behind remote. Pull latest changes now? [Y/n]: " yn
        case "$yn" in
            [Yy]* | "") 
                echo -e "${INFO} Pulling latest changes..."
                git -C "$DOTFILES_DIR" pull --ff-only
                return 0
                ;;
            [Nn]* )
                echo -e "${WARN} Skipping pull. You might be working with outdated files."
                return 1
                ;;
            * ) echo "Please answer yes or no." ;;
        esac
    done
}

choose_folders() {
    mapfile -t FOLDERS < <(
        find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' |
        grep -vE '^\.' |  # exclude dotfolders
        sort
    )
}

prompt_backup_or_skip() {
    local target="$1"
    local choice

    while true; do
        read -rp "\"$target\" exists and is not a symlink. Back up and replace? [y/N]: " yn
        case "$yn" in
            [Yy]*) choice="Backup & replace"; break ;;
            [Nn]*|"") choice="Skip"; break ;;
            *) echo "Please answer yes or no." ;;
        esac
    done

    echo "$choice"
}

perform_symlinks() {
    echo -e "${YELLOW}${INFO}${RESET} Preparing to link ${#FOLDERS[@]} folders from ${DOTFILES_DIR}\n"
    echo

    for folder in "${FOLDERS[@]}"; do
        local source="$DOTFILES_DIR/$folder"
        local target="$CONFIG_DIR/$folder"

        if [ ! -d "$source" ]; then
            echo -e " ${RED}${CROSS}${RESET} Source not found: $source"
            continue
        fi

        echo -e "${BLUE}Folder:${RESET} $folder"

        if ! git -C "$DOTFILES_DIR" ls-files --error-unmatch "$folder" &>/dev/null; then
            echo -e " ${WARN} Warning: Not tracked in git"
        fi

        if [ -e "$target" ]; then
            if [ -L "$target" ]; then
                echo -e " ${INFO} Removing existing symlink: $target"
                $DRY_RUN || rm "$target"
            else
                local action
                action=$(prompt_backup_or_skip "$target")
                if [[ "$action" == "Backup & replace" ]]; then
                    mkdir -p "$BACKUP_DIR"
                    echo -e " ${INFO} Backing up $target → $BACKUP_DIR/"
                    $DRY_RUN || mv "$target" "$BACKUP_DIR/"
                else
                    echo -e " ${CROSS} Skipping: $target exists and is not a symlink."
                    continue
                fi
            fi
        fi

        echo -e " ${INFO} Linking: ~/.config/$folder → ~/$(basename "$DOTFILES_DIR")/$folder"
        $DRY_RUN || ln -sfn "$source" "$target"
        echo -e "   ${GREEN}${CHECK}${RESET} Linked successfully"
        echo
    done

    echo -e "${GREEN}${CHECK}${RESET} All dotfiles processed."
}

main() {
    print_header
    parse_flags "$@"

    if [ ! -d "$DOTFILES_DIR/.git" ]; then
        echo -e "${WARN} Warning: '${DOTFILES_DIR}' is not a git repository. Git checks will be limited."
    else
        if ! is_git_clean; then
            echo -e "${WARN} Warning: You have uncommitted changes or untracked files in your dotfiles directory."
        fi

        if is_git_behind_remote; then
            echo -e "${RED}${WARN} Warning: Your local branch is behind the remote repository.${RESET}"
            prompt_pull
        fi
    fi

    choose_folders

    echo -e "${YELLOW}${INFO}${RESET} Found ${#FOLDERS[@]} folders to process in dotfiles:"
    for folder in "${FOLDERS[@]}"; do
        # Properly print bold folder names with ANSI escape codes interpreted
        printf " - \033[1m%s\033[0m\n" "$folder"
    done
    echo

    read -rp "Proceed with creating symlinks for these folders? [Y/n]: " proceed
    case "$proceed" in
        [Nn]*) echo "Aborted by user."; exit 1 ;;
        *) echo -e "${INFO} Proceeding with symlink creation..." ;;
    esac

    perform_symlinks
}

main "$@"
