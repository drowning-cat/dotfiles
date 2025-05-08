#!/bin/sh

arg_cmd="$1"

WAIT_FILE="/tmp/waybar-auto-cpufreq-wait"

get_governor() {
  cpufreqctl.auto-cpufreq --governor --core=0
}

set_governor() {
  SUDO_ASKPASS="$(dirname -- $0)/../_askpass-rofi.sh" sudo -A true
  if [ $? = 0 ]; then
    governor="$(get_governor)"
    power_on="$(cat /sys/class/power_supply/AC/online)"
    set_wait() {
      echo "$governor" > "$WAIT_FILE"
    }
    if [ "$1" = 'reset' ]; then
      [ "$power_on" = 1 ] && [ "$governor" = 'powersave' ] && set_wait
      [ "$power_on" = 0 ] && [ "$governor" = 'performance' ] && set_wait
    else
      set_wait
    fi
  fi
  sudo auto-cpufreq --force "$1"
}

case "$arg_cmd" in
  --status)
    governor="$(get_governor)"
    display=
    case "$governor" in
      "powersave") display="[save]" ;; "performance") display="[perf]" ;;
    esac
    if [ -f "$WAIT_FILE" ] && [ "$(cat "$WAIT_FILE")" == "$governor" ]; then
      printf '{"text":"%s", "class":"wait"}' "$display"
    else
      # `governor` should not be the same as WAIT_FILE governor
      printf '{"text":"%s"}' "$display"
    fi
    ;;
  --next)
    governor="$(get_governor)"
    next=
    case "$governor" in
      "powersave") next="performance" ;; "performance"|*) next="powersave" ;;
    esac
    set_governor "$next"
    ;;
  --reset)
    set_governor 'reset'
    ;;
esac

