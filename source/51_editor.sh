# Editing

if type emacsclient &> /dev/null; then
    EDITOR="emacsclient"
    alias emacsclient="TERM=$TERM emacsclient"
    alias emacs="emacsclient -c"
else
    EDITOR="emacs"
    alias emacs="TERM=$TERM emacs"
fi

export EDITOR="${EDITOR}"
export SUDO_EDITOR=$EDITOR
export ALTERNATE_EDITOR=""
export VISUAL="$EDITOR"
