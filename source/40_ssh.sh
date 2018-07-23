IDENT="$DOTFILES/vendor/ssh-ident/ssh-ident"

alias ssh="$IDENT"
alias scp="BINARY_SSH=scp $IDENT"
alias rsync="BINARY_SSH=rsync $IDENT"
