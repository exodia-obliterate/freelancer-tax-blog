set -euo pipefail
DATE=$(date '+%Y-%m')
SLUG="month-${DATE}"
TITLE="Month ${DATE} Summary"
cd project_11k/site/blog
hugo new "posts/${SLUG}.md"
