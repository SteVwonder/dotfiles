#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
HOOK_SCRIPT="$DOTFILES_DIR/bin/agent-iterm-tab-state"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

run_case() {
  local name="$1"
  local event="$2"
  local expected="$3"
  local tty_file="$tmpdir/$name.tty"
  local stdout_file="$tmpdir/$name.stdout"

  : > "$tty_file"
  printf '{"hook_event_name":"%s","session_id":"test","cwd":"/tmp"}' "$event" |
    CLAUDE_ITERM_TAB_TTY="$tty_file" "$HOOK_SCRIPT" > "$stdout_file"

  local actual
  actual="$(cat "$tty_file")"
  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL %s: expected OSC %q, got %q\n' "$name" "$expected" "$actual" >&2
    return 1
  fi

  if [[ -s "$stdout_file" ]]; then
    printf 'FAIL %s: hook wrote to stdout: %q\n' "$name" "$(cat "$stdout_file")" >&2
    return 1
  fi
}

run_case running UserPromptSubmit $'\033]1337;SetColors=tab=5fff87\a'
run_case tool PreToolUse $'\033]1337;SetColors=tab=5fff87\a'
run_case approval PermissionRequest $'\033]1337;SetColors=tab=ff5f87\a'
run_case idle Stop $'\033]1337;SetColors=tab=5fd7ff\a'
run_case session_end SessionEnd $'\033]1337;SetColors=tab=5fd7ff\a'

echo "ok"
