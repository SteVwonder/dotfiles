# Editing

if type emacsclient &> /dev/null; then
    EDITOR="emacsclient"
    alias emacs="emacsclient -c"
else
    EDITOR="emacs"
fi

magit() {
    MAGIT_REPO="${1:-$PWD}" emacs -t -u -a "" -e '(progn (magit-status (getenv "MAGIT_REPO")) (delete-other-windows))'
}

export EDITOR="${EDITOR}"
export SUDO_EDITOR=$EDITOR
export ALTERNATE_EDITOR=""
export VISUAL="$EDITOR"
