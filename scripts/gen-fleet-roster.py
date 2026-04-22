#!/usr/bin/env python3
"""
Regenerate fleet-roster.md from manifest.yaml.

Run this after every manifest.yaml edit (adding a bot, changing an ID, etc.).
Each bot's memory/people/bot-team.md is a symlink to the generated file,
so every bot picks up the change on its next turn — no per-bot edits.

Usage:
    python3 scripts/gen-fleet-roster.py

Requires:
    python3-yaml (Debian/Ubuntu: apt install python3-yaml)
"""
from __future__ import annotations

import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit(
        "Missing PyYAML. Install it: apt install python3-yaml  "
        "(or pip install pyyaml)"
    )

REPO = Path(__file__).resolve().parent.parent
MANIFEST = REPO / "manifest.yaml"
OUTPUT = REPO / "fleet-roster.md"


def render(manifest: dict) -> str:
    host = manifest.get("host", {})
    instances = manifest.get("instances", {}) or {}

    lines: list[str] = []
    lines += [
        "# Consolidated Fleet Roster",
        "",
        "> **Auto-generated from `manifest.yaml`. Do not edit by hand.**",
        f"> Regenerate with `python3 scripts/gen-fleet-roster.py`.",
        "",
        f"Host: `{host.get('hostname', '?')}` ({host.get('public_ip', '?')})  ",
        f"OpenClaw: `{manifest.get('shared', {}).get('openclaw_version', '?')}`  ",
        "",
        "---",
        "",
    ]

    # Active / provisioning instances
    active = [(k, v) for k, v in instances.items() if v.get("status") != "planned"]
    planned = [(k, v) for k, v in instances.items() if v.get("status") == "planned"]

    if active:
        lines += ["## Active instances", ""]
        for key, inst in active:
            lines += _render_instance(key, inst)

    if planned:
        lines += ["## Planned / not yet provisioned", ""]
        for key, inst in planned:
            lines += _render_instance(key, inst, brief=True)

    lines += [
        "## Communication contract",
        "",
        "See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full federated model.",
        "",
        "```",
        "Lionel (DM) → Commander → #<worker-channel> → Worker",
        "                  ▲                              │",
        "                  └──── channel reply ◀──────────┘",
        "                  │",
        "                  ▼",
        "Lionel (DM summary from Commander)",
        "```",
        "",
        "- Workers never DM Lionel.",
        "- Workers do not coordinate directly with sibling workers; Commander mediates.",
        "- When mentioning any bot in Discord, use `<@ID>` syntax — never plain-text display names.",
        "- If this roster disagrees with `manifest.yaml`, `manifest.yaml` is authoritative. Regenerate.",
        "",
    ]

    return "\n".join(lines)


def _render_instance(key: str, inst: dict, brief: bool = False) -> list[str]:
    discord = inst.get("discord", {}) or {}
    gateway = inst.get("gateway", {}) or {}
    name = discord.get("bot_name", key)
    bot_id = discord.get("bot_id")
    mention = f"`<@{bot_id}>`" if bot_id else "_(no Discord ID yet)_"

    lines = [f"### {name}", f"- Key: `{key}`"]
    lines.append(f"- Role: **{inst.get('role', '?')}**" + (
        f" — domain: `{inst['domain']}`" if inst.get("domain") else ""
    ))
    if inst.get("reports_to"):
        lines.append(f"- Reports to: **{inst['reports_to']}**")
    lines.append(f"- Discord: {mention}" + (f" (ID `{bot_id}`)" if bot_id else ""))
    if not brief:
        lines.append(f"- User/home: `{inst.get('user', '?')}` / `{inst.get('home', '?')}`")
        lines.append(f"- Systemd unit: `{inst.get('systemd_unit', '?')}`")
        lines.append(f"- Gateway port: `{gateway.get('port', '?')}` ({gateway.get('bind', 'loopback')})")
        lines.append(f"- Workspace: `{inst.get('workspace_target', '?')}`")
        if inst.get("seed_repo"):
            lines.append(f"- Seed repo: `{inst['seed_repo']}`")
    lines.append(f"- Status: `{inst.get('status', '?')}`")
    lines.append("")
    return lines


def main() -> int:
    if not MANIFEST.exists():
        print(f"manifest not found: {MANIFEST}", file=sys.stderr)
        return 1
    manifest = yaml.safe_load(MANIFEST.read_text())
    OUTPUT.write_text(render(manifest))
    print(f"wrote {OUTPUT.relative_to(REPO)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
