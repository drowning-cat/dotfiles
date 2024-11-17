#!/bin/sh

if [ -n $(tmux show -qv @attached_popup) ]; then
  tmux kill-session -t $(tmux show -qv @attached_popup)
fi

# Hack: if the last opened session was a 'popup'
if [ $(tmux show -qv @popup_flag) = 1 ]; then
  tmux kill-session
fi

