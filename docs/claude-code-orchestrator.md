---
name: claude-code-orchestrator
description: Hermes is a pure I/O router. Claude Code does ALL thinking. Repos are persistent memory.
version: 2.0.0
author: Lionel Yu
license: MIT
metadata:
  hermes:
    tags: [Claude-Code, Routing, Thinking-Repos, Persistent-Memory]
---

# Claude Code Orchestrator

Hermes is a pure I/O router. Claude Code does ALL thinking. Repos are persistent memory.

This is the single source of truth for Claude Code orchestration. If overlapping orchestrator skills exist, consolidate into this one and remove the duplicates.

## Hermes's Role
1. Receive Lionel's message.
2. Pick the right repo (see Routing below).
3. For complex work, prefer the persistent tmux Claude Code session tied to that project/repo instead of ad-hoc one-shot runs.
4. Write a clear spec when needed, delegate execution to Claude Code, then verify the result.
5. Relay Claude Code's response to Lionel.
*Hermes orchestrates I/O and verification. Claude Code does implementation work.*

## Current Preferred Execution Pattern
- For easy one-off requests and surgical fixes, Hermes may edit directly, then verify, commit, and push immediately.
- If a recent Claude Code UI/CSS change causes an obvious visual regression, do not reflexively launch another broad Claude run. First inspect the live result directly (browser + DOM/CSS measurements), identify the exact bad commit/change, and if needed revert that narrow commit immediately to restore a known-good state.
- After a revert, prefer the smallest safe direct fix yourself when the issue is a narrow layout/CSS problem (for example padding, min-height, link target, overflow/clipping) and verify with build plus visual review before pushing.
- For larger changes, use persistent Claude Code tmux sessions when available (for example `claude-concept` for `/root/projects/concept-clone`).
- For broader/heavier fidelity passes in DreamPlay concept-clone, explicitly set Claude Code to Opus with high effort instead of relying on default model/effort.
- When Claude Code introduces a visible UI regression, do not iterate blindly on top of the broken state. First identify the offending commit, revert it cleanly if needed, verify the site is back to the last known-good state, then re-approach the issue with the narrowest possible fix.
- For narrow CSS/layout bugs discovered during review (for example clipping, padding, height issues, active-state polish, anchoring, or overlay/scrim behavior in a single existing component), prefer a direct Hermes fix over a new broad Claude pass when the change is confined to a few files and can be immediately browser-verified. Make the smallest targeted change, verify visually plus with build, and push only after confirming the regression is gone.
- For bigger tasks, prefer multiple Claude Code instances/subtasks when the work can be cleanly partitioned, then review and verify each result before finalizing.
- When Hermes is about to hand a substantial task to Claude Code, first write the exact prompt/spec into a markdown file inside the repo if useful, show Lionel the prompt verbatim on request, and get approval before launching the run.
- For broader/heavier Claude Code implementation passes (for example multi-page fidelity sweeps or larger shared UI refinements), do not leave model/effort implicit. Explicitly launch Claude Code with Opus and `--effort high` unless Lionel requests a different setting.
- Always push Claude Code work so Lionel can inspect it.
- For DreamPlay concept-clone, pushing is not optional housekeeping: after Claude finishes, Hermes should push immediately so Lionel can see the live site, and prompts should ask Claude to push after each meaningful change when the repo/workflow permits.
- Do not wait for Lionel to sign off on every small feature. Keep making incremental changes, pushing as you go, and let him review the accumulated result before final sign-off.
- For concurrent Claude Code runs, split by non-overlapping file domains first (for example shared homepage/header work vs `/shop`-only work), and keep a short note of each run's lane and session/process ID so Hermes can monitor them safely.
- If a combined UI refinement prompt mixes page-layout work with header/nav/megamenu behavior, do not keep them bundled. Split into separate Claude runs (for example page lane vs nav lane) so one visual system cannot destabilize the other and each result is easier to review or revert.

- For UI/component experiments, treat the A/B route as an isolated sandbox for the targeted system only (for example header/nav only, not the whole homepage shell). When the experiment is approved, merge only that targeted component/system into the real page.
- If multiple Claude Code runs are active on related UI work, split them by non-overlapping file domains first (for example shared homepage/header work vs `/shop`-only work).
- Before each new UI fidelity pass, Hermes should compare the local result against the live reference, write a short prioritized review doc in the repo, and use that doc as the source of truth for the next Claude prompt.
- If the user wants to review the prompt first, Hermes should write the exact Claude prompt to a repo markdown file, send the prompt text verbatim, wait for approval, then launch it unchanged unless the user requests edits.
- When Claude Code is already running on one implementation lane, Hermes should keep making progress by independently reviewing the live reference in parallel and writing supplemental review docs (for example a collection-page review or a megamenu-specific review) so the next Claude pass can start immediately from grounded notes.
- If multiple Claude Code runs are active on related UI work, verify whether they touch the same files before pushing. If an overlapping run is still modifying the same files, pause/kill/freeze it first, revert any accidental partial splice, then push the clean increment.
- If a Claude Code run stops due to max-turns or otherwise exits mid-task, do NOT immediately discard the work. First inspect `git diff`, run verification (`npm run lint`, `npm run build`, or project-equivalent), and assess whether the partial changes are coherent.
- When salvageable partial work exists, launch a continuation prompt that explicitly tells Claude Code to continue from the existing local diff, not start over, and to stay scoped to the already-modified files unless absolutely necessary. This continuation pattern is preferred over rewriting the task from scratch.
- If a broader Claude run spends several minutes with no visible `git diff` changes and no pushed commit, treat it as likely stuck/overthinking rather than waiting indefinitely. Prefer killing it and splitting the work into 2-3 narrower Claude runs by file/domain (for example reveals vs card/media polish vs header integration).
- When splitting Claude runs, monitor for overlapping file edits before accepting all results. If multiple runs touched the same files, do a salvage pass yourself: inspect the combined diff, verify visually plus with lint/build, keep the safe subset, discard broken reveal/animation logic, then commit/push the cleaned result.
- For Lionel's live-review workflow, pushing is part of completion, not an optional afterthought. In Claude prompts for meaningful UI work, explicitly instruct Claude Code to push after each meaningful change when safe, and Hermes must still push immediately once a Claude run finishes if anything remains unpushed so Lionel can review the live site.
- If a broad UI/interactivity pass appears stuck (long runtime with no file changes or commits), split it into smaller non-overlapping Claude Code lanes (for example reveal/motion vs card/media vs header integration) instead of waiting indefinitely.
- After split Claude runs, do a salvage pass before launching anything new: inspect local diffs, run verification, and keep only the safe subset. Watch especially for JS/CSS reveal systems that can leave content invisible at runtime even when lint/build pass; if the page looks blank or sections disappear, revert the broken reveal changes and keep the safer hover/active-state polish.
- Before large file-writing batches in Claude Code, run `/permissions bypassPermissions` when the environment permits it.
- For Lionel's live-site review workflow, Claude prompts for meaningful multi-step UI passes should explicitly instruct Claude Code to push after each meaningful change/commit, not only at the end.
- Default loop for larger work: write spec -> delegate to Claude Code -> verify output -> push so Lionel can inspect.
- If a Claude Code UI pass creates an obvious visual regression, do not stack more work on top of it. Inspect the bad commit/diff immediately, revert the smallest offending commit to restore a reviewable state, verify the site is sane again, then re-approach with a narrower prompt or a direct surgical fix.
- For tiny, low-risk, CSS-only follow-ups after a Claude run (for example increasing a min-height or adjusting spacing), Hermes should prefer a direct edit + build + visual verification instead of launching another full Claude pass.
- Explicit split for Lionel's workflow: small, scoped fixes should be done directly by Hermes (for example a wrong link target, a single-component CSS/layout bug, a small routing cleanup, or a narrow post-review polish). Larger feature work, broader UI fidelity passes, new pages, or multi-file restructures should go to Claude Code first, then Hermes reviews and handles only the final surgical fixes.
- If a direct Hermes fix starts turning into a messy multi-step implementation/debugging session rather than a surgical change, stop and hand the broader pass back to Claude Code instead of grinding through it manually.
- Before high-risk UI transitions in live-review repos (for example converting a reference clone homepage into a branded production homepage), create explicit backup branches at the important pre-refactor states instead of relying only on linear git history. Good pattern: one branch for the last full reference/theme baseline and one branch for the last pre-branding structural split. Push both branches to origin and write a short repo markdown note documenting what each backup branch preserves and when to use it.
- For megamenus/dropdowns specifically: prefer preserving structure/overflow behavior and fixing clipping with container sizing first. Avoid "overflow: visible" or layout-unlocking changes unless visually verified, because they can fragment the panel and break anchoring.
- Always visually verify high-risk UI changes (browser review or screenshot inspection) before treating them as done.
- In DreamPlay concept-clone specifically, do not trust a "blank page" screenshot at face value when scroll-reveal systems are involved. Browser accessibility snapshots may still show the content while vision screenshots look empty because cards/sections are stuck at `opacity: 0`. When that happens, inspect computed styles in the browser (`opacity`, `transform`, reveal classes) before concluding the page is actually blank.
- After Claude creates a new page/route or introduces new remote media, verify the page in the local browser, not just with `npm run build`. Runtime-only failures can still blank the page even when build passes (for example `next/image` remote host misconfiguration causing a white screen). Use browser inspection / console to catch these before reporting success.
- After pushing a UI/content cleanup, if the live browser still appears to show the old nav/footer/copy, do not immediately assume the push failed. First verify `git log`/push status, then reload the deployed page with a cache-busting query string such as `?v=<short-commit>` before judging whether the deployment actually updated.
- If Claude leaves behind backup or generated build folders (for example `.next-old/`, `.next-build/`, `.next-verify/`, `tmp/`) and lint suddenly explodes with thousands of errors from generated files, do not assume the feature work is broken. First inspect `git status`, revert unintended config edits (for example `tsconfig.json`), remove the generated artifact folders, and rerun lint/build before judging the implementation.
- When a combined Claude UI run mixes two distinct lanes (for example page layout work and header/nav behavior) and starts failing or getting muddled, split it into separate Claude runs by non-overlapping file domains and monitor them independently.
- Hermes should avoid direct implementation on big code tasks when Claude Code is the better tool.
- Hermes should avoid direct implementation on big code tasks when Claude Code is the better tool.

## tmux Session Conventions
- Name persistent sessions with the `claude-<project>` pattern.
- Current canonical example: `claude-concept` -> `/root/projects/concept-clone`.
- Reuse the existing project session instead of spawning throwaway sessions whenever continuity matters.
- If a project has both advisory and implementation contexts, keep the implementation session attached to `/root/projects/...` and keep advisory context in `/root/repos/...`.
- When starting or reusing a session for heavy work, set `/effort max` unless the task is intentionally lightweight.
- Before major write-heavy tasks, set `/permissions bypassPermissions` when the environment permits it.
- Practical tmux control commands worth reusing:
  - create detached session: `tmux new-session -d -s claude-<project>`
  - attach later: `tmux attach -t claude-<project>`
  - list sessions: `tmux ls`
  - kill session: `tmux kill-session -t claude-<project>`
- Practical non-root launch pattern inside tmux for this environment:
  - `tmux new-session -d -s claude-concept`
  - `tmux send-keys -t claude-concept 'su - claude -c '\''export PATH="$HOME/bin:/opt/claude-runtime/bin:$PATH" && cd /home/claude/projects/concept-clone && claude --permission-mode bypassPermissions'\''' C-m`
- Once attached, common setup commands are:
  - `/effort max`
  - `/permissions bypassPermissions`
- Important environment finding: when running as root, Claude Code may refuse `bypassPermissions` / dangerous-skip-permissions modes. Do not waste time retrying the same root launch flags.
- Preferred durable fix: create or reuse a dedicated non-root coding user (for example `claude`) with its own home and workspace, then run Claude Code there with `--permission-mode bypassPermissions`.
- Safe split architecture: keep Hermes/orchestration under root if needed, but give the non-root Claude user a separate workspace clone (for example `/home/claude/projects/<repo>`) and a shared runtime on a root-readable path such as `/opt/claude-runtime/bin/claude`.
- Minimal migration pattern that worked here: create user `claude`, copy Claude auth/config (`~/.claude`, `~/.claude.json`) plus git identity/credentials into `/home/claude`, expose the Claude runtime outside `/root` (for example copy `/root/.hermes/node` to `/opt/claude-runtime`), add `/opt/claude-runtime/bin` to the user's PATH, and clone the active repo into `/home/claude/projects/...`.
- Recommended launch pattern for heavy non-root runs: `su - claude -c 'export PATH="$HOME/bin:/opt/claude-runtime/bin:$PATH" && cd /home/claude/projects/<repo> && claude ... --permission-mode bypassPermissions'`.
- Verify the setup by running as the non-root user: `claude --version`, `git status`, and a tiny `claude -p` call with `--permission-mode bypassPermissions`.
- Important tradeoff of the split-workspace approach: the non-root clone can drift behind `origin/main` if Hermes/root or another workspace keeps pushing. Before pushing results from the non-root workspace, always run `git status -sb`. If the branch is ahead and behind, `git fetch origin && git rebase origin/main`, resolve conflicts, rerun verification, then push.
- If Hermes/root needs to inspect or commit inside the non-root Claude workspace clone, git may reject the repo as dubious ownership. Fix that once with: `git config --global --add safe.directory /home/claude/projects/<repo>` before continuing.
- Claude Code verification runs may leave temporary artifacts in the repo (for example `.next-build/`, `.next-verify/`, `tmp/`) and may even patch `tsconfig.json` to include those temp type paths. Before committing, explicitly inspect `git status -sb` and `git diff`; revert unintended config changes and remove temp build artifacts so only real feature files are shipped.
- In split-ownership DreamPlay concept-clone workspaces, `npm run build` under user `claude` can fail with `EACCES` inside `.next/` if a prior root run touched it. If that happens, fix ownership of `.next` first (for example `chown -R claude:claude /home/claude/projects/concept-clone/.next`) and rerun build instead of assuming the feature is broken.
- Another split-ownership pitfall: git commits from the non-root `claude` user can fail with `insufficient permission for adding an object to repository database .git/objects` if earlier root-side work created root-owned object directories/files under `.git/objects`. Diagnose with `find /home/claude/projects/<repo>/.git -not -user claude -printf '%u %g %m %p\n' | head -50`. Durable fix: `chown -R claude:claude /home/claude/projects/<repo>/.git` before retrying the commit/push.
- In the same split-ownership setup, `git commit` under user `claude` can also fail with `insufficient permission for adding an object to repository database .git/objects` if root created git objects earlier. If that happens, fix repo metadata ownership first with `chown -R claude:claude /home/claude/projects/concept-clone/.git`, then retry the commit/push.
- Only if a non-root setup is not available should Hermes fall back to root-safe `claude -p` runs without bypass permissions, using explicit `--allowedTools` and background/process monitoring.
- After Claude finishes, Hermes verifies outputs before reporting back to Lionel.

## Routing
Topic-specific repos in `/root/repos/` are for **general advisory, research, and strategy**. Actual coding projects live in `/root/projects/`.

| Topic | Thinking Repo (Advisory) | Project Path (Code) |
|-------|--------------------------|----------------------|
| Piano, concert, lessons | `/root/repos/musicalbasics` | - |
| DreamPlay, hardware, Angelo | `/root/repos/dreamplay` | `/root/projects/concept-clone` |
| Personal, travel, life admin | `/root/repos/lionel-personal` | - |

## Architectural Pattern: "Thinking Library"
Instead of the Router (Hermes) doing reasoning, offload to Claude Code for contextual thinking.
1. **Identify**: Is this Strategy (Advisory Repo) or Execution (Code Project)?
2. **Consult**: Fire `claude --print "Based on [Lionel's request] and the context in this repo, what is the best path forward? Update the strategy/code and respond."`
3. **Budget**: Set `claude config set thinking.budget medium` for faster turnaround.
4. **Detail**: Use highly detailed architectural prompts (grid specs, conversion triggers, specific UI goals) rather than sparse instructions to ensure high-fidelity outcomes.

## Creating Thinking Repos
When no existing repo covers a complex request:
```bash
claude -p "Create a new repo at /root/repos/[topic-name]. Initialize with git. Create a CLAUDE.md that explains this repo's purpose: [topic]. Then research/analyze: [Lionel's actual question]. Save your findings as markdown files in the repo. Return your answer to Lionel." \
  --allowedTools "Read,Edit,Bash" \
  --output-format json \
  --max-turns 15 \
  > /tmp/claude-result.json 2>/dev/null
```

## Repo CLAUDE.md Template
Every repo must have a `CLAUDE.md`:
- **Purpose**: What this repo is for.
- **Key entities**: People/stakeholders.
- **Maintenance**: Keep files < 300 lines, archive old content to `/archive`, update context after every task.
- **Response format**: Answer Lionel directly and concisely, update repo files silently.

## Task Execution

### Short Tasks (<10 turns) — Blocking
```bash
cd /root/repos/[repo] && claude -p "PROMPT" \
  --allowedTools "Read,Edit,Bash" \
  --output-format json \
  --max-turns 10 \
  > /tmp/claude-result.json 2>/dev/null && \
  cat /tmp/claude-result.json | jq -r '.result' | head -100
```

### Long Tasks (>10 turns) — Background + Poll
1. **Launch**: `nohup claude -p "PROMPT" ... > /tmp/claude-result.json 2>/dev/null & echo $! > /tmp/claude-pid.txt`
2. **Notify**: "🚀 Working on [task]. I'll check every 3 min."
3. **Poll**: `kill -0 $(cat /tmp/claude-pid.txt) 2>/dev/null && echo "running" || cat /tmp/claude-result.json | jq -r '.result' | head -100`
4. **Max wait**: 15 minutes.

## Prompt Template
Always include:
- "You are working in repo: /root/repos/[name]. Read CLAUDE.md for context."
- "Lionel's request: [RAW MESSAGE]"
- "After completing the task, update any relevant context files in this repo."

## Git Rules
- Follow the repo/user workflow, not a blanket rule.
- For Lionel's active DreamPlay concept-clone work, small and medium approved increments may be committed and pushed directly to `main` so he can review them live.
- For repos that require branch workflow, branch before multi-file changes: `git checkout -b hermes/[task]`.
- If Lionel has not approved direct-to-main momentum for that repo, do not push to `main` without approval.
- `git checkout .` to revert rejected changes.

## Hard Rules — Learn From Mistakes

### Direct edits are for small tasks only
Hermes may directly edit code for small, surgical, one-off fixes when that is faster than orchestration. After each direct fix: verify, commit, and push.

### Use Claude Code for bigger tasks
If the task is substantial, multi-file, ambiguous, or benefits from parallelization, use Claude Code instead of implementing directly. For partitionable work, spin up multiple Claude Code instances, divide the work cleanly, then review and verify each instance's output before merging or reporting success.

### Keep prompts SHORT — let Claude Code think
Don't write essays. Brief, clear instructions win. Bad: "Search the entire codebase for any usage of scrollReveal or scrollRevealDelay as props on the ScrollReveal component. These are invalid props — the correct props are 'animation' (not 'scrollReveal') and 'delay' in ms (not 'scrollRevealDelay' which was a string). The valid animation variants are: fadeIn, fadeInUp, fadeInSlide, slideInLeft, slideInRight, scaleIn. Fix all occurrences and commit." Good: "Find and fix any remaining scrollReveal/scrollRevealDelay prop usage on ScrollReveal components. Commit."

### ALWAYS set effort level
When starting a Claude Code session, run `/effort max` (or appropriate level). Don't leave it on default.

## Never Delegate to Claude Code
Email sending, WhatsApp/Telegram messages, cron jobs, credentials, account changes.
