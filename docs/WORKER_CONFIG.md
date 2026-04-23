# Worker — Setup Config (generic template)

This doc defines **what a worker is** in the consolidated fleet — the shape every worker conforms to. Individual workers get their own `<ROLE>_CONFIG.md` doc for actual values (see `CONCERT_MARKETING_CONFIG.md` as an instance).

For the **runbook** of how to provision a new worker, see [PROVISIONING.md](PROVISIONING.md).

## What a worker is

- **Role**: domain manager — owns one project / business line end to end.
- **Scope**: tactical execution within its domain; local repo state; local memory about its own domain.
- **Autonomy**: runs its own OpenClaw instance with its own workspace, own memory tree, own Discord bot.
- **Future**: each worker will get **sub-agents** (team-member bots) to help it. A worker is a manager of a future team. One manager per project.
- **Not allowed**: DM Lionel directly, message other workers directly, assume access to Commander's or another worker's filesystem.

## Communication contract (same for every worker)

```
Lionel (human)
   │ DM
   ▼
Commander  ──── posts in #<worker-channel> ───▶ Worker
   ▲                                              │
   │                channel reply                 │
   └──────────────────────────────────────────────┘
   │ DM summary
   ▼
Lionel
```

- Lionel DMs Commander only.
- Commander posts to the worker's dedicated Discord channel.
- The worker reads and responds **in that channel** (never DMs Lionel).
- Commander relays the summary to Lionel via DM.

Enforced via each worker's `AGENTS.md` rules (not code) — audit trail of Commander↔worker lives in the channel.

## Runtime footprint (parameterized — substitute `<role>`)

| Field | Pattern |
|---|---|
| Host | `lionel-consolidated-1` (178.104.191.10) — shared with Commander + all other workers |
| Linux user | `<role>` (unique uid per bot; member of `<role>` group and shared `fleet` group) |
| Home | `/home/<role>` |
| OpenClaw config | `/home/<role>/.openclaw/openclaw.json` (mode 640, owner `<role>:<role>`) |
| Workspace | `/home/<role>/.openclaw/workspace` → symlink → `/srv/consolidated-fleet/bots/<role>/workspace` |
| Env file | `/etc/openclaw/<role>.env` (mode 640, owner `root:<role>`; starts empty) |
| Systemd unit | `openclaw-<role>.service` → symlink → `/srv/consolidated-fleet/systemd/openclaw-<role>.service` |
| Gateway port | next free from [manifest.yaml](../manifest.yaml) → `ports.next_free` (workers start at 19001; increment as you add) |
| Gateway auth token | fresh `openssl rand -hex 24`, stored only on server |
| Model | `openai-codex/gpt-5.4` |
| Codex OAuth profile | `openai-codex:yulionel829@gmail.com` (shared account, **separate `auth-profiles.json` per bot** — workers don't share tokens) |
| Discord bot | dedicated app per worker; 3 privileged intents enabled (Presence, Server Members, Message Content) |
| Git auth | optional per-worker PAT at `/home/<role>/.git-credentials` — only set up if the worker itself needs to push/pull. Monorepo maintenance pulls happen as root by default |

## Systemd unit template

Fill in `<role>` below:

```ini
[Unit]
Description=OpenClaw <Role Title> Worker (Consolidated Fleet)
Documentation=https://docs.openclaw.ai
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=<role>
Group=<role>
WorkingDirectory=/home/<role>
EnvironmentFile=-/etc/openclaw/<role>.env
ExecStart=/usr/bin/openclaw gateway run
Restart=always
RestartSec=8s
TimeoutStopSec=20s

# Security hardening
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=full
ProtectHome=read-only
ReadWritePaths=/home/<role>/.openclaw /srv/consolidated-fleet /tmp

[Install]
WantedBy=multi-user.target
```

## openclaw.json template (shape; secrets not checked in)

Identical in shape to Commander's — only the `gateway.port`, `channels.discord.token`, `agents.defaults.workspace`, and (per-bot) `gateway.auth.token` differ.

```json
{
  "auth": {
    "profiles": {
      "openai-codex": { "provider": "openai-codex", "mode": "oauth" },
      "openai-codex:yulionel829@gmail.com": { "provider": "openai-codex", "mode": "oauth" }
    },
    "order": {
      "openai-codex": ["openai-codex:yulionel829@gmail.com", "openai-codex"],
      "openai":        ["openai-codex:yulionel829@gmail.com", "openai-codex"]
    }
  },
  "gateway": {
    "mode": "local",
    "port": <PORT>,
    "bind": "loopback",
    "controlUi": { "enabled": true },
    "auth": { "mode": "token", "token": "<gateway-token>" }
  },
  "agents": {
    "defaults": {
      "models": { "openai-codex/gpt-5.4": {} },
      "model":  { "primary": "openai-codex/gpt-5.4" },
      "workspace": "/home/<role>/.openclaw/workspace",
      "contextTokens": 200000,
      "compaction": { "mode": "safeguard" }
    }
  },
  "channels": {
    "discord": {
      "enabled": true,
      "token": "<discord-bot-token>",
      "groupPolicy": "open",
      "mediaMaxMb": 25,
      "allowBots": true,
      "dangerouslyAllowNameMatching": true,
      "actions": { "roles": true },
      "historyLimit": 50,
      "dmHistoryLimit": 50,
      "contextVisibility": "all",
      "eventQueue": { "listenerTimeout": 5000, "maxConcurrency": 1 }
    }
  },
  "tools": { "profile": "coding", "alsoAllow": ["message", "media", "fs"] }
}
```

## Workspace

- Lives in this monorepo at `bots/<role>/workspace/`.
- Reached from the worker's home via the symlink above.
- Contents follow V2 memory structure: `IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `USER.md`, `MEMORY.md`, `memory/{projects,people,tools,ideas,summaries,daily}/`, `.learnings/`, `docs/`.

### Seeding rules

When you add a worker, seed its workspace from the corresponding **existing Bot Fleet repo** (not from a template) — the seed carries accumulated domain memory:

| Worker | Seed repo |
|---|---|
| concert-marketing | `https://github.com/musical-basics/lionel-openclaw-3.git` |
| dreamplay | `https://github.com/musical-basics/lionel-openclaw-1.git` |
| ultimate-pianist | `https://github.com/musical-basics/lionel-openclaw-2.git` |
| *(future bot with no Bot Fleet origin)* | start fresh from the V2 template structure |

The worker can update its own `IDENTITY.md` / `MEMORY.md` at runtime to reflect its new bot identity (or Lionel tells it to). Do not rewrite seeded memory content manually unless asked.

## Upward memory promotion

Workers own their own memory tree. Durable/strategic/cross-domain signals flow upward to Commander via:
- The worker posting a summary in its channel → Commander reads → updates `bots/commander/workspace/memory/` if cross-cutting.
- Workers don't directly write into Commander's memory tree; Commander synthesizes.

## Codex OAuth (interactive — requires a browser)

Same flow for every bot, run **as the worker's user** (not root):

```bash
sudo -u <role> tmux new-session -d -s ocauth -x 220 -y 50 \
  'openclaw models auth login --provider openai-codex 2>&1; sleep 900'
sudo -u <role> tmux capture-pane -t ocauth -p
# Copy URL → open in browser → sign in with yulionel829@gmail.com
sudo -u <role> tmux send-keys -t <ocauth> -l '<callback-url>'
sudo -u <role> tmux send-keys -t ocauth Enter
sudo -u <role> tmux kill-session -t ocauth

# After auth, set default model to prevent gateway from auto-picking openai/gpt-5.4:
sudo -u <role> bash -c 'cd /home/<role> && openclaw models set openai-codex/gpt-5.4'
```

Tokens land in `/home/<role>/.openclaw/agents/main/agent/auth-profiles.json`.

## Operational commands (substitute `<role>`)

```bash
systemctl status  openclaw-<role>.service
systemctl restart openclaw-<role>.service   # requires explicit permission
journalctl -u     openclaw-<role>.service -f
sudo -u <role> openclaw config validate
sudo -u <role> bash -c 'cd /home/<role> && openclaw models'
```

## Instances (current + planned)

| Worker | Status | Port | Discord bot | Seed repo | Per-bot doc |
|---|---|---|---|---|---|
| Concert Marketing | active | 19001 | Consolidated Concert Marketing 1 (`1496129135934705664`) | lionel-openclaw-3 | [CONCERT_MARKETING_CONFIG.md](CONCERT_MARKETING_CONFIG.md) |
| DreamPlay | planned | 19002 | TBD | lionel-openclaw-1 | — |
| Ultimate Pianist | planned | 19003 | TBD | lionel-openclaw-2 | — |

## Sub-agents (future)

Each worker will eventually get its own team of sub-agents (design lead, copy lead, ops helper, etc.) — one manager per project. Architecture for sub-agents is TBD; this doc will be amended once decided.

## See also
- [ARCHITECTURE.md](ARCHITECTURE.md) — federated model.
- [COMMANDER_CONFIG.md](COMMANDER_CONFIG.md) — orchestrator setup.
- [PROVISIONING.md](PROVISIONING.md) — runbook for adding workers.
- [../manifest.yaml](../manifest.yaml) — fleet registry.
