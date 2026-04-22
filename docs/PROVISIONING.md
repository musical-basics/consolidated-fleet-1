# Provisioning a new worker

## Prerequisites
- OpenClaw already installed on the VPS (shared global install)
- `/srv/consolidated-fleet` is the repo checkout owned by `root:fleet` (group shared across bot users)
- Discord bot app created in the Dev Portal with the 3 privileged intents enabled (Presence, Server Members, Message Content)
- A new GitHub repo **is NOT needed** — this monorepo already handles all bots

## Steps

### 1. Pick a free port
Check `manifest.yaml` → `ports.next_free` (currently 19002). Increment after use.

### 2. Create the user
```bash
useradd --system --shell /bin/bash --create-home --home-dir /home/<role> <role>
mkdir -p /home/<role>/.openclaw/{agents,canvas,identity,logs,tasks}
chown -R <role>:<role> /home/<role>
```

Add the user to the `fleet` group (for access to the shared repo checkout):
```bash
usermod -aG fleet <role>
```

### 3. Seed the workspace
- If seeding from an existing Bot Fleet repo: `git clone <source-repo> /tmp/seed && rsync -a --exclude=.git /tmp/seed/ /srv/consolidated-fleet/bots/<role>/workspace/`
- If starting fresh: copy the V2 template (future: keep a template in this repo)
- Symlink: `ln -s /srv/consolidated-fleet/bots/<role>/workspace /home/<role>/.openclaw/workspace`
- Fix ownership: `chown -Rh <role>:<role> /srv/consolidated-fleet/bots/<role>`

### 4. Write the config
Create `/home/<role>/.openclaw/openclaw.json` modeled after `bots/commander/workspace/` config. Key values:
- `gateway.port` = next free port
- `gateway.auth.token` = `openssl rand -hex 24`
- `channels.discord.token` = the new Discord bot token
- `channels.discord.enabled` = `true`
- `agents.defaults.workspace` = `/home/<role>/.openclaw/workspace`

### 5. Environment file
```bash
touch /etc/openclaw/<role>.env
chown root:<role> /etc/openclaw/<role>.env
chmod 640 /etc/openclaw/<role>.env
```

### 6. Systemd unit
Copy `systemd/openclaw-concert-marketing.service` as a template, edit `User=`, `Group=`, `WorkingDirectory=`, `EnvironmentFile=`, `ReadWritePaths=` for the new role. Save as `systemd/openclaw-<role>.service`, then:
```bash
ln -s /srv/consolidated-fleet/systemd/openclaw-<role>.service /etc/systemd/system/openclaw-<role>.service
systemctl daemon-reload
```

### 7. Codex OAuth (interactive, needs browser)
```bash
sudo -u <role> tmux new-session -d -s ocauth -x 200 -y 50 \
  'openclaw models auth login --provider openai-codex 2>&1; sleep 900'
sudo -u <role> tmux capture-pane -t ocauth -p
# Copy URL, open in browser, sign in
sudo -u <role> tmux send-keys -t ocauth -l '<callback-url>'
sudo -u <role> tmux send-keys -t ocauth Enter
sudo -u <role> tmux kill-session -t ocauth
```

Set default model:
```bash
sudo -u <role> bash -c 'cd /home/<role> && openclaw models set openai-codex/gpt-5.4'
```

### 8. Register in manifest.yaml
Add a new block under `instances:` with all the metadata. Update `ports.next_free`.

### 9. Regenerate the fleet roster
Every bot's `memory/people/bot-team.md` is a symlink to `/srv/consolidated-fleet/fleet-roster.md`, which is auto-generated from `manifest.yaml`. Regenerate it so existing bots learn about the new worker on their next turn:

```bash
python3 /srv/consolidated-fleet/scripts/gen-fleet-roster.py
```

Also symlink the new worker's `memory/people/bot-team.md`:

```bash
ln -sf ../../../../../fleet-roster.md \
  /srv/consolidated-fleet/bots/<role>/workspace/memory/people/bot-team.md
```

No restart needed — existing bots re-read memory per turn, so the new roster propagates on their next interaction.

### 10. Start the service
```bash
systemctl enable --now openclaw-<role>.service
journalctl -u openclaw-<role>.service -n 30 --no-pager
```

### 11. Write the per-worker config doc
Create `docs/<ROLE>_CONFIG.md` mirroring `CONCERT_MARKETING_CONFIG.md`.

### 12. Commit + push
Commit the new `systemd/openclaw-<role>.service`, `bots/<role>/workspace/`, the regenerated `fleet-roster.md`, `manifest.yaml` changes, and the doc to the repo.
