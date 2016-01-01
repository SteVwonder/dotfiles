# Editing

if [[ ! "$SSH_TTY" ]] && is_osx; then
  export EDITOR='mvim'
  export LESSEDIT='mvim ?lm+%lm -- %f'
else
  export EDITOR='vim'
fi

if [[ "$(type -P emacsclient)" ]]; then
    EDITOR="emacsclient"
else
    EDITOR="emacs"
fi
export EDITOR
export SUDO_EDITOR=$EDITOR

export VISUAL="$EDITOR"
alias q="$EDITOR"
