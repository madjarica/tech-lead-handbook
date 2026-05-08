#!/usr/bin/env bash
#
# build-epub.sh — build the Tech Lead Handbook as a single EPUB.
#
# Usage:
#   ./scripts/build-epub.sh
#
# Prerequisites:
#   - pandoc 3.x          https://pandoc.org/installing.html
#
# Optional:
#   - mermaid-filter       https://github.com/raghur/mermaid-filter
#     Add --filter mermaid-filter to the pandoc command below
#     to render Mermaid diagrams as images.
#
# See CONVERSION.md for full details and troubleshooting.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
OUTPUT="${DIST_DIR}/tech-lead-handbook.epub"

mkdir -p "${DIST_DIR}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc is not installed." >&2
  echo "       Install from https://pandoc.org/installing.html" >&2
  echo "       See CONVERSION.md for details." >&2
  exit 1
fi

cd "${ROOT_DIR}"

echo "Building EPUB..."
echo "  Source: book/*.md ($(ls book/*.md | wc -l | tr -d ' ') chapters)"
echo "  Output: ${OUTPUT}"

pandoc \
  --metadata-file=metadata.yaml \
  --toc \
  --toc-depth=2 \
  --epub-chapter-level=1 \
  -o "${OUTPUT}" \
  book/*.md

echo "Done: ${OUTPUT}"
echo "Size: $(du -h "${OUTPUT}" | cut -f1)"
