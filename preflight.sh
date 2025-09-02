SITE_ROOT="$HOME/freelancer-tax-blog/project_11k/site/blog"
REPO_ROOT="$HOME/freelancer-tax-blog"
[ -d "$SITE_ROOT/content" ] || { echo "missing content/ in site root"; exit 1; }
[ -d "$SITE_ROOT/config/_default" ] || { echo "missing config/_default in site root"; exit 1; }
[ -f "$REPO_ROOT/netlify.toml" ] || { echo "missing netlify.toml at repo root"; exit 1; }
[ ! -f "$SITE_ROOT/netlify.toml" ] || { echo "unexpected netlify.toml in site root"; exit 1; }
if [ -d "$SITE_ROOT/project_11k" ]; then echo "nested project_11k in site root"; exit 1; fi
exit 0
