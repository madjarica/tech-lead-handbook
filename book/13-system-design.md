# System Design

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can lead a system design interview at
Tech Lead level: clarify requirements, do capacity math, sketch a
viable architecture, justify trade-offs, and identify failure modes.

## Why This Matters for a Tech Lead

System design is the central interview format for senior+ roles. It
also reflects the actual job: defending choices in front of senior
engineers, architects, and stakeholders.

## Mental Model

> TODO: System design as "constrained optimization": pick building
> blocks (LB, cache, DB, queue, CDN) that satisfy SLOs at acceptable
> cost. Add a Mermaid diagram of a generic high-traffic service.

## Core Terminology

> TODO: SLO/SLI/SLA, RPO/RTO, fan-out, hot key, idempotency key,
> back-pressure, circuit breaker, bulkhead, leader election, quorum.

## Theoretical Foundation

> TODO: Cover:
>
> - The interview structure: clarify -> requirements -> capacity ->
>   high-level design -> deep dives -> trade-offs -> wrap-up.
> - Functional vs non-functional requirements.
> - SLOs and SLIs; turning "fast and reliable" into numbers.
> - Capacity estimation: QPS, storage, bandwidth, fan-out math.
> - Building blocks:
>   - Load balancers (L4 vs L7).
>   - Caches (in-process, distributed, CDN).
>   - Queues and streams (queue vs log; SQS-style vs Kafka-style).
>   - Databases (link to chapter 02).
>   - Search (inverted index at concept level).
>   - Object storage.
> - Patterns:
>   - Read-through, write-through, write-behind cache.
>   - CQRS, event sourcing, outbox pattern.
>   - Sharding, replication, leader/follower.
>   - Idempotency keys.
>   - Saga and distributed transactions.
> - Reliability primitives:
>   - Retries with backoff and jitter.
>   - Timeouts and deadlines.
>   - Circuit breakers and bulkheads.
>   - Load shedding and back-pressure.
> - Multi-region: active-passive, active-active, latency-based routing,
>   disaster recovery.
> - Common system design problems (URL shortener, rate limiter, news
>   feed, chat, search, ride-hailing dispatch, payments).

## Practical Usage

> TODO: How to use this in real architecture reviews and design docs.

## Examples

> TODO:
>
> - Capacity math for a write-heavy service.
> - A rate limiter sketch (token bucket with Redis).
> - An idempotency key flow with a deduplication table.
> - A cache stampede mitigation (single-flight + TTL jitter).

## Common Mistakes

> TODO:
>
> 1. Jumping into a diagram before clarifying requirements.
> 2. Ignoring tail latency.
> 3. Designing the happy path only.
> 4. Treating "microservices" as a default answer.
> 5. Not mentioning idempotency and retries on writes.

## Trade-offs

> TODO: Strong vs eventual consistency; sync vs async; cache invalidation
> strategies; replication topologies.

## Production Considerations

> TODO:
>
> - On-call burden of each block.
> - Cost shape (fixed vs marginal).
> - Operational complexity per added component.
> - Migration path between architectures.

## How to Explain This in an Interview

> TODO: A canonical interview opening: "Before I design, I want to
> agree on three things: what we are optimizing for, what the
> non-functional targets are, and what is out of scope".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Design a URL shortener".

## Tech Lead Checklist

- [ ] SLOs are written and reviewed quarterly.
- [ ] Capacity model exists and is updated with traffic.
- [ ] Reliability primitives (retries, timeouts, circuit breakers)
      are standardized.
- [ ] Idempotency is the default for writes.
- [ ] DR plan and game days exist.

## Interview Questions and Answers

### Basic

> TODO: "What is the difference between SLA, SLO, and SLI?"

### Senior

> TODO: "How would you handle a hot key in a sharded database?"

### Tech Lead

> TODO: "Walk me through how you would lead an architecture review."

### Scenario-based

> TODO: "Design a rate limiter for a multi-tenant API."

### Trick Questions

> TODO: "Is microservices the right answer?"

### Red Flags

> TODO: Candidates who answer with technology names instead of
> requirements.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Designing Data-Intensive Applications"; Google SRE books;
> Hussein Nasser's videos for systems explanations.

---

### Generation Notes

- This is the most important chapter for interview preparation.
- Cross-link aggressively to chapters 02, 12, 14, 18, 19.
- Keep the system design playbook compact enough to internalize.
