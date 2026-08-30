#!/usr/bin/env bash

histfile="$HOME/.cache/cliphist"
placeholder="<NEWLINE>"

# Mostra o histórico no fzf
selection=$(tac "$histfile" | sed "s/$placeholder/ /g" | fzf --prompt="Clipboard history: " --border)

# Se nada foi selecionado, sai
[ -z "$selection" ] && exit 0

# Recupera entrada original do histfile
original=$(grep -F "$selection" "$histfile")

# Copia pro clipboard com quebra de linha restaurada
echo "$original" | sed "s/$placeholder/\n/g" | wl-copy

# Fecha o terminal atual via Hyprland
hyprctl dispatch killactive
