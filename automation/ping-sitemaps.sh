#!/usr/bin/env zsh
set -e
set -u
S="https://blog.kelshd.com/sitemap.xml"
curl -s "https://www.google.com/ping?sitemap=$S" >/dev/null || true
curl -s "https://www.bing.com/ping?sitemap=$S"   >/dev/null || true
echo "OK: pinged search engines"
