set -euo pipefail
TITLE="$*"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//')
cd project_11k/site/blog
hugo new "posts/${SLUG}.md"
