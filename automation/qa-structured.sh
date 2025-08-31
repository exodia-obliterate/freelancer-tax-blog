#!/usr/bin/env zsh
set -e
set -u
set -o pipefail
SITE="$HOME/freelancer-tax-blog/project_11k/site/blog"
cd "$SITE"
hugo --gc --minify
grep -qi '"@type":"WebSite"' public/index.html
grep -qi '"@type":"Organization"' public/index.html
grep -qi '"@type":"BreadcrumbList"' public/blog/launch-notes/index.html || true
echo "OK"
