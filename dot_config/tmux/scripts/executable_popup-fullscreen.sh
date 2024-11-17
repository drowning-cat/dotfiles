#!/bin/sh

args=$@
mw=95%
mh=95%

while [ "$#" -gt 0 ]; do
  case "$1" in
    -mw) mw="$2"; shift 2 ;;
    -mh) mh="$2"; shift 2 ;;
    *) shift 1 ;;
  esac
done

if [ $(tmux show -v @popup_flag) != 1 ]; then
  exit 1
fi

reopen() {
  session_id="$(display -p '#{session_id}')"
  tmux detach -E 'tmux wait -S detach'
  tmux wait detach
  tmux popup $@ -E "tmux attach -t '$session_id'" &>/dev/null
}

if [ $(tmux show -v @popup_fullscreen) = 1 ]; then
  w=$(tmux show -v @popup_open_width)
  h=$(tmux show -v @popup_open_height)
  tmux set @popup_fullscreen 0
  reopen -w $w -h $h
else
  tmux set @popup_fullscreen 1
  reopen -w $mw -h $mh
fi

