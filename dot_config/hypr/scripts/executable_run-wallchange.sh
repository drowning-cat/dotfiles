#!/bin/sh -e

images=$(find "${XDG_PICTURES_DIR:-$HOME/Pictures}/Wallpapers" -maxdepth 1 -type f | sort)

cols=5
rows=$(( ($(echo "$images" | wc -l) + cols - 1) / cols ))

wallpaper=$(
  for w in $images; do printf "$w\x00icon\x1f$w\n"; done |\
    rofi -dmenu -theme imgselect -theme-str "listview {columns:$cols;lines:$rows;}"
)

hyprctl hyprpaper reload ,"$wallpaper"

