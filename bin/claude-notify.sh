#!/bin/bash
# Send a desktop notification via tmux passthrough OSC 9
# Reads Claude Code hook JSON from stdin to extract project name

project=$(jq -r '.cwd // empty' 2>/dev/null | xargs basename 2>/dev/null)
title=${project:-claude}

# Write OSC 9 through tmux passthrough to the active client's tty
tty=$(tmux display-message -p '#{client_tty}' 2>/dev/null)
if [ -n "$tty" ]; then
    printf '\ePtmux;\e\e]9;[%s] Claude needs attention\a\e\\' "$title" > "$tty"
else
    printf '\a' > /dev/tty 2>/dev/null
fi
