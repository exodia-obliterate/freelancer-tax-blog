#!/bin/zsh
set -euo pipefail
TS="$(date +%Y%m%d_%H%M%S)"
LOGDIR="$HOME/freelancer-tax-blog/automation/logs"
SITE="$HOME/freelancer-tax-blog/project_11k/site/blog"
BUILD_LOG="$LOGDIR/build_$TS.log"
QA_LOG="$LOGDIR/qa_$TS.log"
COMBINED="$LOGDIR/combined_$TS.log"

mkdir -p "$LOGDIR"

{
  echo "===== BUILD $TS ====="
  cd "$SITE"
  hugo --gc --minify
  echo "===== BUILD DONE $TS ====="
} 2>&1 | tee "$BUILD_LOG" | tee -a "$COMBINED" >/dev/null

{
  echo "===== QA $TS ====="
  cd "$HOME/freelancer-tax-blog"
  [ -x automation/qa-final.sh ] && automation/qa-final.sh
  [ -x automation/linkcheck.sh ] && automation/linkcheck.sh
  [ -x automation/qa-images.sh ] && automation/qa-images.sh
  echo "===== QA DONE $TS ====="
} 2>&1 | tee "$QA_LOG" | tee -a "$COMBINED" >/dev/null

cp -f "$BUILD_LOG" "$LOGDIR/build_latest.log"
cp -f "$QA_LOG" "$LOGDIR/qa_latest.log"
cp -f "$COMBINED" "$LOGDIR/combined_latest.log"
