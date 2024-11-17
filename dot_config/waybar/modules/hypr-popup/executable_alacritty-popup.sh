#!/bin/sh

title="$1"; cmd="$2"

pid=$(hyprctl clients -j | jq -e --arg t "$title" 'first( .[] | select(.title==$t) ) | .pid // empty')

if [ -n "$pid" ]; then
  kill -9 "$pid"
else
  hyprctl dispatch exec\
    '[float; size 850 500; move 100%-w-10 33; pin]' "alacritty --title '$title' -e zsh -c '$cmd'"
fi

