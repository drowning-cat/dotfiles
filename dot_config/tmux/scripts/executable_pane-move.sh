#!/bin/sh

t=

while [ "$#" -gt 0 ]; do
  case "$1" in
    -t) t="$2"; shift 2 ;;
    *) shift 1 ;;
  esac
done

if tmux list-windows -F '#{window_index}' | grep -qF "$t"; then
  tmux move-pane -t ":$t"
else
  tmux break-pane -t ":$t"
fi

exit 0
