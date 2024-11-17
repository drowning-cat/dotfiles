#!/bin/sh

alacritty -e tmux new-session -s "__terminal-`cat /proc/sys/kernel/random/uuid`"

