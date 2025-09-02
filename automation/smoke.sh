#!/bin/zsh
set -euo pipefail
BASE="https://blog.kelshd.com"
urls=(
  "$BASE/"
  "$BASE/guides/getting-started/"
  "$BASE/contact/"
  "$BASE/sitemap.xml"
  "$BASE/index.xml"
)
fail=0
for u in "${urls[@]}"; do
  code=$(curl -sIL -o /dev/null -w '%{http_code}' "$u" || echo 000)
  echo "$code $u"
  case "$code" in
    200|204|301|302|304) : ;;
    *) fail=1 ;;
  esac
done
echo "Headers for $BASE"
curl -sIL "$BASE" | awk 'BEGIN{IGNORECASE=1}/^(strict-transport-security|content-security-policy|referrer-policy|x-frame-options|x-content-type-options):/{print}'
[ $fail -eq 0 ] || { echo "FATAL: smoke failures"; exit 1; }
