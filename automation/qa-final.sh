#!/usr/bin/env zsh
set -e
set -u
set -o pipefail

SITE_ROOT="$HOME/freelancer-tax-blog/project_11k/site/blog"
TARGET="https://blog.kelshd.com"

cd "$SITE_ROOT"
hugo --gc --minify

test -f public/index.html
test -f public/sitemap.xml
test -f public/index.xml

grep -qi -E '<form[^>]*name *= *"?contact"?|data-netlify' public/contact/index.html
grep -qi -E 'class="featured"|>Featured<' public/index.html
grep -qi -E 'og:image|twitter:image' public/index.html
grep -qi -E 'integrity=' public/index.html
grep -qi -E 'script.*plausible.io' public/index.html

ok_headers=0
i=1
while [ $i -le 30 ]; do
  hdr="$(curl -sIL "$TARGET" | tr -d '\r')"
  echo "$hdr" | grep -qi 'Strict-Transport-Security' && ok_headers=$((ok_headers+1))
  echo "$hdr" | grep -qi 'Content-Security-Policy' && ok_headers=$((ok_headers+1))
  echo "$hdr" | grep -qi 'X-Content-Type-Options' && ok_headers=$((ok_headers+1))
  if [ $ok_headers -ge 2 ]; then
    break
  fi
  ok_headers=0
  sleep 10
  i=$((i+1))
done
[ $ok_headers -ge 2 ]

curl -sL "$TARGET/index.xml" | grep -qi '<rss'
curl -sL "$TARGET/sitemap.xml" | grep -qi '<urlset'

curl -sL "$TARGET/contact/" | grep -qi '<form'
curl -sL "$TARGET/guides/" | grep -qi 'Getting Started'
curl -sL "$TARGET/tags/" | grep -qi '<h1>'
curl -sL "$TARGET/categories/" | grep -qi '<h1>'

echo "=== QA FINAL OK ==="
