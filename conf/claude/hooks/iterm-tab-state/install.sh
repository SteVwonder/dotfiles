#!/usr/bin/env bash
# Idempotently injects iTerm2 tab-state hook entries into ~/.claude/settings.json.
# Creates settings.json.bak before any modification.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
HOOK_SCRIPT="$DOTFILES_DIR/bin/agent-iterm-tab-state"
OLD_HOOK_SCRIPT="$SCRIPT_DIR/iterm-tab-state.sh"
SETTINGS="${CLAUDE_SETTINGS:-$HOME/.claude/settings.json}"
BAK="$SETTINGS.bak"

if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq is required" >&2
  exit 1
fi

if [[ ! -f "$HOOK_SCRIPT" ]]; then
  echo "error: hook script not found at $HOOK_SCRIPT" >&2
  exit 1
fi

mkdir -p "$(dirname "$SETTINGS")"
[[ -f "$SETTINGS" ]] || printf '{}\n' > "$SETTINGS"

# Events this hook should fire on. Kept in sync with bin/agent-iterm-tab-state.
EVENTS=(
  SessionStart
  UserPromptSubmit
  PreToolUse
  PermissionRequest
  PostToolUse
  Notification
  Stop
  SessionEnd
)

cp -- "$SETTINGS" "$BAK"
echo "backup: $BAK"

tmp="$(mktemp)"
trap 'rm -f "$tmp" "$tmp.new"' EXIT

cp -- "$SETTINGS" "$tmp"

for evt in "${EVENTS[@]}"; do
  jq --arg evt "$evt" --arg cmd "$HOOK_SCRIPT" --arg old_cmd "$OLD_HOOK_SCRIPT" '
    .hooks //= {}
    | .hooks[$evt] //= []
    | .hooks[$evt] |= [
        .[]
        | .hooks = ([.hooks[]? | select(.command != $cmd and .command != $old_cmd)])
        | select((.hooks | length) > 0)
      ]
    | .hooks[$evt] += [{
      matcher: "",
      hooks: [{
        type: "command",
        command: $cmd,
        timeout: 2,
        async: true
      }]
    }]
  ' "$tmp" > "$tmp.new"
  mv -- "$tmp.new" "$tmp"
done

jq empty "$tmp"
mv -- "$tmp" "$SETTINGS"
trap - EXIT

echo "installed: hook entries for ${EVENTS[*]} -> $HOOK_SCRIPT"
