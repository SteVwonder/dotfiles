HERDR_CONFIG_DIR="$HOME/.config/herdr"
HERDR_CONFIG="$HERDR_CONFIG_DIR/config.toml"
HERDR_DOTFILES_CONFIG="$DOTFILES/conf/herdr/config.toml"
HERDR_CONFIG_BACKUP="$HERDR_CONFIG.dotfiles-backup"

mkdir -p "$HERDR_CONFIG_DIR"

if [[ -e "$HERDR_CONFIG" && ! "$HERDR_CONFIG" -ef "$HERDR_DOTFILES_CONFIG" ]]; then
  if [[ -e "$HERDR_CONFIG_BACKUP" ]]; then
    e_error "Refusing to replace $HERDR_CONFIG; backup already exists at $HERDR_CONFIG_BACKUP."
    return 1
  fi
  e_arrow "Backing up $HERDR_CONFIG to $HERDR_CONFIG_BACKUP."
  mv "$HERDR_CONFIG" "$HERDR_CONFIG_BACKUP"
fi

e_success "Linking Herdr configuration."
ln -sfn "$HERDR_DOTFILES_CONFIG" "$HERDR_CONFIG"
