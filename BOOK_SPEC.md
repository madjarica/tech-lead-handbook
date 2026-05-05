# Book Specification

This document defines what the book must achieve, how it must be
written, and how to decide when a chapter or the whole book is "done".

It is a working contract between the author and any AI or human
collaborator. Update it deliberately, not casually.

---

## Book Goals

The handbook must:

1. Help an experienced engineer prepare for **Tech Lead** interviews.
2. Convert practical know-how into **correct theoretical terminology**.
3. Provide **mental models** that survive across stack and version changes.
4. Provide **interview-ready answers** with strong/weak contrasts.
5. Capture **trade-offs** and **failure modes** for each topic.
6. Stay usable as a **long-lived personal reference**, not a one-off cram sheet.
7. Compile cleanly to **PDF and EPUB** with Pandoc.

Non-goals:

- It is not a beginner programming book.
- It is not a marketing piece for any framework, cloud, or tool.
- It is not a pure theory textbook.
- It is not a certification cheat sheet.

---

## Target Audience

A reader of this book typically has:

- 6+ years of software engineering experience.
- Hands-on production experience in at least 3 of: web, backend,
  frontend, DevOps, cloud, data, security.
- Some leadership exposure: tech lead, senior+, staff, or team lead.
- Comfort reading code in JavaScript/TypeScript, Python, and SQL.
- Working familiarity with Linux, HTTP, Git, and at least one cloud.

The book assumes the reader already knows how to build and ship software
and is now organizing that knowledge into senior-level vocabulary.

---

## Expected Tone

- Senior peer-to-peer.
- Direct, not academic.
- Practical, not theoretical-only.
- Calm and skeptical, not hyped.
- Opinionated where the field has converged.
- Neutral where there is a real trade-off.

Do not use hype words such as "seamless", "powerful", "blazing fast",
"revolutionary", "next-generation", "game changer". They signal
shallow content.

---

## Expected Depth

For each major concept, the chapter must cover:

1. What it is.
2. Why it exists.
3. Where it is used.
4. How it works (at a level a Tech Lead must explain on a whiteboard).
5. When it is a good choice.
6. When it is a bad choice.
7. Common mistakes and failure modes.
8. Trade-offs.
9. How to explain it in an interview.
10. What a Tech Lead specifically should care about (cost, scaling,
    team, hiring, security, on-call, vendor lock-in, etc.).

A chapter that only covers points 1–4 is not done.

---

## Chapter Rules

- Every chapter follows `CHAPTER_TEMPLATE.md`.
- Every chapter is independently readable.
- Every chapter cross-links other chapters with relative Markdown links
  instead of duplicating content.
- Every chapter ends with a `Summary` and `Further Study` section.
- Every chapter must include at least one **mental model**.
- Every chapter must include at least one **trade-off table or list**.
- Every chapter must include at least one **interview-ready Q&A** in the
  detailed format defined in `STYLE_GUIDE.md`.
- Every chapter must include a **Tech Lead Checklist** with concrete,
  production-grade items.
- Chapters must not invent APIs, framework features, or AWS services.

### Structural Exceptions

The following chapters are **reference chapters**, not teaching chapters,
and explicitly opt out of parts of the template:

- `book/26-glossary.md` — alphabetical glossary. Required sections are
  limited to a chapter title, a goal, "How to Use This Chapter", and the
  alphabetical entries. The teaching-oriented sections (Mental Model,
  Theoretical Foundation, Trade-offs, Production Considerations,
  Interview Q&A, Tech Lead Checklist, Summary, Further Study) do not
  apply.

If a future chapter needs a structural exception, document it here
explicitly. Per-section opt-outs inside otherwise-standard chapters are
governed by the rule in `CHAPTER_TEMPLATE.md` ("write one sentence
explaining why").

---

## Code Example Rules

Code examples must be:

- Short.
- Correct.
- Practical.
- Focused on one teaching point.
- Easy to read at interview speed.
- Production-aware where it matters.

For each important code example, explain:

- What the code does.
- Why it is written this way.
- What the weaker alternative would be.
- How it would change in production.

Avoid huge toy examples. Prefer small, realistic snippets that match
real production patterns. Use a fenced code block with a language tag
from the allowed list in `STYLE_GUIDE.md`.

---

## Interview Question Rules

Every chapter must include an `Interview Questions and Answers` section
with these categories:

- **Basic** — terminology, definitions, "what is X?".
- **Senior** — trade-offs, failure modes, design choices.
- **Tech Lead** — system-level, team-level, cost, hiring, on-call,
  organizational impact.
- **Scenario-based** — "you are given X, design Y".
- **Trick questions** — common phrasings that hide a wrong assumption.
- **Red flags** — answers that should immediately concern an interviewer.

Use the detailed Q&A format from `STYLE_GUIDE.md` for important
questions. Use the short format only for narrow, factual questions.

Every important question must contrast a **strong answer** with a
**weak answer**. The weak answer must be plausible, not a strawman.

---

## Accuracy Rules

- Do not invent facts, APIs, framework features, or AWS service names.
- Do not claim a feature exists in a specific version unless it is
  verified against official documentation.
- Prefer conceptually stable explanations over version-pinned ones.
- When unsure, mark the claim and add a row in
  `notes/verification-needed.md` instead of guessing.
- Numbers (latencies, throughputs, costs, limits) must be either:
  - Quoted from official documentation, or
  - Clearly labeled as "rough order of magnitude", or
  - Removed.

When two reputable sources disagree, prefer the official documentation
of the relevant project (Kubernetes, AWS, MDN, ECMA, RFCs, framework
docs) and note the disagreement in `notes/open-questions.md`.

---

## Version-Sensitive Topic Rules

The following areas change frequently and require extra care:

- AWS services, limits, and pricing.
- Next.js (App Router, Server Components, caching semantics).
- Angular (standalone components, signals, control flow).
- React (concurrent features, server components, hooks behavior).
- Kubernetes (APIs, CRDs, deprecated objects).
- AI tooling (models, IDEs, agentic features, pricing).
- Node.js runtime features and ESM behavior.
- TypeScript module resolution and decorators.

For these topics:

- Prefer concepts that are stable across versions.
- If you must mention a feature, mark it as version-sensitive.
- Add a verification note in `notes/verification-needed.md`.
- Use the phrase **"verify against official documentation"** in the
  chapter where appropriate.

---

## How to Handle Uncertain Information

If a claim is uncertain:

1. Do not write it as a fact.
2. Either rephrase it as a conceptual statement, or
3. Add it to `notes/verification-needed.md` with the chapter,
   section, claim, and what should be verified.
4. Optionally leave a `> Verify against official documentation.`
   blockquote in the chapter so the reader knows it is provisional.

Better to leave a gap than to ship a confidently wrong claim.

---

## How to Handle Official Documentation References

- Reference concepts and behaviors, not URLs that may change.
- When a URL is cited, prefer the canonical project documentation
  (`kubernetes.io`, `developer.mozilla.org`, `nodejs.org`, official
  framework sites, RFC numbers).
- Avoid linking to blog posts, Stack Overflow, or marketing pages as
  primary sources.
- The book itself is not a list of links. Treat external references as
  pointers, not as the body of the chapter.

---

## Definition of Done for a Chapter

A chapter is done when **all** of the following are true:

- The chapter follows the structure in `CHAPTER_TEMPLATE.md`, except
  for chapters listed under **Structural Exceptions** above.
- All required sections (per the template, accounting for exceptions)
  are present and non-empty.
- It includes at least one mental model.
- It includes at least one trade-off list or table.
- It includes a Tech Lead Checklist with concrete, production-grade items.
- It includes interview Q&A across all categories listed above.
- It includes at least one strong-vs-weak answer contrast.
- It avoids hype words and marketing tone.
- All version-sensitive claims are either verified or moved to
  `notes/verification-needed.md`.
- All cross-links to other chapters resolve.
- It builds cleanly when included in `scripts/build-pdf.sh` and
  `scripts/build-epub.sh`.
- A line is appended to `notes/generation-log.md` describing the change.

---

## Definition of Done for the Whole Book

The book is done when:

- All chapters in `SUMMARY.md` meet the chapter Definition of Done.
- The glossary in `book/26-glossary.md` covers every key term used.
- `notes/verification-needed.md` is empty or contains only items that
  are explicitly out of scope.
- `notes/open-questions.md` is empty or only contains items deferred
  to a future edition.
- The PDF and EPUB build successfully via the scripts in `scripts/`.
- The reading experience is consistent: same template, same tone,
  same Q&A format across all chapters.
- The book is usable end-to-end as both a study guide and a reference.

The book is **never** done because the field changes. Treat "done"
as "ready for the current interview cycle".
