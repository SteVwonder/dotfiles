if ! command -v codex &>/dev/null; then
  e_header "Installing Codex"
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

CODEX_DIR="$HOME/.codex"
mkdir -p "$CODEX_DIR"
