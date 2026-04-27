if ! command -v claude &>/dev/null; then
  e_header "Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

mkdir -p "$CLAUDE_DIR"
if [[ ! -f "$SETTINGS" ]]; then
  echo '{}' > "$SETTINGS"
fi

e_header "Installing cc-emacs-notify hooks"
bash "$DOTFILES/conf/claude/hooks/cc-emacs-notify/install.sh"

e_header "Installing Claude Tabtint plugin marketplace"
claude plugin marketplace add stevwonder/tabtint

e_header "Installing Claude Tabtint iTerm2 plugin"
claude plugin install tabtint-iterm2@tabtint
