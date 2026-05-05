# AI Usage in Software Engineering

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can use AI tools effectively across
the SDLC, recognize their failure modes, set team policies for safe
use, and answer interview questions about AI productivity claims
with calibrated skepticism.

## Why This Matters for a Tech Lead

AI tools are now a default part of the engineering workflow. A Tech
Lead must set policy on what is allowed, how to evaluate output, and
how to track real productivity, not vendor claims.

## Mental Model

> TODO: AI as "a fast, cheap, lossy junior with infinite confidence".
> The Tech Lead's job is to design checkpoints where the lossy parts
> are caught. Add a Mermaid diagram showing AI in the SDLC with
> human-in-the-loop checkpoints.

## Core Terminology

> TODO: LLM, embedding, retrieval-augmented generation (RAG),
> agentic coding, hallucination, prompt injection, context window,
> function/tool calling, code review bot, autonomous coding agent.

> Verify against official documentation. AI tooling changes weekly.

## Theoretical Foundation

> TODO: Cover (with strong version-sensitivity caveats):
>
> - Where AI helps in the SDLC:
>   - Code generation (boilerplate, scaffolding).
>   - Refactoring across files.
>   - Test generation.
>   - Documentation and ADR drafting.
>   - On-call: log triage, runbook drafting.
>   - Debugging: stack-trace explanation, hypothesis generation.
> - Prompting patterns for engineers (constraints, examples,
>   self-critique loops).
> - AI in code review: assistant vs reviewer roles.
> - Risks:
>   - Hallucinated APIs and dependencies.
>   - License contamination.
>   - Leaking secrets and PII to vendors.
>   - Over-reliance and skill atrophy.
>   - Prompt injection in agentic tools.
>   - Auto-merge bots that ship the wrong thing.
> - Tool categories: IDE assistants, agentic tools, autonomous coding
>   agents, code review bots.
> - Evaluation: how to judge AI output without trusting it blindly.
> - Productivity claims: what "X% faster" actually measures.

## Practical Usage

> TODO:
>
> - Day-to-day patterns: scaffolding, codemod, test boilerplate.
> - Code review patterns: pre-review summary, surface risk areas.
> - Agentic patterns: scoped tasks with explicit acceptance criteria.

## Examples

> TODO:
>
> - A prompt that produces a focused refactor (not a sprawling one).
> - A code review workflow combining AI suggestions and human review.
> - A team policy for AI-generated code in production.

## Common Mistakes

> TODO:
>
> 1. Trusting hallucinated APIs without checking.
> 2. Using AI to "explain" code as a substitute for reading it.
> 3. No policy on data sent to vendors.
> 4. Treating AI "productivity" claims as unaudited truth.
> 5. Auto-merging AI PRs without strong CI signals.

## Trade-offs

> TODO: Speed vs verification cost; closed vendor models vs
> self-hosted; agentic vs assistant; permissive vs strict policy.

## Production Considerations

> TODO:
>
> - Data governance and vendor agreements.
> - License and IP risk.
> - On-call and incident handling: AI-suggested fixes need human
>   approval.
> - Skill development for the team.

## How to Explain This in an Interview

> TODO: A 60-second answer to "How do you use AI in your workflow?"
> that demonstrates calibrated use, not hype.

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Should we let AI auto-merge PRs?".

## Tech Lead Checklist

- [ ] Team policy on AI tool usage exists and is followed.
- [ ] Data sent to AI vendors is reviewed and approved.
- [ ] AI-generated code goes through the same review as any code.
- [ ] Productivity claims are measured against actual cycle time.
- [ ] Engineers maintain skills they would lose by over-relying on AI.

## Interview Questions and Answers

### Basic

> TODO: "What is a hallucination in an LLM context?"

### Senior

> TODO: "How do you evaluate AI-generated code in code review?"

### Tech Lead

> TODO: "How do you set team policy for AI usage?"

### Scenario-based

> TODO: "An AI-suggested fix is shipped during an incident and breaks
> things further. Walk me through the post-incident response."

### Trick Questions

> TODO: "AI claims to make us 50% faster — should we adopt it
> everywhere?"

### Red Flags

> TODO: Candidates who treat AI as either a silver bullet or a
> non-starter.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: Vendor docs (with version awareness); academic critiques of
> AI productivity claims; security research on prompt injection.

---

### Generation Notes

- Mark **everything tool-specific** as version-sensitive and add to
  `notes/verification-needed.md`.
- Avoid endorsing specific products. Stay at the pattern level.
- Cross-link to chapter 15 (Security) and chapter 16 (Testing).
