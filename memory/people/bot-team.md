# Bot Team

> The OpenClaw bot fleet operating under Lionel's direction.

## Openclaw 1 — DreamPlay
- Discord ID: 1494663087373160580
- Role: DreamPlay Tier 1
- Focus: practical DreamPlay product/business work, preorder customer portal, preorder updates, core product rules
- Upward context to Commander: DreamPlay priorities, major blockers, customer-risk signals, hard constraints (One vs Pro distinction, gold is Pro-only, portal/preorder status), and anything involving refunds, pricing, Stripe, customer complaints, public delivery statements, or manufacturing that needs escalation to Lionel
- Server: lionel-openclaw (Tailscale 100.72.133.40)
- Repo: github.com/musical-basics/lionel-openclaw-1

## Openclaw 2 — Ultimate Pianist
- Discord ID: 1494531954618536007
- Role: execution, Ultimate Pianist Bot
- Focus: pianist-facing execution, memory/continuity, practical project follow-through
- Upward context to Commander: concrete build status, implementation details, blockers, next-step decisions, and durable context from DreamPlay, Ultimate Pianist, and related execution work
- Server: lionel-openclaw-2 (Tailscale 100.90.54.22)
- Repo: github.com/musical-basics/lionel-openclaw-2

## Openclaw 3 — Concert Marketing
- Discord ID: 1494656974732656681
- Role: concert-marketing
- Focus: high-level concert marketing plus worker-level execution planning for the Belgium concert campaign when explicitly delegated
- Upward context to Commander: concert priorities, audience/messaging direction, promotion status, the Belgium concert source-of-truth brief, and execution drafts such as content calendars, sales updates, and Luc update-email drafts
- Server: lionel-openclaw-3 (Tailscale 100.95.180.106)
- Repo: github.com/musical-basics/lionel-openclaw-3

## Openclaw Commander (this bot)
- Discord ID: 1494745573994135725
- Role: high-level coordination, memory, and oversight
- The other three bots contribute context upward to Commander
- Commander holds the big picture; the other bots execute
- Server: lionel-commander-openclaw (Tailscale 100.87.56.101)
- Repo: github.com/musical-basics/lionel-commander-openclaw

## Structural note
The most important organization principle in the Musical Basics server is the agent-role split.
Each core business line has a dedicated worker bot, and Commander coordinates across all of them.
Business framing matters, but durable memory should prioritize which agent owns what.

### Updated

2026-04-18 — Clarified that agent roles are the primary structural concept to remember
2026-04-17 — Created from Discord role check-in responses
