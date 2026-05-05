# Security

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can run a basic threat model, choose
between common authentication patterns, recognize OWASP Top 10
categories in code review, and reason about secrets management,
network security, and supply chain risk.

## Why This Matters for a Tech Lead

A Tech Lead is one of the few roles that can prevent expensive
security mistakes early. Most production breaches are caused by a
small number of repeating patterns. Recognizing them in design
review is a Tech Lead's job.

## Mental Model

> TODO: Security as "reducing the attacker's options at each layer".
> Trust is earned, not granted. Add a Mermaid diagram of layered
> defenses (network -> identity -> application -> data).

## Core Terminology

> TODO: Authentication vs authorization, OAuth 2.0, OIDC, SAML, JWT,
> session, CSRF, XSS, SQLi, SSRF, RCE, CSP, mTLS, KMS, HSM,
> SBOM, threat model, STRIDE, blast radius.

## Theoretical Foundation

> TODO: Cover:
>
> - Threat modeling: STRIDE, attacker mindset, abuse cases.
> - AuthN vs AuthZ.
> - OAuth 2.0 (authorization code with PKCE), OIDC, SAML at concept
>   level.
> - Session-based vs token-based auth; JWT pros and pitfalls;
>   refresh tokens; logout.
> - OWASP Top 10 categories with realistic code-review examples:
>   - Broken access control.
>   - Injection (SQL, command, LDAP).
>   - XSS, CSRF, SSRF.
>   - Insecure deserialization.
>   - Security misconfiguration.
>   - Software and data integrity.
>   - SSRF.
>   - Logging and monitoring failures.
> - Cryptography fundamentals: symmetric vs asymmetric, hashing
>   (with salt and slow KDFs), MAC, signatures, key rotation.
> - Secrets management: vaults, KMS, env vars, sealed secrets.
> - Network security: TLS, mTLS, VPCs, security groups, zero trust.
> - Supply chain: dependencies, SBOM, signing, provenance, typosquatting.
> - Incident response: detection, containment, eradication, recovery,
>   post-mortem.

## Practical Usage

> TODO: Where these concepts surface in real applications and reviews.

## Examples

> TODO:
>
> - JWT validation snippet (with `aud`, `iss`, `exp`, `nbf` checks).
> - A CSP header for a typical web app.
> - A short threat model for a "share via link" feature.
> - An IAM policy that demonstrates least privilege.

## Common Mistakes

> TODO:
>
> 1. Storing secrets in environment variables on shared CI runners.
> 2. JWTs without an `aud`/`iss` check.
> 3. Long-lived access tokens.
> 4. Skipping CSRF protection on state-changing endpoints behind cookies.
> 5. Using `Math.random()` for security-sensitive values.
> 6. Allowing `*` CORS on authenticated endpoints.

## Trade-offs

> TODO: Sessions vs JWTs; centralized auth service vs per-app auth;
> mTLS vs token-based service-to-service.

## Production Considerations

> TODO:
>
> - Key rotation and certificate renewal automation.
> - Secret rotation policy.
> - Vulnerability scanning in CI and at runtime.
> - Log retention vs PII concerns.
> - Incident playbooks and on-call.

## How to Explain This in an Interview

> TODO: A 60-second answer to "Walk me through OAuth 2.0 authorization
> code with PKCE".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Sessions vs JWTs".

## Tech Lead Checklist

- [ ] Threat model exists for every customer-facing service.
- [ ] Secrets are in a vault, not in repos or env files.
- [ ] Dependencies are scanned, with an SLA for severity.
- [ ] Logging excludes secrets and PII by policy.
- [ ] Incident playbook is tested in a game day.

## Interview Questions and Answers

### Basic

> TODO: "What is the difference between authentication and authorization?"

### Senior

> TODO: "What are the trade-offs of JWTs vs server-side sessions?"

### Tech Lead

> TODO: "How do you embed security into the SDLC for your team?"

### Scenario-based

> TODO: "An engineer accidentally commits an AWS access key to a
> public repo — what is your response in the next 60 minutes?"

### Trick Questions

> TODO: "Is HTTPS enough for security?"

### Red Flags

> TODO: Candidates who treat security as the security team's job.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: OWASP Top 10; OAuth 2.0 / OIDC specs; "The Tangled Web";
> SRE security chapters.

---

### Generation Notes

- Cross-link to chapter 12 (API Design), chapter 17 (CI/CD), and
  chapter 18 (Observability).
- Avoid cryptography minutiae the audience doesn't need at Tech Lead
  level. Stay at the design and review level.
