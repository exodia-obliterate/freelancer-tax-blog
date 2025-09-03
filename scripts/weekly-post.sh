set -euo pipefail
DATE=$(date '+%Y-%m-%d')
SLUG="week-${DATE}"
if [ -f "project_11k/site/blog/content/posts/${SLUG}.md" ]; then
  DATE=$(date -v+7d '+%Y-%m-%d')
  SLUG="week-${DATE}"
fi
cd project_11k/site/blog
hugo new --kind weekly "posts/${SLUG}.md"
