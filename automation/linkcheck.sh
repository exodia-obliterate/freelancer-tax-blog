#!/usr/bin/env zsh
set -e
set -u
SITE="$HOME/freelancer-tax-blog/project_11k/site/blog"
TARGET="https://blog.kelshd.com"
cd "$SITE"
hugo --gc --minify
urls=$(xmllint --xpath '//*[local-name()="loc"]/text()' public/sitemap.xml | tr ' ' '\n' | sed '/^$/d')
fail=0
for u in $urls; do
  code=$(curl -sIL -o /dev/null -w '%{http_code}' "$u" || echo 000)
  echo "$code $u"
  case "$code" in
    200|204|301|302|304) : ;;
    *) fail=1 ;;
  esac
done
[ $fail -eq 0 ] && echo "OK: linkcheck passed" || { echo "FATAL: linkcheck failures above"; exit 1; }
