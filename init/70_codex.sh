CODEX_DIR="$HOME/.codex"
mkdir -p "$CODEX_DIR"

e_header "Installing Codex iTerm2 tab-state hooks"
bash "$DOTFILES/conf/codex/hooks/iterm-tab-state/install.sh"
