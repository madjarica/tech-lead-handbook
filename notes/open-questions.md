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

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Question:** Should the chapter include a deeper section on service
  meshes (Istio, Linkerd) or keep them as brief references?
- **Context:** Service meshes are relevant to Kubernetes networking,
  security (mTLS), and observability but are large enough for their
  own chapter. Currently mentioned in canary deployments, mTLS, and
  load balancing but not covered in depth.
- **Options:**
  1. Add a subsection (1-2 pages) on service mesh fundamentals and
     trade-offs within this chapter.
  2. Keep as brief references and consider a future dedicated section
     in the System Design or Architecture chapter.
- **Owner:** author.
- **Status:** open.

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Question:** Should Kubernetes operators (custom controllers, CRDs)
  be covered in this chapter or deferred?
- **Context:** Operators are increasingly common (CloudNativePG,
  Prometheus Operator, cert-manager) and a Tech Lead is expected to
  understand the pattern. Currently mentioned briefly but not explained
  in depth.
- **Options:**
  1. Add a subsection covering the operator pattern, CRDs, and when
     to use vs avoid operators.
  2. Defer to a future pass or System Design chapter.
- **Owner:** author.
- **Status:** open.

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Question:** Non-standard `## Tech Lead Decision-Making` section.
- **Context:** The chapter includes a `## Tech Lead Decision-Making`
  section that is not part of `CHAPTER_TEMPLATE.md`. This section adds
  significant value (adoption strategy, ownership model, cost
  governance, stakeholder communication, overengineering traps, dev vs
  prod divergence, incident response). The same pattern was used in
  `book/15-security.md` and retained during audit.
- **Options:**
  1. Keep as-is (valuable, consistent with security chapter pattern).
  2. Merge content into existing template sections (Production
     Considerations, Tech Lead Checklist).
  3. Update CHAPTER_TEMPLATE.md to include this section officially.
- **Owner:** author.
- **Status:** open (retained during audit — recommend option 3 if more
  chapters adopt this pattern).
- **Update (2026-05-06):** `book/18-observability.md` now also uses
  this pattern, joining `book/04-aws.md`, `book/17-ci-cd-and-devops.md`,
  and `book/15-security.md`. Four chapters now use `## Tech Lead
  Decision-Making` — strong signal to formalize in the template.
