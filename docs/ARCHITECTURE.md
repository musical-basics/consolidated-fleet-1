# Commander OS Federated Architecture

A reusable multi-agent OpenClaw architecture based on multiple independent agent instances coordinated by a central Commander.

## Overview

This architecture is designed for setups where each worker is its own OpenClaw instance, with its own:
- server or host
- repo
- workspace
- memory
- identity
- runtime lifecycle

Instead of sharing one workspace and one memory tree, the system is **federated**:
- **Commander** operates as the orchestration layer
- **workers** operate as separate OpenClaw agents
- coordination happens through messaging, summaries, escalation, and selective memory promotion

This is closer to a distributed team model than a single shared-memory instance.

## Core model

The system has:
- **1 Commander instance**
- **N worker instances**
- **message-based coordination** between them
- **memory isolation by default**
- **upward context flow** from workers to Commander
- **decision flow** from Commander to workers

In this model:
- workers execute in their own domain
- Commander holds cross-domain context
- workers do not automatically share each other's memory
- cross-worker awareness is mediated by Commander

## Communication flow (consolidated-fleet-1 realization)

```
Lionel (human)
   │ DM
   ▼
Commander  ────── posts in #<team> channel ──────▶ Worker
   ▲                                                  │
   │                  channel reply                   │
   └──────────────────────────────────────────────────┘
   │ DM summary
   ▼
Lionel
```

- Lionel DMs Commander only.
- Commander posts to each worker's dedicated Discord channel.
- Workers respond **in the channel** (never DM Lionel).
- Commander synthesizes worker output and DMs Lionel the update.
- Workers are "managers" of their domain — sub-agents may be added to each worker later.

## Per-instance structure

Each agent instance on the fleet owns its own workspace at:
```
/home/<role>/.openclaw/workspace/   # symlink -> /srv/consolidated-fleet/bots/<role>/workspace/
```

Workspace contents:
```
workspace/
├── IDENTITY.md
├── SOUL.md
├── AGENTS.md
├── USER.md
├── MEMORY.md
├── memory/
│   ├── projects/
│   ├── people/
│   ├── tools/
│   ├── ideas/
│   ├── summaries/
│   └── daily/
├── docs/
├── reports/
├── scripts/
└── projects/
```

The crucial point is:
- each instance owns its own memory tree (its own subdir of `bots/`)
- there is no assumption of one global shared memory directory
- per-bot user ownership + Linux perms enforce isolation on-host

## Commander responsibilities

- human-facing communication (DM)
- cross-domain prioritization
- fleet-wide memory
- worker routing via Discord channels
- escalation decisions
- summary synthesis to Lionel

## Worker responsibilities

- domain-specific execution lane (one project / business line each)
- local tactical execution
- reporting status upward to Commander via their channel
- *not* DMing Lionel
- *not* talking directly to other workers

## Memory architecture

### 1. Local memory per instance
Each worker keeps its own memory files under `bots/<role>/workspace/memory/`.

### 2. Commander memory as cross-instance synthesis
Commander memory (`bots/commander/workspace/memory/`) holds:
- role ownership
- durable business-level facts
- cross-project priorities
- escalations
- decisions that affect multiple workers
- stable identity/routing information

### 3. Upward memory promotion
Useful information flows upward when it becomes durable or strategically relevant. In practice: the worker posts a summary in its channel; Commander reads it and updates its own memory if the signal is cross-cutting.

## Instance registry

Authoritative list lives in [`manifest.yaml`](../manifest.yaml) at the repo root.

## Routing rules (see `manifest.yaml` → `routing`)

```yaml
routing:
  inbound_human_messages:
    default_target: commander
  worker_to_human:
    allow_direct: false
    relay_via_commander: true
  worker_to_worker:
    allow_direct: false
    via_commander: true
  file_transfer:
    cross_instance: attachment
```

## Scaling

To add a fifth (or N+1) worker:
1. create a new OpenClaw user + home (`useradd <role> -m`)
2. seed its workspace (either from an existing Bot Fleet repo or fresh V2 templates)
3. allocate the next free gateway port (see `ports.next_free` in `manifest.yaml`)
4. create a Discord bot app + enable the 3 privileged intents
5. add a `systemd/openclaw-<role>.service` unit in this repo, symlink to `/etc/systemd/system/`
6. add the bot to `manifest.yaml`
7. run Codex OAuth via tmux
8. start the service

See [`PROVISIONING.md`](PROVISIONING.md) for the full playbook.

## Benefits of the federated model

- strong isolation between domains
- independent memory boundaries
- less accidental context contamination
- better fit for separate business lines
- each worker can grow its own sub-agents without affecting siblings

## Tradeoffs

- more infrastructure to maintain (per-bot user, systemd unit, config, Discord app)
- requires deliberate summary/escalation discipline for upward memory flow
- more messaging overhead than a shared-memory model

## Core abstraction

Commander OS Federated Architecture is:

**a distributed OpenClaw team model where Commander coordinates multiple independent worker instances, each with its own workspace and memory, using message-based orchestration and selective upward memory promotion.**
