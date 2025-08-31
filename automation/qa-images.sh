#!/usr/bin/env zsh
set -e
set -u
SITE="$HOME/freelancer-tax-blog/project_11k/site/blog"
cd "$SITE"
hugo --gc --minify
page="public/guides/getting-started/index.html"
test -f "$page"
grep -qi '<picture' "$page" || grep -qi '<img ' "$page"
echo "OK: image present on getting-started"
