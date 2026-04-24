#!/usr/bin/env bash
# Idempotently installs the iTerm2 tab-state Codex lifecycle hook.
#
# It enables Codex hooks in ~/.codex/config.toml and injects hook entries into
# ~/.codex/hooks.json. Backups are written before modification.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
HOOK_SCRIPT="$DOTFILES_DIR/bin/agent-iterm-tab-state"
OLD_HOOK_SCRIPT="$SCRIPT_DIR/iterm-tab-state.sh"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
CONFIG="$CODEX_DIR/config.toml"
HOOKS="$CODEX_DIR/hooks.json"

if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq is required" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 is required" >&2
  exit 1
fi

if [[ ! -f "$HOOK_SCRIPT" ]]; then
  echo "error: hook script not found at $HOOK_SCRIPT" >&2
  exit 1
fi

mkdir -p "$CODEX_DIR"
[[ -f "$CONFIG" ]] || : > "$CONFIG"
[[ -f "$HOOKS" ]] || printf '{}\n' > "$HOOKS"

cp -- "$CONFIG" "$CONFIG.bak"
cp -- "$HOOKS" "$HOOKS.bak"
echo "backup: $CONFIG.bak"
echo "backup: $HOOKS.bak"

python3 - "$CONFIG" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text()

if text and not text.endswith("\n"):
    text += "\n"

features = re.search(r"(?m)^\[features\]\s*$", text)

if not features:
    if text and not text.endswith("\n\n"):
        text += "\n"
    text += "[features]\ncodex_hooks = true\n"
else:
    start = features.end()
    next_section = re.search(r"(?m)^\[[^]]+\]\s*$", text[start:])
    end = start + next_section.start() if next_section else len(text)
    section = text[start:end]
    if re.search(r"(?m)^\s*codex_hooks\s*=", section):
        section = re.sub(r"(?m)^(\s*codex_hooks\s*=\s*).*$", r"\1true", section)
    else:
        if section and not section.startswith("\n"):
            section = "\n" + section
        section = "\ncodex_hooks = true" + section
    text = text[:start] + section + text[end:]

path.write_text(text)
PY

tmp="$(mktemp)"
trap 'rm -f "$tmp" "$tmp.new"' EXIT

if ! jq empty "$HOOKS" >/dev/null 2>&1; then
  echo '{}' > "$tmp"
else
  cp -- "$HOOKS" "$tmp"
fi

command="$HOOK_SCRIPT"

install_event() {
  local evt="$1"
  local matcher="$2"

  jq --arg evt "$evt" --arg matcher "$matcher" --arg cmd "$command" --arg old_cmd "$OLD_HOOK_SCRIPT" '
    .hooks //= {}
    | .hooks[$evt] //= []
    | .hooks[$evt] |= [
        .[]
        | .hooks = ([.hooks[]? | select(.command != $cmd and .command != $old_cmd)])
        | select((.hooks | length) > 0)
      ]
    | .hooks[$evt] += [{
      matcher: $matcher,
      hooks: [{
        type: "command",
        command: $cmd,
        timeout: 2
      }]
    }]
  ' "$tmp" > "$tmp.new"
  mv -- "$tmp.new" "$tmp"
}

install_event SessionStart "startup|resume"
install_event UserPromptSubmit ""
install_event PreToolUse "Bash"
install_event PermissionRequest "Bash"
install_event PostToolUse "Bash"
install_event Stop ""

jq empty "$tmp"
mv -- "$tmp" "$HOOKS"
trap - EXIT

echo "installed: Codex iTerm2 tab-state hooks -> $HOOK_SCRIPT"
