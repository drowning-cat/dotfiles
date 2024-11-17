#!/bin/sh -e

args=$@
f=
w=50%
h=50%

while [ "$#" -gt 0 ]; do
  case "$1" in
    -f) f="$2"; shift 2 ;;
    -w) w="$2"; shift 2 ;;
    -h) h="$2"; shift 2 ;;
    *) shift 1 ;;
  esac
done

if [ "$f" != 'open' ] && [ "$(tmux show -qv @popup_flag)" = 1 ]; then
  parent_session=$(tmux show -v @popup_parent_session)
  tmux detach
  # Unlock popup
  sleep .125
  tmux set -t $parent_session @popup_lock 0
else
  session_id=$(tmux display -p '#{session_id}')
  pane_current_path="$(tmux display -p '#{pane_current_path}')"

  popup_id=$(tmux ls -F '#{session_id}' -f "#{==:#{@popup_parent_session},$session_id}" | head -n1)
  if [ -z "$popup_id" ]; then
    popup_id=$(tmux new -d -P -F '#{session_id}') # Don't use "" to avoid $N expansion

    sid=$(echo -n $session_id | cut -c2-)
    pid=$(echo -n $popup_id | cut -c2-)
    tmux rename -t $popup_id "session_${sid}__popup_${pid}"
  else
    # Lock popup
    if [ "$(tmux show -t $session_id -qv @popup_lock)" = 1 ]; then
      exit 0
    fi
    tmux set -t $session_id @popup_lock 1
  fi

  tmux set -t $session_id @attached_popup $popup_id

  tmux set -t $popup_id @popup_parent_session $session_id
  tmux set -t $popup_id @popup_id $popup_id
  tmux set -t $popup_id @popup_flag 1
  tmux set -t $popup_id @popup_open_width $w
  tmux set -t $popup_id @popup_open_height $h
  tmux set -t $popup_id @popup_fullscreen 0

  tw=${popup_id}:0
  tp=${popup_id}:0.1

  tmux select-window -t $tw &>/dev/null || tmux new-window -t $tw
  tmux rename-window -t $tw ''

  if ! pgrep -P $(tmux display -t $tp -p '#{pane_pid}') &>/dev/null; then
    if [ "$pane_current_path" != "$(tmux display -t $tp -p '#{pane_current_path}')" ]; then
      tmux respawn-pane -t $tp -k -c "$pane_current_path"
    fi
  fi

  tmux popup -d "$pane_current_path" -w$w -h$h -E "tmux attach -t '$popup_id' &>/dev/null"
fi

