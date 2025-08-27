#!/usr/bin/env bash
set -euo pipefail

SITE_ROOT="${SITE_ROOT:-$HOME/freelancer-tax-blog/project_11k/site/blog}"
BLOG_URL="${BLOG_URL:-https://blog.kelshd.com}"

echo "▶ Using SITE_ROOT=$SITE_ROOT"
cd "$SITE_ROOT"

echo "▶ Checking Hugo"
hugo version >/dev/null

ts=$(date +%Y%m%d_%H%M%S)

echo "▶ Ensuring clean Ananke theme"
if [ -d "themes/ananke" ]; then
  mkdir -p ".backup/themes"
  mv "themes/ananke" ".backup/themes/ananke_$ts"
fi
rm -rf "themes/ananke"
git clone --depth 1 https://github.com/theNewDynamic/gohugo-theme-ananke "themes/ananke"

echo "▶ Verifying Ananke templates"
test -f "themes/ananke/layouts/_default/baseof.html"
test -f "themes/ananke/layouts/_default/single.html"
test -f "themes/ananke/layouts/_default/list.html"

echo "▶ Forcing theme via config override"
mkdir -p config/_default
printf 'theme = "ananke"\nthemesDir = "themes"\n' > config/_default/zz-theme-override.toml

echo "▶ Effective Hugo settings"
hugo config | grep -iE '^(theme|themesdir)'

echo "▶ Building site"
hugo --gc --minify

echo "▶ Committing and pushing if repo"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git add themes/ananke config/_default/zz-theme-override.toml config.toml hugo.toml || true
  if ! git diff --cached --quiet; then
    git commit -m "Fix theme: clean Ananke, force theme via override, build"
    git push || true
  else
    echo "ℹ No changes to commit"
  fi
else
  echo "ℹ Not a git repo; skipping push"
fi

echo "▶ Verifying live site CSS at $BLOG_URL"
if command -v curl >/dev/null 2>&1; then
  html="$(curl -fsSL "$BLOG_URL" || true)"
  if [ -n "$html" ] && printf "%s" "$html" | grep -qE '<link[^>]+rel=["'\'']stylesheet["'\''][^>]+(ananke|main\.min\.css)'; then
    echo "✅ PASS: Found theme stylesheet on $BLOG_URL"
  else
    echo "❌ FAIL: Could not confirm theme CSS on $BLOG_URL"
    echo "ℹ Tip: View source and search for \"/ananke/\" or \"main.min.css\""
  fi
else
  echo "ℹ curl not available; skipped live verification"
fi

echo "✅ Done"
h

