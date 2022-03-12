#!/usr/bin/env sh
#
# Toggle the current window (all panes) between light and dark themes.
set -e

default_window_style='fg=white,bg=colour234'
default_active_style='fg=white,bg=black'

alternate_window_style='fg=black,bg=colour254'
alternate_active_style='fg=black,bg=white'

current_window_style=$(tmux show -Av window-style)

case $current_window_style in
    $default_window_style|'default')
        # Change to the alternate window style.
        tmux set -g window-style $alternate_window_style
        tmux set -g window-active-style $alternate_active_style
        ;;
    *)
        # Change back to the default window style.
        tmux set -g window-style $default_window_style
        tmux set -g window-active-style $default_active_style
        ;;
esac
