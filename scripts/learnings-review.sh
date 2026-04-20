#!/usr/bin/env bash
set -uo pipefail

WORKSPACE="/home/openclaw/.openclaw/workspace"
cd "$WORKSPACE"

STAMP="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"
TODAY="$(date -u +%F)"
REPORT="reports/learnings-review-report-${TODAY}.md"

count_entries() {
  local file="$1"
  local pattern="$2"
  if [[ -f "$file" ]]; then
    grep -cE "$pattern" "$file" || true
  else
    echo 0
  fi
}

LRN_COUNT="$(count_entries .learnings/LEARNINGS.md '^## \[LRN-')"
ERR_COUNT="$(count_entries .learnings/ERRORS.md '^## \[ERR-')"
FEAT_COUNT="$(count_entries .learnings/FEATURE_REQUESTS.md '^## \[FEAT-')"
PENDING_COUNT="$(grep -Rhc '^Status: pending' .learnings 2>/dev/null | awk '{s+=$1} END{print s+0}')"

{
  echo "# Learnings review"
  echo
  echo "Generated: ${STAMP}"
  echo
  echo "## Snapshot"
  echo "- Learnings entries: ${LRN_COUNT}"
  echo "- Error entries: ${ERR_COUNT}"
  echo "- Feature request entries: ${FEAT_COUNT}"
  echo "- Pending statuses across .learnings/: ${PENDING_COUNT}"
  echo
  echo "## Files reviewed"
  echo "- .learnings/LEARNINGS.md"
  echo "- .learnings/ERRORS.md"
  echo "- .learnings/FEATURE_REQUESTS.md"
  echo
  echo "## Pending items"
  python3 - <<'PY' || true
from pathlib import Path
printed = False
for rel in ['.learnings/LEARNINGS.md', '.learnings/ERRORS.md', '.learnings/FEATURE_REQUESTS.md']:
    path = Path(rel)
    if not path.exists():
        continue
    lines = path.read_text().splitlines()
    current = None
    block = []
    found_any = False
    for line in lines + ['## __END__']:
        if line.startswith('## '):
            if current is not None:
                status = next((x for x in block if x.startswith('Status:')), None)
                if status and 'pending' in status:
                    found_any = True
                    printed = True
                    print(f'- {current}')
                    for item in block:
                        if item.startswith(('Context:', 'Learning:', 'Need:', 'Blocker:', 'Next Step:', 'Resolution:')):
                            print(f'  {item}')
            current = None if line == '## __END__' else line[3:]
            block = []
        else:
            if current is not None:
                block.append(line)
    if not found_any:
        print(f'- No pending items in {rel}')
        printed = True
if not printed:
    print('- No learnings files found or no pending items detected')
PY
  echo
  echo "## Manual action"
  echo "Review repeated failures or requests and promote reusable lessons into memory/process when they become durable."
} > "$REPORT"

STATUS=0
[[ -f "$REPORT" ]] || STATUS=1

echo "$STAMP learnings review written to $REPORT"
exit "$STATUS"