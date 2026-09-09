#!/usr/bin/env bash
# 70_pi.sh — link pi config from the dotfiles repo into ~/.pi/agent/.
#
# Why not the generic /link step: that only symlinks *top-level* ~/ entries
# (ln -s link/.pi ~/.pi, backing up any existing dir). ~/.pi is a mix of
# trackable files and per-host state, so this links individual files instead.
#
#   common.json  -> symlinked (repo = truth, portable baseline). Its contents
#                   are injected into the per-host settings.json by the
#                   common-settings extension.
#   extensions/  -> symlinked, auto-discovered by pi (exit-alias, retry-prompt,
#                   common-settings).
#   open-tui.json-> symlinked (read-only config for the open-tui display pkg).
#
#   settings.json is intentionally NOT symlinked — it's per-host and git-ignored
#   (pi writes to it freely). It's seeded from common.json only on first install.
#
# Idempotent: safe to run on every `dotfiles` invocation.

PI_AGENT="$HOME/.pi/agent"
DOTFILES_PI="$DOTFILES/conf/pi/agent"

[[ -n "$DOTFILES" ]] || DOTFILES="$HOME/.dotfiles"

e_header "Linking pi configuration"

mkdir -p "$PI_AGENT/extensions"

for src in "$DOTFILES_PI"/extensions/*.ts; do
  [[ -e "$src" ]] || continue
  ln -sfn "$src" "$PI_AGENT/extensions/$(basename "$src")"
  e_success "Linked extensions/$(basename "$src")"
done

[[ -f "$DOTFILES_PI/open-tui.json" ]] && \
  ln -sfn "$DOTFILES_PI/open-tui.json" "$PI_AGENT/open-tui.json"

# pi-tool-display-intent: tool-call aggregation config (repo = source of truth).
TOOL_DISPLAY_SRC="$DOTFILES_PI/extension-data/pi-tool-display-intent/config.json"
if [[ -f "$TOOL_DISPLAY_SRC" ]]; then
  TOOL_DISPLAY_DIR="$PI_AGENT/extension-data/pi-tool-display-intent"
  mkdir -p "$TOOL_DISPLAY_DIR"
  ln -sfn "$TOOL_DISPLAY_SRC" "$TOOL_DISPLAY_DIR/config.json"
  e_success "Linked extension-data/pi-tool-display-intent/config.json"
fi

# Portable baseline: symlink it (repo is source of truth).
ln -sfn "$DOTFILES_PI/common.json" "$PI_AGENT/common.json"
e_success "Linked common.json"

# Per-host settings.json: seed once from the portable baseline if absent.
# Each host then adds its machine provider/model + packages locally.
if [[ ! -e "$PI_AGENT/settings.json" ]]; then
  cp "$DOTFILES_PI/common.json" "$PI_AGENT/settings.json"
  e_arrow "Seeded settings.json from common.json — add your machine provider/model/packages"
fi

e_success "pi configuration linked"
