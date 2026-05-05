# Testing and Quality

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can choose the right test type for a
problem, design test doubles correctly, debug flaky tests, and use
quality gates that improve delivery speed instead of slowing it down.

## Why This Matters for a Tech Lead

Testing strategy directly affects throughput, on-call burden, and
release confidence. A Tech Lead must own the testing pyramid (or
shape) used by the team.

## Mental Model

> TODO: Tests as "executable specifications". Different shapes (unit,
> integration, E2E) trade speed for fidelity. Add a diagram of the
> testing pyramid plus an alternative trophy/honeycomb shape.

## Core Terminology

> TODO: Stub, mock, fake, spy, dummy; unit test, integration test,
> contract test, E2E test, smoke test, property-based test, fuzz test,
> snapshot test, flaky test, hermetic test.

## Theoretical Foundation

> TODO: Cover:
>
> - The classical testing pyramid and its critics (testing trophy,
>   honeycomb).
> - Test types and their goals:
>   - Unit: a small unit of behavior in isolation.
>   - Integration: real collaborators (DB, queue) at boundary.
>   - Contract: producer-consumer compatibility.
>   - End-to-end: real flow through deployed systems.
>   - Smoke: minimal post-deploy sanity.
>   - Performance and load.
>   - Chaos and resilience.
>   - Property-based and fuzz testing.
> - Test doubles: stubs, mocks, fakes, spies; when each is correct.
> - Mocking the things you own vs mocking external systems.
> - Code coverage: useful and misleading uses.
> - Flaky tests: causes (time, network, ordering, shared state) and
>   the discipline to fix them.
> - Test data management: factories, fixtures, anonymization.
> - Quality gates in CI: thresholds, required checks, blocking vs
>   non-blocking.

## Practical Usage

> TODO:
>
> - Greenfield: heavy unit + integration, light E2E.
> - Legacy: characterization tests, then refactor.
> - Distributed systems: contract tests over E2E.

## Examples

> TODO:
>
> - A unit test using a fake repository.
> - A contract test with PACT-style consumer expectations.
> - A flaky test before/after fix.
> - A property-based test for a serializer.

## Common Mistakes

> TODO:
>
> 1. Mocking what you don't own (and being wrong about its behavior).
> 2. Snapshot tests that lock in noise.
> 3. E2E suites that take 40 minutes and "always" have a few flakes.
> 4. Coverage as a goal instead of a signal.
> 5. Testing only the happy path.

## Trade-offs

> TODO: Pyramid vs trophy vs honeycomb shapes; mocking vs faking;
> coverage thresholds.

## Production Considerations

> TODO:
>
> - Test environments and data hygiene.
> - Long test times as a delivery bottleneck.
> - Flake budgets and quarantine policy.
> - Quality gates that adapt to risk.

## How to Explain This in an Interview

> TODO: 60-second answer to "How do you decide what to unit test vs
> integration test?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Should you target 100% coverage?".

## Tech Lead Checklist

- [ ] Testing strategy is documented and owned.
- [ ] Flaky tests have an SLA and a quarantine policy.
- [ ] CI runs the right tests at the right stage.
- [ ] Contract tests guard service boundaries.
- [ ] Coverage is a signal, not a target.

## Interview Questions and Answers

### Basic

> TODO: "What is the difference between a stub and a mock?"

### Senior

> TODO: "How do you fix a flaky test?"

### Tech Lead

> TODO: "How do you set quality gates that don't slow delivery?"

### Scenario-based

> TODO: "Design the testing strategy for a 10-service backend."

### Trick Questions

> TODO: "Are 100% covered tests a good test suite?"

### Red Flags

> TODO: Candidates who treat coverage as the only signal.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Working Effectively with Legacy Code"; Kent C. Dodds on the
> testing trophy; PACT documentation.

---

### Generation Notes

- Cross-link to chapter 17 (CI/CD), chapter 18 (Observability),
  chapter 20 (Git workflow).
