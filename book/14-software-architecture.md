# Software Architecture

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can place architectural styles on a
spectrum, choose between monolith, modular monolith, and microservices
with reasons, and lead an Architecture Decision Record (ADR) process.

## Why This Matters for a Tech Lead

Architecture is the part of the job that compounds. A Tech Lead's
biggest leverage is preventing the wrong architectural style from
locking in 2 years of operational debt.

## Mental Model

> TODO: Architecture as "where you draw boundaries and how things
> communicate across them". The interesting part is always the
> boundaries. Add a Mermaid diagram contrasting monolith, modular
> monolith, and microservices.

## Core Terminology

> TODO: Coupling, cohesion, bounded context, aggregate, anti-corruption
> layer, choreography, orchestration, ADR, fitness function,
> conformance test.

## Theoretical Foundation

> TODO: Cover:
>
> - Architecture vs design vs implementation.
> - Architectural styles:
>   - Monolith.
>   - Modular monolith.
>   - Microservices.
>   - Service-oriented architecture (SOA).
>   - Event-driven.
>   - Serverless.
> - Layered, hexagonal, clean, onion architectures.
> - Domain-Driven Design at concept level: bounded contexts,
>   aggregates, ubiquitous language, anti-corruption layers.
> - Communication: sync vs async, choreography vs orchestration.
> - Data ownership: database-per-service rule and its violations.
> - Migration strategies: strangler fig, branch-by-abstraction,
>   parallel run.
> - Architecture Decision Records (ADRs).
> - Architectural fitness functions and quality attributes
>   (performance, scalability, security, observability,
>   evolvability, cost).

## Practical Usage

> TODO:
>
> - When a modular monolith is the right answer (almost always for
>   small teams).
> - When microservices are the right answer (organizational scale,
>   independent release cadence).
> - When event-driven dominates (decoupled producers, replayability).

## Examples

> TODO:
>
> - An ADR template.
> - A bounded context map for a small product.
> - A strangler fig migration plan.
> - A modular monolith package layout.

## Common Mistakes

> TODO:
>
> 1. Splitting into microservices without organizational readiness.
> 2. Sharing a database across services.
> 3. "Distributed monolith" — services that must deploy together.
> 4. Missing anti-corruption layer when integrating with legacy.
> 5. ADRs that say "we decided X" without trade-offs.

## Trade-offs

> TODO: Monolith vs modular monolith vs microservices, by team size,
> deployment cadence, ops cost, on-call burden, observability cost.

## Production Considerations

> TODO:
>
> - Operational tax of each style.
> - Hiring profile required.
> - Refactoring cost when you change your mind.

## How to Explain This in an Interview

> TODO: A clean answer to "When would you not use microservices?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Modular monolith vs microservices
> for a 15-engineer team".

## Tech Lead Checklist

- [ ] An ADR exists for every load-bearing decision.
- [ ] Service boundaries match team boundaries (Conway's Law on purpose).
- [ ] No shared databases across services.
- [ ] Migration plans (strangler fig) for legacy integrations.
- [ ] Architecture is reviewed at least once per quarter.

## Interview Questions and Answers

### Basic

> TODO: "What is coupling vs cohesion?"

### Senior

> TODO: "Explain bounded context."

### Tech Lead

> TODO: "How do you decide when to break a monolith into services?"

### Scenario-based

> TODO: "You inherit a 5-year-old monolith and need to ship a major
> new product line — how do you architect it?"

### Trick Questions

> TODO: "Are microservices best practice?"

### Red Flags

> TODO: Candidates who advocate microservices for a 5-person team.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Building Evolutionary Architectures"; "Domain-Driven Design"
> (Evans); "Building Microservices" (Newman).

---

### Generation Notes

- Cross-link to chapter 13 (System Design), chapter 17 (CI/CD),
  chapter 18 (Observability).
- This chapter must be especially careful about hype-free framing.
