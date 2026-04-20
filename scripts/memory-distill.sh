#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="/home/openclaw/.openclaw/workspace"
cd "$WORKSPACE"

STAMP="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"
TODAY="$(date -u +%F)"
YESTERDAY="$(date -u -d 'yesterday' +%F 2>/dev/null || python3 - <<'PY'
from datetime import datetime, timedelta, timezone
print((datetime.now(timezone.utc) - timedelta(days=1)).strftime('%Y-%m-%d'))
PY
)"
REPORT="reports/memory-distill-report-${TODAY}.md"

{
  echo "# Memory distillation review"
  echo
  echo "Generated: ${STAMP}"
  echo
  echo "## Goal"
  echo "Review recent daily memory capture and identify durable facts worth promoting into atomic memory files."
  echo
  echo "## Files reviewed"
  for f in "memory/${TODAY}.md" "memory/${YESTERDAY}.md"; do
    if [[ -f "$f" ]]; then
      echo "- $f"
    fi
  done
  echo
  echo "## Candidate promotions"

  found=0
  for f in "memory/${TODAY}.md" "memory/${YESTERDAY}.md"; do
    if [[ -f "$f" ]]; then
      if [[ $found -eq 0 ]]; then
        found=1
      fi
      echo "### $f"
      python3 - "$f" <<'PY'
import re, sys, pathlib
path = pathlib.Path(sys.argv[1])
text = path.read_text()
patterns = [r'^- .*', r'^\* (Decision|Information|Insight|Preference|Correction|Task|Error):.*']
lines = text.splitlines()
for line in lines:
    if any(re.match(p, line) for p in patterns):
        print(f"- {line.lstrip('- ').strip()}")
PY
      echo
    fi
  done

  if [[ $found -eq 0 ]]; then
    echo "No recent daily memory files found."
    echo
  fi

  echo "## Manual action"
  echo "Promote only durable signals into atomic files under memory/projects/, memory/people/, memory/tools/, memory/ideas/, or memory/summaries/."
  echo "Do not rewrite MEMORY.md from scratch. Use targeted edits only when needed."
} > "$REPORT"

echo "$STAMP memory distillation review written to $REPORT"