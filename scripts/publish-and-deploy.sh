set -euo pipefail
MSG=${1:-content update}
cd project_11k/site/blog
hugo --gc --minify
cd ../../..
git add -A
git commit -m "$MSG"
git push origin main
netlify deploy --prod --dir=project_11k/site/blog/public
