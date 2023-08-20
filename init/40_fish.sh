FISH_CONFIG_DIRECTORY="$HOME/.config/fish/"
FISH_CONFD_DIRECTORY="$FISH_CONFIG_DIRECTORY/conf.d/"

mkdir -p "$FISH_CONFD_DIRECTORY"
ln -sf $DOTFILES/conf/fish/fish_plugins "$FISH_CONFIG_DIRECTORY/"
ln -sf $DOTFILES/conf/fish/dotfiles.fish "$FISH_CONFD_DIRECTORY/"
