is_zsh || return 1 # only run under zsh

source $DOTFILES/vendor/antigen/bin/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle <<EOBUNDLES
 git
 command-not-found

 # Syntax highlighting bundle.
 zsh-users/zsh-syntax-highlighting
EOBUNDLES

# Load the theme.
antigen bundle agkozak/agkozak-zsh-prompt

# Tell Antigen that you're done.
antigen apply
