#!/usr/bin/env zsh
set -e
set -u
set -o pipefail

SITE_ROOT="$HOME/freelancer-tax-blog/project_11k/site/blog"
TARGET_URL="https://blog.kelshd.com"

cd "$SITE_ROOT"
hugo --gc --minify

grep -q -E 'layout:vFINAL|name="build"|property="og:title"' public/index.html
grep -qi -E '<form[^>]*name *= *"?contact"?|data-netlify *= *"?true"?' public/contact/index.html
test -f public/index.xml
grep -q -E '/css/app\.css|integrity=' public/index.html

cd "$HOME/freelancer-tax-blog"
git checkout main
git push origin main

sleep 5
i=1
while [ $i -le 30 ]; do
  html="$(curl -sL "$TARGET_URL" || true)"
  if echo "$html" | grep -q -E 'layout:vFINAL|name="build"|application/ld\+json'; then
    break
  fi
  sleep 10
  i=$((i+1))
done

curl -sIL "$TARGET_URL" | tr -d '\r' | grep -E 'Strict-Transport-Security|Content-Security-Policy|X-Content-Type-Options' | head -n 3 >/dev/null
curl -sL "$TARGET_URL/contact/" | grep -i -E '<form|data-netlify' -m1 >/dev/null
curl -sL "$TARGET_URL/search/" | grep -E 'id="out"|Type above to search' -m1 >/dev/null
curl -sL "$TARGET_URL/tags/" | grep -m1 '<h1>' >/dev/null

echo "OK"
