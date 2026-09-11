# Global instructions

- Tool call display summaries (the short `displaySummary` snippet pi shows for each tool call) must ALWAYS be written in English, regardless of the language of the user's request.
- `find /` (searching the whole filesystem from root) is almost never the right tool to run — it is extremely slow. Prefer targeted finds scoped to a specific directory (e.g. `find <repo>/<subdir>`) whenever possible.
