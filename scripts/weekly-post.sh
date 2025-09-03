set -euo pipefail
DATE=$(date '+%Y-%m-%d')
SLUG="week-${DATE}"
TITLE="Week ${DATE}"
cd project_11k/site/blog
hugo new "posts/${SLUG}.md"
