CODEX_DIR="$HOME/.codex"
mkdir -p "$CODEX_DIR"

e_header "Installing Codex Tabtint plugin marketplace"
codex plugin marketplace add stevwonder/tabtint --ref main
