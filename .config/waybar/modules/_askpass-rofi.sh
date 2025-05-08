#!/bin/sh

rofi -dmenu -theme dmenu -password -p "Enter password:" || kill -9 "$PPID"

