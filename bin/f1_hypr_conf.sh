#!/bin/bash

atual="$HOME/.config/hypr/hyprland.conf"
f1="$HOME/.config/hypr/hypr_config1.conf"
f2="$HOME/.config/hypr/hypr_config2.conf"

if cmp -s "$atual" "$f1"; then
  # Currently using config1, switch to config2 (focus mode)
  cp "$f2" "$atual"
  pkill waybar # Kill Waybar to hide it
else
  # Currently using config2, switch to config1 (normal mode)
  cp "$f1" "$atual"
  # Start Waybar if not already running
  if ! pgrep -x waybar >/dev/null; then
    waybar &
    disown
  fi
fi

# Reload Hyprland config after switching
hyprctl reload
