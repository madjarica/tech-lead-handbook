# Next.js

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can choose a rendering mode for each
route, reason about Next.js caching layers, design data-fetching
boundaries with server components, and avoid the standard production
pitfalls.

## Why This Matters for a Tech Lead

Next.js is now the default React framework for many companies. Its
caching and rendering semantics change between major versions, which
puts the upgrade and migration burden on the Tech Lead.

## Mental Model

> TODO: Next.js as "a React framework with opinionated routing and a
> caching pipeline that turns request handlers into edges, servers,
> and clients". Add a Mermaid diagram showing a request passing
> through middleware -> server components -> client.

## Core Terminology

> TODO: SSR, SSG, ISR, RSC (React Server Components), streaming,
> middleware, edge runtime, Node.js runtime, route handler, layout,
> loading UI, error UI, revalidation, segment-level caching.

> Verify against official documentation. Next.js caching semantics
> have changed across recent major versions.

## Theoretical Foundation

> TODO: Cover (with version caveats):
>
> - App Router vs Pages Router; when each is relevant.
> - Rendering modes: SSR, SSG, ISR, streaming, RSC.
> - Caching layers: request memoization, data cache, full route cache,
>   router cache (mark all as version-sensitive).
> - Routing model: layouts, route groups, parallel routes, intercepts.
> - Data fetching patterns: in server components, route handlers,
>   server actions.
> - Middleware and edge runtime; constraints and trade-offs.
> - Authentication patterns (cookies, session, third-party).
> - Image and font optimization at concept level.
> - Deployment shapes: Vercel, self-hosted Node, container.

## Practical Usage

> TODO:
>
> - Marketing site: SSG with ISR.
> - Authenticated dashboard: server components + client islands.
> - High-write app: route handlers + server actions + careful caching.

## Examples

> TODO:
>
> - A server component fetching data from a backend.
> - A streaming layout with Suspense boundaries.
> - A revalidation example with tags.
> - Middleware that rewrites for A/B tests.

## Common Mistakes

> TODO:
>
> 1. Mixing client and server components without understanding the
>    serialization boundary.
> 2. Cache busting by accident (forgetting `revalidate` or tags).
> 3. Putting heavy work in middleware.
> 4. Reaching for the edge runtime for everything, then hitting
>    Node-only API limits.
> 5. Treating `use client` as a free fallback.

## Trade-offs

> TODO: Self-hosted Node vs Vercel; Pages Router vs App Router; RSC
> vs traditional SSR.

## Production Considerations

> TODO:
>
> - Cache invalidation strategy and observability.
> - Cold starts on serverless and edge.
> - Vendor lock-in (Vercel-specific features).
> - Cost: bandwidth, function invocations, ISR rebuilds.

## How to Explain This in an Interview

> TODO: 60-second answer to "How does Next.js handle caching?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Should you use server components?".

## Tech Lead Checklist

- [ ] Caching strategy is documented per route.
- [ ] Server/client boundary is reviewed in code review.
- [ ] Observability covers cache hit rates and revalidation.
- [ ] Deployment shape is chosen and documented.
- [ ] Upgrade plan exists for Next.js majors.

## Interview Questions and Answers

### Basic

> TODO: "What is SSR vs SSG vs ISR?"

### Senior

> TODO: "How does the App Router cache data fetches?"

### Tech Lead

> TODO: "What are the cost and lock-in trade-offs of Vercel vs
> self-hosting?"

### Scenario-based

> TODO: "Design a Next.js architecture for a high-traffic e-commerce
> site."

### Trick Questions

> TODO: "Are server components rendered on the server every time?"

### Red Flags

> TODO: Candidates who claim Next.js features without distinguishing
> Pages Router and App Router.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: Next.js documentation (verify version); React docs for RSC;
> Vercel architecture guides.

---

### Generation Notes

- Mark **everything** caching-related as version-sensitive and add to
  `notes/verification-needed.md`.
- Cross-link to chapters 08 (React), 17 (CI/CD), and 19 (Performance).
