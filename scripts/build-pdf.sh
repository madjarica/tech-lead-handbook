#!/usr/bin/env bash
#
# build-pdf.sh — build the Tech Lead Handbook as a single PDF.
#
# Usage:
#   ./scripts/build-pdf.sh
#
# Requirements:
#   - pandoc 3.x
#   - a LaTeX engine (xelatex recommended; TeX Live or TinyTeX)
#
# See ../CONVERSION.md for details and troubleshooting.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"
OUTPUT="${BUILD_DIR}/tech-lead-handbook.pdf"

mkdir -p "${BUILD_DIR}"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc is not installed. See ../CONVERSION.md." >&2
  exit 1
fi

if ! command -v xelatex >/dev/null 2>&1; then
  echo "error: xelatex is not installed. See ../CONVERSION.md." >&2
  exit 1
fi

cd "${ROOT_DIR}"

pandoc \
  --metadata-file=metadata.yaml \
  --pdf-engine=xelatex \
  --toc \
  --toc-depth=2 \
  --number-sections \
  --top-level-division=chapter \
  -o "${OUTPUT}" \
  book/*.md

echo "Built: ${OUTPUT}"
