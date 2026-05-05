# Chapter Template

Copy this template when starting a new chapter. Keep all section
headings even if a section is short. Consistency across chapters is
more valuable than per-chapter creativity.

The template below is the **canonical structure** referenced by
`BOOK_SPEC.md` and the `Definition of Done` for a chapter.

---

```md
# Chapter Title

## Chapter Goal

Explain what the reader should understand after reading this chapter.
2–4 sentences. Be specific. "Understand X" is too vague; prefer
"explain X to an interviewer, choose between Y and Z, and identify
the failure modes of W".

## Why This Matters for a Tech Lead

Explain why this topic matters at Tech Lead level: what decisions a
Tech Lead owns here, what mistakes are expensive at scale, what the
hiring signal is. Avoid generic motivation.

## Mental Model

Give a simple but accurate mental model. Often a one-paragraph
analogy plus a small Mermaid diagram. The mental model must survive
across versions and stacks.

## Core Terminology

Define the most important terms used in this chapter. Use a definition
list or a short table. Cross-link to the glossary when a term has its
own glossary entry. Distinguish closely related terms explicitly
(e.g. concurrency vs parallelism, throughput vs latency).

## Theoretical Foundation

Explain the theory in a practical, structured way. Cover:

- What it is.
- Why it exists.
- How it works at a level a Tech Lead must explain on a whiteboard.
- The invariants and constraints that hold.

This is the longest section in most chapters.

## Practical Usage

Explain where this appears in real projects. Reference real services,
real patterns, real failure scenarios. Avoid toy examples.

## Examples

Add code, configuration, diagrams, or architecture examples where
relevant. After each important example, explain:

- What the code does.
- Why it is written this way.
- What a weaker alternative would be.
- How it would change in production.

Use only allowed language tags from `STYLE_GUIDE.md`.

## Common Mistakes

List common misunderstandings and mistakes using the format from
`STYLE_GUIDE.md`. Each mistake must be something an experienced
engineer can recognize.

## Trade-offs

Explain important trade-offs. Use the shape "optimizes for X at the
cost of Y, and flips when Z". Prefer a small comparison table when
there are 2–4 options.

## Production Considerations

Explain production-grade concerns:

- Security.
- Performance and scalability.
- Reliability and on-call.
- Maintainability.
- Cost.
- Team and hiring implications.
- Vendor and version lock-in.
- Migration and rollback.

## How to Explain This in an Interview

Give strong interview-ready explanations. 3–6 sentences each. Use the
vocabulary an interviewer will recognize. Provide one or two ways to
open the answer, depending on the question shape.

## Good Answer vs Weak Answer

Show one strong answer and one weak answer for the same question.
Both must be plausible. The weak answer is what a mid-level engineer
might say; not a strawman. Follow the format in `STYLE_GUIDE.md`.

## Tech Lead Checklist

A practical checklist for real projects. Items must be concrete and
verifiable. Each item should reference a real artifact (a runbook, a
dashboard, a config flag, an SLO, a contract).

- [ ] Item 1.
- [ ] Item 2.
- [ ] Item 3.

## Interview Questions and Answers

Split questions into the following groups. Each group must have at
least one question. Use the detailed Q&A format from `STYLE_GUIDE.md`
for important questions, and the short format for narrow factual ones.

### Basic

Terminology and definitions.

### Senior

Trade-offs, failure modes, design choices.

### Tech Lead

System-level, team-level, cost, hiring, on-call, organizational impact.

### Scenario-based

"You are given X, design Y" style questions.

### Trick Questions

Common phrasings that hide a wrong assumption. Explain the trap.

### Red Flags

Answers or assumptions that should concern an interviewer.

## Summary

Summarize the chapter in 5–8 bullet points. The summary should be
useful as a refresher right before an interview.

## Further Study

List topics to verify or expand later. If any item is version-sensitive,
also add a row to `notes/verification-needed.md`.
```

---

## Notes for Chapter Authors

- Keep the order of sections exactly as above.
- Do not add new top-level sections without updating `BOOK_SPEC.md`.
- Do not skip a section. If a section is genuinely not applicable,
  write one sentence explaining why.
- When you finish a chapter, append a line to
  `notes/generation-log.md` and clear or update any related items in
  `notes/verification-needed.md` and `notes/open-questions.md`.

## Structural Exceptions

A small number of chapters are **reference chapters** rather than
teaching chapters and are exempt from parts of this template. The
exceptions are listed in `BOOK_SPEC.md` under "Structural Exceptions".
At the time of writing, the only exempt chapter is
`book/26-glossary.md`.

If you propose a new structural exception, update `BOOK_SPEC.md`
first, then this template's reference, in the same change.
