# Angular

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can explain Angular's mental model
(components, DI, change detection), reason about RxJS pitfalls, and
make architectural choices that survive Angular's frequent updates.

## Why This Matters for a Tech Lead

Angular is opinionated and enterprise-friendly, which means upgrades
and architectural decisions are highly visible. A Tech Lead must own
the upgrade strategy, the state-management style, and the testing
approach.

## Mental Model

> TODO: Angular as "components + DI + change detection". Add a Mermaid
> component-tree diagram with OnPush boundaries marked.

## Core Terminology

> TODO: Component, directive, pipe, module (NgModule),
> standalone component, service, provider, dependency injection,
> change detection, OnPush, zone, signal (where stable),
> reactive form, template-driven form.

## Theoretical Foundation

> TODO: Cover:
>
> - Component model: template, class, styles, lifecycle hooks.
> - Dependency injection: hierarchical injectors, providers.
> - Modules vs standalone components.
> - Change detection: zone-based vs zoneless, OnPush, `markForCheck`,
>   `detectChanges`.
> - Forms: template-driven vs reactive; validation, async validators.
> - Routing: lazy loading, route guards, resolvers.
> - RxJS: streams, common operators (`switchMap`, `mergeMap`,
>   `concatMap`, `exhaustMap`), unsubscription patterns, multicast,
>   subjects vs observables.
> - Signals (where stable): reactivity model, integration with
>   change detection.
> - Testing: TestBed, harnesses, isolated unit tests.

> Verify against official documentation. Angular evolves quickly.

## Practical Usage

> TODO:
>
> - Enterprise apps with strong typing and DI.
> - Apps with complex forms and validation.
> - Migration from older Angular versions to current.

## Examples

> TODO:
>
> - A standalone component with OnPush.
> - A reactive form with cross-field validation.
> - A route guard that redirects based on auth state.
> - An RxJS pipeline with `switchMap` for typeahead.

## Common Mistakes

> TODO:
>
> 1. Subscribing in templates without `async` pipe.
> 2. Forgetting to unsubscribe and leaking memory.
> 3. Using `mergeMap` where `switchMap` is correct (typeahead races).
> 4. Mixing reactive and template-driven forms in the same screen.
> 5. Triggering change detection on every event without OnPush.

## Trade-offs

> TODO: Standalone components vs NgModules; signals vs RxJS;
> Angular Material vs custom UI kit.

## Production Considerations

> TODO:
>
> - Bundle size and lazy loading strategy.
> - Upgrade cadence and breaking changes.
> - SSR (Angular Universal) and hydration.
> - Accessibility defaults.

## How to Explain This in an Interview

> TODO: Strong 60-second explanation of change detection and how
> OnPush changes it.

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Why Angular over React?".

## Tech Lead Checklist

- [ ] OnPush is the default for new components.
- [ ] Subscriptions are managed (async pipe or `takeUntilDestroyed`).
- [ ] Forms strategy is consistent across the app.
- [ ] Upgrade plan exists and is followed.
- [ ] Bundle budget enforced in CI.

## Interview Questions and Answers

### Basic

> TODO: "What is Angular DI?"

### Senior

> TODO: "Explain `switchMap` vs `mergeMap` vs `concatMap` vs
> `exhaustMap`."

### Tech Lead

> TODO: "How do you plan an Angular major-version upgrade?"

### Scenario-based

> TODO: "Design state management for a large Angular app."

### Trick Questions

> TODO: "Does OnPush stop change detection entirely?"

### Red Flags

> TODO: Candidates who confuse Angular with AngularJS, or who treat
> all RxJS map operators as interchangeable.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: Angular documentation; `angular.dev`; "RxJS in Action".

---

### Generation Notes

- Mark every signals/zoneless claim as version-sensitive and add to
  `notes/verification-needed.md`.
- Cross-link to chapter 08 (React) for comparison and chapter 16
  (Testing) for testing strategy.
