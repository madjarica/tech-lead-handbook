# Algorithms and Data Structures

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can choose the right data structure and
algorithm for a problem, reason about complexity in real-world terms
(not only Big-O), and explain the choice to an interviewer using
standard terminology.

## Why This Matters for a Tech Lead

A Tech Lead is rarely the person writing the hottest inner loop, but
must recognize when a junior engineer's choice of data structure is the
hidden cause of a production incident, and must coach the team toward
better defaults.

## Mental Model

> TODO: Use the mental model "every data structure trades memory for
> a query shape". Add a short table mapping structures to their fast
> operations and slow operations.

## Core Terminology

> TODO: Define and add to the glossary:
>
> - Big-O, Big-Theta, Big-Omega, amortized analysis.
> - Stable vs unstable sort.
> - In-place algorithm.
> - Tail recursion.
> - Hash collision, load factor.
> - Cache locality.

## Theoretical Foundation

> TODO: Cover:
>
> - Asymptotic notation; the difference between Big-O and Big-Theta.
> - Amortized analysis (e.g. dynamic array push).
> - Core data structures: array, linked list, hash map, set, stack,
>   queue, deque, heap, binary search tree, balanced trees (red-black,
>   AVL at concept level), B-tree (link to chapter 02), trie, graph
>   adjacency list/matrix, disjoint set / union-find, bloom filter,
>   LRU cache.
> - Algorithm families:
>   - Sorting (mergesort, quicksort, heapsort, timsort, counting/radix).
>   - Searching (binary search, binary search on the answer).
>   - Two pointers, sliding window.
>   - Recursion and divide and conquer.
>   - Dynamic programming (top-down vs bottom-up).
>   - Greedy.
>   - Graph traversal (BFS, DFS), shortest path (Dijkstra, Bellman-Ford,
>     A* at concept level), topological sort, MST (Kruskal, Prim).
>   - Backtracking.
> - Practical complexity: cache effects, branch prediction, real
>   constants matter.

## Practical Usage

> TODO: Examples of where this surfaces in real systems:
>
> - LRU cache for a service.
> - Top-K with a heap for trending content.
> - Bloom filter to skip a database lookup.
> - Trie for autocomplete.
> - Graph traversal for permission inheritance.

## Examples

> TODO: Add focused snippets:
>
> - LRU cache implementation in TypeScript.
> - Top-K elements with a min-heap in Python.
> - BFS vs DFS over the same graph.
> - Coin change DP (top-down with memoization, bottom-up table).

## Common Mistakes

> TODO:
>
> 1. Reaching for Big-O without considering constants and memory.
> 2. Using `Array.includes` in a hot path instead of a `Set`.
> 3. Implementing a linked list when an array is faster.
> 4. Ignoring stability when sorting structured records.
> 5. Recursive solutions that blow the stack on real inputs.

## Trade-offs

> TODO: Comparison table for hash map vs sorted map vs array; recursion
> vs iteration; DP memoization vs tabulation.

## Production Considerations

> TODO:
>
> - Prefer the standard library; do not roll your own balanced tree.
> - Memory footprint and GC pressure for hot data structures.
> - When to choose a probabilistic structure (bloom filter, count-min
>   sketch).

## How to Explain This in an Interview

> TODO: Provide opening lines for "walk me through your approach"
> style questions: clarify input shape, state assumptions, propose a
> brute-force baseline, then optimize.

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Find the K most frequent elements".

## Tech Lead Checklist

- [ ] Team uses the standard library's data structures by default.
- [ ] Hot paths have a documented complexity expectation.
- [ ] Code review catches `O(n^2)` patterns in request handlers.
- [ ] A library of approved utilities (LRU, retry, etc.) is in the
      monorepo.

## Interview Questions and Answers

> TODO: Cover all categories. Suggested questions:

### Basic

> TODO: "What is the difference between Big-O and Big-Theta?"

### Senior

> TODO: "When is a hash map a bad choice?"

### Tech Lead

> TODO: "How do you set complexity expectations across a team?"

### Scenario-based

> TODO: "Design an LRU cache for a service handling 100k QPS."

### Trick Questions

> TODO: "Is quicksort always faster than mergesort?"

### Red Flags

> TODO: List interview answers that conflate Big-O with real
> performance.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: CLRS for depth, "Algorithm Design Manual" for breadth, and the
> standard library docs for the chosen language.

---

### Generation Notes

- Keep code examples short. No 100-line implementations.
- Avoid the trap of competitive programming flavor. The audience is a
  working engineer, not an ICPC contestant.
- Cross-link complexity discussions to chapters 02 (B-tree indexes)
  and 19 (cache stampede).
