if [ -f /etc/profile ]; then
    . /etc/profile
fi

if [ -f ~/.zsh_profile_LOCAL ]; then
    . ~/.zsh_profile_LOCAL
fi

if [ -f ~/.zshrc ]; then
    . ~/.zshrc
fi