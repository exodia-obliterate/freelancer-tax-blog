SITE_ROOT="$HOME/freelancer-tax-blog/project_11k/site/blog"
set -e
cd "$SITE_ROOT"
if [ ! -f config.toml ]; then echo "missing config.toml at $SITE_ROOT"; exit 1; fi
rm -f terminal.log
hugo --gc --minify 2>&1 | tee terminal.log
if grep -E -i 'FATAL|ERROR' terminal.log >/dev/null; then
  echo "BUILD FAILED: Errors detected"
  echo "---- First 10 error lines ----"
  grep -E -i -n 'FATAL|ERROR' terminal.log | head -n 10
  osascript -e 'display notification "Hugo build failed" with title "Build Guard"'
  say "Build failed"
  exit 1
else
  echo "BUILD PASSED: No errors found"
  osascript -e 'display notification "Build passed" with title "Build Guard"'
  say "Build passed"
  exit 0
fi
