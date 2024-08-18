#!/bin/bash

PATH=$HOME/.dotfiles/bin:$PATH

if command -v j4-dmenu-desktop && command -v rofi; then
    exec j4-dmenu-desktop --usage-log=$HOME/.cache/j4-usage.log --dmenu='rofi -dmenu -i'
elif command -v j4-dmenu-desktop; then
    exec j4-dmenu-desktop --usage-log=$HOME/.cache/j4-usage.log
else
    exec i3-dmenu-desktop
fi
