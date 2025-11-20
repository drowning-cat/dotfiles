#!/bin/sh

session_id=$(tmux display -p '#{next_session_id}' | cut -c2-)
session_id=${session_id:-0}
alacritty -e tmux new-session -s "session_${session_id}__autoremove" ${1:+"$1"}

