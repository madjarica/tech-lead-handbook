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
- **Update (2026-05-06):** `book/19-performance-and-scalability.md`
  also uses this pattern. Five chapters now include `## Tech Lead
  Decision-Making`. Recommend formalizing in `CHAPTER_TEMPLATE.md`.
- **Update (2026-05-06):** `book/08-react.md` also uses this pattern.
  Six chapters now include `## Tech Lead Decision-Making`
  (`04-aws.md`, `08-react.md`, `15-security.md`, `17-ci-cd-and-devops.md`,
  `18-observability.md`, `19-performance-and-scalability.md`).
  This is now a de facto standard section.
- **Update (2026-05-06):** `book/07-angular.md` also uses this pattern.
  Seven chapters now include `## Tech Lead Decision-Making`
  (`04-aws.md`, `07-angular.md`, `08-react.md`, `15-security.md`,
  `17-ci-cd-and-devops.md`, `18-observability.md`,
  `19-performance-and-scalability.md`).
  Strongly recommend formalizing in `CHAPTER_TEMPLATE.md`.
- **Update (2026-05-06):** `book/09-nextjs.md` also uses this pattern.
  Eight chapters now include `## Tech Lead Decision-Making`
  (`04-aws.md`, `07-angular.md`, `08-react.md`, `09-nextjs.md`,
  `15-security.md`, `17-ci-cd-and-devops.md`, `18-observability.md`,
  `19-performance-and-scalability.md`).
  This is a universal section — should be formalized in the template.
- **Update (2026-05-06):** `book/01-algorithms-and-data-structures.md`
  also uses this pattern. Nine chapters now include
  `## Tech Lead Decision-Making`. This is clearly a universal section
  and should be added to `CHAPTER_TEMPLATE.md`.
- **Update (2026-05-06):** `book/13-system-design.md` also uses this
  pattern. Ten chapters now include `## Tech Lead Decision-Making`.
- **Update (2026-05-07):** `book/14-software-architecture.md` initially
  did not include a separate `## Tech Lead Decision-Making` section,
  weaving the perspective throughout other sections instead.
- **Update (2026-05-07):** `book/14-software-architecture.md` now
  includes a dedicated `## Tech Lead Decision-Making` section with 5
  subsections: decision-making under uncertainty, communicating trade-offs,
  architecture principles, operational maturity assessment, and debugging
  across architectures. This aligns with the pattern used in other
  chapters. Eleven chapters now include this section.
- **Update (2026-05-07):** `book/20-git-and-engineering-workflow.md` now
  includes a dedicated `## Tech Lead Decision-Making` section with 5
  subsections: workflow decisions under uncertainty, communicating changes
  to stakeholders, when not to introduce a process, incident response and
  Git workflow, and cost-benefit analysis for workflow investments.
  Additionally, 4 existing sections (branching strategies, feature flags,
  code review, monorepo/multi-repo) have "What a Tech Lead Is Expected to
  Decide" callouts. Twelve chapters now include the dedicated section,
  reinforcing the recommendation for template formalization.
- **Update (2026-05-07):** `book/11-python.md` now includes a dedicated
  `## Tech Lead Decision-Making` section with 3 subsections: choosing
  between Python and another language, setting typing standards for the
  team, and process model decisions. Thirteen chapters now include the
  dedicated section.
- **Update (2026-05-07):** `book/11-python.md` Tech Lead Decision-Making
  expanded to 6 subsections (added incident response and debugging,
  cost-benefit analysis, and when not to use Python). Additionally, 5
  inline "Tech Lead perspective" callouts added throughout the chapter
  (async adoption risk, runtime validation strategy, framework selection,
  testing investment, AI code governance). This chapter now has the
  strongest Tech Lead coverage across the book and may serve as a model
  for other chapters.

## AI chapter version sensitivity

- **File:** `book/21-ai-usage-in-software-engineering.md`
- **Question:** The AI tooling landscape changes rapidly. Tool names,
  pricing, capabilities, and best practices described in this chapter
  may become outdated within months. Should the chapter adopt a
  pattern-first approach that avoids naming specific tools (Cursor,
  Copilot, ChatGPT), or should it name tools for concreteness and
  accept the maintenance burden of quarterly review?
- **Current decision:** The chapter names specific tools in examples
  and policies for concreteness, but the theoretical and decision
  sections focus on patterns rather than tools. The chapter includes
  an explicit note that AI tooling changes weekly.
- **Action needed:** Decide on a review cadence for tool-specific
  content. Consider a versioned "last verified" date in the chapter
  header.

## AI chapter cost figures and ROI methodology

- **File:** `book/21-ai-usage-in-software-engineering.md`
- **Question:** The chapter now includes detailed cost-benefit
  analysis frameworks with approximate figures (e.g., "$120/engineer/month,"
  "18% cycle time reduction," "$2,400/month pilot cost"). These
  figures are illustrative examples, not empirical data. Should the
  chapter explicitly label these as "example calculations for
  illustration" to prevent readers from citing them as benchmarks?
  Alternatively, should the chapter reference published case studies
  that provide real numbers?
- **Current decision:** The figures appear in stakeholder communication
  examples and decision frameworks. They are presented as sample
  narratives ("our 4-week pilot showed..."), not as general claims.
- **Action needed:** Consider adding a brief note in the cost-benefit
  section stating that the specific numbers are illustrative examples
  and that each team should derive their own figures from a pilot.
