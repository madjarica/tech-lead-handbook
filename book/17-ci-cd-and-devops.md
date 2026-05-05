# CI/CD and DevOps

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can design a CI/CD pipeline with
quality gates and reliable deployments, choose between deployment
strategies (blue/green, canary, rolling, feature flags), and apply
infrastructure as code with discipline.

## Why This Matters for a Tech Lead

A Tech Lead is judged by delivery throughput and release confidence.
Both are downstream of the pipeline. This chapter is where most
"velocity" arguments are won or lost.

## Mental Model

> TODO: CI/CD as "a contract that lets you ship without ceremony".
> The faster and more honest the pipeline, the safer it is to ship.
> Add a Mermaid diagram of a typical pipeline with quality gates.

## Core Terminology

> TODO: CI, CD (delivery vs deployment), build artifact, immutable
> infrastructure, IaC, GitOps, pull-based deployment, blue/green,
> canary, rolling, feature flag, change failure rate, lead time.

## Theoretical Foundation

> TODO: Cover:
>
> - CI vs Continuous Delivery vs Continuous Deployment.
> - Pipeline design: stages, parallelism, caching, fan-in.
> - Build reproducibility and hermetic builds.
> - Artifact management and versioning.
> - Deployment strategies:
>   - Rolling.
>   - Blue/green.
>   - Canary.
>   - Feature flags / dark launches.
> - Infrastructure as Code: Terraform, CloudFormation, Pulumi.
> - GitOps and pull-based deployment (Argo CD, Flux).
> - Secrets in pipelines: short-lived OIDC creds vs long-lived
>   tokens.
> - DORA metrics: deploy frequency, lead time for changes, change
>   failure rate, MTTR.
> - Release management: change advisory, on-call coordination,
>   freezes.

## Practical Usage

> TODO:
>
> - A standard pipeline shape: build -> test -> security scan ->
>   deploy to staging -> smoke -> deploy to prod (canary -> full).
> - Trade-offs of monorepo CI vs polyrepo CI.

## Examples

> TODO:
>
> - A minimal CI workflow (GitHub Actions or GitLab CI).
> - A Terraform module sketch with state, backend, and modules.
> - A canary configuration with metrics-based rollback.
> - A feature flag flow for a risky migration.

## Common Mistakes

## Common Mistakes

> TODO:
>
> 1. Long-lived secrets in pipelines.
> 2. Pipelines that pass without actually running tests.
> 3. Manual deploy steps not in code.
> 4. Big-bang deploys without canary or flags.
> 5. IaC drift between code and reality.

## Trade-offs

> TODO: Push vs pull deploy (CI agents vs GitOps); canary vs feature
> flag; monorepo CI vs polyrepo CI.

## Production Considerations

> TODO:
>
> - Pipeline cost and runtime.
> - Reliability of the pipeline itself.
> - Rollback strategy for both code and infrastructure.
> - Auditability and compliance.

## How to Explain This in an Interview

> TODO: 60-second answer to "Walk me through your CD pipeline".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Canary vs blue/green".

## Tech Lead Checklist

- [ ] DORA metrics are tracked and reviewed.
- [ ] Secrets are short-lived (OIDC) and audited.
- [ ] All deploys are reproducible from a tagged artifact.
- [ ] Rollback is one click or one command.
- [ ] IaC is the source of truth for infrastructure.

## Interview Questions and Answers

### Basic

> TODO: "What is the difference between Continuous Delivery and
> Continuous Deployment?"

### Senior

> TODO: "How do you design a pipeline for a 20-service monorepo?"

### Tech Lead

> TODO: "How do you reduce change failure rate without slowing
> delivery?"

### Scenario-based

> TODO: "A bad migration is rolling out — how do you stop it safely?"

### Trick Questions

> TODO: "Is faster deploy frequency always better?"

### Red Flags

> TODO: Candidates who do not separate build artifacts from environments.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Accelerate" (Forsgren et al.); GitHub Actions / GitLab CI
> docs; Terraform documentation.

---

### Generation Notes

- Cross-link to chapter 03 (Docker/K8s), chapter 16 (Testing), and
  chapter 18 (Observability).
- Avoid pinning specific CI vendor versions. Concepts first.
