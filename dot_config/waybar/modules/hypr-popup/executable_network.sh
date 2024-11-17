#!/bin/sh

"$(dirname -- $0)/alacritty-popup.sh" "waybar-netiwd-popup" "iwctl station wlan0 get-networks && iwctl"

