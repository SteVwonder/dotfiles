FISH_CONFIG_DIRECTORY="$HOME/.config/fish/conf.d/"

mkdir -p "$FISH_CONFIG_DIRECTORY"
ln -sf $DOTFILES/conf/fish/dotfiles.fish "$FISH_CONFIG_DIRECTORY/"
