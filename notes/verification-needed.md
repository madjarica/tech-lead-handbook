# Verification Needed

Version-sensitive claims that must be verified against official
documentation before the book is considered done. When a row is
verified, update the relevant chapter and delete the row from this
file.

Format: one row per claim.

---

## Format

```md
- **Chapter:** file
- **Section:** heading or anchor (if known)
- **Claim:** the statement that needs verification
- **Why it matters:** what depends on the claim being correct
- **Suggested source:** official documentation or specification
- **Status:** unverified / verified / removed
```

---

## Pre-listed Areas (populate during generation)

These chapters have known version-sensitivity. As content is generated,
add specific rows here.

### `book/03-docker-and-kubernetes.md`

- API versions for Deployment, Ingress, NetworkPolicy.
- Default ingress controller and admission controller behavior.
- Probe semantics (initialDelaySeconds, failureThreshold).
- HPA metrics API (autoscaling/v2 status).
- Suggested source: `https://kubernetes.io/docs/`.

### `book/04-aws.md`

- Service limits and quotas (per-service, per-region).
- Pricing model details (savings plans, spot, request pricing).
- S3 consistency model wording (strong read-after-write).
- IAM policy evaluation order and condition keys.
- Lambda concurrency model (reserved, provisioned, account-level).
- Suggested source: AWS official documentation per service.

### `book/07-angular.md`

- Standalone components default in the chosen Angular major.
- Signals stability and integration with change detection.
- Zoneless mode availability.
- Forms API additions.
- Suggested source: `https://angular.dev/`.

### `book/08-react.md`

- Server Components stability and integration.
- `use` hook, Actions, and async transitions.
- Concurrent features defaults.
- Suggested source: `https://react.dev/`.

### `book/09-nextjs.md`

- Caching layers (request memoization, data cache, full route cache,
  router cache) — semantics may have changed across recent majors.
- App Router vs Pages Router status.
- Server Actions stability and constraints.
- Edge runtime API surface.
- Suggested source: `https://nextjs.org/docs`.

### `book/10-nodejs.md`

- ESM resolution rules and `--experimental-*` flags.
- Worker threads behavior.
- Built-in test runner stability.
- Suggested source: `https://nodejs.org/api/`.

### `book/11-python.md`

- Asyncio API surface.
- Type hints features per Python version (e.g., `Self`, `TypeAlias`,
  PEP 695 generics).
- Packaging tools state of the art.
- Suggested source: `https://docs.python.org/3/`.

### `book/06-typescript.md`

- Module resolution modes (`node16`, `nodenext`, `bundler`).
- `verbatimModuleSyntax`, decorators, `using` declarations.
- Suggested source: `https://www.typescriptlang.org/docs/`.

### `book/21-ai-usage-in-software-engineering.md`

- Tool capabilities and modes (IDE assistants, agentic, code review
  bots) — extremely fast moving.
- Vendor data handling and license terms.
- Suggested source: official vendor documentation; verify per-claim.

### `book/17-ci-cd-and-devops.md`

- OIDC support in GitHub Actions / GitLab CI.
- Argo CD / Flux feature surface.
- Terraform state locking and backends.
- Suggested source: official docs per tool.

---

## Active Items

- **Chapter:** `book/05-javascript.md`
- **Section:** The event loop, microtasks, and macrotasks
- **Claim:** The specific Node.js event-loop phases (timers, pending
  callbacks, idle/prepare, poll, check, close callbacks) and the
  priority of `process.nextTick` relative to microtasks.
- **Why it matters:** The chapter mentions the phases exist but does
  not pin them. If a future edit adds phase-specific claims, they
  must be checked.
- **Suggested source:** `https://nodejs.org/en/learn/asynchronous-work/event-loop-timers-and-nexttick`
- **Status:** unverified

---

- **Chapter:** `book/05-javascript.md`
- **Section:** Modules: ESM vs CommonJS
- **Claim:** The `"exports"` field behavior, `"type": "module"`, and
  the resolution algorithm specifics.
- **Why it matters:** ESM resolution rules have evolved across Node
  versions; incorrect advice could cause module-loading failures.
- **Suggested source:** `https://nodejs.org/api/packages.html`
- **Status:** unverified

---

- **Chapter:** `book/05-javascript.md`
- **Section:** Memory model and garbage collection
- **Claim:** `structuredClone` support and its type coverage.
- **Why it matters:** `structuredClone` is relatively recent; browser
  and Node support should be confirmed.
- **Suggested source:** MDN `structuredClone` compat table.
- **Status:** unverified

---

- **Chapter:** `book/06-typescript.md`
- **Section:** Strict mode and tsconfig
- **Claim:** The exact flags included under `strict` and the behavior
  of `verbatimModuleSyntax` (e.g. whether it replaces
  `importsNotUsedAsValues`).
- **Why it matters:** The strict family composition changes across TS
  versions. Incorrect advice causes confusion when enabling strict.
- **Suggested source:** `https://www.typescriptlang.org/tsconfig`
- **Status:** unverified

---

- **Chapter:** `book/06-typescript.md`
- **Section:** Module resolution
- **Claim:** `bundler` module resolution mode added in TypeScript 5.0;
  behavior of `node16`/`nodenext` regarding `package.json` exports.
- **Why it matters:** Module resolution is the #1 source of TS
  configuration bugs. Incorrect guidance leads to broken imports.
- **Suggested source:** `https://www.typescriptlang.org/docs/handbook/modules/reference.html`
- **Status:** unverified

---

- **Chapter:** `book/06-typescript.md`
- **Section:** Scenario-based (decorators question)
- **Claim:** TC39 stage 3 decorators available in TypeScript 5.0+ with
  different API than legacy `experimentalDecorators`.
- **Why it matters:** Teams choosing decorator-based DI must know which
  version they target. The two APIs are incompatible.
- **Suggested source:** TypeScript 5.0 release notes
- **Status:** unverified

---

- **Chapter:** `book/06-typescript.md`
- **Section:** Mapped types (Theoretical Foundation)
- **Claim:** Key remapping added in TypeScript 4.1.
- **Why it matters:** If the version is wrong, readers may try using
  the feature in an earlier version and get confusing errors.
- **Suggested source:** TypeScript 4.1 release notes
- **Status:** unverified

---

- **Chapter:** `book/06-typescript.md`
- **Section:** The satisfies operator (Theoretical Foundation)
- **Claim:** `satisfies` added in TypeScript 4.9.
- **Why it matters:** Version-pinned advice; teams on older TS cannot
  use this feature.
- **Suggested source:** TypeScript 4.9 release notes
- **Status:** unverified

---

- **Chapter:** `book/06-typescript.md`
- **Section:** Interview Q&A — Tech Lead (Zod vs io-ts question)
- **Claim:** Zod bundle size ~13 KB; io-ts requires fp-ts ~30 KB.
- **Why it matters:** Bundle size is a decision factor; incorrect
  numbers mislead the comparison.
- **Suggested source:** Bundlephobia or official package metadata
- **Status:** unverified

---

- **Chapter:** `book/10-nodejs.md`
- **Section:** Event loop phases (Theoretical Foundation)
- **Claim:** Event loop phases are: timers → pending callbacks →
  idle/prepare → poll → check → close callbacks. `process.nextTick`
  runs before microtasks between every phase transition.
- **Why it matters:** The exact phase ordering and nextTick/microtask
  priority have been clarified across Node.js versions. Incorrect
  ordering confuses interview answers.
- **Suggested source:** `https://nodejs.org/en/learn/asynchronous-work/event-loop-timers-and-nexttick`
- **Status:** unverified

---

- **Chapter:** `book/10-nodejs.md`
- **Section:** ESM vs CommonJS (Theoretical Foundation)
- **Claim:** ESM requires `"type": "module"` in `package.json` or
  `.mjs` extension. CJS can `import()` ESM asynchronously but not
  synchronously.
- **Why it matters:** ESM interop rules change across Node versions.
  Incorrect advice causes module resolution failures.
- **Suggested source:** `https://nodejs.org/api/esm.html`
- **Status:** unverified

---

- **Chapter:** `book/10-nodejs.md`
- **Section:** Trick Questions (Express async handling)
- **Claim:** Express 5 adds native async route handler support.
  Express 4 does not propagate rejected Promises to error middleware.
- **Why it matters:** Express 5 has been in beta for years. Its
  release status and feature set should be verified.
- **Suggested source:** Express.js GitHub repository and changelog
- **Status:** unverified

---

- **Chapter:** `book/10-nodejs.md`
- **Section:** Process management
- **Claim:** Node.js terminates on unhandled promise rejections since
  v15 (default `--unhandled-rejections=throw`).
- **Why it matters:** Teams on older Node versions may have different
  default behavior. This is a version-sensitive claim.
- **Suggested source:** Node.js v15 release notes
- **Status:** unverified

---

- **Chapter:** `book/10-nodejs.md`
- **Section:** Database access: Prisma and TypeORM
- **Claim:** Prisma query engine binary adds ~200ms cold-start latency
  in Lambda, and the generated client is ~2MB.
- **Why it matters:** These are specific performance numbers that may
  vary across Prisma versions (especially with the Rust-based engine
  and Prisma Accelerate improvements).
- **Suggested source:** Prisma documentation (deployment/serverless),
  Prisma GitHub benchmarks
- **Status:** unverified

---

- **Chapter:** `book/10-nodejs.md`
- **Section:** REST, GraphQL, and WebSockets
- **Claim:** `graphql-depth-limit` and
  `graphql-validation-complexity` are current recommended libraries for
  GraphQL query cost analysis.
- **Why it matters:** GraphQL ecosystem libraries evolve quickly;
  alternatives like `graphql-query-complexity` or built-in Apollo
  features may have superseded these.
- **Suggested source:** Apollo Server documentation (2025+), npm
  package status
- **Status:** unverified

---

- **Chapter:** `book/10-nodejs.md`
- **Section:** Performance (Interview Q&A), Good Answer vs Weak Answer
- **Claim:** Fastify handles ~3x the throughput of Express for JSON
  response workloads; NestJS adds ~10–15% overhead on top of its
  underlying adapter.
- **Why it matters:** These are specific performance multipliers that
  depend on benchmark methodology, payload size, and framework version.
  Incorrect numbers undermine credibility in an interview.
- **Suggested source:** Fastify benchmarks repository
  (`fastify/benchmarks`), independent TechEmpower benchmarks
- **Status:** unverified

---

- **Chapter:** `book/02-sql-and-nosql.md`
- **Section:** Caching / TTL and expiration
- **Claim:** DynamoDB deletes expired items (TTL) within 48 hours of
  expiration, not immediately.
- **Why it matters:** If the deletion window has changed in recent
  DynamoDB updates, advice about not relying on TTL for time-critical
  expiration may be outdated.
- **Suggested source:** AWS DynamoDB documentation (TTL section)
- **Status:** unverified

---

- **Chapter:** `book/02-sql-and-nosql.md`
- **Section:** Transactions and ACID
- **Claim:** PostgreSQL Repeatable Read does not allow phantom reads
  (unlike the SQL standard which permits them at this level).
- **Why it matters:** This is a PostgreSQL-specific implementation
  detail (SSI). If incorrectly stated, it could confuse answers about
  standard SQL isolation levels vs PostgreSQL behavior.
- **Suggested source:** PostgreSQL documentation on Transaction
  Isolation
- **Status:** unverified

---

- **Chapter:** `book/02-sql-and-nosql.md`
- **Section:** The relational model / Migrations
- **Claim:** PostgreSQL 11+ allows ADD COLUMN with DEFAULT as an
  instant operation (no table rewrite).
- **Why it matters:** This is a version-specific optimization. Teams
  on older PostgreSQL versions would experience a full table rewrite.
- **Suggested source:** PostgreSQL 11 release notes
- **Status:** unverified

---

- **Chapter:** `book/02-sql-and-nosql.md`
- **Section:** Tech Lead Decision-Making / Operational cost
- **Claim:** RDS PostgreSQL db.r6g.xlarge costs ~$450/month. gp3
  storage at 500GB costs ~$50/month. Multi-AZ doubles instance cost.
- **Why it matters:** AWS pricing changes. These numbers are
  approximate order-of-magnitude estimates for illustration but could
  mislead if significantly outdated.
- **Suggested source:** AWS RDS pricing page (us-east-1, on-demand)
- **Status:** unverified

---

- **Chapter:** `book/02-sql-and-nosql.md`
- **Section:** Interview Q&A / Performance
- **Claim:** B-tree write amplification is ~2-10x; LSM-tree write
  amplification is ~10-30x.
- **Why it matters:** These ranges are commonly cited in database
  literature but vary by workload, compaction strategy, and page size.
  Incorrect ranges could weaken an interview answer.
- **Suggested source:** RocksDB wiki on write amplification; PostgreSQL
  documentation on WAL
- **Status:** unverified

---

- **Chapter:** `book/12-api-design.md`
- **Section:** Core Terminology / Error responses
- **Claim:** RFC 9457 is the current number for "Problem Details for
  HTTP APIs" (formerly RFC 7807).
- **Why it matters:** The RFC was renumbered in 2023. References to
  7807 are still common. Confirm 9457 is the current published number.
- **Suggested source:** IETF RFC index
- **Status:** unverified

---

- **Chapter:** `book/12-api-design.md`
- **Section:** Tech Lead Decision-Making / API cost management
- **Claim:** AWS API Gateway costs $3.50 per million requests.
- **Why it matters:** AWS pricing changes. This number is for REST API
  type in us-east-1 and may have changed.
- **Suggested source:** AWS API Gateway pricing page
- **Status:** unverified

---

- **Chapter:** `book/12-api-design.md`
- **Section:** Tech Lead Decision-Making / Cost implications
- **Claim:** AWS data transfer (egress) costs $0.09/GB.
- **Why it matters:** AWS egress pricing varies by region and volume
  tier (first 10TB/month is one rate, subsequent tiers are cheaper).
  The $0.09 figure is approximate.
- **Suggested source:** AWS EC2 data transfer pricing page
- **Status:** unverified

---

- **Chapter:** `book/12-api-design.md`
- **Section:** Tech Lead Decision-Making / Cost implications
- **Claim:** Brotli compression reduces payload size 60-70% compared
  to uncompressed.
- **Why it matters:** Compression ratios depend heavily on content
  type. JSON compresses well but the exact ratio is workload-specific.
  The claim is a rough order of magnitude.
- **Suggested source:** Google Brotli benchmarks, real-world API
  payload tests
- **Status:** unverified (treated as rough order of magnitude)

---

- **Chapter:** `book/15-security.md`
- **Section:** Theoretical Foundation / OWASP Top 10
- **Claim:** The OWASP Top 10 2021 edition is the current version with
  the categories listed (A01-A10).
- **Why it matters:** OWASP may release a new edition. The 2021 edition
  reorganized categories significantly from 2017.
- **Suggested source:** OWASP Top 10 official page
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** Theoretical Foundation / Password hashing
- **Claim:** Argon2id recommended parameters: 64MB memory, 3 iterations,
  4 parallelism.
- **Why it matters:** OWASP password storage cheat sheet and RFC 9106
  provide recommendations that may differ. Parameters depend on
  hardware and threat model.
- **Suggested source:** OWASP Password Storage Cheat Sheet, RFC 9106
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** Production Considerations / Cost
- **Claim:** AWS KMS costs $0.03 per 10K API calls.
- **Why it matters:** AWS pricing changes. This is the symmetric key
  API call pricing in us-east-1.
- **Suggested source:** AWS KMS pricing page
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** Theoretical Foundation / OAuth 2.0
- **Claim:** OAuth 2.1 deprecates the Implicit flow and the Password
  grant.
- **Why it matters:** OAuth 2.1 was in draft as of 2024. Check if it
  has reached RFC status.
- **Suggested source:** IETF OAuth 2.1 draft or RFC
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** Theoretical Foundation / CSP
- **Claim:** CSP deployment typically takes 2-4 sprints for a large
  application.
- **Why it matters:** This is an estimate based on industry experience.
  It may vary significantly depending on application size and
  third-party dependencies.
- **Suggested source:** Industry reports, GitHub CSP case studies
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** Theoretical Foundation / MFA
- **Claim:** Microsoft reports MFA blocks 99.9% of automated attacks.
- **Why it matters:** This statistic is frequently cited but may be
  from a specific 2019 blog post. Verify the source and whether more
  recent data exists.
- **Suggested source:** Microsoft Security Blog, Azure AD identity
  protection reports
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** Theoretical Foundation / Dependency scanning
- **Claim:** GitHub detected over 10 million secrets in public
  repositories in 2023.
- **Why it matters:** The exact number and year should be verified
  against GitHub's official Octoverse or security reports.
- **Suggested source:** GitHub Octoverse 2023, GitHub Secret Scanning
  blog posts
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** Theoretical Foundation / SSRF
- **Claim:** The Capital One breach (2019) exploited SSRF to access
  AWS instance metadata.
- **Why it matters:** While widely reported as SSRF, the exact attack
  vector involved a misconfigured WAF. Verify accuracy of the SSRF
  characterization.
- **Suggested source:** US DOJ indictment, Capital One breach
  post-mortem, Krebs on Security analysis
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** OWASP Top 10
- **Claim:** OWASP Top 10 2021 edition moved "Insecure Design" from
  unranked to A04 and "Software Integrity" to A08. These represent
  new categories in the 2021 edition.
- **Why it matters:** The exact changes from 2017→2021 should be
  verified against the official OWASP documentation to ensure accurate
  characterization.
- **Suggested source:** OWASP Top 10 2021 official release notes,
  comparison page
- **Status:** unverified

---

- **Chapter:** `book/15-security.md`
- **Section:** Incident Response
- **Claim:** GDPR requires data breach notification within 72 hours.
- **Why it matters:** GDPR Article 33 specifies 72 hours to notify
  the supervisory authority. Verify this is still current and check if
  other jurisdictions have different timelines.
- **Suggested source:** GDPR Article 33, ICO guidance on breach
  notification
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Theoretical Foundation — Kubernetes architecture
- **Claim:** Docker is no longer the default runtime since Kubernetes
  1.24 (dockershim removal).
- **Why it matters:** The exact version of dockershim removal should
  be confirmed. Kubernetes 1.24 removed dockershim (May 2022).
- **Suggested source:** Kubernetes changelog 1.24, KEP-2221
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Theoretical Foundation — Resource requests and limits
- **Claim:** CPU throttling uses CFS with 100ms quota periods.
- **Why it matters:** CFS bandwidth control documentation should
  confirm the default 100ms period. Some distributions may differ.
- **Suggested source:** Linux kernel CFS bandwidth control docs,
  Kubernetes CPU management policies documentation
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Production Considerations — Reliability
- **Claim:** Kubelet must be within 2 minor versions of API server
  (version skew policy).
- **Why it matters:** The version skew policy is n-2 for kubelet as
  of recent versions. Confirm this has not changed.
- **Suggested source:** kubernetes.io/docs/setup/release/
  version-skew-policy
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Interview Q&A — Tech Lead (cluster migration)
- **Claim:** Kubernetes does not support skipping minor versions
  during upgrade (must upgrade sequentially 1.26→1.27→1.28→...).
- **Why it matters:** This has been the stated policy but should be
  confirmed for current versions. Some managed services may allow
  larger jumps.
- **Suggested source:** kubernetes.io upgrade documentation, EKS/GKE
  upgrade documentation
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Trade-offs, Production Considerations
- **Claim:** Over-provisioning in Kubernetes clusters is typically
  40-60% (wasted capacity).
- **Why it matters:** Industry survey data (Datadog, CNCF) suggests
  this range but the exact figure varies by source and year.
- **Suggested source:** Datadog Container Report, CNCF surveys
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Docker security — Minimal base images
- **Claim:** Default Docker seccomp profile blocks ~44 dangerous
  syscalls.
- **Why it matters:** The exact number of blocked syscalls depends on
  the Docker version and may have changed in recent releases.
- **Suggested source:** Docker documentation on seccomp, moby/moby
  default seccomp profile in source code
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Docker security — Minimal base images
- **Claim:** Distroless images have ~5-15 CVEs vs ~100-300 for full
  node:20 images.
- **Why it matters:** These are rough magnitudes based on typical scan
  results. Actual counts vary by scan date and vulnerability database.
- **Suggested source:** Run Trivy against current images for actual
  counts; Google distroless documentation
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Resource requests and limits — Operational consideration
- **Claim:** CFS enforces CPU quotas in 100ms periods and
  `container_cpu_cfs_throttled_periods_total` is the metric to monitor.
- **Why it matters:** The CFS period is configurable in some
  environments (--cpu-cfs-quota-period flag) and the metric name
  should be verified against current Prometheus/cAdvisor documentation.
- **Suggested source:** Kubernetes CPU management docs, cAdvisor
  metrics documentation
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Services — Common mistake
- **Claim:** Each LoadBalancer Service costs $15-25/month (cloud LB
  provisioning).
- **Why it matters:** Cloud LB pricing varies by provider and region.
  AWS NLB and ALB have different pricing models. The range is
  approximate and should be noted as such.
- **Suggested source:** AWS ELB pricing page, GCP Load Balancing
  pricing page
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** HPA — Operational consideration
- **Claim:** HPA evaluates metrics every 15 seconds (default
  `--horizontal-pod-autoscaler-sync-period`).
- **Why it matters:** The default sync period may have changed in
  recent Kubernetes versions.
- **Suggested source:** Kubernetes HPA documentation, kube-controller-
  manager flags reference
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** kubectl troubleshooting — CrashLoopBackOff
- **Claim:** Kubernetes applies exponential backoff (10s, 20s, 40s...
  up to 5 minutes) between restart attempts for CrashLoopBackOff.
- **Why it matters:** The exact backoff sequence and maximum backoff
  duration should be verified against current Kubernetes source code.
- **Suggested source:** Kubernetes source code (kubelet restart
  backoff), Kubernetes documentation on container restart policy
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Persistent volumes — Operational consideration
- **Claim:** ConfigMap updates propagate to pods within the kubelet
  sync period (~60s).
- **Why it matters:** The kubelet sync period for ConfigMap/Secret
  volume updates depends on `configMapAndSecretChangeDetectionStrategy`
  and `syncFrequency` configuration.
- **Suggested source:** Kubernetes documentation on ConfigMap and
  Secret propagation delays
- **Status:** unverified

---

- **Chapter:** `book/03-docker-and-kubernetes.md`
- **Section:** Examples — Service and Ingress
- **Claim:** nginx ingress controller rate-limiting annotations use
  `nginx.ingress.kubernetes.io/rate-limit` and
  `nginx.ingress.kubernetes.io/rate-limit-window`.
- **Why it matters:** Annotation names are controller-specific and
  may differ between nginx-ingress versions (community vs F5). The
  rate limiting implementation and annotation syntax should be
  verified against the version in use.
- **Suggested source:** kubernetes/ingress-nginx annotations
  documentation (current version)
- **Status:** unverified

---

### `book/04-aws.md` — Active Items

- **Chapter:** `book/04-aws.md`
- **Section:** NAT Gateway
- **Claim:** NAT Gateway pricing is ~$0.045/hour and ~$0.045/GB
  processed.
- **Why it matters:** NAT Gateway cost is a significant hidden cost
  item. Incorrect pricing guidance undermines cost optimization
  advice.
- **Suggested source:** AWS VPC pricing page (per region)
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** ECS vs EKS
- **Claim:** EKS control plane costs ~$0.10/hour (~$73/month).
- **Why it matters:** EKS pricing is a key decision factor when
  comparing ECS vs EKS. Incorrect pricing changes the TCO analysis.
- **Suggested source:** AWS EKS pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Lambda
- **Claim:** Lambda concurrency account-level default is 1,000 per
  region. Maximum execution timeout is 15 minutes. Memory range is
  128 MB to 10,240 MB. Package size limits are 50 MB zipped, 250 MB
  unzipped, 10 GB for container images.
- **Why it matters:** Lambda limits change periodically. Incorrect
  limits could lead to wrong architectural decisions.
- **Suggested source:** AWS Lambda quotas documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Lambda cold starts
- **Claim:** Cold start ranges: Node.js/Python 100-300 ms, Java/.NET
  500 ms - 3 s, container images 1-5 s.
- **Why it matters:** Cold start latency varies by runtime, package
  size, VPC configuration, and AWS improvements over time. These
  ranges are rough order of magnitude.
- **Suggested source:** AWS Lambda performance documentation, AWS
  re:Invent talks on Lambda optimization
- **Status:** unverified (treated as rough order of magnitude)

---

- **Chapter:** `book/04-aws.md`
- **Section:** API Gateway
- **Claim:** HTTP API is up to 71% cheaper than REST API. API Gateway
  adds 10-30 ms latency.
- **Why it matters:** Cost comparison and latency claims drive service
  selection decisions.
- **Suggested source:** AWS API Gateway pricing page, AWS blog posts
  on HTTP API
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** SQS
- **Claim:** FIFO queue throughput is 300 msg/s (3,000 with batching).
- **Why it matters:** AWS has introduced high-throughput mode for FIFO
  queues that may increase these limits significantly.
- **Suggested source:** AWS SQS FIFO documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Aurora
- **Claim:** Aurora storage replicates 6 copies across 3 AZs, grows
  to 128 TB. Failover to replica in under 30 seconds. Up to 15 read
  replicas. Aurora Serverless v2 scales in half-ACU increments (1
  ACU = 2 GB RAM).
- **Why it matters:** Aurora storage and compute limits are key
  differentiators vs RDS. Incorrect claims undermine the comparison.
- **Suggested source:** AWS Aurora documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** RDS
- **Claim:** Multi-AZ cluster failover is ~35 seconds. Standard
  Multi-AZ failover is 60-120 seconds.
- **Why it matters:** Failover time is a key HA metric. AWS may have
  improved these times.
- **Suggested source:** AWS RDS Multi-AZ documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Secrets Manager vs Parameter Store
- **Claim:** Secrets Manager costs ~$0.40/secret/month. Parameter
  Store advanced tier costs $0.05/parameter/month.
- **Why it matters:** Pricing drives the choice between the two
  services for different use cases.
- **Suggested source:** AWS Secrets Manager and SSM Parameter Store
  pricing pages
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** CloudWatch
- **Claim:** Custom CloudWatch metrics cost ~$0.30/metric/month.
- **Why it matters:** Custom metric cost affects observability budget
  decisions.
- **Suggested source:** AWS CloudWatch pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** CloudFront
- **Claim:** First 1,000 invalidation paths/month are free; additional
  cost ~$0.005 per path.
- **Why it matters:** Invalidation pricing affects deployment strategy
  decisions.
- **Suggested source:** AWS CloudFront pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** S3
- **Claim:** S3 Block Public Access is enabled by default for new
  buckets since April 2023.
- **Why it matters:** Version-specific security default. If the date
  is wrong, security advice about legacy buckets may be incorrect.
- **Suggested source:** AWS S3 documentation, AWS blog announcement
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Trick Questions (Lambda vs EC2 cost)
- **Claim:** A Lambda function running constantly at 1 vCPU costs
  roughly $40-50/month. An EC2 t3.small with Savings Plan costs
  ~$10/month.
- **Why it matters:** These cost comparisons drive serverless vs
  container decisions. Pricing changes frequently.
- **Suggested source:** AWS Lambda pricing calculator, AWS EC2
  pricing page
- **Status:** unverified (treated as rough order of magnitude)

---

- **Chapter:** `book/04-aws.md`
- **Section:** Global infrastructure — regions, AZs, edge locations
- **Claim:** Cross-AZ data transfer costs $0.01/GB in each direction.
  Asia-Pacific regions can be 20-30% more expensive for some services.
- **Why it matters:** Cross-AZ transfer pricing affects architecture
  decisions (AZ-aware routing, service placement). Regional pricing
  differences affect region selection.
- **Suggested source:** AWS EC2 data transfer pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Subnets
- **Claim:** AWS reserves 5 IP addresses per subnet (network, VPC
  router, DNS, future use, broadcast). A /24 subnet provides 251
  usable IPs.
- **Why it matters:** Subnet sizing depends on accurate IP count.
  If the number of reserved IPs changed, subnet size recommendations
  would be wrong.
- **Suggested source:** AWS VPC documentation on subnet sizing
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Subnets — Cost implications
- **Claim:** VPC Interface endpoints cost ~$0.01/hour per AZ plus
  data processing charges. NAT Gateway costs ~$32/month per AZ for
  the hourly charge alone.
- **Why it matters:** These cost comparisons drive VPC endpoint
  adoption decisions.
- **Suggested source:** AWS PrivateLink pricing page, AWS NAT
  Gateway pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Security groups
- **Claim:** Default quota is 60 inbound and 60 outbound rules per
  security group. Maximum 5 security groups per network interface.
- **Why it matters:** Rule limits affect security group design
  decisions. These limits may have changed.
- **Suggested source:** AWS VPC quotas documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** NACLs
- **Claim:** Default NACL rule limit is 20 inbound and 20 outbound
  rules.
- **Why it matters:** Rule limits affect whether NACLs can handle
  complex filtering scenarios.
- **Suggested source:** AWS VPC quotas documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Load Balancers
- **Claim:** ALB hourly pricing is ~$0.0225/hr. NLB hourly pricing
  is ~$0.0225/hr. LCU pricing depends on new connections, active
  connections, processed bytes, and rule evaluations. TLS policy
  name `ELBSecurityPolicy-TLS13-1-2-2021-06`.
- **Why it matters:** Load balancer pricing and TLS policy names
  drive cost estimation and security configuration decisions.
- **Suggested source:** AWS ELB pricing page, AWS ELB security
  policy documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** ECS — Cost implications
- **Claim:** Fargate 0.25 vCPU / 0.5 GB task costs approximately
  $9/month. 1 vCPU / 2 GB task costs approximately $36/month.
  Fargate Spot offers up to 70% discount.
- **Why it matters:** Fargate pricing drives the Fargate vs EC2
  launch type decision and Lambda vs Fargate cost comparison.
- **Suggested source:** AWS Fargate pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Lambda — Cost implications
- **Claim:** Lambda pricing: $0.20 per 1M requests,
  ~$0.0000166667 per GB-second. Provisioned concurrency costs
  ~$0.0000041667 per GB-second.
- **Why it matters:** Lambda pricing drives serverless vs container
  cost comparisons and provisioned concurrency adoption decisions.
- **Suggested source:** AWS Lambda pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** API Gateway — Cost implications
- **Claim:** REST API costs ~$3.50 per million requests. HTTP API
  costs ~$1.00 per million requests. REST API latency ~29 ms,
  HTTP API latency ~10 ms.
- **Why it matters:** These cost and latency comparisons drive API
  Gateway type selection. Some of these were already noted but the
  specific per-million pricing should be verified.
- **Suggested source:** AWS API Gateway pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** S3 — Cost implications
- **Claim:** S3 Standard storage costs ~$0.023/GB/month. GET
  requests cost $0.0004 per 1,000. Data transfer out is $0.09/GB.
  Intelligent-Tiering monitoring fee is ~$0.0025 per 1,000
  objects/month.
- **Why it matters:** S3 pricing details drive storage class
  selection and cost optimization strategies.
- **Suggested source:** AWS S3 pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** CloudFront — Cost implications
- **Claim:** CloudFront data transfer $0.085/GB in North America.
  Origin Shield $0.0075-$0.009 per 10,000 requests. CloudFront
  Functions ~$0.10/million. Lambda@Edge ~$0.60/million + GB-second.
- **Why it matters:** CloudFront pricing drives CDN adoption and
  edge compute decisions.
- **Suggested source:** AWS CloudFront pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Route 53 — Cost implications
- **Claim:** Hosted zone costs $0.50/month. Standard queries cost
  $0.40 per million. Latency/geolocation/failover queries cost
  $0.60 per million. Health checks cost $0.50-$0.75/month. Alias
  queries to AWS resources are free.
- **Why it matters:** Route 53 pricing affects DNS management
  decisions and multi-region architecture cost estimation.
- **Suggested source:** AWS Route 53 pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** RDS — Cost implications
- **Claim:** gp3 storage costs $0.08/GB/month. RDS Proxy costs
  approximately $0.015/vCPU/hour. Reserved instances provide
  30-60% savings.
- **Why it matters:** RDS pricing components drive instance sizing
  and storage decisions.
- **Suggested source:** AWS RDS pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Aurora — Cost implications
- **Claim:** Aurora storage costs $0.10/GB/month, I/O charges
  $0.20 per million requests. Aurora I/O-Optimized storage costs
  ~$0.225/GB. Aurora instances cost 20-30% more than equivalent
  RDS instances.
- **Why it matters:** Aurora pricing details drive the RDS vs
  Aurora decision and I/O-Optimized adoption threshold.
- **Suggested source:** AWS Aurora pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** DynamoDB — Cost implications
- **Claim:** On-demand pricing: ~$1.25/million WCU, ~$0.25/million
  RCU. Provisioned pricing: ~$0.00065/WCU/hour, ~$0.00013/RCU/hour.
  Storage: $0.25/GB/month (Standard), $0.10/GB/month (IA).
- **Why it matters:** DynamoDB pricing drives capacity mode
  selection and table class decisions.
- **Suggested source:** AWS DynamoDB pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** ElastiCache — Cost implications
- **Claim:** cache.r6g.large (13 GB Redis) costs approximately
  $0.18/hour (~$130/month). Reserved nodes provide 30-55% savings.
- **Why it matters:** ElastiCache node pricing drives sizing and
  reservation decisions.
- **Suggested source:** AWS ElastiCache pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** SQS — Cost implications
- **Claim:** Standard queue pricing: ~$0.40/million requests.
  FIFO queue pricing: ~$0.50/million requests.
- **Why it matters:** SQS pricing per queue type drives Standard
  vs FIFO selection and batching optimization decisions.
- **Suggested source:** AWS SQS pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** EventBridge — Cost implications
- **Claim:** Custom events cost $1.00/million. Scheduler costs
  $1.00/million invocations (first 14M free). Pipes cost
  $0.40/million request units.
- **Why it matters:** EventBridge pricing drives adoption vs
  simpler alternatives (SNS, SQS).
- **Suggested source:** AWS EventBridge pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Step Functions — Cost implications
- **Claim:** Standard workflows cost ~$0.025 per 1,000 state
  transitions. Express workflows cost ~$1.00 per million
  requests + duration.
- **Why it matters:** Step Functions pricing drives Standard vs
  Express selection and cost estimation.
- **Suggested source:** AWS Step Functions pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** CloudWatch — Cost implications
- **Claim:** Custom metrics ~$0.30/month. Log ingestion ~$0.50/GB.
  Log storage ~$0.03/GB/month. Dashboards $3.00/month (first 3
  free). Alarms ~$0.10-$0.30/month. Logs Insights ~$0.005/GB.
- **Why it matters:** CloudWatch cost components drive
  observability budget planning.
- **Suggested source:** AWS CloudWatch pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** CloudTrail — Cost implications
- **Claim:** Data events cost ~$0.10 per 100K events. Insights
  events cost ~$0.35 per 100K events analyzed. CloudTrail Lake
  costs $2.50/GB scanned.
- **Why it matters:** CloudTrail data event pricing drives
  selective enablement decisions.
- **Suggested source:** AWS CloudTrail pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** X-Ray — Cost implications
- **Claim:** X-Ray costs ~$5.00 per million traces recorded,
  ~$0.50 per million traces retrieved. First 100K traces/month
  free.
- **Why it matters:** X-Ray pricing drives sampling rate decisions.
- **Suggested source:** AWS X-Ray pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** KMS — Cost implications
- **Claim:** CMKs cost $1.00/month per key. Symmetric API calls
  cost $0.03/10K requests. Asymmetric API calls cost $0.15/10K
  requests.
- **Why it matters:** KMS API call cost drives data key caching
  decisions for high-volume workloads.
- **Suggested source:** AWS KMS pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** WAF — Cost implications
- **Claim:** Web ACL costs $5.00/month. Rules cost $1.00/month
  each. Request inspection costs $0.60/million requests. Bot
  Control costs $10.00/month + $1.00/million requests.
- **Why it matters:** WAF pricing drives rule consolidation and
  deployment scope decisions.
- **Suggested source:** AWS WAF pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Cognito — Cost implications
- **Claim:** First 50K MAU free. Pricing: $0.0055/MAU (50K-100K).
  SAML/OIDC federation: $0.015/MAU. Advanced security: $0.050/MAU.
- **Why it matters:** Cognito pricing at scale can be significant
  for high-MAU consumer applications.
- **Suggested source:** AWS Cognito pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Bedrock — Cost implications
- **Claim:** Claude models cost approximately $0.003-$0.015 per
  1K input tokens and $0.015-$0.075 per 1K output tokens.
- **Why it matters:** Bedrock model pricing evolves rapidly as
  new models are added. Incorrect pricing invalidates cost
  projections.
- **Suggested source:** AWS Bedrock pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Parameter Store
- **Claim:** Parameter Store API throughput limit is 40 TPS
  (standard), 1,000 TPS (advanced).
- **Why it matters:** API throughput limits affect caching strategy
  and application startup behavior.
- **Suggested source:** AWS SSM Parameter Store quotas
  documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Serverless API architecture
- **Claim:** API Gateway HTTP API is up to 71% cheaper than REST
  API.
- **Why it matters:** Cost differential between API types drives
  the HTTP API recommendation for most use cases.
- **Suggested source:** AWS API Gateway pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Container-based platform architecture
- **Claim:** Fargate Spot provides up to 70% discount for
  fault-tolerant workloads.
- **Why it matters:** Spot discount percentage affects cost
  optimization recommendations for batch and worker workloads.
- **Suggested source:** AWS Fargate Spot pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Cost optimization — hidden costs
- **Claim:** NAT Gateway charges $0.045/GB processed. CloudWatch
  Logs ingestion costs $0.50/GB.
- **Why it matters:** These are the most commonly cited hidden
  cost figures and are used to justify VPC endpoints and log
  management strategies.
- **Suggested source:** AWS NAT Gateway pricing page, CloudWatch
  pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Cost optimization — commitment discounts
- **Claim:** Compute Savings Plans provide 20-30% savings (1-year
  no-upfront) and 50-60% savings (3-year all-upfront).
- **Why it matters:** Savings Plan discount ranges are used to
  justify commitment recommendations. Actual percentages vary by
  instance family and region.
- **Suggested source:** AWS Savings Plans pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Backup and restore
- **Claim:** DynamoDB PITR costs approximately $0.20 per GB-month.
- **Why it matters:** PITR pricing affects the recommendation for
  enabling it on all DynamoDB tables.
- **Suggested source:** AWS DynamoDB pricing page (backup section)
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Event-driven backend architecture
- **Claim:** EventBridge charges ~$1.00 per million custom events.
  SQS charges ~$0.40 per million standard requests.
- **Why it matters:** Event volume pricing drives the cost
  comparison between EventBridge and SQS for high-throughput
  event architectures.
- **Suggested source:** AWS EventBridge and SQS pricing pages
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Interview Q&A — Performance (cross-AZ transfer)
- **Claim:** Cross-AZ data transfer costs $0.01/GB each way
  (source and destination).
- **Why it matters:** Cross-AZ pricing is a commonly cited hidden
  cost and the basis for optimization recommendations in
  performance Q&A.
- **Suggested source:** AWS EC2 data transfer pricing page
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Examples — CloudFront and S3 static hosting with CDK
- **Claim:** CDK API `S3BucketOrigin.withOriginAccessControl` is
  the current method for creating OAC-based S3 origins.
- **Why it matters:** CDK construct APIs evolve across versions.
  The specific method name and import path may change in newer CDK
  releases.
- **Suggested source:** AWS CDK API reference for
  `aws-cdk-lib/aws-cloudfront-origins`
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Examples — Secrets Manager retrieval with caching
- **Claim:** Secrets Manager API throttle limit is 10,000 requests
  per second.
- **Why it matters:** Throttle limits affect caching strategy
  decisions. If the limit is lower or higher, caching
  recommendations change.
- **Suggested source:** AWS Secrets Manager service quotas
  documentation
- **Status:** unverified

---

- **Chapter:** `book/04-aws.md`
- **Section:** Examples — Cost investigation checklist
- **Claim:** NAT Gateway data processing costs $0.045/GB.
  Internet egress costs $0.09/GB. CloudFront costs $0.085/GB.
  Cross-AZ transfer costs $0.01/GB each way. Cross-region transfer
  costs $0.02/GB.
- **Why it matters:** Specific per-GB pricing drives cost
  optimization recommendations. These figures are used in the
  cost investigation checklist as decision thresholds.
- **Suggested source:** AWS data transfer pricing page, NAT
  Gateway pricing, CloudFront pricing
- **Status:** unverified

---

- **Chapter:** `book/17-ci-cd-and-devops.md`
- **Section:** Theoretical Foundation — DORA metrics
- **Claim:** DORA metric thresholds for elite/high/medium/low
  performance (deployment frequency, lead time, change failure
  rate, MTTR). Specific thresholds: elite < 1 hour lead time,
  0-15% change failure rate, < 1 hour MTTR.
- **Why it matters:** DORA thresholds are updated periodically
  in the State of DevOps Report. Citing outdated thresholds
  could mislead interview preparation.
- **Suggested source:** Latest DORA State of DevOps Report
  (dora.dev)
- **Status:** unverified

---

- **Chapter:** `book/17-ci-cd-and-devops.md`
- **Section:** Examples — Canary deployment with automated rollback
- **Claim:** Argo Rollouts CRD syntax for canary deployment with
  Prometheus-based analysis (apiVersion, spec.strategy.canary,
  canaryMetrics with Prometheus provider).
- **Why it matters:** Argo Rollouts CRD API may change across
  versions. Incorrect CRD syntax would be misleading.
- **Suggested source:** Argo Rollouts documentation
  (argoproj.github.io/argo-rollouts)
- **Status:** unverified

---

- **Chapter:** `book/17-ci-cd-and-devops.md`
- **Section:** Examples — OIDC-based cloud credentials in GitHub
  Actions
- **Claim:** GitHub Actions OIDC configuration uses `id-token: write`
  permission and `aws-actions/configure-aws-credentials@v4` with
  `role-to-assume` parameter for OIDC-based AWS credential
  acquisition.
- **Why it matters:** GitHub Actions OIDC setup and the
  `aws-actions/configure-aws-credentials` action version and
  parameter names may change. Incorrect syntax would prevent the
  pipeline from authenticating.
- **Suggested source:** GitHub Actions OIDC documentation, AWS
  `configure-aws-credentials` action repository
- **Status:** unverified

---

- **Chapter:** `book/17-ci-cd-and-devops.md`
- **Section:** Tech Lead Decision-Making — Cost-aware pipeline
  decisions
- **Claim:** GitHub-hosted runners cost ~$0.008/minute for Linux.
  Cost estimation example: 22,000 minutes/month = ~$176/month.
- **Why it matters:** GitHub Actions pricing changes periodically.
  Incorrect per-minute pricing would undermine cost estimation
  credibility.
- **Suggested source:** GitHub Actions billing documentation
  (docs.github.com/en/billing/managing-billing-for-github-actions)
- **Status:** unverified

---

### 53. OpenTelemetry SDK stability status

- **Chapter:** 18-observability
- **Section:** Theoretical Foundation > OpenTelemetry; Examples >
  OpenTelemetry instrumentation in Node.js
- **Claim:** OTel tracing API is GA for most languages; metrics and
  logs GA status varies. The `@opentelemetry/sdk-node` and
  `@opentelemetry/auto-instrumentations-node` APIs are used as shown.
- **Why it matters:** OTel SDK surface area has changed across
  versions. Package names, imports, and configuration APIs may differ
  from the examples shown.
- **Suggested source:** OpenTelemetry documentation
  (opentelemetry.io/docs/) and npm package changelogs.
- **Status:** unverified

---

### 54. CloudWatch pricing tiers

- **Chapter:** 18-observability
- **Section:** Theoretical Foundation > Observability tooling
- **Claim:** CloudWatch has pay-per-use pricing and can become
  expensive at high metric/log volume.
- **Why it matters:** AWS pricing changes periodically. Specific
  costs for custom metrics, log ingestion per GB, and dashboard
  charges affect cost comparison accuracy.
- **Suggested source:** AWS CloudWatch pricing page
  (aws.amazon.com/cloudwatch/pricing/)
- **Status:** unverified

---

### 55. DORA metric thresholds (Observability chapter reference)

- **Chapter:** 18-observability
- **Section:** Interview Questions and Answers > Basic (DORA metrics
  question)
- **Claim:** References DORA metrics as a standard framework for
  measuring delivery performance.
- **Why it matters:** DORA metric thresholds are updated in the
  annual State of DevOps Report. Elite/High/Medium/Low thresholds
  may shift.
- **Suggested source:** Latest State of DevOps Report
  (dora.dev)
- **Status:** unverified

### 56. prom-client API (Observability chapter examples)

- **Chapter:** 18-observability
- **Section:** Examples > Custom application metrics in Prometheus
- **Claim:** Uses `Registry`, `Histogram`, `Counter`, `Gauge`
  constructors with `labelNames`, `buckets`, and `registers` options.
- **Why it matters:** The `prom-client` npm package API has changed
  across major versions (v14 → v15). Constructor options, label
  handling, and registry behavior may differ.
- **Suggested source:** prom-client npm package README and CHANGELOG
  (https://github.com/siimon/prom-client)
- **Status:** unverified

### 57. CloudWatch alarm CloudFormation syntax (Observability chapter)

- **Chapter:** 18-observability
- **Section:** Examples > CloudWatch metric alarm
- **Claim:** Uses `TreatMissingData: breaching` and other
  `AWS::CloudWatch::Alarm` properties in CloudFormation.
- **Why it matters:** CloudFormation resource properties and allowed
  values may change. `TreatMissingData` valid values and default
  behavior should be confirmed.
- **Suggested source:** AWS CloudFormation User Guide —
  AWS::CloudWatch::Alarm resource reference
- **Status:** unverified

### 58. Datadog / New Relic per-host pricing (Observability chapter)

- **Chapter:** 18-observability
- **Section:** Trade-offs table (vendor-managed row)
- **Claim:** Vendor-managed observability platforms cost roughly
  $15-30/host/month plus per-metric and per-GB log ingestion costs.
- **Why it matters:** Vendor pricing changes. Datadog and New Relic
  have different pricing models (per-host, per-container, per-GiB).
  Incorrect pricing undermines the self-hosted vs vendor cost
  comparison.
- **Suggested source:** Datadog pricing page, New Relic pricing page
- **Status:** unverified

### 59. Core Web Vitals thresholds and INP metric (Performance chapter)

- **Chapter:** 19-performance-and-scalability
- **Section:** Theoretical Foundation — Frontend performance
- **Claim:** LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1. INP replaced FID
  as of March 2024.
- **Why it matters:** Google updates Core Web Vitals thresholds and
  metric definitions. INP replaced FID in March 2024, but thresholds
  and scoring may evolve.
- **Suggested source:** web.dev Core Web Vitals documentation
- **Status:** unverified

### 60. PostgreSQL default max_connections (Performance chapter)

- **Chapter:** 19-performance-and-scalability
- **Section:** Theoretical Foundation — Connection pooling
- **Claim:** PostgreSQL defaults to 100 max connections.
- **Why it matters:** Default may vary by distribution, hosting
  provider, or major version. AWS RDS PostgreSQL uses a formula
  based on instance memory, not the upstream default.
- **Suggested source:** PostgreSQL documentation (current stable),
  AWS RDS PostgreSQL parameter group defaults
- **Status:** unverified

### 61. BullMQ API and options (Performance chapter)

- **Chapter:** 19-performance-and-scalability
- **Section:** Examples — Back-pressure with a bounded queue
- **Claim:** BullMQ Queue constructor accepts `connection` and
  `defaultJobOptions` with `attempts`, `backoff`, `removeOnComplete`,
  `removeOnFail`. Queue `.count()` returns pending job count.
- **Why it matters:** BullMQ API may change between major versions.
  Constructor options and method signatures should be confirmed.
- **Suggested source:** BullMQ npm package documentation (current
  stable version)
- **Status:** unverified

### 62. @tanstack/react-virtual API (Performance chapter)

- **Chapter:** 19-performance-and-scalability
- **Section:** Theoretical Foundation — Virtualization example
- **Claim:** `useVirtualizer` accepts `count`, `getScrollElement`,
  `estimateSize`, `overscan`. Returns `getVirtualItems()` and
  `getTotalSize()`.
- **Why it matters:** TanStack Virtual has undergone major API
  changes between versions. Hook names and options may differ.
- **Suggested source:** @tanstack/react-virtual npm package
  documentation (current stable version)
- **Status:** unverified

### 63. ioredis constructor and set with EX (Performance chapter)

- **Chapter:** 19-performance-and-scalability
- **Section:** Theoretical Foundation — Redis cache-aside example
- **Claim:** `new Redis({ host, port })` constructor and
  `redis.set(key, value, "EX", ttl)` for TTL-based caching.
- **Why it matters:** ioredis API is stable but constructor options
  and command syntax should be confirmed against current docs.
- **Suggested source:** ioredis npm package documentation
- **Status:** unverified

### 64. pg Pool constructor options (Performance chapter)

- **Chapter:** 19-performance-and-scalability
- **Section:** Theoretical Foundation — Connection pooling example
- **Claim:** `pg.Pool` accepts `max`, `min`, `idleTimeoutMillis`,
  `connectionTimeoutMillis`, `statement_timeout`, `ssl`.
- **Why it matters:** Pool configuration options may change between
  `pg` major versions. `statement_timeout` as a Pool option
  (vs per-query) should be confirmed.
- **Suggested source:** node-postgres (pg) documentation
- **Status:** unverified

### 65. k6 load testing API (Performance chapter)

- **Chapter:** 19-performance-and-scalability
- **Section:** Theoretical Foundation — Load testing example
- **Claim:** k6 `options.stages` with `duration`/`target`, 
  `thresholds` with `http_req_duration` percentile syntax (e.g.,
  `"p(95)<300"`), `check()` API.
- **Why it matters:** k6 API and threshold syntax may evolve between
  versions. The percentile threshold format should be confirmed.
- **Suggested source:** k6 documentation (grafana.com/docs/k6)
- **Status:** unverified

---

### #66. React Server Components model and "use client" directive (React chapter)

- **Chapter:** 08-react
- **Section:** Theoretical Foundation — Server Components
- **Claim:** Server Components run on the server with zero client JS,
  cannot use hooks or event handlers. Client Components are declared
  with `"use client"` at the top of the file. Server Components can
  interleave with Client Components.
- **Why it matters:** The RSC model is evolving. The `"use client"`
  directive, interleaving rules, and framework-specific behavior (Next.js
  App Router) may change between React and Next.js versions.
- **Suggested source:** react.dev Server Components documentation,
  Next.js App Router documentation
- **Status:** unverified

---

### #67. Suspense data fetching and `use` hook (React chapter)

- **Chapter:** 08-react
- **Section:** Theoretical Foundation — Suspense
- **Claim:** Suspense integrates with data fetching via libraries
  that support it (TanStack Query, Relay). The `use` hook is
  mentioned as an evolving API.
- **Why it matters:** Suspense for data fetching is still evolving.
  The `use` hook API surface, constraints, and integration patterns
  may change between React versions.
- **Suggested source:** react.dev Suspense documentation, React
  release notes
- **Status:** unverified

---

### #68. TanStack Query v5 API (React chapter)

- **Chapter:** 08-react
- **Section:** Theoretical Foundation — State management (TanStack Query)
- **Claim:** `useQuery({ queryKey, queryFn, staleTime })` API shape.
  TanStack Query provides caching, deduplication, background
  revalidation, and retry with exponential backoff.
- **Why it matters:** TanStack Query v5 changed the API shape
  (object-only argument). Future versions may change defaults
  or add new options.
- **Suggested source:** TanStack Query documentation
  (tanstack.com/query)
- **Status:** unverified

---

### #69. Redux Toolkit and Zustand bundle sizes (React chapter)

- **Chapter:** 08-react
- **Section:** Theoretical Foundation — State management comparison
- **Claim:** Redux Toolkit is ~11 KB gzipped, Zustand is ~1 KB
  gzipped.
- **Why it matters:** Bundle sizes change with major versions and
  dependency tree changes. These numbers should be verified against
  current npm package data.
- **Suggested source:** bundlephobia.com for @reduxjs/toolkit and
  zustand
- **Status:** unverified

---

### #70. React 18 automatic batching behavior (React chapter)

- **Chapter:** 08-react
- **Section:** Interview Q&A — Basic — "What happens when you call
  setState?"
- **Claim:** React 18+ batches `setState` calls automatically in
  all contexts (event handlers, promises, timeouts), unlike React 17
  which only batched in event handlers.
- **Why it matters:** Batching behavior is version-specific. React 17
  and 18 differ. Future versions may refine this further.
- **Suggested source:** react.dev React 18 changelog, "Automatic
  Batching" blog post
- **Status:** unverified

---

### #71. MSW v2 API changes (React chapter)

- **Chapter:** 08-react
- **Section:** Interview Q&A — Testing and Quality — MSW question
- **Claim:** `msw` v2 changed from `rest.get` / `res(ctx.json())`
  to `http.get` / `HttpResponse.json()` API.
- **Why it matters:** The `msw` API changed significantly between
  v1 and v2. Code examples and setup patterns differ. Teams
  migrating from v1 to v2 need to update all handlers.
- **Suggested source:** mswjs.io migration guide (v1 → v2)
- **Status:** unverified

---

### #72. React Hook Form v7 + @hookform/resolvers Zod integration (React chapter)

- **Chapter:** 08-react
- **Section:** Theoretical Foundation — Form with validation
- **Claim:** `useForm<FormValues>({ resolver: zodResolver(schema) })`
  API shape. `register()` returns props to spread on inputs.
  `handleSubmit` wraps the onSubmit handler. `formState.errors`
  contains field-level error messages.
- **Why it matters:** React Hook Form's API changed between v6 and
  v7 (register API, resolver configuration). The `@hookform/resolvers`
  package must match the React Hook Form major version.
- **Suggested source:** react-hook-form.com documentation, 
  @hookform/resolvers README
- **Status:** unverified

---

### #73. TanStack Query defaultOptions shape (React chapter)

- **Chapter:** 08-react
- **Section:** Examples — App providers
- **Claim:** `QueryClient` constructor accepts `defaultOptions` with
  `queries.staleTime`, `queries.gcTime`, `queries.retry`, and
  `queries.refetchOnWindowFocus`.
- **Why it matters:** TanStack Query v5 renamed `cacheTime` to
  `gcTime`. The `defaultOptions` shape may evolve between versions.
- **Suggested source:** TanStack Query documentation
  (tanstack.com/query)
- **Status:** unverified

---

### #74. Angular standalone component migration schematic (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Theoretical Foundation — Modules and standalone components
- **Claim:** The Angular CLI provides a migration schematic
  `ng generate @angular/core:standalone` that converts NgModules to
  standalone components.
- **Why it matters:** The schematic name, options, and behavior may
  change between Angular versions.
- **Suggested source:** angular.dev standalone migration guide
- **Status:** unverified

---

### #75. Angular Signal APIs (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Theoretical Foundation — Signals; Examples
- **Claim:** `signal()`, `computed()`, `effect()`, `input()`,
  `input.required()`, `model()` are the signal APIs. Signal-based
  inputs replace `@Input()`.
- **Why it matters:** Signal APIs have evolved rapidly across Angular
  16-19. Some were developer preview in earlier versions and may
  have changed.
- **Suggested source:** angular.dev signals guide
- **Status:** unverified

---

### #76. Angular built-in control flow syntax (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Theoretical Foundation — Components, templates
- **Claim:** `@if`, `@for` (with required `track`), `@switch`,
  `@defer`, `@empty`, `@else` are built-in control flow blocks
  introduced in Angular 17.
- **Why it matters:** This syntax was new in Angular 17. Confirm
  exact block names, behavior, and whether they are stable.
- **Suggested source:** angular.dev built-in control flow documentation
- **Status:** unverified

---

### #77. takeUntilDestroyed API (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Theoretical Foundation — RxJS subscription management
- **Claim:** `takeUntilDestroyed()` automatically completes an
  Observable when the component is destroyed. Requires `DestroyRef`.
  Must be called in an injection context.
- **Why it matters:** This API was introduced in Angular 16 and the
  import path / constraints may have changed.
- **Suggested source:** angular.dev API reference for
  `takeUntilDestroyed`
- **Status:** unverified

---

### #78. Functional interceptors and guards API (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Theoretical Foundation — Routing, Interceptors
- **Claim:** `HttpInterceptorFn`, `withInterceptors()`,
  `CanActivateFn`, `CanDeactivateFn`, `CanMatchFn` are the
  functional alternatives to class-based guards and interceptors.
- **Why it matters:** These functional APIs are the modern
  recommended pattern. Verify exact type names and registration
  methods.
- **Suggested source:** angular.dev HTTP guide and routing guide
- **Status:** unverified

---

### #79. Zoneless change detection (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Theoretical Foundation — Change detection
- **Claim:** Zoneless change detection (experimental) removes
  Zone.js entirely, triggering change detection only via signals
  and explicit calls.
- **Why it matters:** Zoneless was experimental in Angular 17-18.
  It may have become stable or changed behavior in later versions.
- **Suggested source:** angular.dev zoneless guide / changelog
- **Status:** unverified

---

### #80. withXsrfConfiguration API (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Interview Q&A — Security
- **Claim:** `provideHttpClient(withXsrfConfiguration({ cookieName,
  headerName }))` configures XSRF/CSRF token handling. Default
  cookie name is `XSRF-TOKEN`, default header is `X-XSRF-TOKEN`.
- **Why it matters:** The functional HTTP client configuration API
  replaced the class-based `HttpClientXsrfModule`. Verify the
  function name and default values.
- **Suggested source:** angular.dev HttpClient XSRF documentation
- **Status:** unverified

---

### #81. ngCspNonce attribute (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Interview Q&A — Security
- **Claim:** Angular supports `ngCspNonce` attribute for
  nonce-based Content Security Policy, avoiding `unsafe-inline`
  for component styles.
- **Why it matters:** CSP nonce support was added in Angular 16+.
  Verify attribute name and usage pattern.
- **Suggested source:** angular.dev security guide, CSP section
- **Status:** unverified

---

### #82. provideHttpClientTesting API (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Interview Q&A — Testing and Quality
- **Claim:** `provideHttpClientTesting()` is the modern replacement
  for `HttpClientTestingModule` for testing HTTP interceptors and
  services.
- **Why it matters:** The functional testing API is the modern
  approach for standalone-based testing. Verify the function name
  and import path.
- **Suggested source:** angular.dev testing HTTP guide
- **Status:** unverified

---

### #83. Angular output() function API (Angular chapter)

- **Chapter:** 07-angular
- **Section:** Examples — Component with input, output, and computed
  signals
- **Claim:** `output<T>()` is the signal-based replacement for
  `@Output() EventEmitter`. Used as `cancel = output<string>()` and
  emitted with `cancel.emit(value)`.
- **Why it matters:** The `output()` function was introduced
  alongside signal-based inputs. Verify the exact API, import path,
  and whether it is stable or developer preview.
- **Suggested source:** angular.dev component interaction guide
- **Status:** unverified
