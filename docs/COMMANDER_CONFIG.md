# Commander — Setup Config (post-migration)

Authoritative reference for the Commander instance of the consolidated fleet as it runs today (2026-04-21 onwards, post-migration to the federated model).

## What Commander is

- **Role**: orchestrator of the fleet (not a domain worker).
- **Owns**: cross-instance memory, human-facing communication, worker routing.
- **Communication contract**:
  - Lionel DMs Commander.
  - Commander posts in each worker's dedicated Discord channel.
  - Workers reply in their channel; Commander reads the channel and DMs Lionel a synthesized summary.
  - Lionel does not talk to workers directly, and workers do not DM Lionel.

## Current runtime state

| Field | Value |
|---|---|
| Host | `lionel-consolidated-1` (178.104.191.10) |
| Linux user | `commander` (uid 999, groups: `commander`, `fleet`) |
| Home | `/home/commander` |
| OpenClaw config | `/home/commander/.openclaw/openclaw.json` (mode 640, owner `commander:commander`) |
| Workspace | `/home/commander/.openclaw/workspace` → symlink → `/srv/consolidated-fleet/bots/commander/workspace` |
| Env file | `/etc/openclaw/commander.env` (mode 640, owner `root:commander`; currently empty) |
| Systemd unit | `openclaw-commander.service` (symlink to `/srv/consolidated-fleet/systemd/openclaw-commander.service`) |
| Gateway port | `19000` (loopback only) |
| Gateway auth token | stored in `openclaw.json` on server (not in this repo) |
| Model | `openai-codex/gpt-5.4` (set via `openclaw models set …`) |
| Codex OAuth profile | `openai-codex:yulionel829@gmail.com` — tokens in `/home/commander/.openclaw/agents/main/agent/auth-profiles.json` |
| Discord bot | **Consolidated Commander 1** — id `1496094900620492840` (3 privileged intents enabled) |
| Git auth | PAT at `/home/commander/.git-credentials` (mode 600), `git config --global user.name "Consolidated Commander 1"`, `user.email lionel@musicalbasics.com` |

## Systemd unit

Lives at `/srv/consolidated-fleet/systemd/openclaw-commander.service` (symlinked to `/etc/systemd/system/openclaw-commander.service`):

```ini
[Unit]
Description=OpenClaw Commander (Consolidated Fleet)
Documentation=https://docs.openclaw.ai
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=commander
Group=commander
WorkingDirectory=/home/commander
EnvironmentFile=-/etc/openclaw/commander.env
ExecStart=/usr/bin/openclaw gateway run
Restart=always
RestartSec=8s
TimeoutStopSec=20s

# Security hardening
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=full
ProtectHome=read-only
ReadWritePaths=/home/commander/.openclaw /srv/consolidated-fleet /tmp

[Install]
WantedBy=multi-user.target
```

## openclaw.json (shape; secrets redacted)

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
    "port": 19000,
    "bind": "loopback",
    "controlUi": { "enabled": true },
    "auth": { "mode": "token", "token": "<server-only>" }
  },
  "agents": {
    "defaults": {
      "models": { "openai-codex/gpt-5.4": {} },
      "model":  { "primary": "openai-codex/gpt-5.4" },
      "workspace": "/home/commander/.openclaw/workspace",
      "contextTokens": 200000,
      "compaction": { "mode": "safeguard" }
    }
  },
  "channels": {
    "discord": {
      "enabled": true,
      "token": "<server-only>",
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

- Contents: `IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `USER.md`, `MEMORY.md`, `memory/` tree (V2 structure: `projects/`, `people/`, `tools/`, `ideas/`, `summaries/`, `daily/`), `.learnings/`, `docs/`, `scripts/`.
- Seeded from `https://github.com/musical-basics/lionel-commander-openclaw.git` at HEAD `716bef9` (2026-04-21).
- Lives at `bots/commander/workspace/` inside this monorepo; reached from Commander's home via the workspace symlink.

## Operational commands

```bash
# Status
systemctl status openclaw-commander.service

# Live logs
journalctl -u openclaw-commander.service -f

# Restart (requires Lionel's explicit permission — see CLAUDE.md in Openclaw-Bots)
systemctl restart openclaw-commander.service

# Validate config
sudo -u commander openclaw config validate

# Check auth + model status
sudo -u commander bash -c 'cd /home/commander && openclaw models'

# Re-auth Codex (if OAuth expires)
sudo -u commander tmux new-session -s ocauth -x 200 -y 50
# Inside tmux: openclaw models auth login --provider openai-codex
# Full flow docs: Openclaw-Bots repo -> docs/openclaw/CODEX_AUTH_PROCESS.md
```

## Git auth (server-side)

`/home/commander/.git-credentials` holds a PAT in the form:
```
https://x-access-token:<github-pat>@github.com
```
Plus `git config --global credential.helper store`. Lets the `commander` user `git push`/`pull` against `musical-basics` org repos the PAT can reach.

**Rotation**: revoke at https://github.com/settings/tokens, regenerate, rewrite the file.

## Migration history

- **2026-04-21 morning**: provisioned as the *first* consolidated-fleet bot. Back then:
  - Linux user was `openclaw` with home `/home/commander` (name mismatch).
  - Systemd unit was `openclaw.service` (generic).
  - Workspace was a standalone git repo at `/home/commander/.openclaw/workspace`, tracking `consolidated-commander-1` (later renamed to `consolidated-fleet-1`).
- **2026-04-21 afternoon**: migrated to the federated model.
  - `usermod -l commander openclaw` + `groupmod -n commander openclaw`.
  - Repo restructured into a monorepo with per-bot subdirs (`bots/commander/workspace/`, etc.).
  - Workspace replaced with a symlink into the monorepo.
  - Systemd unit renamed to `openclaw-commander.service` and symlinked from `/srv/consolidated-fleet/systemd/`.
  - `/etc/openclaw/openclaw.env` renamed to `/etc/openclaw/commander.env`.
  - Pre-migration workspace backup: `/root/commander-workspace-pre-migrate-20260421-090257.tar.gz` on the VPS.

## See also
- [ARCHITECTURE.md](ARCHITECTURE.md) — federated model.
- [WORKER_CONFIG.md](WORKER_CONFIG.md) — generic worker spec.
- [PROVISIONING.md](PROVISIONING.md) — runbook for adding new workers.
- [../manifest.yaml](../manifest.yaml) — fleet registry.
