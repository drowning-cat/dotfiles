#!/bin/sh

pid=$(pgrep -P $(tmux display -p '#{pane_pid}'))

if [ -z $pid ]; then
  tmux kill-pane
  exit 0
fi

name=$(ps -o args= -p "$pid")

confirm_kill_pane() {
  tmux confirm -p "Kill pane with running '$name'? [y/N]" kill-pane
  return 0
}

case "$name" in
  sudo*|'sudo pacman'*|paru*|nvim*)
    confirm_kill_pane
    ;;
  *) # man*|htop*|btop*)
    tmux kill-pane
    ;;
esac

