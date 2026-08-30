#!/usr/bin/env bash
set -euo pipefail

mapfile -t players < <(playerctl -l 2>/dev/null || true)
((${#players[@]})) || exit 0

current="$(playerctl -l 2>/dev/null | head -n 1 || true)"
next="${players[0]}"
for i in "${!players[@]}"; do
    if [[ "${players[$i]}" == "$current" ]]; then
        next="${players[$(( (i + 1) % ${#players[@]} ))]}"
        break
    fi
done

playerctl -p "$next" play-pause
