#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WEBSITE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BOOK_DIR="$(cd "$WEBSITE_DIR/../book" && pwd)"
DOCS_DIR="$WEBSITE_DIR/docs"

rm -rf "$DOCS_DIR"
mkdir -p "$DOCS_DIR"

echo "Syncing book files to docs/..."

for src in "$BOOK_DIR"/*.md; do
  filename="$(basename "$src")"
  dest="$DOCS_DIR/$filename"

  cp "$src" "$dest"

  # Fix internal links: strip .md extension and numeric prefix from link targets
  # ./XX-chapter-name.md -> ./chapter-name
  # ./XX-chapter-name.md#section -> ./chapter-name#section
  sed -i '' -E 's|\(\./[0-9]+-([a-z][a-z0-9_-]*)\.md(#[^)]*)?|\(./\1\2|g' "$dest"
done

# Add front matter to introduction to make it the homepage
if [ -f "$DOCS_DIR/00-introduction.md" ]; then
  temp=$(mktemp)
  printf '%s\n' '---' 'slug: /' '---' '' > "$temp"
  cat "$DOCS_DIR/00-introduction.md" >> "$temp"
  mv "$temp" "$DOCS_DIR/00-introduction.md"
fi

echo "Synced $(ls "$DOCS_DIR"/*.md | wc -l | tr -d ' ') files."
