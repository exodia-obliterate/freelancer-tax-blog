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
grep -q -E 'class="featured"' public/index.html
grep -q -E 'og:image|twitter:image' public/index.html
grep -q -E 'integrity=' public/index.html
grep -q -E 'script.*plausible.io' public/index.html

curl -sIL "$TARGET" | grep -E 'Strict-Transport-Security'
curl -sIL "$TARGET" | grep -E 'Content-Security-Policy'
curl -sIL "$TARGET" | grep -E 'X-Content-Type-Options'

curl -sL "$TARGET/sitemap.xml" | grep -q '<urlset'
curl -sL "$TARGET/feed" | grep -q '<rss'

curl -sL "$TARGET/contact/" | grep -i -q '<form'
curl -sL "$TARGET/guides/" | grep -q 'Getting Started'
curl -sL "$TARGET/tags/" | grep -q '<h1>'
curl -sL "$TARGET/categories/" | grep -q '<h1>'

echo "=== QA FINAL OK ==="
