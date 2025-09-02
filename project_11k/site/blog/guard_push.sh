SITE_ROOT="$HOME/freelancer-tax-blog/project_11k/site/blog"
cd "$SITE_ROOT" || exit 1

echo "==> Guarded push starting (site root: $SITE_ROOT)"

git stash push -u -m "guard-push-stash" >/dev/null 2>&1 || true
git fetch origin
if ! git rebase origin/main; then
  echo "!! Rebase conflict. Resolve manually and re-run ./guard_push.sh"
  exit 1
fi

if git stash list | grep -q guard-push-stash; then
  git stash pop >/dev/null 2>&1 || true
fi

if git push origin main; then
  echo "==> Push successful."
else
  echo "!! Push failed. Run 'git status' and retry."
  exit 1
fi
