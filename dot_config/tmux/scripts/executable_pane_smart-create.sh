#!/bin/sh

APPROX_CURSOR_RATIO=0.45

calc() {
  awk "BEGIN {print int($1)}"
}

pane_height=$(tmux display-message -p "#{pane_height}")

pane_width=$(tmux display-message -p "#{pane_width}")
pane_width=$(calc "$pane_width * $APPROX_CURSOR_RATIO / 1")

if [ $pane_height -le 2 ] || [ $pane_width -le 2 ]; then
  exit 0
fi

if [ $pane_width -gt $pane_height ]; then
  tmux split-window -h -c '#{pane_current_path}'
else
  tmux split-window -v -c '#{pane_current_path}'
fi

