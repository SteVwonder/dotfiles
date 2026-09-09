# pi configuration (tracked in dotfiles)

This tracks the **portable** parts of this machine's [pi](https://pi.dev) setup.
Machine-specific bits (NVIDIA provider, locally-checked-out packages, creds)
are intentionally **not** committed.

## How it works — common.json is injected into a per-host settings.json

`settings.json` is a **per-host, git-ignored** file: pi writes to it freely
(theme, `lastChangelogVersion`, packages added by `pi install`), so it can't be
symlinked into the repo without leaking per-machine bits back into it.

Instead, the portable baseline lives in the repo as **`agent/common.json`**
(symlinked to `~/.pi/agent/common.json`) and the **`agent/extensions/
common-settings.ts`** extension injects it into the live `settings.json` on
startup:

- `packages` are **unioned** — machine packages (nv-inference, plan-mode) you
  added per-host are preserved.
- portable scalars (theme, UI/network settings, thinking level) come from
  `common.json`.
- machine keys (`defaultProvider`, `defaultModel`) are never touched — they
  come from the host's own `settings.json`.

When the repo's `common.json` is updated, `settings.json` re-syncs on the next
pi startup. If pi itself adds something portable to `settings.json`, move it
into `common.json` (an agent can do this) so it's shared.

## What's tracked & symlinked (repo = source of truth)

| file | purpose | auto-discovered by pi |
|------|---------|----------------------|
| `agent/common.json` | portable baseline (injected into settings.json) | — |
| `agent/extensions/exit-alias.ts` | `/clear` + `/exit` | ✅ |
| `agent/extensions/retry-prompt.ts` | `/retry` | ✅ |
| `agent/extensions/common-settings.ts` | injects common.json → settings.json | ✅ |
| `agent/open-tui.json` | TUI display prefs | via open-tui package |

`init/70_pi.sh` symlinks these individual files into `~/.pi/agent/...` and
seeds `settings.json` from `common.json` on first install.

## Per-host, NOT committed

- **`~/.pi/agent/settings.json`** — lives on the host, git-ignored. Holds the
  machine provider/model (`defaultProvider`/`defaultModel`) and machine package
  paths (nv-inference, nv-web-search, plan-mode) plus anything else pi adds.
- `~/.pi/agent/models.json`, `nvidia-gateway.json`, `auth.json` — provider
  registry / keys / gateway creds.
- `~/.pi/agent/herdr-agent-state.ts` — herdr-managed integration (reinstalled
  by herdr).
- `lazy.json`, `mcp-cache.json`, `mcp-onboarding.json`, `sessions/`,
  `missions/`, `run-history.jsonl`, `trust.json`, `extension-data/`, `npm/`.

Because `settings.json` is per-host, the machine paths never appear in the
repo at all — no leaking, no working-tree churn.

`agent/agents/`, `agent/prompts/`, and `packages/plan-mode/` are intentionally
not tracked here.
