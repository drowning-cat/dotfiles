#!/bin/sh

pid=$(hyprctl clients -j | jq -e 'first( .[] | select(.title=="waybar-netiwd") ) | .pid // empty')

if [ -n "$pid" ]; then
  kill -9 "$pid"
else
  hyprctl dispatch exec '[float; size 850 500; move 100%-w-2 33; pin]' 'alacritty --title "waybar-netiwd" -e zsh -c "iwctl station wlan0 get-networks && iwctl"'
fi

