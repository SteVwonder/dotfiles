if type direnv &> /dev/null; then
    if is_bash; then
        eval "$(direnv hook bash)"
    elif is_zsh; then
        eval "$(direnv hook zsh)"
    fi
fi
