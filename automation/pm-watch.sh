#!/bin/zsh
set -euo pipefail
LOGDIR="$HOME/freelancer-tax-blog/automation/logs"
mkdir -p "$LOGDIR"
while true; do
  "$HOME/freelancer-tax-blog/automation/pm-run.sh" || true
  echo "===== SLEEP 15s ====="
  sleep 15
done
