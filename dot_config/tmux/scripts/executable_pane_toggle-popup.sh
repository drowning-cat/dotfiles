#!/bin/sh

args=$@
s="popup"

while [ "$#" -gt 0 ]; do
  case "$1" in
    -s) s="$2"; shift 2 ;;
     *) shift 1 ;;
  esac
done

if [ "$(tmux display-message -p -F "#{session_name}")" = "$s" ]; then
  tmux detach-client
else
  tmux popup -d '#{pane_current_path}' -E $args "tmux attach -t '$s' &>/dev/null || tmux new -s '$s'"
fi

