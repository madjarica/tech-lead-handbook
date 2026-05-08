# Summary — Detailed Table of Contents

This is the master plan for the book. Each chapter entry lists the
expected sections, subsections, examples, diagrams, and interview
question categories. Use this as the reference when generating or
editing chapters.

The chapters in `book/` are numbered for **reading order**. See the
README for the recommended **generation order**.

---

## [00. Introduction](./book/00-introduction.md)

- How to use this book.
- Who the book is for.
- The Tech Lead role: scope, decisions, and signals.
- Mental models the book relies on (latency vs throughput, availability
  vs durability, coupling vs cohesion, blast radius, back-pressure).
- How to read each chapter.
- How chapters cross-reference each other.

**Examples:** none.
**Diagrams:** one Mermaid diagram showing chapter dependencies.
**Interview categories:** none (this is an orientation chapter).

---

## [01. Algorithms and Data Structures](./book/01-algorithms-and-data-structures.md)

- Big-O, Big-Theta, Big-Omega; amortized analysis.
- Core data structures: arrays, linked lists, hash maps, trees, heaps,
  graphs, tries, disjoint sets, bloom filters, LRU caches.
- Algorithm families: sorting, searching, two pointers, sliding window,
  recursion, divide and conquer, dynamic programming, greedy, graph
  traversal, shortest path, topological sort.
- Practical complexity: cache locality, I/O cost, real-world constants.
- When to **not** roll your own: prefer the standard library.

**Examples:** LRU cache, top-K with a heap, BFS vs DFS, simple DP
(coin change or longest common subsequence).
**Diagrams:** tree diagram for traversals, graph for shortest path.
**Interview categories:** Basic, Senior, Tech Lead, Scenario-based,
Trick, Red flags.

---

## [02. SQL and NoSQL Databases](./book/02-sql-and-nosql.md)

- Relational model and normalization (1NF–3NF, BCNF in passing).
- Indexes: B-tree, hash, partial, covering, multi-column, full-text.
- Query planning, EXPLAIN, common slow-query patterns.
- Transactions: ACID, isolation levels, anomalies, MVCC.
- Replication: primary/replica, multi-primary, logical vs physical.
- Sharding: range, hash, directory; resharding pain.
- NoSQL families: key-value, document, wide-column, graph, time-series.
- CAP and PACELC; consistency models in practice.
- Choosing a database: workload shape, query shape, ops cost.

**Examples:** an `EXPLAIN` walkthrough, an N+1 fix, a partial index,
a Mongo vs Postgres modeling comparison.
**Diagrams:** B-tree index, primary/replica replication, sharding.
**Interview categories:** all six.

---

## [03. Docker and Kubernetes](./book/03-docker-and-kubernetes.md)

- Containers vs VMs; Linux namespaces, cgroups, OCI images.
- Dockerfile patterns: multi-stage, layer caching, distroless, non-root.
- Kubernetes core objects: Pod, ReplicaSet, Deployment, Service,
  Ingress, ConfigMap, Secret, Job, CronJob, StatefulSet, DaemonSet.
- Scheduling: requests/limits, nodeSelector, taints/tolerations,
  affinity/anti-affinity, PodDisruptionBudget.
- Networking: ClusterIP, NodePort, LoadBalancer, Ingress, Services
  vs Endpoints, NetworkPolicy.
- Storage: PV, PVC, StorageClass, ephemeral vs persistent.
- Health checks: liveness, readiness, startup probes.
- Observability and rollout strategies; canary, blue/green.
- Cluster ops at Tech Lead level: cost, multi-tenancy, GitOps.

**Examples:** a clean multi-stage Dockerfile, a Deployment with
probes and resource limits, a HorizontalPodAutoscaler.
**Diagrams:** Pod-to-Service-to-Ingress flow.
**Interview categories:** all six.

> Verify against official documentation. Kubernetes APIs change.

---

## [04. AWS](./book/04-aws.md)

- Global structure: regions, availability zones, edge locations.
- Compute: EC2, ECS, EKS, Lambda, Fargate, Batch.
- Storage: S3, EBS, EFS, FSx; durability and consistency models.
- Databases: RDS, Aurora, DynamoDB, ElastiCache, Redshift, OpenSearch.
- Networking: VPC, subnets, security groups, NACLs, NAT, Transit
  Gateway, PrivateLink, Route53.
- Identity: IAM, STS, roles vs users, policy evaluation.
- Messaging: SQS, SNS, EventBridge, Kinesis, MSK.
- Edge and CDN: CloudFront, Global Accelerator.
- Observability: CloudWatch, X-Ray, CloudTrail.
- Cost levers: pricing models, savings plans, egress, idle resources.
- Multi-account organization: AWS Organizations, SCPs, landing zones.

**Examples:** an IAM trust policy, an S3 lifecycle rule, a serverless
event flow (S3 -> Lambda -> DynamoDB).
**Diagrams:** VPC layout with public/private subnets and NAT.
**Interview categories:** all six.

> Verify against official documentation. AWS services and limits change.

---

## [05. JavaScript](./book/05-javascript.md)

- The JavaScript runtime model: event loop, microtasks, macrotasks.
- Types and coercion; equality and comparison pitfalls.
- Scope, closures, hoisting, `this` binding, arrow functions.
- Prototypes vs classes.
- Async: callbacks, Promises, `async/await`, AbortController.
- Modules: ESM vs CJS, module resolution, dual-package hazards.
- Memory: references, garbage collection, common leaks.
- Error handling and stack traces.

**Examples:** an event-loop ordering snippet, a closure leak, a
correct `Promise.all` with cancellation.
**Diagrams:** event loop with microtask/macrotask queues.
**Interview categories:** all six.

---

## [06. TypeScript](./book/06-typescript.md)

- Structural typing vs nominal typing.
- Type inference, type narrowing, control-flow analysis.
- Generics, conditional types, mapped types, template literal types.
- `unknown` vs `any` vs `never`.
- Discriminated unions and exhaustiveness checks.
- Module resolution: `moduleResolution`, `paths`, ESM/CJS interop.
- `tsconfig.json` choices that scale across teams.
- Type-only imports, declaration files, ambient modules.
- Trade-offs: type safety vs build speed vs developer ergonomics.

**Examples:** a discriminated union with exhaustive `switch`, a small
generic utility, a `tsconfig.json` for a monorepo.
**Diagrams:** structural vs nominal typing in a Mermaid class diagram.
**Interview categories:** all six.

---

## [07. Angular](./book/07-angular.md)

- Mental model: components, directives, services, dependency injection.
- Modules vs standalone components.
- Change detection: zone-based vs zoneless, OnPush.
- Forms: template-driven vs reactive.
- Routing, lazy loading, route guards.
- RxJS: streams, operators, common pitfalls (subscriptions, multicast).
- Signals (where stable) and the modern reactivity story.
- Testing: TestBed, harnesses, isolated unit tests.
- Tech Lead concerns: upgrade strategy, library choices, build size.

**Examples:** a standalone component with OnPush, a reactive form, a
route guard.
**Diagrams:** component tree with change detection boundaries.
**Interview categories:** all six.

> Verify against official documentation. Angular evolves quickly.

---

## [08. React](./book/08-react.md)

- The React mental model: components, props, state, rendering.
- Reconciliation and the rendering pipeline.
- Hooks: `useState`, `useEffect`, `useMemo`, `useCallback`,
  `useReducer`, `useContext`, `useRef`, custom hooks, rules.
- State management: local state, lifted state, context, external
  stores (Redux, Zustand), server state (React Query/SWR).
- Server components and the React Server Components model
  (where stable).
- Suspense, transitions, concurrent rendering.
- Performance: memoization, list virtualization, code splitting.
- Testing strategies: React Testing Library philosophy.

**Examples:** a custom hook, a `useEffect` with proper cleanup, a
memoized list.
**Diagrams:** rendering and reconciliation flow.
**Interview categories:** all six.

> Verify against official documentation. React's concurrent and server
> features are evolving.

---

## [09. Next.js](./book/09-nextjs.md)

- App Router vs Pages Router (where relevant).
- Rendering modes: SSR, SSG, ISR, streaming, RSC.
- Caching layers and revalidation semantics.
- Routing, layouts, loading and error UI.
- Data fetching patterns and where to put them.
- Middleware and edge runtime trade-offs.
- Authentication patterns.
- Deployment shapes: Vercel, self-hosted Node, container.
- Tech Lead concerns: vendor lock-in, observability, cost.

**Examples:** a server component fetching data, a streaming layout, a
revalidation example.
**Diagrams:** request flow through middleware, RSC, and client.
**Interview categories:** all six.

> Verify against official documentation. Next.js caching semantics
> have changed across recent major versions.

---

## [10. Node.js: Express, NestJS, Fastify](./book/10-nodejs.md)

- Node.js runtime: event loop, libuv, worker threads, clustering.
- HTTP server fundamentals; streams and back-pressure.
- Express: minimal, middleware-driven, unopinionated.
- Fastify: schema-driven, performance-oriented, plugin model.
- NestJS: opinionated framework, modules, providers, DI, decorators.
- Validation, error handling, request lifecycle.
- Observability: logging, tracing, metrics, structured logs.
- Process management and graceful shutdown.
- Performance and scaling: keep-alive, connection pools, hot paths.

**Examples:** a minimal Express server, a Fastify schema, a NestJS
module with a service and controller.
**Diagrams:** Node.js event loop with libuv.
**Interview categories:** all six.

---

## [11. Python](./book/11-python.md)

- Language model: dynamic typing, references, MRO, GIL.
- Data model: iterables, generators, context managers.
- Async Python: `asyncio`, event loop, `await`, common pitfalls.
- Concurrency: threads, processes, async, when to choose which.
- Type hints, `mypy`/`pyright`, dataclasses, `Protocol`.
- Packaging and dependency management (Poetry, pip, virtualenvs).
- Web frameworks at a glance: FastAPI, Django, Flask.
- Performance and tooling: profiling, `cProfile`, `pyinstrument`.

**Examples:** a generator, a context manager, a small FastAPI handler.
**Diagrams:** GIL and concurrency model.
**Interview categories:** all six.

---

## [12. API Design](./book/12-api-design.md)

- API styles: REST, RPC, GraphQL, gRPC, event-driven.
- Resource modeling, URI design, HTTP methods, status codes.
- Idempotency, safe vs unsafe operations.
- Pagination strategies (offset vs cursor).
- Versioning: URL, header, content negotiation; deprecation.
- Errors: structured error responses, problem+json.
- Authentication and authorization patterns.
- Rate limiting, quotas, throttling.
- Backwards compatibility and contract testing.
- API governance at organization scale.

**Examples:** a cursor-paginated endpoint, an idempotent POST with
keys, a structured error response.
**Diagrams:** REST vs gRPC vs GraphQL request shape.
**Interview categories:** all six.

---

## [13. System Design](./book/13-system-design.md)

- The system design interview format and how to lead it.
- Functional vs non-functional requirements; SLOs and SLIs.
- Capacity estimation: back-of-the-envelope.
- Building blocks: load balancers, caches, queues, databases, CDNs.
- Patterns: read-through cache, write-behind, CQRS, event sourcing.
- Scaling: vertical vs horizontal, sharding, replication.
- Consistency vs availability; CAP, PACELC; idempotency keys.
- Reliability: retries, timeouts, circuit breakers, bulkheads.
- Multi-region: active-passive, active-active, latency-based routing.
- Common system design problems (URL shortener, rate limiter, news
  feed, chat, search, ride-hailing dispatch).

**Examples:** capacity math for a write-heavy service, a rate limiter
sketch, an idempotency key flow.
**Diagrams:** layered architecture for a high-traffic service.
**Interview categories:** all six.

---

## [14. Software Architecture](./book/14-software-architecture.md)

- Architecture vs design vs implementation.
- Architectural styles: monolith, modular monolith, microservices,
  service-oriented, event-driven, serverless.
- Hexagonal, Clean, Onion, layered architectures.
- Domain-Driven Design: bounded contexts, aggregates, anti-corruption
  layers.
- Communication: sync vs async, choreography vs orchestration.
- Data ownership and the database-per-service rule.
- Migration strategies: strangler fig, branch-by-abstraction.
- Architecture decision records (ADRs).
- Architectural fitness functions and quality attributes.

**Examples:** an ADR template, a strangler fig sketch, a bounded
context map.
**Diagrams:** modular monolith vs microservices comparison.
**Interview categories:** all six.

---

## [15. Security](./book/15-security.md)

- Threat modeling: STRIDE, attacker mindset.
- AuthN vs AuthZ; OAuth 2.0, OIDC, SAML, JWT vs sessions.
- Common web vulnerabilities: OWASP Top 10 categories.
- Cryptography fundamentals: symmetric vs asymmetric, hashing,
  key rotation, certificate management.
- Secrets management: vaults, KMS, environment variables.
- Network security: TLS, mTLS, VPCs, security groups, zero trust.
- Supply chain: dependencies, SBOM, signing, provenance.
- Incident response basics.
- Security at Tech Lead level: ownership, policy, audits.

**Examples:** a JWT validation snippet, a CSP header, a basic
threat model for a service.
**Diagrams:** OAuth 2.0 authorization code flow with PKCE.
**Interview categories:** all six.

---

## [16. Testing and Quality](./book/16-testing-and-quality.md)

- The testing pyramid (and its critics).
- Unit, integration, contract, end-to-end, smoke, performance,
  chaos, security tests.
- Test doubles: stubs, mocks, fakes, spies; when to use which.
- Property-based testing.
- Code coverage: useful and misleading uses.
- Flaky tests: causes and fixes.
- Test data management.
- CI integration and quality gates.
- Quality at Tech Lead level: SLOs, error budgets, code review
  standards.

**Examples:** a unit test with a fake, a contract test, a flaky test
fix.
**Diagrams:** the testing pyramid and an alternative shape.
**Interview categories:** all six.

---

## [17. CI/CD and DevOps](./book/17-ci-cd-and-devops.md)

- Continuous Integration vs Continuous Delivery vs Continuous
  Deployment.
- Pipeline design: stages, caching, parallelism.
- Build reproducibility and hermetic builds.
- Artifact management and versioning.
- Deployment strategies: blue/green, canary, rolling, feature flags.
- Infrastructure as Code: Terraform, CloudFormation, Pulumi.
- GitOps and pull-based deployment.
- Secrets in pipelines.
- Release management at Tech Lead level: change advisory, on-call.

**Examples:** a minimal CI workflow, a Terraform module sketch, a
canary configuration.
**Diagrams:** CI/CD pipeline with quality gates.
**Interview categories:** all six.

---

## [18. Observability](./book/18-observability.md)

- Three pillars: logs, metrics, traces; and beyond (events, profiles).
- Structured logging and log levels.
- Metric types: counter, gauge, histogram, summary; cardinality.
- Distributed tracing: spans, context propagation, OpenTelemetry.
- SLIs, SLOs, error budgets.
- Alerting: symptoms vs causes, paging discipline.
- Dashboards as products.
- Observability at Tech Lead level: ownership, cost, vendor choice.

**Examples:** a structured log line, a Prometheus query for an SLO,
an OpenTelemetry trace sketch.
**Diagrams:** trace fan-out across services.
**Interview categories:** all six.

---

## [19. Performance and Scalability](./book/19-performance-and-scalability.md)

- Latency vs throughput; tail latency; percentiles vs averages.
- Where to look first: I/O, locks, allocation, network.
- Caching: cache hierarchies, invalidation, stampede control.
- Concurrency models: threads, async, actors, queues.
- Back-pressure and load shedding.
- Horizontal scaling and stateless services.
- Database scaling: read replicas, partitioning, denormalization.
- Performance budgets and continuous profiling.
- The cost dimension of performance work.

**Examples:** a cache stampede mitigation, a back-pressure pattern,
a percentile-aware load test.
**Diagrams:** request path with cache layers.
**Interview categories:** all six.

---

## [20. Git and Engineering Workflow](./book/20-git-and-engineering-workflow.md)

- Git internals at the level a Tech Lead must explain.
- Branching strategies: trunk-based, GitFlow, GitHub Flow.
- Commit hygiene: atomic commits, conventional commits, signed
  commits.
- Pull request culture: size, scope, review depth.
- Merge vs rebase vs squash.
- Monorepo vs polyrepo trade-offs.
- Code ownership, CODEOWNERS, review SLAs.
- Release branches and hotfix flow.
- Engineering workflow at Tech Lead level: throughput, lead time,
  review backlog.

**Examples:** a clean rebase, a CODEOWNERS snippet, a conventional
commit message.
**Diagrams:** trunk-based vs GitFlow.
**Interview categories:** all six.

---

## [21. AI Usage in Software Engineering](./book/21-ai-usage-in-software-engineering.md)

- Where AI helps in the SDLC: code generation, review, refactoring,
  testing, debugging, docs, on-call.
- Prompting patterns for engineers.
- Code review with AI: assistant vs reviewer.
- Risks: hallucinated APIs, license contamination, leaking secrets,
  over-reliance, skill atrophy.
- Tooling categories: IDE assistants, agentic tools, code review
  bots, autonomous coding agents.
- Evaluation: how to judge AI output without trusting it blindly.
- AI at Tech Lead level: policy, training, productivity claims,
  hiring impact.

**Examples:** a prompt that produces a focused refactor, a review
workflow that combines AI and human review.
**Diagrams:** AI in the SDLC, with human-in-the-loop checkpoints.
**Interview categories:** all six.

> Verify against official documentation. AI tooling changes weekly.

---

## [22. Soft Skills](./book/22-soft-skills.md)

- Communication: writing, speaking, listening.
- Technical writing: design docs, ADRs, RFCs, post-mortems.
- Stakeholder management.
- Influence without authority.
- Disagreement and decision-making.
- Mentoring and feedback.
- Working across timezones and cultures.
- Time and attention management for senior engineers.

**Examples:** a design doc skeleton, a post-mortem template.
**Diagrams:** none required; this chapter is mostly prose.
**Interview categories:** all six.

---

## [23. Tech Lead Skills](./book/23-tech-lead-skills.md)

- The Tech Lead role vs Engineering Manager vs Staff Engineer.
- Owning technical direction.
- Project planning and breakdown.
- Risk identification and mitigation.
- Estimation that survives reality.
- Hiring and interviewing as a Tech Lead.
- Onboarding engineers and ramping teams.
- Cross-functional collaboration: product, design, data, ops.
- Working with leadership and executives.
- Career growth: from senior to Tech Lead and beyond.

**Examples:** a project breakdown structure, a risk register row.
**Diagrams:** Tech Lead responsibilities map.
**Interview categories:** all six.

---

## [24. Interview Questions and Answers](./book/24-interview-questions-and-answers.md)

- Aggregated Q&A across topics, with cross-links into chapters.
- Categories repeated per topic group: Basic, Senior, Tech Lead,
  Scenario-based, Trick, Red flags.
- A "warm-up" set for the day before an interview.
- A "deep dive" set for long-form preparation.

**Examples:** representative answers for the most common Tech Lead
interview questions.
**Diagrams:** none.
**Interview categories:** all six (this chapter is the main bank).

---

## [25. Practical Interview Scenarios](./book/25-practical-interview-scenarios.md)

- End-to-end scenarios that combine multiple chapters.
- System design walkthroughs (e.g. URL shortener, news feed,
  rate limiter, chat, search, payments).
- Incident scenarios (e.g. cache stampede, runaway query, leaked
  secret, regional outage).
- Team scenarios (e.g. underperforming engineer, cross-team
  blocker, missed deadline).
- For each scenario: the prompt, the expected structure, a strong
  answer, common pitfalls.

**Examples:** complete scenario walkthroughs.
**Diagrams:** one architecture diagram per system design scenario.
**Interview categories:** Scenario-based and Tech Lead.

---

## [26. Glossary](./book/26-glossary.md)

- Topic-organized glossary of all key terms used in the book,
  grouped into 14 areas (Algorithms, Databases, Docker/Kubernetes,
  AWS, JavaScript/TypeScript, Frontend Frameworks, Backend/API,
  Security, Architecture, Testing, CI/CD, Observability, AI, Leadership).
- Each entry: area, definition, practical example, interview usage,
  common confusion, related terms, and optional Tech Lead note.
- Distinguish closely related terms with explicit comparison guidance.

**Examples:** none.
**Diagrams:** none.
**Interview categories:** none.
