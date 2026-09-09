/**
 * /retry extension — force a retry of the last prompt without retyping.
 *
 * When pi hangs in the "Working..." state and will eventually die with
 * "Error: Request timed out", there's no built-in single-action retry: Esc
 * only aborts (and restores *queued* messages, not your submitted prompt),
 * and auto-retry only covers transient provider errors (overload/rate-limit/
 * 5xx), not timeouts. So you end up retyping "please continue".
 *
 * This registers `/retry`, which:
 *   1. Finds the last real user message in the session.
 *   2. If a turn is still running/hung, aborts it (ctx.abort()).
 *   3. Re-sends that message, triggering a fresh turn.
 *
 * Usage:
 *   /retry            - re-send the last user message
 *   /retry <prompt>   - re-send the given prompt instead (optional override)
 *
 * Auto-discovered from ~/.pi/agent/extensions/. Reload with /reload.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import type { ImageContent, TextContent } from "@earendil-works/pi-ai";

type UserContent = string | (TextContent | ImageContent)[];

/** Walk the branch backwards to the most recent non-empty real user message. */
function findLastUserMessage(ctx: {
	sessionManager: {
		getBranch(): { type: string; message?: { role?: string; content?: unknown } }[];
	};
}): { content: UserContent } | null {
	for (const entry of [...ctx.sessionManager.getBranch()].reverse()) {
		if (entry.type === "message" && entry.message?.role === "user") {
			const content = entry.message.content;
			if (typeof content === "string") {
				if (content.trim()) return { content };
			} else if (Array.isArray(content) && content.length > 0) {
				return { content: content as UserContent };
			}
		}
	}
	return null;
}

function preview(content: UserContent): string {
	if (typeof content === "string") {
		return content.length > 60 ? content.slice(0, 60) + "…" : content;
	}
	return content
		.map((c) => (c.type === "text" ? c.text : "[image]"))
		.join(" ");
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("retry", {
		description: "Abort the current turn (if any) and re-send the last prompt",
		handler: async (args, ctx) => {
			// Optional explicit override: "/retry <prompt>".
			const content: UserContent | null = args.trim()
				? args
				: findLastUserMessage(ctx)?.content ?? null;

			if (!content) {
				ctx.ui.notify("No previous user message to retry.", "warning");
				return;
			}

			if (!ctx.isIdle()) {
				// Cancel the hung/in-progress turn so the re-sent prompt can run.
				ctx.abort();
				ctx.ui.notify(`Aborting current turn; retrying: ${preview(content)}`, "info");
				// Delivered once the (now aborted) turn settles.
				await pi.sendUserMessage(content, { deliverAs: "steer" });
			} else {
				ctx.ui.notify(`Retrying: ${preview(content)}`, "info");
				await pi.sendUserMessage(content);
			}
		},
	});
}
