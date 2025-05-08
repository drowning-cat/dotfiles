#!/bin/sh

device_name=$(iwctl device list | awk 'NR==5 {print $2}')
"$(dirname -- $0)/_float.sh" 'waybar-netiwd-popup' "iwctl station $device_name get-networks && iwctl"

