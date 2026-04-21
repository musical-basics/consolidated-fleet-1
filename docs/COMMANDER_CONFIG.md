# Commander — Setup Config

**Role**: orchestrator (owns fleet-wide memory, relays between Lionel and workers)
**Host**: `lionel-consolidated-1` (178.104.191.10)
**User**: `commander` (uid 999)
**Home**: `/home/commander`
**Workspace**: `/home/commander/.openclaw/workspace` → `/srv/consolidated-fleet/bots/commander/workspace`
**Gateway port**: 19000 (loopback)
**Systemd unit**: `openclaw-commander.service` → `/srv/consolidated-fleet/systemd/openclaw-commander.service`
**Env file**: `/etc/openclaw/commander.env`

---

## Codex OAuth

- Auth profile: `openai-codex:yulionel829@gmail.com` (OAuth)
- Model: `openai-codex/gpt-5.4` (set via `openclaw models set openai-codex/gpt-5.4`)
- OAuth tokens stored in `/home/commander/.openclaw/agents/main/agent/auth-profiles.json`

## Discord

- Bot: **Consolidated Commander 1**
- Bot ID: `1496094900620492840`
- Token: stored in `/home/commander/.openclaw/openclaw.json` on server (NOT in this repo)
- Privileged gateway intents: all 3 enabled (Presence, Server Members, Message Content)

## Gateway

```json
{
  "gateway": {
    "mode": "local",
    "port": 19000,
    "bind": "loopback",
    "controlUi": { "enabled": true },
    "auth": {
      "mode": "token",
      "token": "<stored on server only>"
    }
  }
}
```

## Workspace origin

Seeded from `https://github.com/musical-basics/lionel-commander-openclaw.git` at commit `716bef9` (2026-04-21). Now lives in this monorepo at `bots/commander/workspace/`.

## History

- 2026-04-21: provisioned as first consolidated-fleet bot (user was `openclaw` + home `/home/commander`; unit was `openclaw.service`)
- 2026-04-21: renamed user `openclaw` → `commander` for consistency across the fleet; unit renamed to `openclaw-commander.service`; workspace migrated to monorepo structure at `/srv/consolidated-fleet/bots/commander/workspace`
