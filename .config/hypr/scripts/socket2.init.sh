#!/bin/sh

generate_colorscheme() {
  PYWAL_CACHE="${XDG_CACHE_HOME:-$HOME/.cache/wal}"
  mkdir -p "$PYWAL_CACHE"
  current_monitor=$(hyprctl monitors | grep Monitor | awk '{print $2}' | tail -n 1)
  next_wallpaper=$(hyprctl hyprpaper listactive | awk -F ' = ' -v mon="$current_monitor" '$1 == mon {print $2}')
  prev_wallpaper=$(cat $PYWAL_CACHE/wal)
  if [ "$next_wallpaper" = "$prev_wallpaper" ]; then
    return 0
  fi
  ln -f "$next_wallpaper" "$PYWAL_CACHE/hyprpaper"
  wal -stenq -i "$next_wallpaper"
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
  case "$line" in
    "openlayer>>hyprpaper")
      generate_colorscheme
      ;;
    "monitorremoved")
      killall hyprpaper && hyprctl dispatch exec hyprpaper
      killall waybar && hyprctl dispatch exec waybar
      ;;
  esac
done

