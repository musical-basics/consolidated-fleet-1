# Ultimate Pianist Hermes Path Issue

## Summary

We found a mismatch between the Ultimate Pianist repo-side Hermes folders and the actual live Hermes runtime/profile locations on disk.

## What was wrong

Earlier project/workspace notes treated this repo path as if it were the live Hermes config area:

- `projects/ultimate-pianist/hermes/`

That was inaccurate.

The repo-side Hermes tree is project scaffolding and reference documentation, not the active Hermes runtime location.

## Correct model

The live Hermes profiles are under:

- `/home/openclaw/.hermes/profiles/planner/`
- `/home/openclaw/.hermes/profiles/developer/`
- `/home/openclaw/.hermes/profiles/operator/`

Examples verified:

- `/home/openclaw/.hermes/profiles/planner/config.yaml`
- `/home/openclaw/.hermes/profiles/planner/SOUL.md`
- `/home/openclaw/.hermes/profiles/developer/config.yaml`
- `/home/openclaw/.hermes/profiles/operator/config.yaml`

## Why this matters

If we confuse these two layers, we can make bad assumptions about:

- where Hermes actually reads its live config from
- which files change real bot behavior
- whether a repo edit is operational or just documentation
- whether a profile exists, is recognized, or is running

In short, the repo can describe the team, but Hermes actually runs from `~/.hermes/profiles/`.

## Repo-side role of `projects/ultimate-pianist/hermes/`

This repo path should be treated as:

- project-side role docs
- scaffolding/reference material
- team coordination notes
- librarian/manager documentation

It should **not** be treated as the live Hermes config/runtime path.

## What was verified

The worker verified the real profile locations and Hermes recognition using:

- `/home/openclaw/.local/bin/hermes profile show planner`
- `/home/openclaw/.local/bin/hermes profile show developer`
- `/home/openclaw/.local/bin/hermes profile show operator`

At the time of verification:

- planner: recognized, running
- developer: recognized
- operator: recognized

## Correction applied

Project and workspace references were updated so they now distinguish:

1. live Hermes profile paths under `~/.hermes/profiles/`
2. repo-side Ultimate Pianist Hermes docs under `projects/ultimate-pianist/hermes/`

## Practical rule going forward

Use this rule:

- If the question is "What does the team intend, document, or role-define?" check `projects/ultimate-pianist/hermes/`
- If the question is "What is Hermes actually running from?" check `~/.hermes/profiles/`
