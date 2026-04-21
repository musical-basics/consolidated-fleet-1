# Concert Marketing Worker — Setup Config

**Role**: worker — concert marketing domain (landing pages, copy, campaigns, organizer ops)
**Reports to**: commander
**Host**: `lionel-consolidated-1` (178.104.191.10)
**User**: `concert-marketing`
**Home**: `/home/concert-marketing`
**Workspace**: `/home/concert-marketing/.openclaw/workspace` → `/srv/consolidated-fleet/bots/concert-marketing/workspace`
**Gateway port**: 19001 (loopback)
**Systemd unit**: `openclaw-concert-marketing.service` → `/srv/consolidated-fleet/systemd/openclaw-concert-marketing.service`
**Env file**: `/etc/openclaw/concert-marketing.env`

---

## Codex OAuth

- Auth profile: `openai-codex:yulionel829@gmail.com` (same account as commander — separate token store per bot)
- Model: `openai-codex/gpt-5.4`
- OAuth tokens stored in `/home/concert-marketing/.openclaw/agents/main/agent/auth-profiles.json`

## Discord

- Bot: **Consolidated Concert Marketing 1**
- Bot ID: `1496129135934705664`
- Token: stored in `/home/concert-marketing/.openclaw/openclaw.json` on server (NOT in this repo)
- Privileged gateway intents: all 3 must be enabled (Presence, Server Members, Message Content)

## Gateway

```json
{
  "gateway": {
    "mode": "local",
    "port": 19001,
    "bind": "loopback",
    "auth": {
      "mode": "token",
      "token": "<stored on server only>"
    }
  }
}
```

## Workspace origin

Seeded from `https://github.com/musical-basics/lionel-openclaw-3.git` (Bot 3 Concert Marketing content at 2026-04-18 HEAD `28546f7`).

## Communication rules

Per the federated architecture (see `ARCHITECTURE.md`):
- Responds only in its dedicated Discord channel (the concert-marketing channel).
- Never DMs Lionel.
- Escalations and cross-domain concerns go to Commander via the channel.
- Commander reads the channel and relays summaries to Lionel.
