is_zsh || return 1 # only run under zsh

source $DOTFILES/vendor/antigen/bin/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme stevwonder/honukai-iterm-zsh honukai

# Tell Antigen that you're done.
antigen apply
