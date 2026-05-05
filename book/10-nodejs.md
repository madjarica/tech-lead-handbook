# Node.js: Express, NestJS, Fastify

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can build a production-grade Node.js
service, understand the event loop and back-pressure, and choose
between Express, Fastify, and NestJS with a defensible reason.

## Why This Matters for a Tech Lead

Node.js services often sit on the hot path of a product. The wrong
framework choice multiplies operational pain. A Tech Lead must own
the framework standard, observability, and graceful shutdown story.

## Mental Model

> TODO: Node.js as "single-threaded JavaScript on top of a libuv
> thread pool". The hot path is non-blocking; CPU-heavy work belongs
> in workers or a different service. Add a Mermaid diagram of the
> event loop with libuv.

## Core Terminology

> TODO: Event loop, libuv, worker thread, cluster, stream,
> back-pressure, graceful shutdown, middleware, decorator, DI
> container, schema-driven validation.

## Theoretical Foundation

> TODO: Cover:
>
> - Node.js runtime: event loop phases, libuv thread pool, worker
>   threads, cluster, child processes.
> - HTTP server fundamentals; keep-alive, sockets, timeouts.
> - Streams and back-pressure; readable, writable, transform.
> - Express: minimal, middleware-driven, unopinionated; trade-offs.
> - Fastify: schema-driven JSON validation, plugin system, performance
>   focus.
> - NestJS: opinionated framework, modules, providers, controllers,
>   DI, decorators, interceptors, guards, pipes.
> - Validation and error handling patterns.
> - Graceful shutdown and signal handling (`SIGTERM`, in-flight
>   requests, draining).
> - Observability: structured logs (`pino`), tracing (OpenTelemetry),
>   metrics.

## Practical Usage

> TODO:
>
> - Express for small services or BFFs.
> - Fastify when throughput per core matters.
> - NestJS when team size and structure benefit from opinionation.

## Examples

> TODO:
>
> - Minimal Express server with structured logging and graceful
>   shutdown.
> - Fastify route with schema-based validation.
> - NestJS module with controller, service, and a DTO with class
>   validators.
> - A worker thread example for CPU-bound work.

## Common Mistakes

> TODO:
>
> 1. Blocking the event loop with synchronous CPU work.
> 2. No graceful shutdown; in-flight requests dropped on deploy.
> 3. Building a "framework" on top of Express.
> 4. Trusting NestJS DI without understanding singleton scope.
> 5. Using `console.log` in production.

## Trade-offs

> TODO: Express vs Fastify vs NestJS table by performance, opinionation,
> learning curve, ecosystem, testability.

## Production Considerations

> TODO:
>
> - Graceful shutdown and Kubernetes preStop hooks (link to chapter 03).
> - Connection pooling (DB, HTTP).
> - Process management: PM2 vs systemd vs container orchestrator.
> - Memory profiling and heap dumps.
> - Observability defaults.

## How to Explain This in an Interview

> TODO: 60-second answer to "How does Node.js handle thousands of
> concurrent connections on one thread?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Express vs NestJS".

## Tech Lead Checklist

- [ ] All services have a graceful shutdown sequence.
- [ ] Structured logging is enforced.
- [ ] Tracing is wired in via OpenTelemetry.
- [ ] Connection pools are sized intentionally.
- [ ] CPU-bound work is offloaded out of the event loop.

## Interview Questions and Answers

### Basic

> TODO: "What is the event loop?"

### Senior

> TODO: "How do you handle back-pressure in a streaming endpoint?"

### Tech Lead

> TODO: "How do you choose a Node framework standard for a 50-engineer
> backend team?"

### Scenario-based

> TODO: "Your Node service starts dropping requests after 30 minutes
> in production — how do you investigate?"

### Trick Questions

> TODO: "Is `setImmediate` faster than `setTimeout(fn, 0)`?"

### Red Flags

> TODO: Candidates who treat Node.js as multithreaded by default.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: Node.js docs on the event loop; Fastify benchmarks (with
> caveats); NestJS docs.

---

### Generation Notes

- Cross-link to chapter 05 (JavaScript), chapter 18 (Observability),
  and chapter 19 (Performance).
- Avoid version-pinning Node features unless verified.
