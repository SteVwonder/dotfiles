#!/bin/bash

if command -v dmenu-frecency; then
    exec dmenu-frecency
elif command -v j4-dmenu-desktop && command -v rofi; then
    exec j4-dmenu-desktop --usage-log=~/.cache/j4-usage.log --dmenu='rofi -dmenu -i'
elif command -v j4-dmenu-desktop; then
    exec j4-dmenu-desktop --usage-log=~/.cache/j4-usage.log
else
    exec i3-dmenu-desktop
fi
