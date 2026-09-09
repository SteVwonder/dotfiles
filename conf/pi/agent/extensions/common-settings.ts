/**
 * common-settings.ts — keep the per-host settings.json in sync with the
 * dotfiles-tracked portable baseline (common.json).
 *
 * WHY THIS EXISTS
 * pi's ~/.pi/agent/settings.json is a per-host, git-ignored file: pi writes to
 * it freely (theme, lastChangelogVersion, packages added by `pi install`), so
 * it can't be symlinked into the dotfiles repo without leaking per-machine
 * bits back into it. Instead the portable baseline lives in the repo
 * (`conf/pi/agent/common.json`, symlinked to ~/.pi/agent/common.json) and this
 * extension injects it into the live settings.json on startup:
 *
 *   - `packages` are UNIONED — machine packages (nv-inference, plan-mode) that
 *     the host added are preserved, never dropped.
 *   - portable scalar keys (theme, UI/network settings, thinking level) are
 *     applied from common.json.
 *   - machine-only keys (`defaultProvider`, `defaultModel`) are never touched —
 *     they come from the host's own settings.json.
 *
 * A repo update to common.json propagates to settings.json on the next startup.
 * Auto-discovered from ~/.pi/agent/extensions/. Reload with /reload.
 */
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const AGENT_DIR = join(homedir(), ".pi", "agent");
const COMMON_FILE = join(AGENT_DIR, "common.json");
const SETTINGS_FILE = join(AGENT_DIR, "settings.json");

/** Portable scalar keys that common.json owns. Machine keys are excluded. */
const PORTABLE_KEYS = [
	"theme",
	"hideThinkingBlock",
	"retry",
	"httpIdleTimeoutMs",
	"defaultThinkingLevel",
];

function readJson(path: string): Record<string, unknown> | null {
	try {
		if (!existsSync(path)) return null;
		const v = JSON.parse(readFileSync(path, "utf-8"));
		return v && typeof v === "object" ? (v as Record<string, unknown>) : null;
	} catch {
		return null;
	}
}

function stringify(v: unknown): string {
	return JSON.stringify(v);
}

/** Merge common.json's portable bits into the live settings.json (idempotent). */
function syncFromCommon(): void {
	const common = readJson(COMMON_FILE);
	if (!common) return;

	const settings = readJson(SETTINGS_FILE) ?? {};

	// Union `packages` — keep every machine package the host already has.
	// Iterate existing-first so a file that already contains everything stays
	// byte-identical (no churn); append only common packages that are missing.
	const commonPkgs = Array.isArray(common.packages) ? (common.packages as unknown[]) : [];
	const existingPkgs = Array.isArray(settings.packages) ? (settings.packages as unknown[]) : [];
	const packages: unknown[] = [];
	const seen = new Set<string>();
	for (const p of [...existingPkgs, ...commonPkgs]) {
		const key = typeof p === "string" ? p : (p as Record<string, unknown>)?.source ?? stringify(p);
		if (!seen.has(key)) {
			seen.add(key);
			packages.push(p);
		}
	}
	if (packages.length) settings.packages = packages;

	// Apply portable scalars from common.json (repo wins for these keys).
	for (const key of PORTABLE_KEYS) {
		if (common[key] !== undefined) settings[key] = common[key];
	}

	// Write only if something changed.
	try {
		const raw = readFileSync(SETTINGS_FILE, "utf-8");
		if (JSON.stringify(settings) === JSON.stringify(JSON.parse(raw))) return;
	} catch {
		// settings.json missing/unreadable — fall through to write.
	}
	writeFileSync(SETTINGS_FILE, JSON.stringify(settings, null, 2) + "\n");
	// eslint-disable-next-line no-console
	console.log("[common-settings] synced settings.json from common.json");
}

export default function (_pi: ExtensionAPI) {
	syncFromCommon();
}
