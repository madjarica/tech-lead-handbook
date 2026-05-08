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

---

### Service meshes depth

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

### Kubernetes operators depth

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

### AI chapter version sensitivity

- **File:** `book/21-ai-usage-in-software-engineering.md`
- **Question:** The AI tooling landscape changes rapidly. Should the
  chapter adopt a review cadence for tool-specific content?
- **Current decision:** The chapter names specific tools in examples
  and policies for concreteness, but the theoretical and decision
  sections focus on patterns rather than tools. The chapter includes
  an explicit note that AI tooling changes weekly.
- **Action needed:** Decide on a review cadence for tool-specific
  content. Consider a versioned "last verified" date in the chapter
  header.
- **Owner:** author.
- **Status:** open.

---

### AI chapter cost figures

- **File:** `book/21-ai-usage-in-software-engineering.md`
- **Question:** The chapter includes illustrative cost figures
  (e.g., "$120/engineer/month," "18% cycle time reduction"). Should
  these be explicitly labeled as example calculations?
- **Current decision:** The figures appear in stakeholder communication
  examples as sample narratives, not as general claims.
- **Action needed:** Consider adding a brief note that specific numbers
  are illustrative and each team should derive their own from a pilot.
- **Owner:** author.
- **Status:** open.

---

## Resolved Items

### Code example language balance — DECIDED

- **Decision:** TypeScript by default for generic examples; Python
  only in Python-specific chapters (`book/11-python.md`). This matches
  the reader's primary stack and interviewer expectations.
- **Resolved:** 2026-05-08 (final editorial pass — de facto standard
  across all chapters).

### Depth of Practical Interview Scenarios — DECIDED

- **Decision:** Full walkthroughs for all 30 scenarios, each with the
  11-subsection format (Situation through Follow-up questions).
- **Resolved:** 2026-05-07 (chapter generated with full depth).

### Glossary depth — DECIDED

- **Decision:** Definition + practical example + interview usage +
  common confusion + related terms + optional Tech Lead note.
  Topic-organized, not alphabetical.
- **Resolved:** 2026-05-07 (chapter generated with full depth per term).

### Tech Lead Decision-Making as a standard section — DECIDED

- **Decision:** Added to `CHAPTER_TEMPLATE.md` as an official section.
  All 23 teaching chapters now include `## Tech Lead Decision-Making`.
- **Resolved:** 2026-05-08 (final editorial pass — formalized in
  template after all 23 chapters adopted the pattern).

### Chapter 22/23 overlap — RESOLVED

- **Decision:** Chapter 22 focuses on communication behaviors; chapter
  23 focuses on leadership strategy. Cross-links in place. No
  duplication requiring consolidation.
- **Resolved:** 2026-05-07.

### Introduction chapter structural exception — RESOLVED

- **Decision:** `book/00-introduction.md` added to Structural
  Exceptions in `BOOK_SPEC.md` alongside `book/24-*`, `book/25-*`,
  and `book/26-glossary.md`.
- **Resolved:** 2026-05-08 (global quality audit).
