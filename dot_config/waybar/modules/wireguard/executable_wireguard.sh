#!/bin/sh

SCRIPT_SRC=`dirname -- $0`

arg_cmd="$1"
arg_interface="${2:-wg0}"

case "$arg_cmd" in
  --status)
    OPENED='{"text":"Connected","class":"connected","alt":"connected"}'
    CLOSED='{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'
    find /sys/class/net -name "$arg_interface" | grep -q "." && echo "$OPENED" || echo "$CLOSED"
    ;;
  --toggle)
    SUDO_ASKPASS=$SCRIPT_SRC/askpass-rofi.sh sudo -A wg-quick down "$arg_interface" ||\
    SUDO_ASKPASS=$SCRIPT_SRC/askpass-rofi.sh sudo -A wg-quick up "$arg_interface"
    ;;
esac

