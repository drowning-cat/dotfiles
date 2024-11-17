#!/bin/sh

if [ `tmux show-option -gqv status` != "on" ]; then
  exit 0
fi

new_window_args="$@"
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

tmux new-window $new_window_args || tmux select-window -t "$t"

