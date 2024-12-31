#!/bin/bash

STEP=2
UNIT="%"   # dB, %, etc.
SETVOL="/usr/bin/amixer -qc 0 set Master"
MUTE="pactl set-sink-mute 0 toggle"
DIRECTION=$1

case "$1" in
    "up")
          $SETVOL $STEP$UNIT+
          ;;
  "down")
          $SETVOL $STEP$UNIT-
          ;;
  "mute")
          $MUTE
          ;;
esac

STATE=$(amixer get Master | grep 'Mono:' | grep -o "\[on\]")
VOLUME=$(amixer get Master | grep -oE '\[[0-9]+%\]' | sed -r 's/\[([0-9]+)%]/\1/' | head -n1)

# Show volume with volnoti
if [[ -n $STATE ]]; then
    volnoti-show $VOLUME
else
    volnoti-show -m $VOLUME
fi

exit 0
