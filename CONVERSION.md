# Conversion Guide

This document explains how to convert the Markdown source into a single
PDF or EPUB using Pandoc. The build scripts in `scripts/` are thin
wrappers around the commands shown here.

The goal is reproducible builds with no surprises.

---

## Requirements

### Pandoc

Install **Pandoc 3.x** from <https://pandoc.org/installing.html>.

| Platform | Command |
|----------|---------|
| macOS    | `brew install pandoc` |
| Ubuntu/Debian | `sudo apt install pandoc` (may be older; use the official release for 3.x) |
| Windows  | Download the `.msi` installer from the Pandoc releases page |

Verify:

```bash
pandoc --version
```

### LaTeX engine (PDF only)

A LaTeX distribution with `xelatex` is required for PDF output.

| Platform | Recommended |
|----------|-------------|
| macOS    | `brew install --cask mactex-no-gui` or TinyTeX |
| Ubuntu/Debian | `sudo apt install texlive-xetex texlive-fonts-recommended texlive-latex-recommended` |
| Windows  | MiKTeX or TeX Live |

Alternatively, install **TinyTeX** (lightweight):

```bash
# Any platform with R or standalone installer
# See https://yihui.org/tinytex/
```

Verify:

```bash
xelatex --version
```

### Mermaid filter (optional)

Only needed if you want Mermaid diagrams rendered as images in the
PDF/EPUB. Without it, Mermaid blocks appear as raw text.

```bash
npm install -g mermaid-filter
```

See <https://github.com/raghur/mermaid-filter>.

---

## Recommended Build Order

1. Review `metadata.yaml` — confirm title, author, and language.
2. Build PDF — run `scripts/build-pdf.sh`.
3. Build EPUB — run `scripts/build-epub.sh`.
4. Spot-check output — verify TOC, chapter breaks, code blocks, and
   tables render correctly.
5. Review the [Final Publishing Checklist](#final-publishing-checklist)
   at the bottom of this file.

---

## Build PDF

### Quick start

```bash
chmod +x scripts/build-pdf.sh
./scripts/build-pdf.sh
```

Output: `dist/tech-lead-handbook.pdf`

### Manual command

```bash
pandoc \
  --metadata-file=metadata.yaml \
  --pdf-engine=xelatex \
  --toc \
  --toc-depth=3 \
  --number-sections \
  --top-level-division=chapter \
  -o dist/tech-lead-handbook.pdf \
  book/*.md
```

Notes:

- `--top-level-division=chapter` treats each H1 as a chapter break.
- `--toc-depth=3` includes H1, H2, and H3 in the table of contents
  for full topic coverage.
- `--number-sections` adds numeric prefixes (1, 1.1, 1.2, ...).
- `book/*.md` expands in alphabetical order, which matches the chapter
  numbering convention (`00-`, `01-`, ..., `26-`).

To include rendered Mermaid diagrams, add `--filter mermaid-filter`
before the `-o` flag.

---

## Build EPUB

### Quick start

```bash
chmod +x scripts/build-epub.sh
./scripts/build-epub.sh
```

Output: `dist/tech-lead-handbook.epub`

### Manual command

```bash
pandoc \
  --metadata-file=metadata.yaml \
  --toc \
  --toc-depth=3 \
  --epub-chapter-level=1 \
  -o dist/tech-lead-handbook.epub \
  book/*.md
```

Notes:

- `--epub-chapter-level=1` splits the EPUB at every H1, so each
  chapter becomes a separate EPUB section.
- EPUB readers handle code blocks differently. Keep code blocks short
  to avoid horizontal scrolling on small screens.

---

## Build Both

```bash
chmod +x scripts/build-pdf.sh scripts/build-epub.sh
./scripts/build-pdf.sh && ./scripts/build-epub.sh
```

Both outputs go to `dist/`.

---

## Handling Mermaid Diagrams

The book contains **43 Mermaid diagram blocks** across 24 chapters.
Mermaid renders natively on GitHub, GitLab, and many Markdown editors,
but **Pandoc does not render Mermaid by default**.

### Options

| Strategy | Pros | Cons |
|----------|------|------|
| Leave as fenced code | No extra tooling | Diagrams appear as raw text in PDF/EPUB |
| Use `mermaid-filter` | Automatic rendering at build time | Requires Node.js + Puppeteer/Chromium |
| Pre-render to PNG/SVG | No runtime dependencies | Manual step; images must be maintained |

### Recommended approach

For a first build, skip Mermaid rendering — the text content is
self-contained. When you are ready:

```bash
npm install -g mermaid-filter
# Then add to the Pandoc command:
pandoc --filter mermaid-filter ...
```

If `mermaid-filter` fails on some diagrams (complex arrow labels,
subgraphs), pre-render those specific diagrams:

```bash
npx @mermaid-js/mermaid-cli -i diagram.mmd -o diagram.png
```

Then replace the fenced block with `![description](diagram.png)`.

### Chapters with Mermaid diagrams

| Chapter | Diagrams |
|---------|----------|
| 00 Introduction | 1 |
| 01 Algorithms and Data Structures | 2 |
| 02 SQL and NoSQL | 2 |
| 03 Docker and Kubernetes | 2 |
| 04 AWS | 3 |
| 05 JavaScript | 1 |
| 06 TypeScript | 1 |
| 07 Angular | 1 |
| 08 React | 1 |
| 09 Next.js | 1 |
| 10 Node.js | 1 |
| 11 Python | 1 |
| 12 API Design | 2 |
| 13 System Design | 3 |
| 14 Software Architecture | 3 |
| 15 Security | 2 |
| 16 Testing and Quality | 2 |
| 17 CI/CD and DevOps | 1 |
| 18 Observability | 1 |
| 19 Performance and Scalability | 1 |
| 20 Git and Engineering Workflow | 3 |
| 21 AI Usage in Software Engineering | 5 |
| 22 Soft Skills | 1 |
| 23 Tech Lead Skills | 1 |
| 25 Practical Interview Scenarios | 1 |

---

## Handling Code Blocks

All code blocks in the book use fenced syntax with language tags
(e.g., ` ```ts `, ` ```bash `, ` ```yaml `). Pandoc respects these
tags for syntax highlighting.

### Known considerations

- **Long lines**: Some code examples have lines exceeding 80 characters.
  In PDF, these may overflow the text area. Pandoc's `--wrap=auto` does
  not wrap code blocks. If overflow is a problem, consider adding
  `\lstset{breaklines=true}` to a LaTeX header include, or manually
  shorten the longest lines.
- **EPUB code blocks**: EPUB readers vary widely in monospace font
  rendering and horizontal scroll behavior. Test on your target reader.
- **`text` blocks**: ASCII diagrams use the `text` language tag. These
  render as plain monospace without syntax highlighting, which is
  intentional.

---

## Handling Tables

The book contains tables throughout. Most are 2–4 columns and convert
cleanly. Six chapters contain wider tables (6+ columns):

| Chapter | Notes |
|---------|-------|
| 01 Algorithms and Data Structures | Sorting algorithm comparison table (6 columns) |
| 12 API Design | HTTP methods table (6 columns) |
| 13 System Design | Comparison tables (6 columns) |
| 14 Software Architecture | Pattern comparison tables |
| 20 Git and Engineering Workflow | Workflow comparison tables |
| 23 Tech Lead Skills | Responsibility matrices |

### PDF table overflow

Wide tables may extend beyond the page margin in PDF. Mitigations:

1. Use `--variable=geometry:margin=0.75in` for slightly wider pages.
2. Use landscape mode for specific pages (requires LaTeX customization).
3. Accept minor overflow for reference tables — the Markdown source
   remains the canonical version.

### EPUB table rendering

Most EPUB readers render Markdown tables as HTML `<table>` elements.
Wide tables may require horizontal scrolling on small screens. This is
acceptable for reference content.

---

## Handling Internal Links

Chapters use relative Markdown links (e.g.,
`[Security](./15-security.md)`) for cross-references. These work on
GitHub and in most Markdown viewers.

### Pandoc behavior

- **PDF**: Pandoc resolves relative `.md` links within the concatenated
  input. Cross-chapter links generally work because all chapters are
  passed as a single input stream. Links resolve to heading anchors.
- **EPUB**: Same behavior — Pandoc concatenates then splits, preserving
  internal links.

### Known limitations

- Links to specific sections (e.g., `./15-security.md#owasp-top-10`)
  depend on Pandoc generating matching anchor IDs. Most work, but
  verify after building.
- External URLs (https://...) work in both PDF and EPUB.

---

## Handling Fonts

The `metadata.yaml` does not specify a custom font. Pandoc uses the
LaTeX default (Computer Modern for PDF, system serif for EPUB).

### If you want a custom font

Add to `metadata.yaml`:

```yaml
mainfont: "DejaVu Serif"
sansfont: "DejaVu Sans"
monofont: "DejaVu Sans Mono"
```

Use fonts installed on your system. Do not bundle font files in the
repository.

### Fallback

If `xelatex` reports a missing font, either:

1. Install the font on your system.
2. Remove the `monofont`/`mainfont`/`sansfont` lines from
   `metadata.yaml` to use defaults.

---

## Troubleshooting

### "Unicode character not set up for use with LaTeX"

The book uses Unicode characters (curly quotes, em dashes, arrows).
The `xelatex` engine handles these natively. If you see this error,
confirm you are using `--pdf-engine=xelatex` (not `pdflatex`).

### Code blocks overflow the page

Long code lines extend past the right margin. Options:

- Shorten lines in the Markdown source (preferred).
- Add `header-includes: \usepackage{listings}\lstset{breaklines=true}`
  to `metadata.yaml` and use `--listings` in the Pandoc command.

### EPUB chapters appear in the wrong order

Chapter files use numeric prefixes (`00-`, `01-`, ..., `26-`). The
`book/*.md` glob expands in alphabetical order, which matches chapter
order. If you add a chapter, give it the correct numeric prefix.

### Mermaid blocks appear as raw text

Install `mermaid-filter` and add `--filter mermaid-filter` to the
Pandoc command. See [Handling Mermaid Diagrams](#handling-mermaid-diagrams).

### Title page shows wrong metadata

Check `metadata.yaml`. The `title`, `subtitle`, `author`, and `date`
fields control the title page.

### Missing LaTeX packages

If `xelatex` fails with "File not found" for a `.sty` package:

```bash
# TeX Live
tlmgr install <package-name>

# TinyTeX (auto-installs missing packages)
# Just re-run the build — TinyTeX fetches what it needs.
```

### "YAML parse exception" from horizontal rules

Pandoc treats `---` as a YAML metadata block boundary. All horizontal
rules in the book use `***` instead to avoid this. If you add new
horizontal rules, use `***` not `---`.

### Math expressions render as raw text

Inline math uses `$...$` syntax (e.g., `$O(n \log n)$`). Pandoc
renders these in both PDF and EPUB. If you see raw `\log` or `\Theta`
in the output, confirm the expression is wrapped in `$...$`.

### PDF is very large

The book is 100,000+ lines of Markdown. Expect a large PDF. To reduce
size, omit `--number-sections` or reduce `--toc-depth` to 1.

### Windows-specific notes

- Use Git Bash, WSL, or PowerShell to run the build scripts.
- In PowerShell, run: `bash ./scripts/build-pdf.sh`
- Ensure `pandoc` and `xelatex` are on your `PATH`.
- Line endings: the repository uses LF. If you see rendering issues,
  run `git config core.autocrlf input`.

---

## Conversion Risks

The following are known conversion risks identified during the
preparation pass. None are blocking, but review them before publishing.

| Risk | Severity | Details |
|------|----------|---------|
| Mermaid diagrams (43 blocks, 24 chapters) | Medium | Appear as raw text without `mermaid-filter`. Content is self-contained without diagrams. |
| Wide tables (6 chapters) | Low | Tables with 6+ columns may overflow PDF margins. Readable in Markdown and EPUB. |
| Long code blocks | Low | Some examples exceed 80 characters per line. May overflow in PDF. |
| Deeply nested lists (ch03, ch22) | Low | 4+ nesting levels in YAML examples and agenda templates. Pandoc handles these but indentation may compress. |
| Raw HTML in Angular/React templates | None | All HTML is inside fenced code blocks. Pandoc treats it as code, not markup. |
| Internal `.md` links | Low | Pandoc resolves these in concatenated mode. Verify anchor targets after build. |
| Unicode ≤ ≥ characters | Low | ~33 prose occurrences. Latin Modern font lacks these glyphs — they render as blanks. Set a `mainfont` with Unicode coverage (e.g., DejaVu Serif) to fix. |
| Book size (100K+ lines) | Low | Build may take 30–120 seconds depending on hardware. |

---

## Final Publishing Checklist

- [ ] All chapters are generated.
- [ ] Global quality audit completed.
- [ ] Final editorial pass completed.
- [ ] Verification notes reviewed.
- [ ] Open questions reviewed.
- [ ] PDF build tested.
- [ ] EPUB build tested.
- [ ] Internal links checked.
- [ ] Code blocks checked.
- [ ] Diagrams checked.
- [ ] Large tables checked.
