#!/usr/bin/env zsh
set -e
set -u
set -o pipefail

SITE="$HOME/freelancer-tax-blog/project_11k/site/blog"

cd "$SITE"
if grep -R --include='*.md' -n 'draft *= *true' content >/dev/null 2>&1; then
  echo "FATAL: Draft content found. Remove draft=true before release."
  grep -R --include='*.md' -n 'draft *= *true' content || true
  exit 1
fi
echo "OK: no drafts flagged."
