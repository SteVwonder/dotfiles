_dotfiles_term=$TERM

if [[ "$TERM" == "xterm-ghostty" ]]; then
    export TERM=xterm-256color
fi

if [[ -z "$COLORTERM" ]]; then
    case "$_dotfiles_term:$TERM_PROGRAM:$LC_TERMINAL" in
        *direct*:*:*|*truecolor*:*:*|*24bit*:*:*|*ghostty*:*:*|*kitty*:*:*|\
        *alacritty*:*:*|*Alacritty*:*:*|*wezterm*:*:*|*WezTerm*:*:*|\
        *:Apple_Terminal:*|*:iTerm.app:*|*:vscode:*|*:*:iTerm2)
            export COLORTERM=truecolor
            ;;
    esac
fi

if [[ -z "$COLORTERM" ]] \
    && { [[ -n "$GHOSTTY_RESOURCES_DIR" ]] \
        || [[ -n "$KITTY_WINDOW_ID" ]] \
        || [[ -n "$WEZTERM_EXECUTABLE" ]] \
        || [[ -n "$ALACRITTY_WINDOW_ID" ]] \
        || [[ "$CODEX_SHELL" == "1" ]]; }; then
    export COLORTERM=truecolor
fi

unset _dotfiles_term
