#!/bin/bash

set -euo pipefail

# Map of "name -> config path"
declare -A CONFIGS=(
  [kitty]="$HOME/.config/kitty/kitty.conf"
  [hyprland]="$HOME/.config/hypr/hyprland.conf"
  [hypr]="$HOME/.config/hypr/hyprland.conf"
  [zsh]="$HOME/.zshrc"
  [waybar]="$HOME/.config/waybar/config.jsonc"
  [self]="$HOME/scripts/config.sh"
  [aliases]="$HOME/.aliases"
  [vim]="$HOME/.vimrc"
  [nvim]="$HOME/.config/nvim/init.vim"
)

usage() {
  cat <<EOF
Usage: $0 [name]

Names:
  kitty      -> ~/.config/kitty/kitty.conf
  hyprland   -> ~/.config/hypr/hyprland.conf
  hypr       -> ~/.config/hypr/hyprland.conf
  zsh        -> ~/.zshrc
  waybar     -> ~/.config/waybar/config

Special:
  --list     List all known configs
  -h, --help Show this help
EOF
}

list_configs() {
  echo "Available configs:"
  for key in "${!CONFIGS[@]}"; do
    printf "  %-9s -> %s\n" "$key" "${CONFIGS[$key]}"
  done
}

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

case "$1" in
  -h|--help)
    usage
    exit 0
    ;;
  --list)
    list_configs
    exit 0
    ;;
esac

name="$1"

# Exact match first
if [[ -n ${CONFIGS[$name]+x} ]]; then
  target="$name"
else
  # Try fuzzy prefix match: e.g. "hyp" -> "hyprland"
  matches=()
  for key in "${!CONFIGS[@]}"; do
    if [[ "$key" == "$name"* ]]; then
      matches+=("$key")
    fi
  done

  if [[ ${#matches[@]} -eq 1 ]]; then
    target="${matches[0]}"
  else
    echo "Unknown or ambiguous name: '$name'"
    echo
    list_configs
    exit 1
  fi
fi

config_path="${CONFIGS[$target]}"

# Ensure directory exists
config_dir="$(dirname "$config_path")"
mkdir -p "$config_dir"

# Create file if missing
if [[ ! -e "$config_path" ]]; then
  : > "$config_path"
fi

editor="${EDITOR:-vim}"
exec "$editor" "$config_path"

