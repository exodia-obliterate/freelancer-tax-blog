#!/bin/zsh
set -euo pipefail
SITE="$HOME/freelancer-tax-blog/project_11k/site/blog"
LOGDIR="$HOME/freelancer-tax-blog/automation/logs"
LOG="$LOGDIR/monitor_1s.log"
mkdir -p "$LOGDIR"
: > "$LOG"
while true; do
  TS="$(date +%Y-%m-%dT%H:%M:%S%z)"
  cd "$SITE"
  OUT="$(hugo --gc --minify 2>&1 || true)"
  printf "[%s] BUILD\n" "$TS" >> "$LOG"
  printf "%s\n" "$OUT" >> "$LOG"
  printf "%s\n" "$OUT" | grep -E "FATAL|Error:|ERROR render|error calling partial|failed to render|build failed" | tail -n 8
  sleep 1
done
