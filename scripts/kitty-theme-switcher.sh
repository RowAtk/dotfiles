#!/usr/bin/env bash

KITTY_DIR="$HOME/.config/kitty"
THEMES_DIR="$KITTY_DIR/kitty-themes/themes"
THEME_LINK="$KITTY_DIR/theme.conf"

THEME=$(ls "$THEMES_DIR" | sed 's/\.conf$//' | fzf --prompt="Kitty theme > ")

[[ -z "$THEME" ]] && exit 0

ln -sf "$THEMES_DIR/$THEME.conf" "$THEME_LINK"
kitty @ set-colors -a "$THEME_LINK" 2>/dev/null || true

echo "✅ Kitty theme switched to: $THEME"

