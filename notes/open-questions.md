# Open Questions

Questions that need an opinion or decision before a chapter can be
finalized. Move resolved items into the relevant chapter and delete
the row here.

Format: one row per question.

---

## Format

```md
- **Topic:** chapter or area
- **Question:** what needs deciding
- **Options:** the alternatives under consideration
- **Decision criteria:** what would make one option win
- **Owner:** who decides
- **Status:** open / decided
```

---

## Open Items

### Mermaid rendering strategy

- **Topic:** Build (CONVERSION).
- **Question:** Should Mermaid diagrams be pre-rendered to SVG/PNG at
  build time, or rendered through `mermaid-filter`, or left as raw
  fenced blocks (rendered only on GitHub)?
- **Options:**
  1. Leave as raw `mermaid` blocks. No rendering in PDF/EPUB.
  2. Use `mermaid-filter` in the Pandoc command.
  3. Pre-render to SVG/PNG and replace blocks at build time.
- **Decision criteria:** simplicity of the build vs visual quality of
  the PDF/EPUB.
- **Owner:** author.
- **Status:** open.

### Code example language balance

- **Topic:** All chapters.
- **Question:** What is the default language for generic code
  examples (JavaScript/TypeScript vs Python)?
- **Options:**
  1. TypeScript by default; Python only in language-specific chapters.
  2. Match the chapter's natural language (TS for frontend/Node,
     Python for data/Python chapters).
- **Decision criteria:** reader's primary stack and the interviewer's
  expected language.
- **Owner:** author.
- **Status:** open.

### Depth of "Practical Interview Scenarios"

- **Topic:** `book/25-practical-interview-scenarios.md`.
- **Question:** Should each scenario include a full strong-vs-weak
  walkthrough, or just the prompt and expected structure?
- **Options:**
  1. Full walkthroughs for 3 anchor scenarios; shorter for the rest.
  2. Full walkthroughs for all scenarios.
  3. Short for all; rely on topic chapters for depth.
- **Decision criteria:** length budget for the book vs interview
  rehearsal value.
- **Owner:** author.
- **Status:** open.

### Glossary depth

- **Topic:** `book/26-glossary.md`.
- **Question:** Should the glossary include short worked examples or
  remain strictly definition-only?
- **Options:**
  1. Strict definition + chapter link.
  2. Definition + a one-line example.
- **Decision criteria:** the glossary's role as a quick lookup vs a
  refresher tool.
- **Owner:** author.
- **Status:** open.

### Tech Lead Decision-Making as a standard section

- **Topic:** `CHAPTER_TEMPLATE.md` / all chapters.
- **Question:** Should `## Tech Lead Decision-Making` be added to the
  canonical template? Both `book/05-javascript.md` and
  `book/06-typescript.md` include it between Production Considerations
  and How to Explain This in an Interview. The template currently says
  "Do not add new top-level sections without updating BOOK_SPEC.md."
- **Options:**
  1. Add it to `CHAPTER_TEMPLATE.md` as an official section.
  2. Keep it as an optional section allowed per-chapter (document the
     exception in BOOK_SPEC.md).
  3. Fold the content into the existing "Production Considerations"
     or "Tech Lead Checklist" sections and remove it.
- **Decision criteria:** whether the narrative decision-making format
  adds enough interview value to justify a section beyond what the
  checklist provides.
- **Owner:** author.
- **Status:** open.
