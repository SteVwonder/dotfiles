# Editing

if [[ "$(type -P emacsclient)" ]]; then
    EDITOR="emacsclient"
else
    EDITOR="emacs"
fi

export EDITOR
export SUDO_EDITOR=$EDITOR
export ALTERNATE_EDITOR=""
export VISUAL="$EDITOR"
alias q="$EDITOR"
