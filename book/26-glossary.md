# Glossary

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

This chapter defines the key terms used across the book. Every entry
points back to the chapter where the term is explored in depth.

The glossary is a **lookup tool**, not a teaching tool. Entries are
short and precise. Long explanations belong in the topic chapters.

## Why This Matters for a Tech Lead

Crisp terminology is one of the strongest signals in interviews and
in design reviews. The glossary is the cheat sheet for that signal.

## How to Use This Chapter

- Open it the day before an interview to refresh terminology.
- Use it during writing to keep terminology consistent.
- When a chapter introduces a key term, add it here in the same PR.

## Conventions

- Entries are alphabetical.
- Each entry is 1–3 sentences.
- "X vs Y" entries call out commonly confused pairs.
- Each entry links back to the chapter where it is explored.

---

## A

> TODO:
>
> - **AbortController** — a standard mechanism for cooperative
>   cancellation of async operations. See
>   [JavaScript](./05-javascript.md).
> - **ACID** — see [SQL and NoSQL](./02-sql-and-nosql.md).
> - **ADR (Architecture Decision Record)** — see [Software
>   Architecture](./14-software-architecture.md).
> - **Aggregate** — DDD term; see [Software
>   Architecture](./14-software-architecture.md).
> - **Amortized analysis** — see [Algorithms](./01-algorithms-and-data-structures.md).
> - **Anti-corruption layer** — DDD term; see [Software
>   Architecture](./14-software-architecture.md).
> - **API gateway** — see [API Design](./12-api-design.md).
> - **async/await** — syntactic sugar over Promises; `async` returns
>   a Promise, `await` pauses until it settles. See
>   [JavaScript](./05-javascript.md).
> - **AuthN vs AuthZ** — authentication is "who you are", authorization
>   is "what you can do". See [Security](./15-security.md).

## B

> TODO:
>
> - **Back-pressure** — see [Performance and
>   Scalability](./19-performance-and-scalability.md).
> - **Bloom filter** — see [Algorithms](./01-algorithms-and-data-structures.md).
> - **Bounded context** — see [Software
>   Architecture](./14-software-architecture.md).
> - **Blast radius** — see [System Design](./13-system-design.md).
> - **Blue/green deployment** — see [CI/CD](./17-ci-cd-and-devops.md).

## C

> TODO:
>
> - **Call stack** — LIFO stack of execution contexts; JavaScript has
>   one per thread. See [JavaScript](./05-javascript.md).
> - **CAP theorem** — pick two of consistency, availability, partition
>   tolerance under partition. See [SQL and
>   NoSQL](./02-sql-and-nosql.md) and [System
>   Design](./13-system-design.md).
> - **Canary deployment** — see [CI/CD](./17-ci-cd-and-devops.md).
> - **Cache stampede** — see [Performance](./19-performance-and-scalability.md).
> - **Circuit breaker** — see [System Design](./13-system-design.md).
> - **Closure** — a function plus the lexical environment where it was
>   created. See [JavaScript](./05-javascript.md).
> - **Concurrency vs Parallelism** — concurrency is structure,
>   parallelism is execution. See [JavaScript](./05-javascript.md) and
>   [Python](./11-python.md).
> - **Consistency models** — strong, eventual, causal,
>   read-your-writes, monotonic. See [SQL and NoSQL](./02-sql-and-nosql.md).

## D

> TODO:
>
> - **Debounce** — delay invocation until events stop for a specified
>   interval. See [JavaScript](./05-javascript.md).
> - **Disjoint set / Union-find** — see
>   [Algorithms](./01-algorithms-and-data-structures.md).
> - **DORA metrics** — see [CI/CD](./17-ci-cd-and-devops.md).
> - **Domain-Driven Design (DDD)** — see [Software
>   Architecture](./14-software-architecture.md).
> - **Dual-package hazard** — when CJS and ESM copies of the same
>   package coexist in one process, breaking singletons and
>   `instanceof`. See [JavaScript](./05-javascript.md).

## E

> TODO:
>
> - **Error budget** — see [Observability](./18-observability.md).
> - **ESM (ECMAScript Modules)** — the language-standard module system
>   (`import`/`export`); static, async, tree-shakeable. See
>   [JavaScript](./05-javascript.md).
> - **Event delegation** — attaching one listener at an ancestor and
>   dispatching via `event.target`. See [JavaScript](./05-javascript.md).
> - **Event loop** — the mechanism that dequeues microtasks and
>   macrotasks onto the single call stack. See
>   [JavaScript](./05-javascript.md) and [Node.js](./10-nodejs.md).
> - **Event sourcing** — see [System Design](./13-system-design.md).
> - **Execution context** — the environment binding variables, `this`,
>   and the scope chain for a piece of running code. See
>   [JavaScript](./05-javascript.md).

## F

> TODO:
>
> - **Feature flag** — see [CI/CD](./17-ci-cd-and-devops.md).
> - **Fitness function** — see [Software
>   Architecture](./14-software-architecture.md).

## G

> TODO:
>
> - **GIL (Global Interpreter Lock)** — see [Python](./11-python.md).
> - **GitOps** — see [CI/CD](./17-ci-cd-and-devops.md).

## H

> TODO:
>
> - **Hoisting** — declaration processing phase before execution;
>   `var` is initialized to `undefined`, `let`/`const` enter the TDZ,
>   function declarations are fully hoisted. See
>   [JavaScript](./05-javascript.md).
> - **Hot key** — see [System Design](./13-system-design.md).
> - **HPA (Horizontal Pod Autoscaler)** — see [Docker and
>   Kubernetes](./03-docker-and-kubernetes.md).

## I

> TODO:
>
> - **IaC (Infrastructure as Code)** — see [CI/CD](./17-ci-cd-and-devops.md).
> - **Idempotency** — see [API Design](./12-api-design.md).
> - **Idempotency key** — see [API Design](./12-api-design.md) and
>   [System Design](./13-system-design.md).

## J

> TODO:
>
> - **JWT (JSON Web Token)** — see [Security](./15-security.md).

## K

> TODO:
>
> - **Kubernetes** — see [Docker and
>   Kubernetes](./03-docker-and-kubernetes.md).

## L

> TODO:
>
> - **Latency vs Throughput** — latency is per-request time, throughput
>   is requests per second. See [Performance](./19-performance-and-scalability.md).
> - **LRU (Least Recently Used)** — see
>   [Algorithms](./01-algorithms-and-data-structures.md).

## M

> TODO:
>
> - **Macrotask (task)** — a callback scheduled by timers, I/O
>   completion, or UI events; picked one at a time after microtasks
>   drain. See [JavaScript](./05-javascript.md).
> - **Microtask** — a high-priority callback (Promise `.then`,
>   `queueMicrotask`) drained fully before the next macrotask. See
>   [JavaScript](./05-javascript.md).
> - **Microservices** — see [Software
>   Architecture](./14-software-architecture.md).
> - **MVCC (Multi-Version Concurrency Control)** — see [SQL and
>   NoSQL](./02-sql-and-nosql.md).

## N

> TODO:
>
> - **NoSQL** — see [SQL and NoSQL](./02-sql-and-nosql.md).

## O

> TODO:
>
> - **OAuth 2.0 / OIDC** — see [Security](./15-security.md).
> - **OnPush** (Angular change detection) — see [Angular](./07-angular.md).
> - **OpenTelemetry** — see [Observability](./18-observability.md).

## P

> TODO:
>
> - **PACELC** — extension of CAP. See [SQL and NoSQL](./02-sql-and-nosql.md).
> - **PDB (PodDisruptionBudget)** — see [Docker and
>   Kubernetes](./03-docker-and-kubernetes.md).
> - **Percentile (p50, p95, p99)** — see [Performance](./19-performance-and-scalability.md).
> - **Promise** — an object representing the eventual result of an
>   async operation (pending, fulfilled, rejected). See
>   [JavaScript](./05-javascript.md).
> - **Prototype chain** — linked list of objects walked on property
>   lookup. See [JavaScript](./05-javascript.md).

## Q

> TODO:
>
> - **Queue vs Log** — see [System Design](./13-system-design.md).

## R

> TODO:
>
> - **RBAC (Role-Based Access Control)** — see [Security](./15-security.md)
>   and [Docker and Kubernetes](./03-docker-and-kubernetes.md).
> - **RPO vs RTO** — see [System Design](./13-system-design.md).
> - **RSC (React Server Components)** — see [React](./08-react.md) and
>   [Next.js](./09-nextjs.md).

## S

> TODO:
>
> - **SBOM (Software Bill of Materials)** — see [Security](./15-security.md).
> - **Service mesh** — see [Docker and
>   Kubernetes](./03-docker-and-kubernetes.md).
> - **Sharding** — see [SQL and NoSQL](./02-sql-and-nosql.md) and
>   [System Design](./13-system-design.md).
> - **SLA, SLO, SLI** — see [Observability](./18-observability.md).
> - **SSR vs SSG vs ISR** — see [Next.js](./09-nextjs.md).
> - **STRIDE** (threat modeling) — see [Security](./15-security.md).
> - **Strangler fig pattern** — see [Software
>   Architecture](./14-software-architecture.md).

## T

> TODO:
>
> - **Tail latency** — see [Performance](./19-performance-and-scalability.md).
> - **Temporal dead zone (TDZ)** — the interval between entering a
>   scope and the `let`/`const` declaration; access throws
>   `ReferenceError`. See [JavaScript](./05-javascript.md).
> - **Throttle** — invoke a function at most once per interval. See
>   [JavaScript](./05-javascript.md).
> - **Throughput vs Latency** — see Latency vs Throughput.
> - **Trie** — see [Algorithms](./01-algorithms-and-data-structures.md).
> - **Trunk-based development** — see [Git
>   Workflow](./20-git-and-engineering-workflow.md).

## U

> TODO:
>
> - **Unit vs Integration vs E2E test** — see [Testing and
>   Quality](./16-testing-and-quality.md).

## V

> TODO:
>
> - **Vendor lock-in** — see [AWS](./04-aws.md) and [Next.js](./09-nextjs.md).
> - **VPC (Virtual Private Cloud)** — see [AWS](./04-aws.md).

## W

> TODO:
>
> - **Worker thread** (Node.js) — see [Node.js](./10-nodejs.md).
> - **Write-through cache / Write-behind cache** — see
>   [Performance](./19-performance-and-scalability.md).

## X / Y / Z

> TODO:
>
> - **YAGNI** ("You aren't gonna need it") — see [Software
>   Architecture](./14-software-architecture.md).
> - **Zero trust** — see [Security](./15-security.md).

---

### Generation Notes

- Grow this glossary continuously as chapters are generated.
- Every key term used in any chapter must have an entry here.
- Keep entries short. The chapter does the teaching.
