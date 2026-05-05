# Tech Lead Handbook

A personal, book-as-code Markdown handbook designed to help an experienced
software engineer prepare for **Tech Lead** interviews and to systematize
practical knowledge into correct theoretical terminology.

This is **not** a beginner book. It assumes real production experience in
web, backend, frontend, DevOps, cloud, and team leadership, and focuses on
crisp definitions, mental models, trade-offs, and interview-ready answers.

---

## What This Project Is

- A Markdown source tree that compiles to a single book (PDF and EPUB).
- A study guide and a Tech Lead interview preparation handbook.
- A technical terminology refresher for senior engineers.
- A practical engineering handbook with real-world trade-offs.
- A long-lived personal reference, written like a strong internal
  engineering handbook rather than a marketing blog.

The repository is organized so each chapter can be generated, edited, and
reviewed independently, then assembled into a complete book.

---

## Who This Book Is For

The target reader is a senior engineer who:

- Has practical experience in several of the covered areas.
- Wants to organize that experience into formal terminology.
- Is preparing for **Tech Lead** or **Staff Engineer** interviews.
- Wants a handbook that prioritizes **trade-offs** and **mental models**
  over surface-level definitions.

If you are looking for a beginner introduction to programming, this book
is not the right fit.

---

## Repository Layout

```text
tech-lead-handbook/
  README.md                   You are here
  SUMMARY.md                  Detailed table of contents
  BOOK_SPEC.md                What the book must achieve
  STYLE_GUIDE.md              Writing rules and formats
  CHAPTER_TEMPLATE.md         Reusable structure for every chapter
  CHAPTER_GENERATION_PROMPT.md  Canonical prompt for generating a chapter
  CONVERSION.md               How to build PDF and EPUB
  metadata.yaml               Pandoc metadata
  .gitignore                  Build artifacts and OS/editor noise
  book/                       All chapter Markdown files
  examples/                   Code, configs, and diagrams referenced in chapters
  scripts/                    Build scripts (PDF, EPUB)
  notes/                      Generation log, open questions, verification queue
```

See `SUMMARY.md` for the full chapter list and section breakdown.

---

## How to Use the Book

You can use this handbook in several ways:

1. **Read sequentially** following the order in `SUMMARY.md`.
2. **Jump to a chapter** that maps to an upcoming interview topic.
3. **Use the `Interview Questions and Answers` sections** as a drill set.
4. **Use the `Glossary`** to refresh terminology before interviews.
5. **Use the `Practical Interview Scenarios`** to simulate live questions.

Each chapter follows the same structure (see `CHAPTER_TEMPLATE.md`), so
you always know where to find the mental model, trade-offs, and the
"how to explain this in an interview" sections.

---

## How to Generate Chapters

Chapters are generated incrementally. The recommended workflow is:

1. Open the chapter skeleton in `book/`.
2. Read `BOOK_SPEC.md` and `STYLE_GUIDE.md`.
3. Use `CHAPTER_GENERATION_PROMPT.md` as the canonical prompt. It
   takes the chapter file, title, target length, and version-sensitivity
   as inputs and enforces the rules in `BOOK_SPEC.md` and
   `STYLE_GUIDE.md`.
4. Compare the result against `CHAPTER_TEMPLATE.md` and the
   self-review checklist at the bottom of
   `CHAPTER_GENERATION_PROMPT.md`.
5. Move uncertain claims into `notes/verification-needed.md` when the
   content depends on version-sensitive APIs (AWS, Next.js, Angular,
   React, Kubernetes, AI tooling, etc.).
6. Append a row to `notes/generation-log.md`.
7. Commit the chapter as a separate, reviewable change.

The recommended generation order is listed at the bottom of this README.

---

## How to Edit Chapters

- Keep changes scoped to a single chapter when possible.
- Preserve the chapter template structure.
- Avoid duplicating content that already lives in another chapter.
  Cross-link with relative Markdown links instead.
- When you change terminology, also update `book/26-glossary.md`.
- When you remove or rename a section, update `SUMMARY.md`.

---

## How to Convert to PDF or EPUB

See `CONVERSION.md` for the full toolchain. Short version:

```bash
# PDF
./scripts/build-pdf.sh

# EPUB
./scripts/build-epub.sh
```

The build scripts are intentionally thin wrappers around Pandoc. They
read `metadata.yaml` and concatenate `book/*.md` in alphabetical order.

---

## Recommended Generation Workflow

When generating a chapter:

1. Read the chapter skeleton.
2. Read `STYLE_GUIDE.md` and `BOOK_SPEC.md`.
3. Generate one chapter at a time. Do not generate multiple chapters in
   the same step. Quality drops sharply when scope explodes.
4. Prefer **conceptual** explanations over version-pinned ones.
5. Add a verification note in `notes/verification-needed.md` for any
   version-sensitive claim.
6. Append a generation entry to `notes/generation-log.md`.
7. Re-read the produced chapter as if you were an interviewer. Cut
   anything that sounds like a marketing post.

---

## Recommended Study Workflow

1. Read `book/00-introduction.md`.
2. Pick a chapter that targets your next interview.
3. Read the **Mental Model**, **Core Terminology**, and **Trade-offs**
   sections first.
4. Then read **How to Explain This in an Interview** and
   **Good Answer vs Weak Answer**.
5. Drill the **Interview Questions and Answers** out loud.
6. Use **Practical Interview Scenarios** for end-to-end rehearsals.
7. Track gaps in `notes/open-questions.md`.

---

## How to Track TODOs and Verification Notes

Three files in `notes/` carry the working state of the book:

- `notes/generation-log.md` — what was generated and when.
- `notes/open-questions.md` — questions that need an opinion or decision.
- `notes/verification-needed.md` — version-sensitive claims that must
  be checked against official documentation.

Treat these notes as a queue. Drain them before considering the book
"done".

---

## How to Avoid Shallow AI-Generated Content

This is the single most important quality rule for this project.

Apply these checks to any generated chapter:

- Does it explain **why** the concept exists, not only **what** it is?
- Does it list **trade-offs**, not only "advantages"?
- Does it show **failure modes** and **common mistakes**?
- Does it give a **mental model** an experienced engineer would respect?
- Does it provide **interview-grade** answers, not blog-grade summaries?
- Does it avoid hype words ("seamless", "powerful", "revolutionary")?
- Does it cite **specific versions only when verified**, otherwise prefer
  conceptually stable explanations?
- Does it include **at least one weak answer** to contrast against?
- Does the **Tech Lead Checklist** point to real production concerns?

If any answer is "no", the chapter is not done.

---

## Recommended Chapter Generation Order

The chapters are numbered for reading order, not generation order.

A pragmatic generation order:

1. `26-glossary.md` (start as a stub, grow it with every chapter)
2. `13-system-design.md`
3. `14-software-architecture.md`
4. `12-api-design.md`
5. `02-sql-and-nosql.md`
6. `19-performance-and-scalability.md`
7. `15-security.md`
8. `18-observability.md`
9. `17-ci-cd-and-devops.md`
10. `03-docker-and-kubernetes.md`
11. `04-aws.md`
12. `10-nodejs.md`
13. `05-javascript.md`
14. `06-typescript.md`
15. `08-react.md`
16. `09-nextjs.md`
17. `07-angular.md`
18. `11-python.md`
19. `01-algorithms-and-data-structures.md`
20. `16-testing-and-quality.md`
21. `20-git-and-engineering-workflow.md`
22. `21-ai-usage-in-software-engineering.md`
23. `22-soft-skills.md`
24. `23-tech-lead-skills.md`
25. `00-introduction.md` (generated late so it can cite real chapters)
26. `24-interview-questions-and-answers.md`
27. `25-practical-interview-scenarios.md`

The rationale: build the **architecture and systems backbone** first
(chapters 13, 14, 12, 02, 19), then the **operational skin** (security,
observability, CI/CD, containers, cloud), then **language/framework**
chapters, then the **process and people** chapters. The introduction
(`00`) and the two interview-only chapters (`24`, `25`) come last so
they can cross-link the rest of the book accurately. The glossary
(`26`) starts first as a stub and grows with every chapter.
