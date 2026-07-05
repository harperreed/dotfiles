#!/bin/bash
# ABOUTME: Unified theme switcher - swaps waybar CSS and Hyprland window theme
# ABOUTME: Usage: theme.sh <name> or theme.sh --list

WAYBAR_THEMES="$HOME/.config/waybar/themes"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
HYPR_THEMES="$HOME/.config/hypr/themes"
HYPR_ACTIVE="$HOME/.config/hypr/themes/active.conf"

if [ "$1" = "--list" ] || [ -z "$1" ]; then
    echo "Available themes:"
    for f in "$WAYBAR_THEMES"/*.css; do
        name=$(basename "$f" .css)
        echo "    $name"
    done
    exit 0
fi

NAME="$1"
WAYBAR_FILE="$WAYBAR_THEMES/$NAME.css"
HYPR_FILE="$HYPR_THEMES/$NAME.conf"

if [ ! -f "$WAYBAR_FILE" ]; then
    echo "Waybar theme '$NAME' not found."
    exit 1
fi

cp "$WAYBAR_FILE" "$WAYBAR_STYLE"

if [ -f "$HYPR_FILE" ]; then
    cp "$HYPR_FILE" "$HYPR_ACTIVE"
    hyprctl reload 2>/dev/null
fi

killall waybar 2>/dev/null
waybar &
disown
echo "Switched to '$NAME'"
