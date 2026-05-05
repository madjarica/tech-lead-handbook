# JavaScript

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can explain the JavaScript runtime
model on a whiteboard, reason about asynchronous code without
hand-waving, and avoid the standard memory and equality pitfalls.

## Why This Matters for a Tech Lead

JavaScript is the language of the browser and a major server-side
language. A Tech Lead must reason about correctness, performance, and
debuggability without slipping into "works on my machine" territory.

## Mental Model

> TODO: Single-threaded event loop with a microtask queue and a
> macrotask queue. Add a Mermaid diagram of one tick of the loop.

## Core Terminology

> TODO: Event loop, call stack, microtask, macrotask, closure,
> hoisting, temporal dead zone, prototype chain, structural cloning,
> WeakRef, ESM vs CJS, AbortController.

## Theoretical Foundation

> TODO: Cover:
>
> - Types and coercion: primitives vs objects, `==` vs `===`,
>   `Object.is`, `typeof` quirks.
> - Scope: var/let/const, lexical scope, closures, hoisting, TDZ.
> - `this` binding: function, method, arrow, `bind`/`call`/`apply`.
> - Prototypes vs classes; how `class` desugars.
> - Async: callbacks, Promises, `async`/`await`, `Promise.all`,
>   `Promise.allSettled`, `Promise.any`, `AbortController`.
> - Event loop: microtask vs macrotask, ordering, starvation.
> - Modules: ESM vs CJS, dual-package hazards, `import.meta`,
>   dynamic `import()`.
> - Memory: references, GC, common leaks (closures over DOM nodes,
>   forgotten timers, large globals).
> - Error handling: synchronous throws, rejected promises,
>   uncaughtException, unhandledRejection.

## Practical Usage

> TODO: Where these surface:
>
> - Race conditions in async UI code.
> - Background memory leaks in long-running Node servers.
> - Surprising ordering with `setTimeout(fn, 0)` vs `queueMicrotask`.

## Examples

> TODO:
>
> - An event-loop ordering snippet (sync, microtask, macrotask).
> - A closure leak example and the fix.
> - `Promise.all` with `AbortController` for cancellation.
> - A correct `for-await-of` over an async iterable.

## Common Mistakes

> TODO:
>
> 1. Awaiting in a loop where `Promise.all` would be correct.
> 2. Forgetting that rejected promises must be handled.
> 3. Using `==` "because it's shorter".
> 4. Capturing large objects in closures unintentionally.
> 5. Mixing CJS and ESM in a package without understanding the cost.

## Trade-offs

> TODO: Callbacks vs Promises vs `async/await`; ESM vs CJS for a
> Node service; class fields vs closures.

## Production Considerations

> TODO:
>
> - Long-running processes need explicit error handlers and
>   structured logging (link to chapter 18).
> - Memory profiling in Node (heap snapshots, `--inspect`).
> - Browser performance: long tasks, main-thread blocking.

## How to Explain This in an Interview

> TODO: A clean explanation of "what is the event loop" without
> hand-waving.

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Explain closures".

## Tech Lead Checklist

- [ ] Lint rules forbid `==`, unhandled rejections, and floating
      promises.
- [ ] Long-running services have a documented shutdown sequence.
- [ ] Memory metrics are tracked in production.
- [ ] Module strategy (ESM vs CJS) is decided and consistent.

## Interview Questions and Answers

### Basic

> TODO: "What is hoisting?"

### Senior

> TODO: "Difference between microtasks and macrotasks?"

### Tech Lead

> TODO: "Migration strategy from CJS to ESM in a 50-package monorepo?"

### Scenario-based

> TODO: "A Node service has slowly growing memory in production —
> how do you investigate?"

### Trick Questions

> TODO: "Is `null == undefined`?"

### Red Flags

> TODO: Candidates who say "JavaScript is multithreaded".

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: MDN, "You Don't Know JS" series, Node.js docs on the event loop.

---

### Generation Notes

- Cross-link to chapter 06 (TypeScript) for type-related concerns.
- Cross-link to chapter 10 (Node.js) for runtime-specific concerns.
