#!/bin/sh

args="$@"
t=

while [ "$#" -gt 0 ]; do
  case "$1" in
    -t)
      t="$2"
      shift 2
      ;;
    *)
      shift 1
      ;;
  esac
done

active_pane="$(tmux display-message -p '#{pane_id}')"

if tmux list-windows -F '#{window_index}' | grep -qF "$t"; then
  tmux move-pane $args -s "$active_pane"
else
  tmux break-pane $args -s "$active_pane"
fi

