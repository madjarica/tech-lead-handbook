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
