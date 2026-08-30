#!/usr/bin/env bash
set -euo pipefail

workspace="${1:?workspace is required}"
command_line="${2:?command is required}"

hyprctl dispatch togglespecialworkspace "$workspace"
if ! hyprctl clients -j | jq -e --arg name "special:${workspace}" '.[] | select(.workspace.name == $name)' >/dev/null; then
    bash -lc "$command_line" >/dev/null 2>&1 &
fi
