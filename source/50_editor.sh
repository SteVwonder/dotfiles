# Editing

if type emacsclient > /dev/null; then
    EDITOR="emacsclient -c"
else
    EDITOR="emacs"
fi

export EDITOR="${EDITOR}"
export SUDO_EDITOR=$EDITOR
export ALTERNATE_EDITOR=""
export VISUAL="$EDITOR"
alias q="$EDITOR"
alias emacs="$EDITOR"
