#!/usr/bin/env bash
# Notifies a running Emacs (via emacsclient) when a Claude Code instance
# is blocked waiting on input, so tabspaces hosting blocked CC instances
# can be surfaced visually and via a picker command.
#
# Reads CC's hook JSON from stdin. Dispatches on hook_event_name:
#   PermissionRequest        -> mark blocked (state: permission)
#   Notification, Stop       -> mark blocked (state: idle)
#   UserPromptSubmit, SessionEnd -> clear blocked state
#
# Failures are swallowed: this hook must never block Claude Code.

set -u

payload=$(cat)

# Missing jq is not fatal; just exit.
command -v jq >/dev/null 2>&1 || exit 0
command -v emacsclient >/dev/null 2>&1 || exit 0

cwd=$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null)
event=$(printf '%s' "$payload" | jq -r '.hook_event_name // empty' 2>/dev/null)
session_id=$(printf '%s' "$payload" | jq -r '.session_id // empty' 2>/dev/null)

[[ -z "$cwd" || -z "$event" ]] && exit 0

case "$event" in
  PermissionRequest)            fn="my/cc-mark-blocked";   state="permission" ;;
  Notification|Stop)            fn="my/cc-mark-blocked";   state="idle" ;;
  UserPromptSubmit|SessionEnd)  fn="my/cc-mark-unblocked"; state="" ;;
  *) exit 0 ;;
esac

# Escape backslashes and double quotes for embedding in an elisp string.
esc() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'; }

cwd_e=$(esc "$cwd")
state_e=$(esc "$state")
sid_e=$(esc "$session_id")

emacsclient --no-wait \
  --eval "($fn \"$cwd_e\" \"$state_e\" \"$sid_e\")" \
  >/dev/null 2>&1 || true

exit 0
