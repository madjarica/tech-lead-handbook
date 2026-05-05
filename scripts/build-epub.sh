#!/usr/bin/env bash
#
# build-epub.sh — build the Tech Lead Handbook as a single EPUB.
#
# Usage:
#   ./scripts/build-epub.sh
#
# Requirements:
#   - pandoc 3.x
#
# See ../CONVERSION.md for details and troubleshooting.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
OUTPUT="${BUILD_DIR}/tech-lead-handbook.epub"

mkdir -p "${BUILD_DIR}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc is not installed. See ../CONVERSION.md." >&2
  exit 1
fi

cd "${ROOT_DIR}"

pandoc \
  --metadata-file=metadata.yaml \
  --toc \
  --toc-depth=2 \
  --epub-chapter-level=1 \
  -o "${OUTPUT}" \
  book/*.md

echo "Built: ${OUTPUT}"
