/**
 * /exit and /clear alias extension.
 *
 * Registers `/exit` as an alias for the built-in `/quit` command (graceful
 * shutdown via ctx.shutdown()) and `/clear` as an alias for `/new` (start a
 * new session via ctx.newSession()), carrying over the current model and
 * thinking (effort) level into the new session.
 *
 * How carryover works: pi re-instantiates extensions for the replacement
 * session, so the fresh instance owns the new `pi` (the old one is stale and
 * session-bound). The /clear handler therefore writes the current model +
 * thinking level to a state file, and the new instance applies them on
 * `session_start` with reason "new", then deletes the file. The file is only
 * ever written by /clear, so plain pi startups and the built-in /new are
 * unaffected.
 *
 * Auto-discovered from ~/.pi/agent/extensions/. Reload with /reload.
 */

import { existsSync, readFileSync, unlinkSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type ThinkingLevel = "off" | "minimal" | "low" | "medium" | "high" | "xhigh" | "max";

const STATE_FILE = join(homedir(), ".pi", "agent", ".clear-carryover.json");

interface CarryoverState {
	provider?: string;
	modelId?: string;
	thinkingLevel?: ThinkingLevel;
}

export default function (pi: ExtensionAPI) {
	// New instance for the replacement session: re-apply model + effort.
	pi.on("session_start", async (event, ctx) => {
		if (event.reason !== "new") return;
		try {
			if (!existsSync(STATE_FILE)) return;
			const state = JSON.parse(readFileSync(STATE_FILE, "utf-8")) as CarryoverState;
			unlinkSync(STATE_FILE);

			if (state.provider && state.modelId) {
				const model = ctx.modelRegistry.find(state.provider, state.modelId);
				if (model) {
					const ok = await pi.setModel(model);
					if (!ok) {
						ctx.ui.notify(
							`/clear carryover: no API key for ${state.provider}/${state.modelId}`,
							"warning",
						);
					}
				}
			}
			if (state.thinkingLevel) {
				// Clamped to the model's capabilities automatically.
				pi.setThinkingLevel(state.thinkingLevel);
			}
		} catch {
			// Carryover is best-effort; never block session startup.
		}
	});

	pi.registerCommand("exit", {
		description: "Alias for /quit (quit pi)",
		handler: async (_args, ctx) => {
			ctx.shutdown();
		},
	});

	pi.registerCommand("clear", {
		description: "Alias for /new (start a new session, keeping model + effort)",
		handler: async (_args, ctx) => {
			const state: CarryoverState = {
				provider: ctx.model?.provider,
				modelId: ctx.model?.id,
				thinkingLevel: ctx.thinkingLevel,
			};
			writeFileSync(STATE_FILE, JSON.stringify(state));

			const result = await ctx.newSession();
			if (result.cancelled) {
				// Session replacement was vetoed; don't leave state behind.
				try {
					unlinkSync(STATE_FILE);
				} catch {
					// ignore
				}
			}
		},
	});
}
