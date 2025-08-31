#!/usr/bin/env zsh
set -e
set -u

TARGET="https://blog.kelshd.com"

urls=$(curl -sL "$TARGET/sitemap.xml" | sed -n 's:.*<loc>\(.*\)</loc>.*:\1:p' | sed '/^$/d' | sort -u)
[ -n "$urls" ] || { echo "FATAL: no URLs parsed from sitemap"; exit 1; }

fail=0
for u in $urls; do
  code=$(curl -s -o /dev/null -w '%{http_code}' -L "$u" || echo 000)
  if [ "$code" = "000" ] || [ -z "$code" ]; then
    code=$(curl -s -o /dev/null -w '%{http_code}' "$u" || echo 000)
  fi
  echo "$code $u"
  case "$code" in
    200|204|301|302|304) : ;;
    *) fail=1 ;;
  esac
done

[ $fail -eq 0 ] && echo "OK: linkcheck passed" || { echo "FATAL: linkcheck failures above"; exit 1; }
