#!/bin/sh

file="$HOME/.local/share/chezmoi/.chezmoidata/packages.yaml"

cat << EOF > $file
packages:
  arch:
    paru:
EOF

paru -Qeq | sed -e "s/^/    - '/;s/$/'/" >> $file

