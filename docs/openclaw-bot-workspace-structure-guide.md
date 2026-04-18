# OpenClaw Bot Workspace Structure Guide

Standard directory layout for all OpenClaw bot workspaces. Follow this to keep bot system files separate from project work.

**Workspace root:** `/home/openclaw/.openclaw/workspace/`

---

## Directory Layout

```text
workspace/
├── IDENTITY.md # Bot identity (name, vibe, emoji)
├── SOUL.md # Bot behavior rules
├── AGENTS.md # Multi-agent config
├── BOOTSTRAP.md # First-run onboarding (delete after setup)
├── HEARTBEAT.md # Health/status
├── MEMORY.md # Memory index
├── .gitignore
│
├── memory/ # Bot memory files (auto-managed)
│ ├── people/
│ ├── projects/
│ ├── tools/
│ ├── summaries/
│ └── .dreams/
│
├── plans/ # Active plans and specs
│
├── projects/ # ALL project work goes here
│ ├── dreamplay-website-3/ # (has its own .git)
│ ├── dreamplay-media-indexer-2/ # (has its own .git)
│ └── any-future-project/
│
├── data/ # Data files (imports, exports, CSVs)
│ └── dreamplay/
│
├── reports/ # Generated reports
│
├── deploy/ # Deployment scripts and configs
│
└── docs/ # Reference docs created by the bot
```

---

## Rules

### 1. Never put project repos in the workspace root
All git-tracked projects go inside `projects/`. This prevents embedded-repo warnings and keeps the workspace git history clean.

```text
# WRONG
workspace/dreamplay-website-3/

# RIGHT
workspace/projects/dreamplay-website-3/
```

### 2. Keep bot system files at the root
These files stay at the workspace root, they are the bot's identity and memory:
- `IDENTITY.md`, `SOUL.md`, `AGENTS.md`, `MEMORY.md`, `HEARTBEAT.md`
- `memory/` directory

### 3. Specs and plans go in `plans/`
Don't scatter `*-SPEC.md`, `*-CONTEXT.md` files across the root. Put them in `plans/`.

```text
# WRONG
workspace/DREAMPLAY-CUSTOMER-PORTAL-V1-SPEC.md
workspace/DREAMPLAY-TIER1-CONTEXT.md

# RIGHT
workspace/plans/dreamplay-customer-portal-v1-spec.md
workspace/plans/dreamplay-tier1-context.md
```

### 4. Reference docs go in `docs/`
Setup guides, runbooks, architecture docs, anything that's reference material, not an active plan.

```text
# WRONG
workspace/CLAUDE_CODE_SETUP_STATUS.md
workspace/HERMES-GATEWAY-API-V1.md

# RIGHT
workspace/docs/claude-code-setup-status.md
workspace/docs/hermes-gateway-api-v1.md
```

### 5. Update `.gitignore`
Every workspace should have this at minimum:

```gitignore
node_modules/
.openclaw/
memory/.dreams/
*.log
.env
.env.*
.cache/
.npm-cache/
.npm-global/
.npm-tmp/
.tmp/
.tmp-home/
.pm2/
.worker-tools/
__pycache__/
*.pyc
projects/*/node_modules/
projects/*/.next/
```

### 6. Projects have their own git repos
Each project inside `projects/` should have its own `.git` and be pushed to its own GitHub remote. The workspace repo should `.gitignore` or use submodules for these, never commit them as embedded repos.

Add to workspace `.gitignore`:
```gitignore
projects/
```

This way the workspace repo only tracks bot system files and the project repos are managed independently.

---

## What goes where, quick reference

- Bot identity/personality → Root (`IDENTITY.md`, `SOUL.md`)
- Bot memory → `memory/`
- Active plans and specs → `plans/`
- Reference docs and runbooks → `docs/`
- Project source code → `projects/<project-name>/`
- Data files (CSVs, exports) → `data/`
- Deployment configs → `deploy/`
- Generated reports → `reports/`
