#!/bin/sh

t=

while [ "$#" -gt 0 ]; do
  case "$1" in
    -t) t="$2"; shift 2 ;;
     *) shift 1 ;;
  esac
done

tmux move-window -t "$t" || tmux swap-window -d -t "$t"

