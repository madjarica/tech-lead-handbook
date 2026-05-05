# Chapter Generation Prompt

This is the canonical prompt for generating a single chapter of the
Tech Lead Handbook. Copy it, fill in the placeholders, and run it.

The goal is **consistency across chapters**. Every chapter must read
like it was written by the same author, with the same standards, and
to the same depth. This prompt is what enforces that.

Do not modify this prompt casually. Update it deliberately, and
record the change in `notes/generation-log.md`.

---

## Inputs You Must Provide

Before running the prompt, decide:

- **CHAPTER_FILE** — the path to the chapter skeleton, e.g.
  `book/13-system-design.md`.
- **CHAPTER_TITLE** — the chapter title as it appears in the file's
  H1, e.g. `System Design`.
- **TARGET_LENGTH** — a soft length budget. Default: 4,000–8,000
  words for topic chapters, shorter for `00-introduction.md` and
  `26-glossary.md`.
- **VERSION_SENSITIVITY** — `low`, `medium`, or `high`. See the rules
  below.

---

## The Prompt

Paste the block below into the AI you are using, replacing the
placeholders. Keep the rest verbatim.

> You are an expert technical author, senior software engineer, tech
> lead, system design interviewer, and engineering mentor. You are
> writing one chapter of a personal Tech Lead interview preparation
> handbook in Markdown.
>
> The chapter you must produce is **{CHAPTER_TITLE}**, located at
> `{CHAPTER_FILE}`.
>
> Read these documents and treat them as binding before writing:
>
> - `BOOK_SPEC.md` — the contract for the book.
> - `STYLE_GUIDE.md` — the writing rules, banned words, and Q&A format.
> - `CHAPTER_TEMPLATE.md` — the canonical chapter structure.
> - `SUMMARY.md` — the section plan for this chapter.
> - `{CHAPTER_FILE}` — the existing skeleton, including its TODO
>   outline and per-chapter generation notes.
> - `notes/verification-needed.md` — version-sensitive items relevant
>   to this chapter.
> - `notes/open-questions.md` — open decisions that affect this chapter.
> - `book/26-glossary.md` — keep terminology consistent with the glossary.
>
> Hard requirements:
>
> 1. Follow the structure in `CHAPTER_TEMPLATE.md` exactly. All
>    sections must be present and non-empty (the only chapter-level
>    exception is documented in `BOOK_SPEC.md`).
> 2. Apply every rule in `STYLE_GUIDE.md`, including:
>    - Banned hype words.
>    - Heading rules (one H1, H2 sections, H3 subsections).
>    - Allowed code-block languages only.
>    - Detailed Q&A format for important questions.
>    - Strong-vs-weak answer pairs are not strawmen.
>    - Trade-offs framed as "optimizes for X at the cost of Y, flips
>      when Z".
> 3. Cover, for every important concept: what it is, why it exists,
>    where it is used, how it works, when it is a good or bad choice,
>    common mistakes, trade-offs, how to explain it in an interview,
>    and what a Tech Lead specifically should care about.
> 4. Include at least one mental model, at least one trade-off
>    table or list, at least one strong-vs-weak Q&A pair, and a
>    `Tech Lead Checklist` whose items reference real artifacts
>    (runbooks, dashboards, ADRs, SLOs, config flags).
> 5. Use Mermaid diagrams only where they add value, with a one-
>    paragraph caption underneath.
> 6. Code examples are short, correct, and followed by a paragraph
>    that states what the code does, why it is written this way,
>    what the weaker alternative would be, and how it would change
>    in production.
> 7. Cross-link other chapters with relative Markdown links instead
>    of duplicating content. Add new key terms to
>    `book/26-glossary.md` in the same change.
> 8. Do not invent APIs, framework features, or AWS service behavior.
>    For any version-sensitive claim, either ground it in stable
>    concepts or add a row to `notes/verification-needed.md` and
>    mark the claim with "verify against official documentation".
>
> Process:
>
> 1. Read all input documents listed above.
> 2. Replace the existing skeleton at `{CHAPTER_FILE}` with the full
>    chapter, preserving the file path and the H1 title.
> 3. Update `book/26-glossary.md` to include any new key terms.
> 4. Append a row to `notes/generation-log.md` describing what was
>    generated, the toolchain assumed, and any follow-ups.
> 5. Add or update rows in `notes/verification-needed.md` for any
>    version-sensitive content; remove rows that have been verified.
> 6. If you discovered a question that requires the author's
>    decision, append it to `notes/open-questions.md` instead of
>    guessing.
>
> Style reminders specific to this chapter:
>
> - The reader is a senior engineer with strong practical experience.
>   Skip motivational paragraphs.
> - The chapter must be readable both end-to-end and as a reference.
> - Banned tone: marketing, blog-style, hype.
>
> Output format:
>
> - Return the full Markdown body of `{CHAPTER_FILE}`.
> - Do not include explanations outside the file content.
> - Do not include any text before the H1 line.
>
> Now write the chapter.

---

## Length Guidance

| Chapter type | Target length |
| --- | --- |
| Reference (`26-glossary`) | as needed; entries are 1–3 sentences |
| Orientation (`00-introduction`) | 1,200–1,800 words |
| Topic (most chapters) | 4,000–8,000 words |
| Bank (`24-interview-questions-and-answers`) | 5,000–10,000 words |
| Scenarios (`25-practical-interview-scenarios`) | 6,000–10,000 words |

Length is a guide, not a target. A short, dense chapter is better
than a long, padded one.

---

## Version-Sensitivity Levels

- **low** — language fundamentals, core algorithms, REST principles,
  Git internals. Stable for years.
- **medium** — Node.js, Python, Docker, software architecture,
  testing, CI/CD concepts. Stable enough for principles, evolving in
  details.
- **high** — AWS, Kubernetes, Next.js, Angular, React (concurrent and
  server features), AI tooling. Mark every specific claim and add it
  to `notes/verification-needed.md`.

When in doubt, prefer the conceptually stable framing.

---

## Self-Review Checklist (before committing the chapter)

Apply this before you accept the generated chapter:

- [ ] All template sections present, in order.
- [ ] At least one mental model, at least one trade-off list/table,
      at least one strong-vs-weak Q&A.
- [ ] No banned hype words.
- [ ] No invented APIs or version-pinned claims unless verified.
- [ ] Glossary updated for new terms.
- [ ] `notes/generation-log.md` has a new entry.
- [ ] `notes/verification-needed.md` updated.
- [ ] All cross-links to other chapters resolve.
- [ ] Build still succeeds (`scripts/build-pdf.sh`,
      `scripts/build-epub.sh`).
