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

> No active items yet. As specific claims are written into chapters,
> append rows here in the `Format` shape.
