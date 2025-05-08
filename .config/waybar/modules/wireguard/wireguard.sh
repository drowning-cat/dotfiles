#!/bin/sh

arg_cmd="$1"
arg_interface="${2:-wg0}"

OPENED='{"text":"Connected","class":"connected","alt":"connected"}'
CLOSED='{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'

_sudo() {
  SUDO_ASKPASS="$(dirname -- $0)/../_askpass-rofi.sh" sudo -A $@
}

case "$arg_cmd" in
  --status)
    find /sys/class/net -name "$arg_interface" | grep -q "." && echo "$OPENED" || echo "$CLOSED"
    ;;
  --toggle)
    _sudo wg-quick down "$arg_interface" || _sudo wg-quick up "$arg_interface"
    ;;
esac

