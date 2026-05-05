# Python

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can reason about Python's data model
and concurrency primitives, choose between threads, processes, and
asyncio with confidence, and apply type hints and packaging practices
that scale.

## Why This Matters for a Tech Lead

Python dominates data, ML, scripting, and many backend services. A
Tech Lead must understand the GIL's real impact, choose async vs
threads correctly, and set the packaging and typing standard.

## Mental Model

> TODO: Python as "everything is an object, references are everywhere,
> the GIL serializes bytecode execution per process". Add a Mermaid
> sketch of GIL and the asyncio event loop.

## Core Terminology

> TODO: GIL, MRO, descriptor, generator, coroutine, asyncio event
> loop, context manager, dataclass, Protocol, type hint.

## Theoretical Foundation

> TODO: Cover:
>
> - Language model: dynamic typing, references, mutability.
> - Data model: `__slots__`, descriptors, `__init_subclass__`,
>   metaclasses (concept level).
> - MRO and multiple inheritance.
> - Generators and `yield`; coroutines and `async def`.
> - Context managers: `with`, `__enter__`/`__exit__`,
>   `contextlib`.
> - Concurrency: threads (GIL impact), multiprocessing, asyncio,
>   when to choose which.
> - Async pitfalls: blocking calls inside the event loop.
> - Type hints: `typing`, `Protocol`, `TypedDict`, `Literal`,
>   `dataclasses`, `pydantic` at concept level.
> - Packaging: pip, virtualenvs, Poetry/uv, lock files.
> - Web frameworks at a glance: FastAPI, Django, Flask.
> - Performance and tooling: `cProfile`, `pyinstrument`,
>   `tracemalloc`, py-spy.

## Practical Usage

> TODO:
>
> - I/O-bound services: asyncio + FastAPI.
> - CPU-bound work: multiprocessing or a different runtime.
> - Data pipelines: pandas, Polars, PySpark at concept level.

## Examples

> TODO:
>
> - A generator-based pipeline.
> - A context manager for a database transaction.
> - A small FastAPI handler with type hints and a Pydantic model.
> - An async function that wraps a blocking library with
>   `run_in_executor`.

## Common Mistakes

> TODO:
>
> 1. Using threads for CPU-bound work and being surprised by the GIL.
> 2. Mutable default arguments.
> 3. Catching `Exception` (or worse, bare `except:`).
> 4. Mixing sync and async without isolating blocking calls.
> 5. Shipping without a lock file.

## Trade-offs

> TODO: Threads vs processes vs asyncio; FastAPI vs Django vs Flask;
> pip vs Poetry vs uv.

## Production Considerations

> TODO:
>
> - Process model: gunicorn workers, uvicorn workers, async vs sync.
> - Memory: long-running processes, fragmentation.
> - Packaging and reproducibility: lock files and hashes.
> - Type checking in CI.

## How to Explain This in an Interview

> TODO: 60-second answer to "What is the GIL and why does it matter?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "When would you use asyncio?".

## Tech Lead Checklist

- [ ] Lock files committed; reproducible builds.
- [ ] Type hints + static checker in CI.
- [ ] Process model documented per service.
- [ ] Profiling is part of the performance toolkit.
- [ ] Async services do not call blocking libraries on the event loop.

## Interview Questions and Answers

### Basic

> TODO: "What is a generator?"

### Senior

> TODO: "Why is the GIL not 'just bad'?"

### Tech Lead

> TODO: "How do you decide between Python and another language for a
> new service?"

### Scenario-based

> TODO: "Design a Python service for a high-fan-out HTTP workload."

### Trick Questions

> TODO: "Is Python single-threaded?"

### Red Flags

> TODO: Candidates who claim threads always help in Python.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Fluent Python"; Python docs on data model and asyncio;
> `pyperformance`.

---

### Generation Notes

- Avoid version-pinning specific features unless verified.
- Cross-link to chapter 16 (Testing), chapter 18 (Observability),
  chapter 19 (Performance).
