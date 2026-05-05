# Conversion Guide

This document explains how to convert the Markdown source tree into a
single PDF or EPUB using Pandoc. The build scripts in `scripts/` are
thin wrappers around the commands shown here.

The goal is reproducible builds with no surprises.

---

## Prerequisites

Install the following on your machine:

- **Pandoc** 3.x — Markdown to PDF/EPUB conversion.
  See `https://pandoc.org/installing.html`.
- **A LaTeX engine** — required for PDF output.
  Recommended: **TeX Live** with `xelatex`, or **TinyTeX**.
- **Mermaid Filter** (optional) — only if you want Mermaid diagrams
  rendered as SVG/PNG in the PDF/EPUB.
  See `https://github.com/raghur/mermaid-filter`.

Verify versions:

```bash
pandoc --version
xelatex --version
```

> Verify against official documentation. Pandoc flags and filters
> change between major versions.

---

## Source Layout Used by the Build

The build concatenates Markdown files from `book/` in **alphabetical
order**, which matches the chapter numbering. The convention:

- `book/00-introduction.md` is read first.
- `book/26-glossary.md` is read last.
- All other chapters are read between them, in numeric order.

Do not rely on any other ordering. If you add a new chapter, give it
a numeric prefix that places it in the correct position.

`metadata.yaml` provides title, author, language, and styling hints
to Pandoc. Update it deliberately.

---

## Build PDF

The recommended command:

```bash
pandoc \
  --metadata-file=metadata.yaml \
  --pdf-engine=xelatex \
  --toc \
  --toc-depth=2 \
  --number-sections \
  --top-level-division=chapter \
  -o build/tech-lead-handbook.pdf \
  book/*.md
```

Notes:

- `--top-level-division=chapter` makes the H1 of each chapter render
  as a real chapter break in the PDF.
- `--toc-depth=2` keeps the table of contents readable.
- `--number-sections` adds numeric prefixes in the rendered output.
- The output goes to `build/`, which is created by the script.

If you want Mermaid diagrams rendered, add `--filter mermaid-filter`.

---

## Build EPUB

```bash
pandoc \
  --metadata-file=metadata.yaml \
  --toc \
  --toc-depth=2 \
  --epub-chapter-level=1 \
  -o build/tech-lead-handbook.epub \
  book/*.md
```

Notes:

- `--epub-chapter-level=1` splits the EPUB at every H1, so each
  chapter file becomes a separate EPUB section.
- EPUB readers handle code blocks differently. Keep code blocks short
  to avoid horizontal scrolling on small screens.

---

## Mermaid Diagrams

Mermaid blocks render natively on GitHub and many Markdown viewers,
but Pandoc does not render them by default. There are three options:

1. **Leave them as fenced `mermaid` blocks.** They will render on
   GitHub but appear as raw text in the PDF/EPUB.
2. **Use `mermaid-filter`.** Adds rendered SVG/PNG to the PDF/EPUB
   build at the cost of a Node.js dependency.
3. **Pre-render to PNG/SVG.** Replace `mermaid` blocks with image
   references at build time. More work, fewer runtime dependencies.

Pick one strategy per release and document it in
`notes/generation-log.md`.

---

## Reproducibility Tips

- Pin the Pandoc version in `notes/generation-log.md`.
- Keep all build flags inside the scripts in `scripts/`. Do not run
  Pandoc from memory.
- Do not commit `build/`. The shipped `.gitignore` already excludes it.
- Treat the PDF/EPUB as **build artifacts**. The Markdown source is
  the canonical book.

---

## Troubleshooting

- **"Unicode character not set up for use with LaTeX"**: switch to
  `xelatex` (already the recommended engine here).
- **Code blocks bleed off the page**: shorten lines, or set a
  Pandoc highlight style with shorter line wrapping.
- **EPUB chapters appear in the wrong order**: confirm chapter file
  names start with their numeric prefix.
- **Mermaid blocks appear as raw text**: install `mermaid-filter`
  and add `--filter mermaid-filter` to the Pandoc command.
- **Title page shows the wrong author or title**: check
  `metadata.yaml`.
