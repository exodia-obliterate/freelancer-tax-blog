#!/bin/bash
set -euo pipefail

DOMAIN="${1:-blog.kelshd.com}"
ASSET="${2:-/css/main.css}"

FILTER='content-security|strict-transport|referrer-policy|permissions-policy|x-frame|x-content-type|cache-control'

echo "=== Homepage headers ==="
curl -sSI "https://${DOMAIN}/" | grep -Ei "$FILTER" || true
echo

echo "=== Feed headers (/index.xml) ==="
curl -sSI "https://${DOMAIN}/index.xml" | grep -Ei 'cache-control' || true
echo

echo "=== Asset headers (${ASSET}) ==="
curl -sSI "https://${DOMAIN}${ASSET}" | grep -Ei 'cache-control' || true
echo

echo "=== Canonical tag on homepage ==="
curl -sS "https://${DOMAIN}/" | tr -d '\n' | grep -Eio '<link[^>]+rel="canonical"[^>]*>' || echo "No canonical tag found"
echo

echo "=== robots.txt ==="
curl -sS "https://${DOMAIN}/robots.txt" | sed -n '1,40p'
echo

echo "=== sitemap.xml reachable (first lines) ==="
curl -sS "https://${DOMAIN}/sitemap.xml" | head -n 20
echo

