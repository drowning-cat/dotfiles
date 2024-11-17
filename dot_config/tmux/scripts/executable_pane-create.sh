#!/bin/sh

calc() {
  awk "BEGIN { print $1 }"
}

cell_width=$(tmux display -p '#{window_cell_width}')
cell_height=$(tmux display -p '#{window_cell_height}')
cell_ratio=$(calc "$cell_width / $cell_height")

pane_height=$(tmux display -p '#{pane_height}')
pane_width=$(tmux display -p '#{pane_width}')
pane_width=$(calc "int($pane_width * $cell_ratio / 1)")

if [ $pane_height -le 2 ] || [ $pane_width -le 2 ]; then
  exit 0
fi

if [ $pane_width -gt $pane_height ]; then
  tmux split-window -h -c '#{pane_current_path}'
else
  tmux split-window -v -c '#{pane_current_path}'
fi

