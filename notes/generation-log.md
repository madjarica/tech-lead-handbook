# Generation Log

A chronological log of changes to the book. Append a row for every
generation pass, edit, or restructuring. Use this to:

- Track what was generated when, and by whom.
- Pin the toolchain versions used for builds.
- Document deliberate scope changes.

Format: one entry per change, newest at the bottom.

---

## Entry Template

```md
## YYYY-MM-DD — short title

- **Author:** name or model
- **Scope:** chapters or files touched
- **Change:** 1–3 sentences describing what was done and why
- **Toolchain (if relevant):**
  - Pandoc: x.y.z
  - LaTeX engine: xelatex / tinytex / etc.
- **Follow-ups:** items moved to `open-questions.md` or
  `verification-needed.md`
```

---

## Entries

## 2026-05-05 — Initial scaffolding

- **Author:** Initial author
- **Scope:** Whole repository.
- **Change:** Created the project structure described in
  `../README.md`. Wrote the root documents (`README.md`,
  `SUMMARY.md`, `BOOK_SPEC.md`, `STYLE_GUIDE.md`,
  `CHAPTER_TEMPLATE.md`, `CONVERSION.md`, `metadata.yaml`).
  Created skeleton files for all chapters in `book/`. Created
  placeholder example folders, build scripts, and note files.
- **Toolchain:** not yet pinned. Build will be exercised in a later
  pass.
- **Follow-ups:**
  - Drain `verification-needed.md` as version-sensitive chapters are
    generated (especially AWS, Kubernetes, Next.js, Angular, React,
    AI tooling, Node.js).

## 2026-05-05 — Structure review pass

- **Author:** Initial author
- **Scope:** Root documents and structural rules; no chapter content
  changed.
- **Change:**
  - Documented `book/26-glossary.md` as a chapter-level structural
    exception in `BOOK_SPEC.md` and `CHAPTER_TEMPLATE.md`. The
    glossary keeps the alphabetical entries section and is exempt
    from teaching-oriented sections (Mental Model, Theoretical
    Foundation, Trade-offs, Production Considerations, Interview
    Q&A, Tech Lead Checklist, Summary, Further Study).
  - Reconciled the recommended generation order in `README.md` with
    the in-chapter generation note in `book/00-introduction.md`
    (intro is now generated late so it can cite real chapters).
  - Added `CHAPTER_GENERATION_PROMPT.md` to enforce consistency
    across chapter generations, with target length and
    version-sensitivity inputs and a self-review checklist.
  - Added `.gitignore` for `build/`, OS junk (`.DS_Store`, `Thumbs.db`),
    editor caches, and LaTeX intermediates.
  - Updated `README.md` to reference `CHAPTER_GENERATION_PROMPT.md`
    and `.gitignore`. Updated `CONVERSION.md` to drop the "if you
    initialize a git repo" hedge.
- **Toolchain:** not yet pinned.
- **Follow-ups:**
  - First chapter to generate: `26-glossary.md` as a stub, then
    `13-system-design.md`. See the "Recommended Chapter Generation
    Order" section in the README.

## 2026-05-05 — Chapter: JavaScript (05)

- **Author:** AI generation pass
- **Scope:** `book/05-javascript.md`, `book/26-glossary.md`
- **Change:** Generated the full JavaScript chapter covering:
  execution context, call stack, event loop, microtasks/macrotasks,
  hoisting, TDZ, scope, closures, `this` binding, prototypes,
  classes, ESM vs CJS, Promises, async/await, error handling, GC,
  memory leaks, FP (map/filter/reduce), immutability, destructuring,
  spread/rest, optional chaining, nullish coalescing, debounce,
  throttle, fetch, DOM, event delegation.
  - 60+ interview Q&A (30 basic/senior, 10 Tech Lead, 10 scenario,
    5 trick, 5 red flags).
  - Updated glossary with: AbortController, async/await, call stack,
    closure, debounce, dual-package hazard, ESM, event delegation,
    event loop, execution context, hoisting, macrotask, microtask,
    Promise, prototype chain, TDZ, throttle.
- **Toolchain:** N/A (prose + code generation).
- **Follow-ups:**
  - Added verification note for Node.js event-loop phases and ESM
    resolution evolution.
  - Next chapter to generate: `13-system-design.md` or
    `06-typescript.md` (adjacent topic for cross-link accuracy).

## 2026-05-05 — Quality Pass: Expand Interview Q&A — JavaScript (05)

- **Author:** AI generation pass
- **Scope:** `book/05-javascript.md` (Interview Q&A section only)
- **Change:** Expanded the Interview Questions and Answers section
  from ~55 questions to **106 questions** organized into 9
  categories:
  - Basic JavaScript concepts: 30
  - Senior-level JavaScript: 15
  - Tech Lead architecture/decision: 16
  - Performance: 10
  - Security: 6
  - Testing/quality: 6
  - Scenario-based: 12
  - Trick questions: 6
  - Red flags and weak answers: 10 (expanded from 5)
  Added three new section categories (Performance, Security,
  Testing/quality). Converted several short-format questions to
  detailed format (Strong Answer / Explanation / Example / What the
  Interviewer Is Testing / Weak Answer / Red Flags). Total chapter
  word count: ~14,800 words.
- **Toolchain:** N/A.
- **Follow-ups:** None. No new version-sensitive claims added.

### 2026-05-05 — Quality Pass: Improve Code Examples (JavaScript)

- **File:** `book/05-javascript.md`
- **Change:** Added 12 new production-grade code examples to the
  `## Examples` section, each with a four-part explanation (what /
  why useful / common mistake / production change):
  - Closure as a request-scoped logger
  - `this` binding — problem and three solutions
  - `Promise.allSettled` for partial success
  - Safe `fetch` with timeout and structured errors
  - Proper listener cleanup with `AbortController`
  - Immutability patterns for state updates
  - Realistic map/filter/reduce pipeline
  - ESM and CommonJS side by side
  - Promise chain vs async/await
  - Async error handling — the correct pattern
  Also added clarifying explanation under the debounce/throttle
  implementations in Theoretical Foundation. Total code blocks
  in chapter: 37. Total chapter line count: ~2360.
- **Toolchain:** N/A.
- **Follow-ups:** None.

### 2026-05-05 — Quality Pass: Strengthen Tech Lead Perspective (JavaScript)

- **File:** `book/05-javascript.md`
- **Change:** Added a new `## Tech Lead Decision-Making` section
  (~320 lines) with 10 subsections covering:
  - Choosing plain JS vs TypeScript (migration scope, strictness)
  - Establishing team coding standards (lint policy, formatter)
  - Async error handling standards (categories, boundaries, policy)
  - Promise concurrency patterns (limits, timeout, back-pressure)
  - Browser compatibility decisions (support matrix, differential serving)
  - Memory leak prevention (proactive policy, monitoring, debugging playbook)
  - Frontend bundle size and execution cost (budgets, cost model)
  - Dependency governance (approval, updates, vendoring, licenses)
  - Debugging production JavaScript issues (source maps, runbooks, canary)
  - Reducing accidental complexity (banning clever patterns, layering)
  - When not to use a pattern (table)
  - Explaining decisions to stakeholders (translation table)
  Expanded the Tech Lead Checklist from 8 items to 21 items
  organized into 4 categories (Code quality, Async/errors,
  Performance/observability, Operational readiness, Team/onboarding).
  Added Tech Lead perspective lines to the Summary section.
  Total chapter line count: ~2740.
- **Toolchain:** N/A.
- **Follow-ups:** None.

### 2026-05-05 — Quality Pass: Chapter Audit (JavaScript)

- **File:** `book/05-javascript.md`
- **Change:** Audited against BOOK_SPEC, STYLE_GUIDE, and
  CHAPTER_TEMPLATE. Fixed:
  1. Removed ~60 lines of duplicate content (trick questions and
     red flags repeated twice at end of Interview Q&A section).
  2. Renamed interview Q&A category headings to match template
     (Basic, Senior, Tech Lead, Performance, Security, Testing and
     quality, Scenario-based, Trick Questions, Red Flags).
  3. Removed inline code from three `###` headings (style guide
     prohibits code in headings).
  4. Added Security bullet to Production Considerations (template
     requires it).
  Verified: all 30 required JavaScript topics covered; all code
  blocks have language tags (37 pairs, balanced); all cross-links
  resolve; no banned words; no shallow definitions; heading case
  correct. Total chapter line count: ~2686.
- **Toolchain:** N/A.
- **Follow-ups:** One structural note: `## Tech Lead Decision-Making`
  is not in CHAPTER_TEMPLATE but adds significant value. Consider
  updating BOOK_SPEC if this pattern is adopted in other chapters.
