SITE_ROOT="$HOME/freelancer-tax-blog/project_11k/site/blog"
set -e
cd "$SITE_ROOT"
rm -f terminal.log
hugo --gc --minify 2>&1 | tee terminal.log
if grep -E -i 'FATAL|ERROR' terminal.log >/dev/null; then
  echo "FAIL"
  first="$(grep -E -i -n 'FATAL|ERROR' terminal.log | head -n1)"
  echo "$first"
  pathline="$(echo "$first" | grep -Eo '/[^"]+:[0-9]+' | head -n1)"
  file="$(echo "$pathline" | cut -d: -f1)"
  line="$(echo "$pathline" | cut -d: -f2)"
  if [ -n "$file" ] && [ -f "$file" ] && [ -n "$line" ]; then
    start=$((line-5)); [ $start -lt 1 ] && start=1
    end=$((line+5))
    echo "CONTEXT $file:$line"
    nl -ba "$file" | sed -n "${start},${end}p"
  fi
  exit 1
else
  echo "PASS"
  exit 0
fi
