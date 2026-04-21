# consolidated-fleet-1

Federated OpenClaw fleet running on a single VPS (`lionel-consolidated-1` / `178.104.191.10`).

This repo is the **scaffolding + operational contents** of the fleet:
- per-bot workspaces (identity, memory, agent rules) under [`bots/`](bots/)
- systemd unit files under [`systemd/`](systemd/)
- fleet registry at [`manifest.yaml`](manifest.yaml)
- architecture + per-bot setup docs under [`docs/`](docs/)

**Excluded from this repo** (covered by VPS snapshots instead):
- Secrets: Discord tokens, OpenAI OAuth token stores, gateway auth tokens, GitHub PATs, per-bot `.env` files in `/etc/openclaw/`
- Rendered `openclaw.json` configs (contain Discord + gateway tokens inline — stored only on the server at `~/.openclaw/openclaw.json` per bot)
- Ephemeral / reference files the bots process at runtime

## Fleet

| Bot | Role | User | Port | Discord |
|---|---|---|---|---|
| Commander | orchestrator | `commander` | 19000 | Consolidated Commander 1 |
| Concert Marketing | worker | `concert-marketing` | 19001 | Consolidated Concert Marketing 1 |

See [`manifest.yaml`](manifest.yaml) for the authoritative registry and [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the federated model.

## Layout

```
consolidated-fleet-1/
├── manifest.yaml              # instance registry (source of truth)
├── systemd/                   # per-bot systemd unit files
│   ├── openclaw-commander.service
│   └── openclaw-concert-marketing.service
├── docs/
│   ├── ARCHITECTURE.md        # federated architecture reference
│   ├── PROVISIONING.md        # how to add a new worker
│   ├── COMMANDER_CONFIG.md    # commander-specific setup
│   └── CONCERT_MARKETING_CONFIG.md
└── bots/
    ├── commander/
    │   └── workspace/         # Commander's OpenClaw workspace (identity, memory, rules)
    └── concert-marketing/
        └── workspace/         # Concert Marketing's workspace
```

## VPS layout

- Repo clone lives at `/srv/consolidated-fleet` on the VPS.
- Each bot's `~/.openclaw/workspace` is a **symlink** into its `bots/<role>/workspace/` subdir.
- systemd unit files at `/etc/systemd/system/openclaw-<role>.service` are symlinked from `systemd/`.
