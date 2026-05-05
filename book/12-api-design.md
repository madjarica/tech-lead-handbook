# API Design

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can choose an API style (REST, RPC,
GraphQL, gRPC, event-driven), design idempotent and versionable
endpoints, and apply pagination, rate limiting, and error formats
that survive scale.

## Why This Matters for a Tech Lead

APIs are contracts. A bad contract is a long-term cost: every consumer
inherits its mistakes. A Tech Lead owns the contract style, the
deprecation policy, and the governance model.

## Mental Model

> TODO: An API as "a contract you cannot easily change". Add a Mermaid
> diagram showing producer, contract, multiple consumers, and the
> blast radius of a breaking change.

## Core Terminology

> TODO: Resource, idempotency, safe method, ETag, conditional request,
> cursor pagination, problem+json, rate limit, quota, contract test,
> backwards compatibility, deprecation.

## Theoretical Foundation

> TODO: Cover:
>
> - API styles:
>   - REST (resource-oriented, HTTP semantics).
>   - RPC over HTTP (JSON-RPC, OpenAPI-style RPC).
>   - GraphQL (single endpoint, client-driven query).
>   - gRPC (binary, schema-first, streaming).
>   - Event-driven (queues, topics, webhooks).
> - REST modeling: resources, URIs, methods, status codes, HATEOAS
>   (and why it is rare in practice).
> - Idempotency: which methods are idempotent by spec, how to make
>   POSTs idempotent with idempotency keys.
> - Pagination: offset vs cursor; trade-offs.
> - Versioning: URL, header, content negotiation; deprecation
>   strategies.
> - Errors: structured error responses; problem+json (RFC 7807).
> - AuthN/AuthZ patterns (link to chapter 15).
> - Rate limiting and quotas; token bucket vs leaky bucket vs fixed
>   window.
> - Backwards compatibility rules; what counts as breaking.
> - Contract testing; consumer-driven contracts.

## Practical Usage

> TODO:
>
> - Public REST APIs with strong contracts.
> - Internal RPC/gRPC for high-throughput service-to-service calls.
> - GraphQL for client-driven products with diverse data needs.
> - Event-driven for decoupled producers and consumers.

## Examples

> TODO:
>
> - A cursor-paginated REST endpoint.
> - An idempotent POST with `Idempotency-Key` header.
> - A problem+json error response.
> - A small OpenAPI fragment.

## Common Mistakes

> TODO:
>
> 1. Confusing "RESTful" with "JSON over HTTP".
> 2. Offset pagination on large datasets.
> 3. No idempotency on retryable POSTs (double charges).
> 4. Breaking changes shipped without a versioning plan.
> 5. Returning HTML error pages from a JSON API.

## Trade-offs

> TODO: REST vs GraphQL vs gRPC table by tooling, performance,
> caching, learning curve, ecosystem maturity.

## Production Considerations

> TODO:
>
> - Documentation: OpenAPI/AsyncAPI, generated clients.
> - Observability: per-endpoint metrics, distributed tracing.
> - Rate limiting and abuse handling.
> - Versioning and deprecation timelines.
> - Multi-region and idempotency.

## How to Explain This in an Interview

> TODO: 60-second answer to "How do you make a POST endpoint
> idempotent?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "REST vs GraphQL".

## Tech Lead Checklist

- [ ] Each API has a published contract (OpenAPI/AsyncAPI/proto).
- [ ] Versioning and deprecation policy is documented.
- [ ] Retry-safe operations are idempotent by design.
- [ ] Pagination is cursor-based for unbounded sets.
- [ ] Rate limiting is in place at the gateway.

## Interview Questions and Answers

### Basic

> TODO: "What is idempotency?"

### Senior

> TODO: "How would you design pagination for a feed?"

### Tech Lead

> TODO: "How do you govern API design across 30 teams?"

### Scenario-based

> TODO: "Design the public API for a payments product."

### Trick Questions

> TODO: "Is `PUT` always idempotent?"

### Red Flags

> TODO: Candidates who treat HTTP status codes as decoration.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Web API Design" (Apigee), "Designing APIs with Swagger and
> OpenAPI", RFC 7807, RFC 9110.

---

### Generation Notes

- Cross-link to chapter 13 (System Design), chapter 14 (Architecture),
  chapter 15 (Security).
- Avoid recommending a single style as universal. Be explicit about
  trade-offs.
