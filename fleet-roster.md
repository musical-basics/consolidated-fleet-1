# Consolidated Fleet Roster

> **Auto-generated from `manifest.yaml`. Do not edit by hand.**
> Regenerate with `python3 scripts/gen-fleet-roster.py`.

Host: `lionel-consolidated-1` (178.104.191.10)  
OpenClaw: `2026.4.15`  

---

## Active instances

### Consolidated Commander 1
- Key: `commander`
- Role: **orchestrator**
- Discord: `<@1496094900620492840>` (ID `1496094900620492840`)
- User/home: `commander` / `/home/commander`
- Systemd unit: `openclaw-commander.service`
- Gateway port: `19000` (loopback)
- Workspace: `bots/commander/workspace`
- Seed repo: `https://github.com/musical-basics/lionel-commander-openclaw.git`
- Status: `active`

### Consolidated Concert Marketing 1
- Key: `concert-marketing`
- Role: **worker** — domain: `concert-marketing`
- Reports to: **commander**
- Discord: `<@1496129135934705664>` (ID `1496129135934705664`)
- User/home: `concert-marketing` / `/home/concert-marketing`
- Systemd unit: `openclaw-concert-marketing.service`
- Gateway port: `19001` (loopback)
- Workspace: `bots/concert-marketing/workspace`
- Seed repo: `https://github.com/musical-basics/lionel-openclaw-3.git`
- Status: `active`

## Communication contract

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full federated model.

```
Lionel (DM) → Commander → #<worker-channel> → Worker
                  ▲                              │
                  └──── channel reply ◀──────────┘
                  │
                  ▼
Lionel (DM summary from Commander)
```

- Workers never DM Lionel.
- Workers do not coordinate directly with sibling workers; Commander mediates.
- When mentioning any bot in Discord, use `<@ID>` syntax — never plain-text display names.
- If this roster disagrees with `manifest.yaml`, `manifest.yaml` is authoritative. Regenerate.
