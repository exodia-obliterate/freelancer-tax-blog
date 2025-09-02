set -e
./preflight.sh
netlify status
netlify deploy --prod --dir=project_11k/site/blog/public
