CONFIG_DIRECTORY="$HOME/.config/"

if ! command -v lemonade &>/dev/null; then
  e_header "Installing lemonade"
  go install github.com/lemonade-command/lemonade@latest
fi

ln -sf $DOTFILES/conf/lemonade.toml "$CONFIG_DIRECTORY/"

if is_osx; then
  LAUNCH_AGENTS="$HOME/Library/LaunchAgents"
  cp $DOTFILES/conf/com.sherbein.lemonade.plist "$LAUNCH_AGENTS/"
fi
