#!/bin/sh -e

images=$(find "${XDG_PICTURES_DIR:-$HOME/Pictures}/Wallpapers" -maxdepth 1 -type f | sort)
imgnum=$(echo "$images" | wc -l)

maxrow=2

cols=5
rows=$(((imgnum + cols) / cols))
rows=$((rows > maxrow ? maxrow : rows))

wallpaper=$(
  for i in $images; do printf "$i\x00icon\x1f$i\n"; done |
    rofi -dmenu -theme imgselect -theme-str "listview {columns:$cols;lines:$rows;}"
)

hyprctl hyprpaper wallpaper ,"$wallpaper"
ln -f "$wallpaper" "${XDG_CACHE_HOME:-$HOME/hyprpaper}"
