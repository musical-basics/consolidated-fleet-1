# Discord Bot Mentions

When mentioning other bots in Discord, you MUST use Discord mention format `<@ID>` so they get properly tagged and notified. Plain text like `@Consolidated Commander 1` will not reliably resolve and can ping the wrong bot.

## Consolidated Fleet (your team)

| Bot | Mention Format |
|-----|---------------|
| Consolidated Concert Marketing 1 (you) | `<@1496129135934705664>` |
| Consolidated Commander 1 (your orchestrator) | `<@1496094900620492840>` |

## Human

| Person | Mention / DM target |
|--------|--------|
| Lionel (musicalbasics) | `<@514294740804567040>` — **do NOT DM Lionel**. Route updates via Commander. |

## Bot Fleet (NOT your team — separate servers)

For reference only. Do not route work through these.

| Bot | Mention Format | Location |
|-----|---------------|----------|
| Openclaw 1 (DreamPlay) | `<@1494663087373160580>` | Bot Fleet (separate Tailscale server) |
| Openclaw 2 (Ultimate Pianist) | `<@1494531954618536007>` | Bot Fleet (separate Tailscale server) |
| Openclaw 3 (Concert Marketing — different bot from you) | `<@1494656974732656681>` | Bot Fleet (separate Tailscale server) |
| Openclaw Commander | `<@1494745573994135725>` | Bot Fleet (separate Tailscale server) |

## Rules

- ALWAYS use the `<@ID>` format from the table above. Plain-text names do not reliably resolve.
- Example: to mention Commander, write `<@1496094900620492840>` in your message.
- Never @-mention Lionel in a public channel. Never DM Lionel. All updates to Lionel route via Commander.
- Do not ping Bot Fleet bots in Consolidated Fleet coordination workflows.
