# Fleet Identity — how bots know each other

This doc captures *how* bots in the Consolidated Fleet become aware of each other's Discord identities, and logs the 2026-04-21 episode that established the current dynamic-roster model (for future reference and to avoid re-stepping on the same rakes).

---

## The model: `manifest.yaml` → generator → symlink → bot memory

```
manifest.yaml
     │  (one-time edit per provisioning)
     ▼
scripts/gen-fleet-roster.py
     │  (writes)
     ▼
fleet-roster.md                  ←── single source of truth at repo root
     │  (each bot symlinks here)
     ▼
bots/<role>/workspace/memory/people/bot-team.md    (symlink)
     │  (OpenClaw re-reads per turn)
     ▼
bot's working memory uses the live roster
```

### What this buys us
- Adding a bot = **one edit** (`manifest.yaml`) + regen, not N per-bot memory patches.
- Existing bots pick up new teammates on their **next interaction** — no restarts, no edits to their AGENTS.md / identity files.
- Any drift (manifest vs. memory) is eliminated by construction because the file is symlinked, not copied.

### What stays inline in each bot's AGENTS.md
- The rule: "always use `<@ID>` format, never plain display names."
- Self-identity (one line naming *this* bot's ID, so it knows who it is without having to read the roster).
- A pointer to `memory/people/bot-team.md` + `/srv/consolidated-fleet/manifest.yaml` for teammate lookups.
- The "NOT your team" reference block (external Bot Fleet + Hermes IDs — these are outside the manifest so they have to live inline).

### Authoritative files
- [`/manifest.yaml`](../manifest.yaml) — source of truth (raw data).
- [`/fleet-roster.md`](../fleet-roster.md) — generated artifact; **do not hand-edit**.
- [`/scripts/gen-fleet-roster.py`](../scripts/gen-fleet-roster.py) — the generator (Python stdlib + PyYAML).

---

## Adding a new bot (what provisioning ends up touching)

Full runbook in [`PROVISIONING.md`](PROVISIONING.md); identity-relevant subset:

1. Edit `manifest.yaml` — add the instance block with `discord.bot_id`, `role`, `reports_to`, etc. Bump `ports.next_free`.
2. `python3 scripts/gen-fleet-roster.py` — regenerates `fleet-roster.md`.
3. Symlink the new bot's `memory/people/bot-team.md`:
   ```bash
   ln -sf ../../../../../fleet-roster.md \
     bots/<role>/workspace/memory/people/bot-team.md
   ```
4. Commit + push.
5. Pull on the VPS. Every existing bot sees the update on its next turn.

No identity patching of existing bots is needed. If you find yourself editing `AGENTS.md` or `IDENTITY.md` in an existing bot's workspace to add/change a teammate, you're doing it wrong — regenerate the roster instead.

---

## Log — how this was established (2026-04-21)

### Problem (discovered around 9pm)

Lionel pinged `@Consolidated Commander 1 talk to @Consolidated Concert Marketing 1 and ping each other when you talk` in the `#concert-marketing` channel. Both bots replied, but they @-mentioned `@Openclaw 2`, `@Openclaw Commander`, `@Openclaw 1` — old Bot Fleet handles (IDs `1494531954…` etc.), not each other.

### Root cause

Each bot's workspace was seeded from its corresponding **Bot Fleet** repo during provisioning earlier that day:
- `bots/commander/workspace/` seeded from `lionel-commander-openclaw`
- `bots/concert-marketing/workspace/` seeded from `lionel-openclaw-3`

Those seed repos' identity files (`IDENTITY.md`, `AGENTS.md`, `memory/people/bot-team.md`, `docs/DISCORD_MENTIONS.md`) described the **Bot Fleet** world — with Bot Fleet Discord IDs. Seeding carried that identity forward; nothing in the provisioning pipeline rewrote it for the new Consolidated Fleet context. So Commander still thought the worker was `Openclaw 3` (ID `1494656974732656681`, a bot on a different server), and CM still thought Commander was `Openclaw Commander` (ID `1494745573994135725`).

### Fix 1 — hardcoded identity refresh (commit `be69302`)

Rewrote the identity surface of both bots:
- `bots/<role>/workspace/AGENTS.md` — Discord Mentions section rewritten. Moved Bot Fleet IDs to a "NOT your team" reference block; added Consolidated Fleet IDs as the active-team block.
- `bots/<role>/workspace/IDENTITY.md` — `Name:` updated to the actual consolidated identity with the new Discord ID inline.
- `bots/commander/workspace/memory/people/bot-team.md` — rewrote to describe the Consolidated Fleet roster; Bot Fleet details demoted to a historical section.
- `bots/concert-marketing/workspace/memory/people/bot-team.md` — created (didn't exist before); same shape, CM's perspective.
- `bots/concert-marketing/workspace/docs/DISCORD_MENTIONS.md` — rewrote IDs + added "do not DM Lionel" rule.

This worked but was fragile: four files per bot, manually edited. Adding a third bot would mean four more edits to each existing bot.

### Fix 2 — dynamic roster via manifest + symlinks (commit `dc832bc`)

Replaced the hardcoded tables with a generator pipeline.

- New file: `scripts/gen-fleet-roster.py` — reads `manifest.yaml`, writes `fleet-roster.md` at repo root. Renders each instance with name, key, role, Discord ID (as `<@ID>`), user/home, systemd unit, port, seed repo, status. Splits active vs. planned. Appends the federated communication contract.
- New file: `fleet-roster.md` — generated artifact.
- Both bots' `memory/people/bot-team.md` converted from regular files to **symlinks** → `../../../../../fleet-roster.md`. Git preserves them as symlinks (mode `120000`).
- Both bots' `AGENTS.md` Discord Mentions section slimmed: removed the hardcoded active-team table (would drift), kept the `<@ID>` format rule, self-identity line, Bot Fleet "NOT your team" reference, and a pointer to `memory/people/bot-team.md` + `/srv/consolidated-fleet/manifest.yaml` as the source of truth.
- `docs/PROVISIONING.md` — added step 9: regenerate `fleet-roster`, symlink the new worker's `bot-team.md`.

### Propagation to the VPS

```bash
apt-get install -y python3-yaml          # generator dep (future regens)
cd /srv/consolidated-fleet && git pull   # pulls the symlinks + generator
python3 scripts/gen-fleet-roster.py      # smoke-tested: "wrote fleet-roster.md"
head -3 bots/commander/workspace/memory/people/bot-team.md
# -> # Consolidated Fleet Roster
#    > **Auto-generated from manifest.yaml. Do not edit by hand.**
```

Symlinks resolved correctly under systemd's `ProtectHome=read-only` because `/srv/consolidated-fleet` is in `ReadWritePaths`.

### Service restarts (with explicit permission)

Both services restarted to flush any gateway-cached identity:
```bash
systemctl restart openclaw-commander.service
systemctl restart openclaw-concert-marketing.service
```

Startup logs showed clean reconnects:
- `[discord] client initialized as 1496094900620492840 (Consolidated Commander 1)`
- `[discord] client initialized as 1496129135934705664 (Consolidated Concert Marketing 1)`
- No `4014` errors.

### Verification in Discord

Lionel re-sent the ping. Bots now correctly address each other as `@Consolidated Commander 1` / `@Consolidated Concert Marketing 1` with the right underlying IDs.

---

## Gotchas to avoid

1. **Seeding from a Bot Fleet repo inherits Bot Fleet identity.** After seeding, either rewrite the identity files manually OR (better) just symlink `memory/people/bot-team.md` to `fleet-roster.md` so the bot's roster comes from the manifest, not the seed.
2. **`.gitignore` patterns without leading slash match at any depth.** Seed repos' `.gitignore` had `projects/` which caught `memory/projects/` and silently dropped those files during the initial seed commit. If you see missing `memory/projects/` files after a seed, check the `.gitignore` pattern. Fix is `/projects/` (anchored to top-level).
3. **OpenClaw re-reads workspace memory per turn, but gateway-level identity may cache at startup.** For deterministic behavior after major memory/identity changes, restart the service (with permission). Small updates propagate naturally on the next interaction.
4. **Don't hand-edit `fleet-roster.md`.** It's generated. Edit `manifest.yaml` and regen.
5. **Bot Fleet IDs stay hardcoded in `AGENTS.md`** (the "NOT your team" reference block) because they are external — they aren't tracked in `manifest.yaml` and never should be.

---

## See also
- [ARCHITECTURE.md](ARCHITECTURE.md) — federated model overview.
- [WORKER_CONFIG.md](WORKER_CONFIG.md) — worker spec template.
- [COMMANDER_CONFIG.md](COMMANDER_CONFIG.md) — commander spec.
- [PROVISIONING.md](PROVISIONING.md) — runbook for adding workers.
- [../manifest.yaml](../manifest.yaml) — fleet registry.
- [../fleet-roster.md](../fleet-roster.md) — generated roster.
