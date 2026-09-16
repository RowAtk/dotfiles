#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
STORE_FILE="current_wallpaper.txt"
CURRENT_WALL=$(cat $STORE_FILE)
# Get the name of the focused monitor with hyprctl
FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

echo $WALLPAPER > $STORE_FILE

# Apply the selected wallpaper
hyprctl hyprpaper wallpaper "$FOCUSED_MONITOR","$WALLPAPER",cover
