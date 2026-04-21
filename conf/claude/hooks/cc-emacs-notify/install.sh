#!/usr/bin/env bash
# Idempotently injects cc-emacs-notify hook entries into ~/.claude/settings.json.
# Creates settings.json.bak before any modification.
#
# The hook script is referenced by its absolute path inside the dotfiles repo,
# so no symlinks are needed. Running this script on a new machine (after cloning
# dotfiles) wires up the hooks for the current user.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK_SCRIPT="$SCRIPT_DIR/notify.sh"
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

if [[ ! -f "$SETTINGS" ]]; then
  echo "error: $SETTINGS not found" >&2
  exit 1
fi

# Events this hook should fire on. Kept in sync with notify.sh.
EVENTS=(Notification PermissionRequest Stop UserPromptSubmit SessionEnd)

cp -- "$SETTINGS" "$BAK"
echo "backup: $BAK"

tmp="$(mktemp)"
trap 'rm -f "$tmp" "$tmp.new"' EXIT

cp -- "$SETTINGS" "$tmp"

for evt in "${EVENTS[@]}"; do
  jq --arg evt "$evt" --arg cmd "$HOOK_SCRIPT" '
    .hooks //= {}
    | .hooks[$evt] //= []
    | if any(.hooks[$evt][]?.hooks[]?; .command == $cmd)
      then .
      else .hooks[$evt] += [{
        matcher: "",
        hooks: [{
          type: "command",
          command: $cmd,
          timeout: 5,
          async: true
        }]
      }]
      end
  ' "$tmp" > "$tmp.new"
  mv -- "$tmp.new" "$tmp"
done

# Validate before overwriting.
jq empty "$tmp"

mv -- "$tmp" "$SETTINGS"
trap - EXIT

echo "installed: hook entries for ${EVENTS[*]} -> $HOOK_SCRIPT"
