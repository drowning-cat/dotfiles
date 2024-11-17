#!/bin/sh

if [ $(tmux show-option -gv status) != 'on' ]; then
  exit 0
fi

args=$@
t=

while [ "$#" -gt 0 ]; do
  case "$1" in
    -t) t="$2"; shift 2 ;;
    *) shift 1 ;;
  esac
done

tmux new-window $args || tmux select-window -t "$t"

