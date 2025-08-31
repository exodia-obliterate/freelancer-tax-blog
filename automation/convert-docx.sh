#!/usr/bin/env zsh
set -e
set -u
set -o pipefail

# Usage: automation/convert-docx.sh input.docx output.md section
# Example: automation/convert-docx.sh docs/file.docx content/guides/file.md guides

in="$1"
out="$2"
section="$3"

mkdir -p "$(dirname "$out")"

# Convert DOCX → Markdown with Pandoc
pandoc "$in" -f docx -t markdown -o "$out.tmp" --standalone

# Wrap in Hugo front matter if missing
if ! grep -q '^+++' "$out.tmp"; then
  title="$(basename "$out" .md | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')"
  d="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  {
    echo "+++"
    echo "title = \"$title\""
    echo "date = $d"
    echo "description = \"\""
    echo "draft = true"
    echo "tags = []"
    echo "categories = [\"$section\"]"
    echo "+++"
    echo
    cat "$out.tmp"
  } > "$out"
  rm "$out.tmp"
else
  mv "$out.tmp" "$out"
fi

echo "OK: converted $in → $out"
