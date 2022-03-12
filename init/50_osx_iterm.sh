# OSX-only stuff. Abort if not OSX.
#is_osx || return 1

ITERM_SCRIPT_DIRECTORY="$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"

mkdir -p "$ITERM_SCRIPT_DIRECTORY"
ln -sf $DOTFILES/conf/osx/iterm2/theme.py "$ITERM_SCRIPT_DIRECTORY/"
