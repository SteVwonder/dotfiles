if is_bash; then
    export ITERM2_SQUELCH_MARK=1
    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi
