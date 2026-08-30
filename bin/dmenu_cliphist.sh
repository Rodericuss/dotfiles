#!/usr/bin/env bash

histfile="$HOME/.cache/cliphist"
placeholder="<NEWLINE>"

highlight() {
  clip=$(timeout 0.3 wl-paste --no-newline 2>/dev/null)
}

output() {
  clip=$(tee >(wl-copy) </dev/stdin)
}

write() {
  [ -f "$histfile" ] || notify-send "Creating $histfile"
  touch $histfile
  [ -z "$clip" ] && exit 0
  multiline=$(echo "$clip" | sed ':a;N;$!ba;s/\n/'"$placeholder"'/g')
  grep -Fxq "$multiline" "$histfile" || echo "$multiline" >>"$histfile"
  notification=$(echo \"$multiline\")
}

sel() {
  selection=$(tac "$histfile" | sed "s/$placeholder/ /g" | fzf --prompt="Clipboard history: ")

  [ -z "$selection" ] && exit 0

  # Recupera o conteúdo real com quebras
  original=$(grep -F "$selection" "$histfile")

  echo "$original" | sed "s/$placeholder/\n/g" | wl-copy && notify-send "Copied to clipboard!"
}

case "$1" in
add) highlight && write ;;
out) output && write ;;
sel) sel ;;
*)
  printf "$0 | File: $histfile\n\nadd - copies primary selection to clipboard, and adds to history file\nout - pipe commands to copy output to clipboard, and add to history file\nsel - select from history file with dmenu and recopy!\n"
  exit 0
  ;;
esac

# [ -z "$notification" ] || notify-send "$notification"
