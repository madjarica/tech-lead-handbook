# React

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can explain React's rendering model,
reason about hooks rules and pitfalls, choose appropriate state-management
boundaries, and decide where to apply server components and Suspense.

## Why This Matters for a Tech Lead

React is the dominant frontend ecosystem and is the basis for most
modern frameworks (Next.js, Remix, etc.). A Tech Lead must set the
state management strategy, performance budget, and the boundary between
client and server components.

## Mental Model

> TODO: React as "UI = f(state)". Components produce trees of elements;
> the renderer reconciles trees against the DOM. Add a Mermaid diagram
> of the rendering pipeline.

## Core Terminology

> TODO: Element, component, props, state, hook, reconciliation,
> commit phase, render phase, key, ref, context, suspense, transition,
> server component, hydration.

## Theoretical Foundation

> TODO: Cover:
>
> - Components and elements; functional vs class (class is legacy
>   but appears in interviews).
> - Reconciliation and the rendering pipeline.
> - Hooks: `useState`, `useEffect`, `useMemo`, `useCallback`,
>   `useReducer`, `useContext`, `useRef`, custom hooks.
> - Hook rules and why they exist.
> - State management: local state, lifted state, context, external
>   stores (Redux Toolkit, Zustand, Jotai), server state (TanStack
>   Query, SWR).
> - Server components and the React Server Components model
>   (where stable).
> - Suspense, transitions, concurrent rendering at concept level.
> - Performance: memoization (`memo`, `useMemo`, `useCallback`),
>   list virtualization, code splitting, key stability.
> - Effects vs derived state; when **not** to use `useEffect`.

> Verify against official documentation. React's concurrent and
> server features are evolving.

## Practical Usage

> TODO: Where each tool fits:
>
> - Local state for ephemeral UI.
> - Server state library for cache + fetch + invalidation.
> - Global state for cross-cutting concerns only.
> - Server components for data-heavy, low-interaction screens.

## Examples

> TODO:
>
> - A custom hook (`useDebouncedValue`).
> - A `useEffect` with proper cleanup and AbortController.
> - A memoized list with stable keys and `React.memo`.
> - A reducer-based state machine for a form.

## Common Mistakes

> TODO:
>
> 1. Using `useEffect` for derived state.
> 2. Effects that fetch without cancellation.
> 3. Using array index as a key.
> 4. Premature memoization that hides correctness bugs.
> 5. Putting everything in global state.

## Trade-offs

> TODO: Local vs global state; Redux vs Zustand vs Jotai vs Context;
> server components vs client components; SWR vs React Query.

## Production Considerations

> TODO:
>
> - Performance budgets and Core Web Vitals.
> - SSR/streaming/hydration costs.
> - Accessibility.
> - Bundle size and code splitting.

## How to Explain This in an Interview

> TODO: 60-second explanation of how React decides what to re-render.

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "When should you reach for Redux?".

## Tech Lead Checklist

- [ ] State management boundaries are documented.
- [ ] Server-state caching is centralized in one library.
- [ ] Effects always handle cleanup and cancellation.
- [ ] Performance budget enforced in CI.
- [ ] Accessibility checks are part of the test suite.

## Interview Questions and Answers

### Basic

> TODO: "What is the virtual DOM?" (and why the question is slightly
> outdated).

### Senior

> TODO: "When does `useMemo` actually help?"

### Tech Lead

> TODO: "How do you choose between client components and server
> components?"

### Scenario-based

> TODO: "Design state management for a real-time dashboard."

### Trick Questions

> TODO: "Does `React.memo` prevent re-renders?"

### Red Flags

> TODO: Candidates who put fetch logic directly in `useEffect` for
> production code without cancellation.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: `react.dev`; "Thinking in React"; the docs for the chosen
> state library.

---

### Generation Notes

- Cross-link to chapter 09 (Next.js) for the framework angle.
- Mark version-sensitive items (server components, transitions,
  `use` hook) and add to `notes/verification-needed.md`.
