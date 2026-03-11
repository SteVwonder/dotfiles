# Set TERM for emacs
if [[ -f /usr/share/terminfo/v/vscode-direct ]]; then
    TERM="vscode-direct"
    export COLORTERM=truecolor
else
    TERM="xterm-emacs"
fi

if [[ "$TERM" == "xterm-ghostty" ]]; then
    export TERM=xterm-256color
    export COLORTERM=truecolor
fi
