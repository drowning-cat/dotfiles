#!/bin/sh

choices="shutdown;reboot;log out;suspend;hibernate"
chosen=$(echo "$choices" | tr ';' '\n' | rofi -dmenu -p "powermenu" -theme dmenu)

case "$chosen" in
'shutdown') shutdown now ;;
'reboot') reboot ;;
'log out') loginctl lock-session ;;
'suspend') systemctl suspend ;;
'hibernate') systemctl hibernate ;;
*) exit 0 ;;
esac
