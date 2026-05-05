# Performance and Scalability

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can diagnose performance bottlenecks
in real systems, choose between caching, sharding, async, and
back-pressure as scaling tools, and reason about percentiles instead
of averages.

## Why This Matters for a Tech Lead

Performance is where users feel architecture. A Tech Lead must
prevent silent regressions, make scaling decisions before they hurt,
and steer the team away from premature optimization.

## Mental Model

> TODO: Performance as "find the smallest bottleneck and remove it,
> then repeat". Latency vs throughput are different problems. Add a
> Mermaid diagram of a typical request path with cache layers.

## Core Terminology

> TODO: Latency, throughput, p50/p95/p99, tail latency, back-pressure,
> load shedding, work conservation, locality, memoization, cache
> stampede, hot key, fan-out.

## Theoretical Foundation

> TODO: Cover:
>
> - Latency vs throughput; tail latency; why averages lie.
> - Where to look first: I/O, locks, serialization, allocation,
>   network round trips.
> - Caching:
>   - Cache hierarchies (browser, CDN, in-process, distributed).
>   - Read-through, write-through, write-behind.
>   - Invalidation strategies.
>   - Stampede control: single-flight, request coalescing, TTL jitter.
> - Concurrency models: threads, async, actors, queues.
> - Back-pressure and load shedding.
> - Horizontal scaling and stateless services.
> - Database scaling: read replicas, partitioning, denormalization.
> - Async and queues for write smoothing.
> - Performance budgets and continuous profiling.
> - Cost dimension of performance.

## Practical Usage

> TODO:
>
> - Reducing p99 in an existing service.
> - Designing a hot path that survives a 10x burst.
> - Adding caching without introducing inconsistency bugs.

## Examples

> TODO:
>
> - A cache stampede mitigation with single-flight.
> - A back-pressure pattern using a bounded queue.
> - A percentile-aware load test that surfaces tail latency.
> - A profile-driven optimization of a hot function.

## Common Mistakes

> TODO:
>
> 1. Optimizing the wrong layer (CPU when the bottleneck is I/O).
> 2. Caching without an invalidation strategy.
> 3. Optimizing the average while the p99 worsens.
> 4. Adding indexes without measuring write impact.
> 5. Treating "scale" as a synonym for "add more instances".

## Trade-offs

> TODO: Caching consistency vs freshness; sync vs async; vertical vs
> horizontal scaling; precomputation vs on-demand.

## Production Considerations

> TODO:
>
> - Continuous profiling.
> - Capacity planning and load testing.
> - Cost vs latency budget.
> - Hot/cold data separation.

## How to Explain This in an Interview

> TODO: 60-second answer to "How do you debug a slow endpoint in
> production?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "How would you reduce p99 latency
> for a hot endpoint?".

## Tech Lead Checklist

- [ ] Performance budgets exist for hot paths.
- [ ] p95 and p99 are tracked, not just averages.
- [ ] Load tests are run before major launches.
- [ ] Caching has an explicit invalidation story.
- [ ] Back-pressure exists at every queue boundary.

## Interview Questions and Answers

### Basic

> TODO: "What is the difference between latency and throughput?"

### Senior

> TODO: "What is a cache stampede and how do you prevent it?"

### Tech Lead

> TODO: "When would you choose vertical scaling over horizontal?"

### Scenario-based

> TODO: "Your read-heavy service is at p99 = 2s. Walk me through
> your optimization plan."

### Trick Questions

> TODO: "Is more caching always better?"

### Red Flags

> TODO: Candidates who reach for caching before measuring.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Systems Performance" (Brendan Gregg); Tail at Scale paper
> (Dean & Barroso); database vendor performance docs.

---

### Generation Notes

- Cross-link to chapters 02, 13, 18.
- Avoid quoting specific latency numbers without verification.
