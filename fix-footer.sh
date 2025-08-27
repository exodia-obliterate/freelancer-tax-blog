# Make sure project-level partials directory exists
mkdir -p layouts/partials

# Copy theme footer into your own project override directory
cp themes/ananke/layouts/partials/site-footer.html layouts/partials/site-footer.html

# Add fingerprint to the override
cat > layouts/partials/site-footer.html <<'EOF'
<footer class="pv4 ph3 ph5-ns tc">
  <small class="f6 db">© {{ now.Year }} {{ .Site.Title }} — Powered by Hugo + Ananke</small>
  <!-- build:{{ now.Format "2006-01-02T15:04:05Z07:00" }} -->
</footer>
EOF

