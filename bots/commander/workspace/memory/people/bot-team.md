# Bot Team

> The **Consolidated Fleet** operating under Lionel's direction. This is *your* team — the bots you coordinate. The original Bot Fleet (separate Tailscale servers `lionel-openclaw-*` + `lionel-commander-openclaw`) is preserved below as historical reference but is **not** your team and you do not route work to it.

## Consolidated Commander 1 (you)
- Discord ID: `1496094900620492840` — mention as `<@1496094900620492840>`
- Role: orchestrator — owns fleet-wide memory, human-facing communication, worker routing
- Host: `lionel-consolidated-1` (178.104.191.10)
- User/home: `commander` / `/home/commander`
- Systemd unit: `openclaw-commander.service`
- Gateway port: 19000

## Consolidated Concert Marketing 1
- Discord ID: `1496129135934705664` — mention as `<@1496129135934705664>`
- Role: worker — concert marketing domain (Belgium concert campaign, landing pages, copy, organizer ops)
- Reports to: you
- Channel: `#concert-marketing` (you post there; the worker replies there; you DM Lionel the summary)
- Host: `lionel-consolidated-1`
- User/home: `concert-marketing` / `/home/concert-marketing`
- Systemd unit: `openclaw-concert-marketing.service`
- Gateway port: 19001
- Seeded from Bot Fleet's Openclaw 3 workspace (`lionel-openclaw-3`) on 2026-04-21

## Future Consolidated Fleet members
- **Consolidated DreamPlay 1** — planned, port 19002, will seed from `lionel-openclaw-1`
- **Consolidated Ultimate Pianist 1** — planned, port 19003, will seed from `lionel-openclaw-2`

## Communication flow (federated)

```
Lionel (DM) → Commander → #<worker-channel> → Worker
                  ▲                              │
                  └──── channel reply ◀──────────┘
                  │
                  ▼
Lionel (DM summary from Commander)
```

- Lionel only DMs you.
- You post in each worker's dedicated channel (`#concert-marketing`, future `#dreamplay`, `#ultimate-pianist`).
- Workers reply in their channel (they do not DM Lionel directly).
- You read the channel, synthesize, and DM Lionel a summary.

## Structural note
Each core business line gets a dedicated worker bot. You coordinate across all of them. Each worker is a "manager" of its domain; sub-agents may be added to each worker later (one manager per project, with helpers beneath).

---

## Historical reference — the Bot Fleet (NOT your team)

The Bot Fleet runs on separate servers (each on its own Tailscale-joined VPS) and is independent of the Consolidated Fleet. Do **not** delegate Consolidated Fleet work to these bots.

- **Openclaw 1 — DreamPlay** (Bot Fleet): `<@1494663087373160580>`, server `lionel-openclaw` (Tailscale 100.72.133.40), repo `lionel-openclaw-1`
- **Openclaw 2 — Ultimate Pianist** (Bot Fleet): `<@1494531954618536007>`, server `lionel-openclaw-2` (Tailscale 100.90.54.22), repo `lionel-openclaw-2`
- **Openclaw 3 — Concert Marketing** (Bot Fleet): `<@1494656974732656681>`, server `lionel-openclaw-3` (Tailscale 100.95.180.106), repo `lionel-openclaw-3`
- **Openclaw Commander** (Bot Fleet's commander, not you): `<@1494745573994135725>`, server `lionel-commander-openclaw` (Tailscale 100.87.56.101), repo `lionel-commander-openclaw`

### Updated

- 2026-04-21 — Rewrote for the Consolidated Fleet. Moved Bot Fleet details to historical section. Updated own identity: was "Openclaw Commander" on `lionel-commander-openclaw` (Discord `1494745573994135725`); now "Consolidated Commander 1" on `lionel-consolidated-1` (Discord `1496094900620492840`).
- 2026-04-18 — (prior) Clarified that agent roles are the primary structural concept to remember.
- 2026-04-17 — (prior) Created from Discord role check-in responses.
