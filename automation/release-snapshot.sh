#!/usr/bin/env zsh
set -e
set -u
set -o pipefail
SITE="$HOME/freelancer-tax-blog/project_11k/site/blog"
OUT="$HOME/freelancer-tax-blog/automation/site-snapshot-$(date -u +%Y%m%dT%H%M%SZ).tar.gz"
cd "$SITE"
hugo --gc --minify
tar -C public -czf "$OUT" .
echo "$OUT"
