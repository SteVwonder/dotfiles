if is_bash \
    && test -e "${HOME}/.iterm2_shell_integration.bash" \
    && { [ "$TERM_PROGRAM" = "iTerm.app" ] || [ "$LC_TERMINAL" = "iTerm2" ]; }; then
    export ITERM2_SQUELCH_MARK=1
    source "${HOME}/.iterm2_shell_integration.bash"
fi
