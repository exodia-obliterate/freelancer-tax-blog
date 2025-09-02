SITE_ROOT="$HOME/freelancer-tax-blog/project_11k/site/blog"
set -e
cd "$SITE_ROOT"
if ! [ -f terminal.log ]; then echo "terminal.log missing"; exit 1; fi
first="$(grep -E -i -n 'FATAL|ERROR' terminal.log | head -n1 || true)"
if [ -z "$first" ]; then echo "NO ERRORS"; exit 0; fi
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
