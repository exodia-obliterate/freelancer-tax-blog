set -e

# Step 1: Back up configs
cp config.toml config.toml.bak.$(date +%s) || true
cp hugo.toml hugo.toml.bak.$(date +%s) || true

# Step 2: Write clean config.toml
cat > config.toml <<'EOF'
baseURL = "https://blog.kelshd.com/"
title = "UK Freelancer Survival Kit: Taxes Edition (2025)"
theme = "ananke"
themesDir = "themes"
canonifyURLs = true
enableRobotsTXT = true
languageCode = "en-gb"

[params]
  description = "Guides, notes, and insights on UK freelancer taxes"
  images = ["images/og-default.jpg"]
EOF

# Step 3: Ensure Ananke theme present
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke || true
git submodule update --init --recursive

# Step 4: Clean + rebuild
rm -rf public resources
hugo --gc --minify

# Step 5: Add Netlify config
cat > netlify.toml <<'EOF'
[build]
  base = "project_11k/site/blog"
  publish = "public"
  command = "hugo --gc --minify"

[build.environment]
  HUGO_VERSION = "0.148.2"
EOF

# Step 6: Verification
echo "---- INDEX TITLE ----"
grep -i "<title>" public/index.html || true
echo "---- CSS REF (ananke) ----"
grep -i "ananke" public/index.html | head -n 5 || true

