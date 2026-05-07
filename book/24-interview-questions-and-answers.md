# Interview Questions and Answers

## How to Use This Chapter

This chapter is a **drill set**, not a textbook. It complements the topic chapters — it does not replace them. Open it the week before an interview and rehearse answers out loud.

**Recommended approach:**

1. **Skim the basics** for each domain you expect to be tested on. If anything feels unfamiliar, go back to the source chapter.
2. **Practice senior and Tech Lead questions** by answering aloud in under two minutes each. Record yourself if possible — hearing your own hesitation reveals gaps that reading alone does not.
3. **Study the weak answers and red flags.** Interviewers listen for these. Knowing what *not* to say is as valuable as knowing the right answer.
4. **Work through scenario-based questions** with a whiteboard or paper. These test whether you can connect concepts under time pressure.
5. **Finish with cross-domain questions.** Tech Lead interviews rarely stay inside one topic — the cross-domain section trains you to synthesize across areas.

Each domain section follows the same structure:

| Category | What it tests | How to use it |
|---|---|---|
| Basic | Core definitions and mental models | Quick review — you should already know these |
| Senior | Production experience and trade-offs | Practice explaining *why*, not just *what* |
| Tech Lead | Decision-making, team impact, architecture | Practice framing as a leader, not an individual contributor |
| Scenario-Based | End-to-end problem solving | Walk through out loud, narrating trade-offs |
| Trick | Hidden wrong assumptions | Learn to pause before answering |
| Weak Answers and Red Flags | Anti-patterns interviewers watch for | Ensure none of these match your default answers |

## Answering Strategy for Tech Lead Interviews

Most Tech Lead interviews test three layers:

1. **Knowledge** — "Define X." Can you explain the concept clearly and concisely?
2. **Trade-offs** — "When would you not use X?" Can you reason about alternatives, costs, and failure modes?
3. **Leadership** — "How would you decide on X for a team of eight?" Can you make decisions, communicate them, and own the consequences?

A weak candidate only hits layer one. A strong Senior Engineer covers layers one and two. A strong Tech Lead candidate covers all three consistently.

**Structure your answers with this pattern:**

1. **Define** — One or two sentences that show you understand the concept.
2. **Explain why it matters** — Connect to production, team, or business impact.
3. **Give a concrete example** — From your experience or a realistic scenario.
4. **Mention trade-offs** — What you gain, what you give up, what can go wrong.
5. **Add the leadership angle** — How you would decide, communicate, or roll out for a team.

**Common mistakes to avoid:**

- Jumping to a solution without clarifying requirements or constraints.
- Listing technologies instead of explaining trade-offs between them.
- Avoiding the failure-mode discussion — interviewers want to hear what can go wrong.
- Over-claiming familiarity with features you have not used in production.
- Answering only at the individual contributor level when the question asks for team or architecture reasoning.
- Not asking the interviewer clarifying questions — silence is not confidence.


## Algorithms and Data Structures

### Basic Questions

**Question:** What does Big-O describe, and how does it differ from Big-Theta?

**Answer:** Big-O is an upper bound on growth rate (at most this fast); Big-Theta is a tight bound (grows at that rate). In practice people say Big-O when they mean the tight bound. Example: merge sort is \(Θ(n \log n)\) and also \(O(n^2)\)—the loose bound is technically true but not informative. Interviewers care that you state the tight bound for the algorithm you chose.

---

**Question:** What is amortized constant time, and where do you see it?

**Answer:** Some operations occasionally pay a large cost that is “spread” over many cheap operations so the average per operation is \(O(1)\). Classic case: dynamic array append—most appends are \(O(1)\); periodic resize+copy is \(O(n)\) but happens rarely enough that amortized append is \(O(1)\). In production this matters because amortized structures behave like constant-time for bursty workloads until you hit pathological patterns.

---

**Question:** What are realistic expectations for hash map read/write complexity?

**Answer:** Average case: \(O(1)\) get/put/delete with a good hash and moderate load factor. Worst case: \(O(n)\) if keys collide into one bucket (adversarial or broken hashing). Resizes cost \(O(n)\) but are amortized across inserts. Production lesson: assume \(O(1)\) for normal keys, but know the escape hatches—sorted structures for ordering, and awareness of collision attacks on string-key maps.

---

**Question:** When should you prefer an array over a linked list?

**Answer:** Arrays win for sequential access, random index access \(O(1)\), and CPU cache behavior. Linked lists help when you need \(O(1)\) splice at a node you already hold (e.g., LRU internals) or stable node identity—but finding that node is still \(O(n)\) without extra structure. Default in application code: array/vector; linked list is a niche tool.

---

**Question:** What breaks a binary search tree’s performance, and how do systems avoid it?

**Answer:** Height \(h\) drives search/insert/delete \(O(h)\). Sorted inserts produce a skewed tree with \(h = O(n)\). Self-balancing trees (AVL, red-black) or skipping BSTs for ordered maps in favor of B-trees in databases keep height \(O(\log n)\). In interviews, “degenerates when data is sorted” is the key phrase.

---

**Question:** How do min-heaps and max-heaps differ in usage?

**Answer:** Min-heap: parent ≤ children, root is minimum. Max-heap: parent ≥ children, root is maximum. Both support insert/extract-min (or max) in \(O(\log n)\). Common pattern: track **K largest** with a **min-heap of size K** (evict the smallest of the top-K when a larger item arrives).

---

**Question:** When is a trie preferable to a hash map?

**Answer:** Trie supports prefix queries and enumeration by prefix in time tied to prefix length + results; hash maps excel at exact key lookup only. Autocomplete, routing tables, and typeahead often use tries; general key-value lookaside caches use hash maps. Trade-off: trie uses more pointers and memory; hash map is denser for exact match.

---

**Question:** Why does stable sorting matter in real systems?

**Answer:** Stable sorts preserve relative order of equal keys. Multi-pass sorts (sort by department, then by name within department) only work as users expect if the second sort is stable—or you bake the tie-break into a composite key. Know your language/runtime: stability guarantees differ between primitives and objects.

---

**Question:** How do you choose between BFS and DFS on a graph?

**Answer:** BFS: shortest path in unweighted graphs, level-by-level exploration, can use more memory on wide graphs. DFS: topological sort, cycle detection (with care for directed vs undirected), often less memory on deep narrow graphs. Choice is driven by **goal** (shortest path vs ordering vs exhaustive exploration) and **shape** of the graph.

---

**Question:** What is topological sort, and what prerequisite does it need?

**Answer:** Linear ordering of a DAG where every edge \(u \rightarrow v\) places \(u\) before \(v\). Used in build systems, migrations, task DAGs. No topological order exists if there is a cycle. Kahn’s algorithm (BFS on in-degrees) and DFS post-order variants both run in \(O(V+E)\).

### Senior Questions

### Question

When is a hash map the wrong abstraction?

### Strong Answer

Skip (or narrow) hash maps when you need **sorted iteration**, **range queries**, **floor/ceiling** neighbors, or **deterministic worst-case** behavior—balanced BSTs or B-tree indexes cover those. They are also weak when keys are adversarial (collision piles) or when the working set is tiny (linear scan in a hot small array can beat hashing overhead and cache misses). Memory overhead (buckets, pointers, load-factor headroom) can matter on memory-bound services. Security-sensitive HTTP handlers sometimes need extra care with attacker-controlled string keys.

### Explanation

Interviewers want you to go beyond “hash map = \(O(1)\)”. Naming **ordering**, **adversarial hashing**, **memory**, and **range access clarifies senior judgment.

### Practical Example

An interval scheduler that must answer “next event after timestamp T” repeatedly is awkward with a hash map alone; an ordered map keyed by time (or a heap plus lazy deletion) matches the access pattern.

### What the Interviewer Is Testing

- Trade-off thinking, not single-data-structure dogma
- Ordering vs lookup patterns
- Production/security awareness (HashDoS-style thinking)

### Weak Answer

“Hash maps are always fastest; use a better hash function if you have collisions.”

### Red Flags

- Treats hash maps as universal
- Cannot name a workload where sorted structures win
- No mention of memory or adversarial keys

---

### Question

Your API handler has a hot path that is \(O(n^2)\). How do you respond?

### Strong Answer

First validate the problem: profile p95/p99 and estimate **n** in production. Small bounded **n** may not justify the engineering cost. If it is real: inspect the inner loop—often repeated linear lookups become \(O(1)\) with a set/map; nested scans become sort + two pointers or binary search; duplicate work becomes memoization. After change, benchmark with realistic payloads and watch memory regressions. Document expected complexity in code review guidelines for that module.

### Explanation

Shows measurement-first discipline and pattern recognition (lookup dedup, sorting once, caching), not reflexive rewriting.

### Practical Example

`items.filter(x => banned.includes(x))` inside a loop is \(O(n \cdot m)\); a `Set` for `banned` drops inner lookup to \(O(1)\).

### What the Interviewer Is Testing

- Profiling before optimizing
- Ability to spot quadratic patterns
- Verification mindset

### Weak Answer

“I’d rewrite it to \(O(n)\) because quadratic is unacceptable.”

### Red Flags

- Skips measurement and bound on **n**
- Vague “better algorithm” without a concrete pattern
- No talk of validation/benchmarks

---

### Question

Why does cache locality sometimes dominate Big-O on real hardware?

### Strong Answer

CPUs fetch memory in lines; sequential array access benefits from prefetching and hits L1/L2 often. Pointer-chasing (linked lists, deep trees with scattered nodes) triggers misses—often tens to hundreds of cycles each—so an \(O(n)\) array walk can wall-clock beat an \(O(n)\) list walk by a large factor at moderate **n**. This is why open-addressing hash tables and array-backed structures win in benchmarks despite similar asymptotics, and why microbenchmarks matter for hot paths.

### Explanation

Tests whether you connect asymptotic analysis to hardware reality—a senior differentiator.

### Practical Example

Profiling shows 60% of time in linked-list traversal for a collection under 5k elements; switching to a contiguous buffer plus index map cuts CPU by 4× at the same Big-O class of “linear scan”.

### What the Interviewer Is Testing

- Beyond-textbook performance mental model
- Ability to explain measurable outcomes

### Weak Answer

“Locality means things are close in memory, so it’s faster.”

### Red Flags

- Cannot tie locality to cache lines/miss cost
- Uses Big-O as sole performance predictor

---

**Question:** How does a sliding window improve complexity for substring/subarray problems?

**Answer:** Two pointers expand/shrink a window so each element enters and leaves once—typically \(O(n)\) instead of enumerating all ranges \(O(n^2)\). Works when the validity of a window is monotone as you move pointers. Example: longest substring without repeats—advance right, while invalid, shrink left.

---

**Question:** How would you implement a single-node rate limiter algorithmically?

**Answer:** Common cores: **token bucket** (refill rate + burst capacity, \(O(1)\) per check) or **sliding window counter** (more memory, smoother than fixed windows). Fixed windows are easy but allow bursts at boundaries. Distributed limits need shared state (e.g., Redis `INCR` with TTL or sorted sets) and idempotent client behavior.

---

**Question:** How do bloom filters behave, and what invariant do they never violate?

**Answer:** False positives possible; **no false negatives** on membership (if bits say “no”, key is absent). Multiple hashes set/check bits; sizing trades space vs false-positive rate. Use for skipping expensive work (disk/page probes), never as authoritative existence proof without confirmation.

---

**Question:** Directed vs undirected: what changes for cycle detection?

**Answer:** Undirected: DFS/BFS with parent tracking avoids calling a back-edge to immediate parent a cycle. Directed: need **three-color** or equivalent (unvisited/in-stack/finished); a visited node can be reached without a cycle (cross edge). Mixing the two models is a common interview failure mode.

---

**Question:** When is merge sort preferable to quicksort in practice?

**Answer:** Merge sort: stable, guaranteed \(O(n \log n)\), great for linked lists and external sort. Quicksort variants: often faster in-memory with good locality, typically in-place \(O(\log n)\) stack. Libraries may use hybrid/Tim-style sorts; in production, prefer stdlib and know **stability** promises.

---

**Question:** How does LRU eviction work at the data-structure level?

**Answer:** Combine **hash map** (key → node) with **doubly linked list** (usage order) for \(O(1)\) get/put/evict: on access, unlink and move to MRU end; evict LRU from head. Some runtimes approximate with ordered maps. At scale, use Redis `volatile-lru`/`allkeys-lru` or a vetted library—not a hand-rolled list unless you own the edge case tests.

---

**Question:** How would you apply binary search when the input is not a sorted array?

**Answer:** **Binary search on the answer**: monotonic predicate over a numeric range (e.g., “minimum capacity to ship within D days”). You binary search the domain, evaluating feasibility in \(O(\log U)\) steps with an \(O(n)\) check per step. Trade-off: need monotonicity proof; off-by-one boundaries trip many candidates—test with small examples.

### Tech Lead Questions

### Question

How do you set and enforce complexity expectations for a team?

### Strong Answer

Combine **documented performance budgets** (e.g., p99 targets and complexity class expectations for hot paths), **review checklists** that flag nested scans and ORM N+1 risk, **static checks** where feasible, and **percentile dashboards/alerts** so regressions become incidents with follow-up. Escalation path: when someone introduces a hot path worse than \(O(n \log n)\), require justification tied to measured bounds on input size. Balance: not every engineer proves limits formally—everyone should recognize common quadratic traps.

### Explanation

Tests leadership mechanisms: standards, tooling, feedback loops—not vague “write efficient code.”

### Practical Example

Add a linter rule or custom CI script that flags `.includes` inside a tight loop in TypeScript hot modules; pair with microbench on payment capture service before merge.

### What the Interviewer Is Testing

- Org-level quality systems
- Measurement + prevention balance

### Weak Answer

“I’d tell people to be careful in code review.”

### Red Flags

- No concrete guardrails or observability
- No documented standards

---

### Question

An engineer wants unbounded in-memory state keyed by every user in a 50k RPS service. How do you lead on that?

### Strong Answer

Unbounded process memory is a reliability defect. Quantify footprint per user and expected cardinality; show crash scenario. Redirect to **bounded** structures: capped LRU + TTL, sharded external store (Redis), **CQRS** if reads/writes differ, or **probabilistic** structures if false positives are tolerable. Add metrics on structure size and alerts. Capture decision in an ADR; link to capacity tests.

### Explanation

Tech leads connect algorithm choices to **SLOs and operability**, not only correctness.

### Practical Example

Replace `Map` of every session with a Redis cluster with TTL + eviction, or a count-min sketch for heavy-hitter detection instead of exact sets.

### What the Interviewer Is Testing

- Risk framing for scale
- Alternative architectures, not only “bigger pod”

### Weak Answer

“We’ll raise memory limits and add another replica.”

### Red Flags

- Saves symptoms, not design
- No eviction/TTL/externalization story

---

### Question

How do you decide between an in-process cache and Redis for shared hot data?

### Strong Answer

In-process: microsecond access, no network—**per-process** isolation, lost on restart, duplication across replicas. Redis: shared, consistent across instances, observable centrally, adds latency, ops cost, and failure modes. Decide from **sharing need**, **durability**, **staleness tolerance**, and **latency budget**. Often use both in layers: tiny near-static in-process + Redis for cross-box coherence.

### Explanation

Build-vs-buy and **operational** ownership are lead-level concerns.

### Practical Example

Feature flags: short TTL local cache in API pods + Redis backing for coherence; invalidate via pub/sub for critical toggles.

### What the Interviewer Is Testing

- Layered caching thinking
- Ops and consistency trade-offs

### Weak Answer

“Always use Redis so it scales.”

### Red Flags

- Ignores per-process caching and latency
- No invalidation or consistency story

---

**Question:** How do you evaluate a proposal to add a bloom filter in front of storage reads?

**Answer:** Quantify prevented I/O, target false-positive rate, memory budget \((m, k)\), rebuild strategy on updates, and compare to cheaper fixes (better index, caching). Approve when benefit is measured and operations own FP behavior.

---

**Question:** A lead proposes competitive programming drills for all backend engineers. Your stance?

**Answer:** Targeted pattern literacy helps; marathon competitive training has **declining returns** versus profiling, stdlib data-structure literacy, SQL plans, and distributed systems. Recommend focused study + production skills (measurement, review of hot paths).

---

**Question:** How do you explain a two-sprint performance refactor to a product executive?

**Answer:** Use analogy (phone book vs pairwise comparison) tied to revenue risk: quadratic growth explodes operational cost and outage risk; phased migration protects live traffic. Tie timeline to **dual-write/read** safety, not jargon alone.

---

**Question:** Junior teammate claims linked lists beat arrays for “insert performance.” Response?

**Answer:** Ack intent; explain **node finding** cost and **cache** effects; offer microbenchmark; update team guidelines. Linked lists are specialized, not default.

---

**Question:** Prod cache hit ratio drops after a deploy—could algorithms/data structures be involved?

**Answer:** Yes—check for nondeterministic iteration order, resized hash maps changing iteration, or new code paths bypassing memoization. Compare key distributions and eviction policies; validate that equality/hash contracts for cache keys did not change across language/runtime updates.

### Scenario-Based Questions

**Question:** P99 for search spikes linearly with catalog growth; code uses nested loops over categories and SKUs.

**Answer:** Profile, confirm \(O(categories \cdot skus)\); pre-index SKUs by category in a map; or pre-sort and binary search; add load test tied to roadmap. Post-fix: alert on p99 vs catalog cardinality slope.

---

**Question:** Rate limiting per API key on 12 stateless replicas—local counters diverge.

**Answer:** Move counters to Redis/Redis Cluster with atomic ops or Lua; or centralized edge proxy; accept softer limits with gossip only if product allows. Document burst behavior.

---

**Question:** Incident shows stack overflow in deep recursive tree walk of user-uploaded JSON.

**Answer:** Switch to explicit stack/iterative traversal; cap depth at validation; add payload size limits. Add regression tests for adversarial depth.

---

**Question:** Logs reveal sort inside a tight request loop on a list that changes rarely.

**Answer:** Sort once per change, keep sorted copy, or maintain heap order incrementally; verify with benchmark and fix review checklist item.

---

**Question:** DAG job runner occasionally deadlocks in custom worker pool.

**Answer:** Re-verify topological order before schedule; detect cycles with three-state DFS; add watchdog + metrics on queue depth; property-test scheduler invariants.

### Trick Questions

**Question:** “Quicksort is always faster than merge sort—yes?”

**Answer:** No. Quicksort can hit \(O(n^2)\) with bad pivots; merge sort is \(O(n \log n)\) worst-case and stable. “Always faster” ignores worst case, stability, and external sort needs.

---

**Question:** “Hash map lookup is \(O(1)\)—correct?”

**Answer:** Qualified: expected \(O(1)\); worst-case \(O(n)\) collisions; security-sensitive inputs need care. “Always \(O(1)\)” is the trap.

---

**Question:** “Linked lists insert in \(O(1)\)—so lists beat arrays for inserts?”

**Answer:** Insert at a known node is \(O(1)\); finding that node is usually \(O(n)\). Arrays often win practically due to locality unless you already hold the iterator/node reference.

### Weak Answers and Red Flags

1. **“We’ll pick the algorithm with the best Big-O and ship it.”** Ignores constants, memory, hardware, and measured SLOs—signals theory-only thinking without profiling discipline.
2. **“Recursion is always clearer than iteration.”** Misses stack depth limits and production failure modes on adversarial inputs—signals unfamiliarity with operational constraints.
3. **“I’ll implement a custom hash map/B-tree for speed.”** Without a rare, proven gap versus the stdlib, this is maintenance risk and usually indicates immature trade-off analysis.

## SQL and NoSQL

### Basic Questions

**Question:** What is a primary key at the logical and physical level?

**Answer:** Logical: uniqueness + not-null row identity, FK target. Physical: clustered PK in some engines orders rows on disk (InnoDB); PostgreSQL heap is unordered—PK still enforces uniqueness via its index. Trade-off surrogate (UUID/bigint) vs natural keys (stable business identifiers).

---

**Question:** What do foreign keys buy you in production systems?

**Answer:** Referential integrity enforced in the database—prevents orphans, clarifies ownership boundaries. Behaviors like `ON DELETE CASCADE/RESTRICT/SET NULL` encode policy. Trade-off: extra write cost and migration friction versus app-only checks that drift under concurrency.

---

**Question:** What problem does normalization solve, and what does it cost?

**Answer:** Removes redundancy to prevent update anomalies; typical OLTP goes to 3NF-ish. Cost: more joins on read paths—sometimes you denormalize read models or use materialized views when measured join cost dominates and writes are rare.

---

**Question:** How do B-tree indexes change planner behavior?

**Answer:** B-trees support point, range, and prefix scans with few seeks on large tables; writes maintain index pages. Composite index column order must match **filter + sort** patterns. Trade-off: each index slows writes and consumes space—avoid speculative indexes.

---

**Question:** Explain MVCC at a high level.

**Answer:** Readers see a snapshot; writers create new row versions; old versions are collected by vacuum/purge. Reduces blocking versus single-version locking but creates bloat and long-transaction hazards if not tuned.

---

**Question:** What is the N+1 query smell, and how do you fix it?

**Answer:** One query for parents + one per child. Fix: joins, batched `IN`, dataloaders, or ORM eager loads. In APIs, track queries per request in staging to catch regressions.

---

**Question:** Partial vs covering index—when each?

**Answer:** Partial: smaller index for a **subset** of rows you always filter (e.g., `WHERE archived = false`). Covering/`INCLUDE`: index-only scans when all selected columns live in the index—saves heap fetches for hot read queries.

---

**Question:** What does CAP actually constrain?

**Answer:** During a **partition**, you cannot have both linearizable consistency and total availability. It is not a permanent “pick two of three” badge—many systems are CP or AP **when partitioned** and behave differently when the network is healthy. Pair with **PACELC** for latency vs consistency under normal conditions.

---

**Question:** DynamoDB partition keys vs sort keys—what are they for?

**Answer:** Partition key hashes to a shard; items with the same partition key live together for efficient `Query`. Sort key orders items within that partition for range queries and adjacency patterns. Hot partitions arise from low-cardinality partition keys.

---

**Question:** Redis vs Postgres for caching sessions—quick differentiation?

**Answer:** Redis: sub-ms networked cache, TTL/eviction native, good for shared ephemeral state. Postgres: durable and transactional but heavier; use when you need richer querying or single-system simplicity at smaller scale. Trade-off: consistency, ops, latency.

---

**Question:** How do optimistic and pessimistic locking differ in throughput?

**Answer:** Pessimistic (`SELECT ... FOR UPDATE`) blocks writers—great when conflicts are frequent and hot rows are known. Optimistic (version column) retries on conflict—better when collisions are rare; avoids long locks but needs retry logic.

---

**Question:** `EXPLAIN` vs `EXPLAIN ANALYZE`—when to use which?

**Answer:** `EXPLAIN`: planner estimate without executing—fast, safe for prod-peeking if no mutations. `EXPLAIN ANALYZE`: executes, shows actual rows/timings—best on replicas for heavy queries; beware side effects on mutating statements—wrap in rollback if needed.

### Senior Questions

### Question

How do you chase a slow query in production safely?

### Strong Answer

Use `pg_stat_statements` (or equivalent) ranked by **total** time, not only mean latency. Reproduce on a replica with anonymized prod-sized data; `EXPLAIN (ANALYZE, BUFFERS)`; look for seq scans on large tables, inflated rows removed by filter, nested-loop bombs, spills to disk. Fix with composite/covering/partial indexes matching predicates and order-by, rewrite to remove useless joins, or batch work. Verify plan flip and **p99** after deploy; add guardrail tests or query budgets in CI for critical paths.

### Explanation

Shows disciplined, measurement-led tuning—not random index sprinkling.

### Practical Example

Dashboard query doing seq scan on `orders` filtered by `tenant_id, created_at`—add `(tenant_id, created_at DESC)` and consider `INCLUDE` for projected columns to shrink heap hits.

### What the Interviewer Is Testing

- Observability of SQL workload
- Index design tied to predicates
- Safety (replica, rollback mindset)

### Weak Answer

“I’d add indexes until it feels fast.”

### Red Flags

- No `pg_stat_statements` / plan discipline
- Ignores write amplification of indexes
- Cannot separate one-off vs total-time impact

---

### Question

How do you ship schema changes without taking the app down?

### Strong Answer

Expand–contract: add nullable columns/new tables; deploy writers/readers tolerant of both; backfill; swap reads; remove old fields later. Use `CREATE INDEX CONCURRENTLY`, `NOT VALID` constraints then `VALIDATE`, and short transactions for DDL. Never let a migration hold strong locks across peak traffic without rehearsal on a clone sizing rows like prod.

### Explanation

Tests zero-downtime maturity and lock awareness—core staff engineer skill.

### Practical Example

Rename column via add-new, dual-write, backfill, flip read, drop old—rather than in-place rename requiring lock-heavy rewrites on some engines.

### What the Interviewer Is Testing

- Phased migrations
- Operational postgres/mysql knowledge

### Weak Answer

“We run migrations nightly when traffic is low—that’s enough.”

### Red Flags

- No expand/contract
- Dismisses lock risk on big tables

---

### Question

How do you model DynamoDB when several access patterns must stay fast?

### Strong Answer

Start from **enumerated access paths** (entities + GSIs). Single-table design co-locates related items with composite `PK/SK`, overloads prefixes, and adds GSIs for inverted patterns. Trade: phenomenal efficiency for known queries, painful rigidity when patterns churn—budget migrations and GSI projection costs. If patterns are exploratory, relational or document stores may reduce rework.

### Explanation

Separates hype from access-pattern discipline.

### Practical Example

User profile under `USER#id`, orders under same partition with `ORDER#ts#id` sort keys; GSI on status for operational queues.

### What the Interviewer Is Testing

- Single-table thinking
- GSI cost/latency awareness
- When **not** to force Dynamo

### Weak Answer

“We’ll add a GSI whenever we need a new query.”

### Red Flags

- No upfront access-pattern list
- Ignores hot partitions and item size limits

---

**Question:** Outbox pattern—what problem is it solving?

**Answer:** Atomically persist domain change + outbound event in one DB transaction; separate publisher drains outbox—avoids “DB committed but message lost” without 2PC across broker and DB.

---

**Question:** Cursor pagination vs deep `OFFSET`?

**Answer:** Cursors (`WHERE (sort,id) > last`) use index seeks—stable under concurrent inserts; `OFFSET` degrades linearly in scanned rows. Trade-off: no random page jumps—acceptable for feeds/admin tools with different UX.

---

**Question:** How do you detect/prevent DynamoDB hot partitions?

**Answer:** Watch throttled units and per-key metrics; random-write sharding (`KEY#shard`) for viral keys; design PKs with cardinality; use adaptive features where available. Prevention beats post-fire capacity hikes.

---

**Question:** When is a graph database justified?

**Answer:** Variable-length relationship traversal (fraud graphs, permissions, recommendations) where join explosion in SQL hurts; not for straight CRUD or teams lacking ops expertise.

---

**Question:** What is write amplification and why should leads care?

**Answer:** Bytes written to media per application byte—LSM engines amplify via compaction; affects SSD wear, latency, and cloud IOPS bills. Informs capacity and instance selection.

---

**Question:** How do you choose shared DB vs database-per-service?

**Answer:** Shared lowers ops burden and allows joins but couples teams/schemas; split improves ownership and scaling independence but needs sagas, outboxes, and no cross-joins. Decision hinges on team topology, scaling pain, and compliance boundaries.

---

**Question:** How would you add full-text search alongside Postgres?

**Answer:** `tsvector` + GIN for moderate corpora; move to OpenSearch/Meilisearch when ranking, typo tolerance, or faceting complexity grows—often fed by CDC.

---

**Question:** Serializable vs read committed with `FOR UPDATE`?

**Answer:** Serializable detects anomalies automatically—needs retries; good for rare conflicts across sets. `FOR UPDATE` pins rows—predictable for single hot aggregates but deadlock-order discipline required.

---

**Question:** How does connection pooling change failure modes?

**Answer:** Pools hide connect latency and cap server processes; mis-sized pools cause queueing timeouts. Use PgBouncer transaction pooling for high fan-in; size from cores and workload—not “max connections = infinity.”

### Tech Lead Questions

### Question

How do you pick a datastore for a new service?

### Strong Answer

Start with **access patterns** and **consistency** needs; default relational (often Postgres) unless latency, scale, or model constraints push elsewhere. Evaluate **team ops skill**, backup/DR expectations, and dollars per query at target RPS. Document the choice for review—marketing names are not arguments.

### Explanation

Tech leads align product SLOs, cost, and org capability.

### Practical Example

Known key lookups at very high RPS with narrow patterns → DynamoDB; cross-entity reporting + constraints → Aurora/Postgres; hot ephemeral coordination → Redis.

### What the Interviewer Is Testing

- Structured decision records
- Avoiding resume-driven design

### Weak Answer

“We default to NoSQL for scale.”

### Red Flags

- No access-pattern analysis
- Confuses operational simplicity of managed KV with modeling simplicity

---

### Question

PostgreSQL connections are exhausted—what is your lead playbook?

### Strong Answer

Measure wait time on pool; calculate `instances × pool_size` vs `max_connections`; reduce per-instance pool; introduce **PgBouncer** (transaction mode); terminate leaked idle in app; long term split read replicas or services. Educate that Postgres is process-per-connection—RAM and scheduler limits are real.

### Explanation

Classic scaling incident; tests knowledge beyond “raise max_connections.”

### Practical Example

2000 Node workers × pool 20 = 40k attempted conns—collapse pool to 10 and front with PgBouncer to cap DB sessions at 200.

### What the Interviewer Is Testing

- Math-backed capacity thinking
- Pooler layering

### Weak Answer

“Set max_connections to 5000.”

### Red Flags

- Ignores RAM per backend
- No PgBouncer / pooling strategy

---

### Question

How do you govern migrations across many teams?

### Strong Answer

One toolchain (Flyway/Prisma/skeema), mandatory review for DDL, CI against **prod-shaped** data with timing gates, lint for unsafe patterns (`squawk`), required rollback/forward-compatible steps, and deploy ordering policy (schema-first vs dual-read). Measure incidents caused by migrations quarterly.

### Explanation

Migrations are high-blast-radius changes—governance is lead accountability.

### Practical Example

Block `ALTER` that rewrites full table without online algorithm; require two-step nullability or backfill jobs with chunking.

### What the Interviewer Is Testing

- Process + automation
- Lock and downtime awareness

### Weak Answer

“Developers run migrations from laptops when needed.”

### Red Flags

- No CI simulation
- No ownership of risky DDL

---

**Question:** Eventual consistency across microservices—how do you set expectations?

**Answer:** Prefer sagas with compensations + idempotent consumers and outbox for publication; avoid 2PC. Document user-visible delay boundaries per journey.

---

**Question:** Sharding Postgres—when and how to sequence?

**Answer:** After vertical scale, replicas, and caching exhausted; pick shard key on **even** write spread and locality of joins; dual-write/shadow-read migration; plan cross-shard reporting separately (warehouse/CDC).

---

**Question:** High write rate breaks single-node SQL—direction?

**Answer:** Measure WAL/IOPS/locks; consider append log (Kafka) + materialized read DB, CQRS, or purpose engine (Dynamo/Cassandra/ClickHouse) matched to pattern—cost-model both infra and engineering.

---

**Question:** 99.99% DB tier—what non-negotiables?

**Answer:** Replication with monitored lag, automated failover drills, PITR backups tested restores, bounded blast radius, and documented RPO/RTO—managed services still need **your** runbooks.

---

**Question:** How do you arbitrate “best tool for the job” when every team wants a different database?

**Answer:** Publish an **approved technology catalog** (default allow, requires review, or blocked without exception). Require ADR for new engines; weight team skill, on-call surface, and license/support cost—not novelty. Cap distinct production engines per org unless platform commits SRE capacity.

---

**Question:** BI wants Mongo-like ad hoc queries on your OLTP Postgres—how do you respond?

**Answer:** Keep OLTP bounded; spin **read models**: replica, materialized views, or warehouse/ lake fed by CDC. Negotiate freshness SLAs; never let analytics patterns dictate OLTP indexing without guardrails.

---

**Question:** Your startup’s single `users` table is 200M rows; simple lookups are fine but any migration scares the team—what’s the path?

**Answer:** Table partitioning by time or tenant, **online** DDL patterns, background vacuum tuning, archival to cold storage for tail rows, and **shadow** migration practice before any column rewrite. Leadership: sequence risk so you never need a hero cutover.

### Scenario-Based Questions

**Question:** 1k-tenant SaaS; tenants range 10–10k users—sketch storage isolation.

**Answer:** Shared Postgres + `tenant_id` + RLS; composite indexes leading with `tenant_id`; PgBouncer; carve largest tenants to dedicated DB when noisy-neighbor metrics demand.

---

**Question:** Flash sale—10k buyers racing 100 units—how prevent oversell?

**Answer:** Row-level `SELECT ... FOR UPDATE` or optimistic version checks; queue-based serializers for extreme spikes; never trust app-only compare-and-swap without DB constraints verifying stock ≥ 0.

---

**Question:** Admin dashboard joins six huge tables—5s loads.

**Answer:** `EXPLAIN ANALYZE`, covering/partial indexes, limit aggregates, materialized view with concurrent refresh, route heavy read to replica, consider warehouse for BI shape.

---

**Question:** Mongo service now needs cross-row transactions and heavy reporting.

**Answer:** Measure % needing multi-doc ACID; maybe Mongo transactions for narrow path; long term CDC to relational/warehouse for analytics; polyglot persistence if bounded contexts differ.

---

**Question:** Need 30-day undo for user operations.

**Answer:** Event log + projections or rich audit table with compensating events; partition by time; enforce append-only audit semantics.

---

**Question:** API idempotency with Postgres back end—outline.

**Answer:** `Idempotency-Key` header, unique constraint row storing serialized response, transactional insert around business work, TTL cleanup job—handles retries race-free.

### Trick Questions

**Question:** “NoSQL is faster than SQL—agree?”

**Answer:** Meaningless without workload. In-memory KV can beat disk SQL for point reads; SQL wins on messy joins; Dynamo excels at partition-key queries but punishes ad hoc analytics.

---

**Question:** “Mongo has no schema—true?”

**Answer:** Enforcement is flexible, but **shape exists** in application code; optional JSON schema validation can harden collections.

---

**Question:** “CAP means pick two letters and you’re done.”

**Answer:** Misread; partition response drives C vs A; healthy networks allow both; real designs need latency/consistency nuance (PACELC).

---

**Question:** “Always normalize to 3NF.”

**Answer:** Normalize OLTP defaults; denormalize/read models when metrics show join pain and update rates are low—measure, don’t dogma.

### Weak Answers and Red Flags

1. **“We’ll fix performance with a bigger RDS instance.”** Bypasses plan analysis and indexing—signals cost-only thinking without query science.
2. **“We use read replicas so we don’t need indexes.”** Replicas don’t erase sequential scans or N+1—they shift load, not inefficiency.
3. **“Transactions across microservices via 2PC.”** Usually impractical—signals outdated distributed patterns and missing saga/outbox vocabulary.
4. **“ORM handles SQL injection so we’re safe.”** Unsafe raw helpers and string-built SQL still exist—defense needs parameterized queries, least-privilege DB roles, and reviews.

## Docker and Kubernetes

### Basic Questions

**Question:** Container vs VM—what actually isolates what?

**Answer:** VMs virtualize hardware with guest kernels; containers share the host kernel and isolate with namespaces/cgroups. Faster start and denser packing for containers; weaker isolation boundary from kernel bugs—design security accordingly.

---

**Question:** What is a pod, and why not always one container?

**Answer:** Smallest schedulable unit; shared network/IP and optional volumes. Sidecars/init containers justify multi-container pods—for logging, mesh, migration init.

---

**Question:** Deployment vs StatefulSet—decision rule?

**Answer:** Deployment: interchangeable replicas, random identities. StatefulSet: stable network IDs, ordered rollout, per-pod PVCs—Kafka, DB clusters—at cost of harder ops.

---

**Question:** Service types at a glance?

**Answer:** `ClusterIP` internal LB, `NodePort` node-published port, `LoadBalancer` cloud LB, `ExternalName` DNS CNAME—choose based on exposure path and cost.

---

**Question:** ConfigMap vs Secret—what changes operationally?

**Answer:** Secrets carry sensitive data, tighter RBAC, still base64 in etcd by default—**encrypt etcd** and integrate external secret managers for real assurance. Neither belongs in git plaintext.

---

**Question:** Liveness vs readiness vs startup probes?

**Answer:** Startup gates slow boots; readiness removes endpoints from service; liveness restarts on deadlock—**never** probe flaky external deps as liveness or you churn pods.

---

**Question:** Requests vs limits?

**Answer:** Requests schedule/plan capacity; limits enforce max (OOM on memory, CPU throttling). Gap defines QoS class—mis-set pairs cause eviction surprises.

---

**Question:** What does `.dockerignore` protect?

**Answer:** Shrinks build context, speeds CI, prevents secrets and fat artifacts from landing in layers—treat like `.gitignore` for builds.

---

**Question:** Why multi-stage Dockerfiles?

**Answer:** Final image copies only runtime artifacts—smaller surface, fewer CVEs, faster pulls—build tools stay in earlier stages.

---

**Question:** Helm vs raw YAML—one-line guidance?

**Answer:** Helm packages parameterized releases; great for sharing charts; increases templating complexity—`helm template` for transparency. Kustomize suits fork-friendly bases without templating.

### Senior Questions

### Question

How do you tune Kubernetes resources without wasting money or risking OOM?

### Strong Answer

Observe real usage (`kubectl top`, Prometheus/VPA **recommendation** mode). Memory requests near sustained footprint with headroom for spikes; CPU requests near typical; limits set with policy (some teams limit memory hard, CPU soft/throttled). Revisit quarterly—over-request is pure waste; under-request → throttling/OOM. Pair with HPA that matches real signals (custom metrics if CPU lies).

### Explanation

Shows cost/reliability trade literacy on clusters.

### Practical Example

Java service: align heap + native with memory request; add startup probe to absorb slow JIT warmups before liveness kills the pod.

### What the Interviewer Is Testing

- Relationship of requests/limits/QoS
- Data-driven tuning

### Weak Answer

“Set requests really low and rely on limits.”

### Red Flags

- Ignores scheduler/OOM interplay
- No observational basis

---

### Question

What does a zero-downtime rollout require beyond `Deployment` defaults?

### Strong Answer

Readiness gates before receiving traffic; `maxUnavailable:0`/`maxSurge` tuned; `preStop` sleep to let LB endpoints drain; PDBs so drains don’t take all replicas; graceful timeouts matching longest request; for legacy clients, validate LB health check timing vs kube proxy updates.

### Explanation

Connects Kubernetes lifecycle with load balancers—common 503 root cause.

### Practical Example

Add 10–15s `preStop` sleep plus aligned ALB deregistration delay after seeing 503 spikes during node drains.

### What the Interviewer Is Testing

- End-to-end rolling semantics
- LB coordination

### Weak Answer

“Kubernetes rolling updates are zero-downtime by default.”

### Red Flags

- Misses readiness/drain race
- No PDB/preStop awareness

---

### Question

StatefulSet versus managed database—how do you argue?

### Strong Answer

Default managed DB for backups, failover, patching, and supportability. Run stateful workloads on Kubernetes when portability, cost at scale, or operator-mature DBs (e.g., CNPG) justify the extra failure-domain work—always with tested backup/restore and storage class awareness (AZ sticky volumes).

### Explanation

Pragmatic platform leadership vs resume-driven k8s-everything.

### Practical Example

Aurora/RDS for OLTP; Redis/ElastiCache for cache; self-host Postgres only when compliance or unit economics clearly demand it and staffing exists.

### What the Interviewer Is Testing

- Operability realism
- Risk ownership clarity

### Weak Answer

“Everything in Kubernetes for consistency.”

### Red Flags

- Ignores Day-2 data operations
- No backup/DR story

---

**Question:** Debugging `Pending` pods?

**Answer:** `describe` events—resources, affinity, taints, PVC binding, quotas; correlate with node allocatable; fix scheduling constraints or capacity.

---

**Question:** How does the scheduler score nodes?

**Answer:** Filter infeasible nodes; score remainder on spread, affinity, resource balance—uses **requests** not limits for feasibility—trap for under-requested noisy neighbors.

---

**Question:** Canary options without a mesh?

**Answer:** Separate small Deployment + shared selector cautiously, Argo Rollouts, or weighted split at ingress—validate metrics automation.

---

**Question:** NetworkPolicies effectively?

**Answer:** Default deny then explicit allows; requires CNI enforcement—test with real traffic; keep DNS egress documented.

---

**Question:** Secrets in cluster—hardening stack?

**Answer:** External Secrets Operator, etcd encryption, RBAC scoping, rotation story; no cluster-admin for apps; audit pulls.

---

**Question:** Image tags in prod?

**Answer:** Immutable tags/digests, `IfNotPresent` where safe—`:latest` breeds mystery rollbacks.

---

**Question:** HPA vs VPA tension?

**Answer:** HPA scales out; VPA grows pod; don’t auto both on conflicting signals—often VPA “Off” mode for recommendations only.

### Tech Lead Questions

### Question

Eight services / twelve engineers—adopt Kubernetes now?

### Strong Answer

Assess **pain** (deploy consistency, env drift) and **skills**; if Fargate/ECS solves today’s needs with less toil, defer k8s until service count, tenancy, or edge features justify it. If adopting: managed control plane, narrow platform scope, golden paths—not DIY etcd surgery.

### Explanation

Tests willingness to say “not yet” and org-fit reasoning.

### Practical Example

Team lacks SRE—start with PaaS + IaC; revisit k8s when multi-team CRDs/admission policies become necessary.

### What the Interviewer Is Testing

- Cost of complexity
- Honest gatekeeping

### Weak Answer

“Industry uses k8s, so we must.”

### Red Flags

- Popularity argument
- Ignores staffing curve

---

### Question

Cluster bill tripled on flat traffic—how do you lead finance + eng?

### Strong Answer

Attribute by namespace/service (OpenCost/Kubecost), compare requests vs usage, check replica floors ratcheted after incidents, node group/instance mix, spot eligibility, and orphaned PVCs/PVs. Program: right-size top offenders, quotas, weekly cost dashboards, rewards for efficiency—not blind caps that harm reliability.

### Explanation

Bridges observability with governance—TL accountability.

### Practical Example

Find one service requesting 4Gi using 600Mi—staged decrease with HPA safety net + load test evidence for risk-averse leadership.

### What the Interviewer Is Testing

- Analytical billing triage
- Stakeholder communication

### Weak Answer

“Buy savings plans and bigger nodes.”

### Red Flags

- No attribution
- Hardware spend before waste removal

---

### Question

Define platform vs application ownership on shared clusters.

### Strong Answer

Platform owns cluster lifecycle, policy enforcement, observability stack, ingress/dns patterns, paved-road templates; apps own manifests within guardrails, probes, SLOs, and on-call for their crash loops. Success metric: time-to-first-safe deploy for a new service.

### Explanation

Prevents “everything is everyone’s job” chaos.

### Practical Example

Admission checks enforce non-root, label schema, and resource minimums; app teams cannot toggle PSP-equivalent relaxations without break-glass process.

### What the Interviewer Is Testing

- Operating model clarity
- Guardrails vs autonomy

### Weak Answer

“Devs kubectl whatever; we’ll fix nodes.”

### Red Flags

- No golden path
- No policy automation

---

**Question:** Engineer demands `privileged: true` for monitoring—response?

**Answer:** Decline broad privilege; isolate actual need (`hostNetwork`, specific caps, DaemonSet platform namespace). Enforce policy via admission; document rare exceptions.

---

**Question:** Multi-year cluster—drift and `kubectl apply` cowboys—fix?

**Answer:** Audit (`kyverno report`), prioritize security/reliability gaps, GitOps + drift detection, phased enforcement, make compliance default via updated base charts.

---

**Question:** Org wants separate clusters per team—evaluate?

**Answer:** Validate isolation requirement—namespaces/quotas/node pools often suffice; multi-cluster raises control-plane cost, cross-cluster networking, and ops surface; separate for regulatory/untrusted boundaries.

---

**Question:** Two teams share a Redis operator; one needs cluster mode, the other single-node—who decides?

**Answer:** Platform sets supported **tiers** (dev/stage/prod patterns); exceptions need capacity review. Shared operators get one topology per environment class; specialized needs get dedicated namespace/cluster slices with cost attribution.

---

**Question:** How do you decide image registry strategy (single vs per-team registries)?

**Answer:** Single org registry with **repos per team** and IAM/scopes usually wins; per-team registries add auth sprawl unless regulatory separation demands it. Scanning policy and retention are centralized either way.

### Scenario-Based Questions

**Question:** Post-upgrade intermittent 503s on core API.

**Answer:** Inspect endpoints churn, readiness failures, PDB during drains, `preStop`/termination grace vs LB deregistration; fix drain sequencing—not blind rollback of control plane.

---

**Question:** CI Docker builds ≥15 minutes.

**Answer:** Layer order, BuildKit cache mounts, remote cache, slim base, `.dockerignore`, parallel matrix builds.

---

**Question:** Memory 4× request—OOMKilled.

**Answer:** Confirm metric (`container_memory_working_set_bytes`), heap/profile for leaks vs spikes; temporary limit bump while fixing; alerts at 70% of limit.

---

**Question:** Compose → k8s migration for 20 services.

**Answer:** Pilot stateless first; golden chart; managed data stores; GitOps rollout; stagger cutovers with traffic shifting.

---

**Question:** Noisy neighbor tenant API inside cluster.

**Answer:** Rate limits at ingress, quotas, priority classes, separate Deployments or node pools; clarify SLO slices per consumer.

### Trick Questions

**Question:** Does Deployment guarantee exactly N pods always?

**Answer:** No—rolling updates, evictions, and failures mean temporary skew; eventual convergence; PDBs only cover voluntary disruptions.

---

**Question:** CPU limit 1000m means guaranteed 1 core?

**Answer:** Limits cap bursts via throttling; guarantees come from **requests**; CFS throttling can sting latency even at “low average” CPU.

---

**Question:** Are Kubernetes secrets encrypted out of the box?

**Answer:** Etcd stores data that is base64-wrapped, not meaningfully secret without encryption config + KMS; RBAC still gates access.

### Weak Answers and Red Flags

1. **“We’ll fix image size by raising probe timeouts.”** Masks slow pulls/startups instead of slimming images and fixing init paths—signals shallow ops thinking.
2. **“One cluster-admin kubeconfig for all developers.”** Conflicts with blast-radius minimization and audit—signals immature RBAC culture.
3. **“Stateful app—`Deployment` with hostPath is fine.”** Ignores PVC/StatefulSet semantics and scheduling failure domains—data loss risk.

## AWS

### Basic Questions

**Question:** Region vs Availability Zone—why care?

**Answer:** Region: isolated geography; AZ: independent power/network within it, low-latency linked. Multi-AZ survives DC faults; multi-Region survives regional disasters—different RTO/RPO and cost.

---

**Question:** VPC purpose?

**Answer:** Private IP space, routing controls, segmentation via subnets, SGs/NACLs—foundation for least-privilege networking.

---

**Question:** Public vs private subnet routing?

**Answer:** Public routes to IGW for inbound Internet; private uses NAT (or endpoints) for egress—place app/db tiers private by default.

---

**Question:** Security group vs NACL?

**Answer:** SG: stateful, instance ENI level, allow rules. NACL: stateless subnet filter with explicit deny order—defense in depth and coarse blocks.

---

**Question:** IAM user vs role—modern guidance?

**Answer:** Humans via federation/SSO into roles; workloads assume roles with short-lived creds—avoid long-lived keys except rare break-glass automation with rotation.

---

**Question:** S3 durability/perf model snapshot?

**Answer:** Extremely durable object store; strong read-after-write consistency on objects; lifecycle tiers balance $ vs retrieval latency; still design for permissions and replication lag on cross-region copies.

---

**Question:** ALB vs NLB decision?

**Answer:** ALB Layer-7 HTTP routing + WAF integration; NLB Layer-4 static IPs, extreme throughput, TLS pass-through—pick by protocol and static IP needs.

---

**Question:** SQS vs SNS vs EventBridge—thumbnail sketch?

**Answer:** SQS: queue/load-level; SNS: fanout; EventBridge: content-based routing, SaaS integrations, schema registry—often combine SNS→SQS for fanout with per-consumer queues.

---

**Question:** Lambda cold start—mitigations?

**Answer:** Smaller artifacts, init outside handler, tuned memory (CPU scales), provisioned concurrency for tail latency sensitive paths—know 15-minute cap.

---

**Question:** NAT Gateway vs VPC endpoint?

**Answer:** NAT for general egress; Gateway Endpoints (S3/Dynamo free) and Interface Endpoints keep AWS API traffic private and can cut NAT GB charges—balance hourly interface cost vs data processing savings.

---

**Question:** KMS vs Secrets Manager quick contrast?

**Answer:** KMS: keys/envelope crypto; Secrets Manager: secret storage + rotation integrations + higher per-secret cost—use Parameter Store for non-secret config tiers.

---

**Question:** CloudTrail vs CloudWatch Logs?

**Answer:** CloudTrail: API audit across control plane (and optional data events); CloudWatch Logs: app/service logs and metric filters—different compliance vs observability roles.

### Senior Questions

### Question

How does S3 consistency affect pipeline design post-2020?

### Strong Answer

Strong read-after-write and list consistency for objects removes many client polling hacks after Put—but **CRR** remains asynchronous; bucket policy/CORS propagation is still eventual. Pipelines can rely on immediate reads after successful Put in a region, but cross-region readers need versioning + lag awareness or manifest markers.

### Explanation

Filters candidates stuck on old “eventual S3 read” folklore.

### Practical Example

Lambda on Put can read object immediately; multi-region DR reader must handle replica lag with version IDs or job state machine.

### What the Interviewer Is Testing

- Updated mental model
- Boundary conditions (CRR, metadata)

### Weak Answer

“S3 reads are eventually consistent—retry forever.”

### Red Flags

- Outdated consistency claims
- No CRR caveat

---

### Question

Design multi-AZ web tier + data—what breaks if you forget capacity?

### Strong Answer

ALB across AZs; compute private per AZ with autoscale sized so **N-1 AZ** still carries peak; RDS Multi-AZ or Aurora placement; caches multi-AZ; **each** AZ needs egress path (NAT per AZ pattern); verify quotas and subnets symmetrically. Forgotten math → partial outages during AZ loss.

### Explanation

Multi-AZ ≠ automatic magic—capacity and component coverage matter.

### Practical Example

Four tasks split 2/2 across AZs fails when one AZ dies if autoscaler max cannot rebalance to double stack surviving AZ quickly enough—test failover GameDay.

### What the Interviewer Is Testing

- Holistic stack thinking
- N-1 capacity literacy

### Weak Answer

“We enabled Multi-AZ RDS, so we’re resilient.”

### Red Flags

- Equates one checkbox with full-stack HA
- Ignores compute/NAT/cache symmetry

---

### Question

Choosing DynamoDB vs Aurora—framework?

### Strong Answer

DynamoDB when access patterns are crisp, item sizes controlled, horizontal scale with predictable per-request cost is valued, and joins are avoided. Aurora when relational model, ad hoc SQL/reporting, cross-row transactions, and flexible querying dominate. Both scale; **data shape and query unpredictability** decide.

### Explanation

Stops buzzword-driven datastore selection.

### Practical Example

Order cart + checkout with tight key access → Dynamo acceptable with modeled PK/SK; finance aggregations + constraints → Aurora.

### What the Interviewer Is Testing

- Access-pattern-first thinking

### Weak Answer

“DynamoDB because serverless scales more.”

### Red Flags

- Scale-driven without modeling
- Ignores SQL needs

---

**Question:** IAM policy evaluation order?

**Answer:** Implicit deny baseline; explicit deny wins; allows must exist via union within boundaries; SCPs and permission boundaries only shrink effective access.

---

**Question:** SQS Standard vs FIFO?

**Answer:** Standard: huge throughput, at-least-once, best-effort order; FIFO: ordering + dedup with throughput ceilings—consumers must be idempotent regardless.

---

**Question:** Aurora vs classic RDS?

**Answer:** Shared storage cluster, faster failover, many read replicas possible, different pricing—evaluate IOPS needs and ops savings vs budget.

---

**Question:** Secrets rotation pattern?

**Answer:** Secrets Manager + Lambda rotation handlers; support dual-secret window in apps; test rotation failures with alarms.

---

**Question:** VPC peering constraints?

**Answer:** Non-overlapping CIDRs; **non-transitive** graphs—use TGW for hub-and-spoke at scale.

---

**Question:** ALB health checks vs kube readiness?

**Answer:** Both must align timing—slow health checks prolong bad routing; coordinate deregistration delays and grace periods.

---

**Question:** EventBridge-driven design keys?

**Answer:** Schema registry, rule granularity, archive/replay; per-consumer SQS for backpressure and DLQs; idempotent handlers.

---

**Question:** Cost anomaly on NAT / data transfer?

**Answer:** Service map in Cost Explorer; add endpoints; fix cross-AZ chatter; tag offenders; educate engineers on AZ affinity.

---

**Question:** Lambda in VPC—pain points?

**Answer:** ENI/IP exhaustion risk on high concurrency; cold start penalty; need subnet sizing and careful concurrency design—monitor `ConcurrentExecutions` vs IP capacity.

### Tech Lead Questions

### Question

Multi-account strategy for ~200 engineers—outline?

### Strong Answer

Org + OUs separate prod/nonprod; security/log archive accounts; SCPs to prevent disabling logging/public s3 paths; workloads per team/app with guardrails; SSO-only human access; central networking optionally via shared services; automate account vending with Control Tower/ALZ patterns.

### Explanation

Balances blast radius with operational overhead.

### Practical Example

Deny `s3:PutBucketPublicAccess` org-wide; aggregate CloudTrail to immutable bucket in log archive.

### What the Interviewer Is Testing

- Landing-zone thinking
- SCP grasp

### Weak Answer

“One prod account, shared IAM users.”

### Red Flags

- Flat account chaos
- Long-lived keys

---

### Question

FinOps program for AWS—what do you institute?

### Strong Answer

Mandatory tags + budgets + anomaly detection; weekly service/team reviews; rightsizing & GP3 migration; Savings Plans after baseline stable; endpoints to cut NAT charges; educate on data transfer geometry; tie cost KPIs to engineering dashboards alongside reliability.

### Explanation

Shows economic ownership, not ticket reactive bill paying.

### Practical Example

Top NAT spend service moves S3/Dynamo access to VPC endpoints when math shows hourly interface costs < processed GB fees.

### What the Interviewer Is Testing

- Concrete levers
- Process + tooling

### Weak Answer

“Finance emails us when bill spikes.”

### Red Flags

- No accountability by tag/team
- Only RIs without analysis

---

### Question

Least-privilege IAM at org scale—how?

### Strong Answer

No humans with static keys; per-workload roles; tight resource ARNs; permission boundaries for delegated admin; Access Analyzer + Config rules; SCP guardrails; quarterly access reviews; CI lint on IAM templates.

### Explanation

Security as continuous process—aligns with modern AWS guidance.

### Practical Example

CI fails CDK/Terraform adding `*` actions on `*` resources without exception ticket.

### What the Interviewer Is Testing

- Governance tooling
- Cultural enforcement

### Weak Answer

“We use tight policies—trust our developers.”

### Red Flags

- Trust without automation
- No analyzer/SCP mention

---

**Question:** DR strategy pick for tiered workloads?

**Answer:** Match RPO/RTO to backup-restore, pilot light, warm standby, active-active; test quarterly; Multi-AZ is HA not full regional DR story.

---

**Question:** Serverless vs containers choice framework?

**Answer:** Event/spiky short work → Lambda; long connections, steady load, custom OS needs → ECS/Fargate/EC2; calculate GB-second vs always-on breakeven; watch cold starts and 15m limits.

---

**Question:** EventBridge + Step Functions—when together?

**Answer:** Sagas / multi-step workflows requiring visibility, retries, and compensations beyond raw Lambda glue—keep consumers idempotent.

---

**Question:** IaC: Terraform vs CDK criteria?

**Answer:** Multi-cloud vs AWS-centric typed constructs; state handling; pipeline maturity; pick one primary to reduce toolchain entropy.

---

**Question:** Incident triggered by AWS API throttle—lead response?

**Answer:** Identify exponential backoff bugs, account-wide limits vs per-resource; open limit cases if justified; architectural smoothing (queues, sharding); communicate customer impact timeline.

---

**Question:** A product team demands a new region for data residency—how do you phase work?

**Answer:** Classify data categories; pick smallest compliant footprint (maybe object storage + one service) before full multi-region active-active; model **egress and replication** cost; automate with parameter packs in IaC; run game days on failover assumptions—not checkbox expansion.

---

**Question:** CloudFront + ALB + Cognito—where do you terminate TLS and why?

**Answer:** Often TLS at CloudFront to users, optional re-encrypt to ALB for zero-trust between edge and origin; terminate JWT validation at ALB/API GW layer with short-lived credentials to services. Document compliance needs (PCI segmentation) before picking “TLS end-to-end vs offload.”

### Scenario-Based Questions

**Question:** Serverless ingestion: S3 → validate → transform → Dynamo—sketch resilient flow.

**Answer:** S3 event to lightweight validator; valid messages to SQS with DLQ; transform Lambda with reserved concurrency; idempotent writes keyed; lifecycle old objects; Step Functions/Fargate for >15m heavy transforms.

---

**Question:** $50k/mo bill +40%—first week actions?

**Answer:** Cost Explorer by service/tag; attack NAT, idle EBS/snapshots, rightsizing, data transfer cross-AZ, S3 tiering; quick governance alerts; assign owners.

---

**Question:** Multi-region RPO 5m / RTO 15m passive-active.

**Answer:** Aurora cross-region replica, Route53 health failover, minimal warm ECS, parameterize IaC for region flip, rehearse promotion + DNS TTL assumptions.

---

**Question:** Lambda timeouts under load—diagnose tree.

**Answer:** Check throttles, duration, downstream latencies via X-Ray; ENI/IP for VPC; memory/CPU tuning; batch size for pollers; concurrency limits versus account caps.

---

**Question:** E-commerce order saga on AWS—components?

**Answer:** EventBridge/SNS fanout to SQS per consumer; idempotent handlers; Step Functions for orchestrated compensations; DLQs everywhere.

---

**Question:** Deployment safety baselines for prod?

**Answer:** Pipeline-only deploys, IaC review with second pair, progressive rollout + auto rollback on SLO breach, feature flags, migration pipelines separated, post-deploy smoke checks.

### Trick Questions

**Question:** Does Multi-AZ RDS replace cross-region DR?

**Answer:** No—same-region failure modes vs regional disaster; different RPO/RTO needs; backups and runbooks still required.

---

**Question:** Are S3 bucket policies instantaneous globally?

**Answer:** Configuration and permission propagation can lag; don’t assert immediate consistency for control plane edits; test before relying in automation loops.

---

**Question:** Is FIFO SQS “exactly-once everything”?

**Answer:** Exactly-once **processing** semantics within constraints—not a magic blanket; consumers still design for duplicate delivery edge cases.

---

**Question:** “Encrypt everything with KMS customer keys solves compliance.”

**Answer:** Keys reduce raw data exposure but don’t replace network controls, IAM, logging, or application-level crypto needs—encryption is one layer.

### Weak Answers and Red Flags

1. **“We’re safe because we’re in a private VPC—no security group work needed.”** Misunderstands east-west threat models and IAM—signals weak network depth.
2. **“Lambda auto-scales forever—no capacity planning.”** Account concurrency, downstream DB pool limits, and budget caps bite—signals missing systems thinking.
3. **“We’ll use Cross-Region Replication for S3 and call DR done.”** Without tested restore/failover routing and RPO proof, it is a checkbox, not a program.
4. **“Reserved Instances fix our bill.”** Without rightsizing and modernization first, commits can cement waste—signals finance-only lever misuse.

## JavaScript

### Basic Questions

**Question:** How do `let`, `const`, and `var` differ in scope, hoisting, and reassignment?

**Answer:** `var` is function-scoped, hoisted and initialized to `undefined`, and can be redeclared in the same scope. `let` and `const` are block-scoped, hoisted into a temporal dead zone until the declaration runs, and cannot be redeclared. `const` forbids rebinding the identifier; neither freezes nested objects. Prefer `const` by default, `let` when reassignment is required, and avoid `var` in new code. Trade-off: TDZ catches accidental use-before-declaration bugs but requires discipline in declaration order.

---

**Question:** What does the JavaScript event loop actually coordinate?

**Answer:** A single call stack runs synchronous code to completion, then the engine drains the microtask queue (Promises, `queueMicrotask`), then runs one macrotask (timers, I/O, user events). It provides concurrency on one thread: work is interleaved, not parallel. In production, starving macrotasks with endless microtasks causes UI freezes or delayed I/O callbacks.

---

**Question:** Why do developers reach for nullish coalescing (`??`) instead of `||`?

**Answer:** `||` treats many falsy values (`0`, `""`, `NaN`) as “empty,” which is wrong when those are valid data. `??` only substitutes for `null` and `undefined`. Example: `count ?? 10` keeps `0`; `count || 10` does not. Trade-off: `??` is narrower; you still need explicit handling for empty strings when they mean “missing.”

---

**Question:** What is a closure, and why does it matter for components and callbacks?

**Answer:** A closure pairs a function with the lexical environment where it was created, so outer bindings stay reachable after the outer function returns. That enables private state and factory patterns but also retains memory when references leak to timers or caches. Teams should pair closures with clear teardown (AbortController, clearing intervals) in long-lived surfaces.

---

**Question:** How does the prototype chain resolve property access?

**Answer:** Reads walk from the object to `[[Prototype]]` until the property exists or the chain ends at `null`. Classes attach methods on the prototype; fields usually live on the instance. Trade-off: shared prototype methods save memory but mutable prototype patches affect all instances.

---

**Question:** What is the temporal dead zone for `let`/`const`?

**Answer:** From block entry until the declaration executes, the binding exists but must not be read; it throws `ReferenceError`. Unlike `var`, there is no `undefined` placeholder. This surfaces bugs where code ran “accidentally” before initialization under `var`.

---

**Question:** When would you choose `Promise.all` over `Promise.allSettled`?

**Answer:** `Promise.all` fails fast on the first rejection—use when all results are required for a coherent outcome (e.g., loading dependent config shards). `Promise.allSettled` returns per-promise status—use for independent probes, bulk health checks, or partial success. Trade-off: `allSettled` never rejects the aggregate; callers must inspect each entry.

---

**Question:** How do debouncing and throttling differ for browser handlers?

**Answer:** Debounce fires once after a quiet period—good for search boxes. Throttle caps how often a handler runs—good for scroll or resize. Both reduce work; neither replaces profiling when INP is poor. Passive listeners and rAF gates are often paired with throttle for scroll.

---

**Question:** What problem does `AbortController` solve in modern JS?

**Answer:** Cooperative cancellation: `signal` threads into `fetch`, event listeners, and custom async flows. Calling `abort()` marks the signal and rejects fetches with `AbortError`. Teams should standardize on it instead of ad-hoc boolean flags so teardown stays consistent and testable.

---

**Question:** Why can microtasks starve the UI or macrotasks?

**Answer:** Microtasks run until empty after each synchronous chunk. A chain that schedules another microtask synchronously never yields to macrotasks, delaying paints and timers. Production symptom: “the page is stuck” while Promises recurse.

---

**Question:** What is the practical difference between shallow and deep copying?

**Answer:** Shallow copy duplicates top-level keys but shares nested references (`structuredClone` or manual recursion for deep). Spread feels like isolation but nested mutation leaks. Choose deep copy when crossing trust boundaries or caching derived graphs; accept shallow when structures are flat or immutable.

---

**Question:** How does `this` differ between arrow functions and ordinary functions?

**Answer:** Ordinary functions bind `this` by call site (method, plain, `new`, explicit `bind`). Arrow functions close over lexical `this`. Use arrows for callbacks inside methods; avoid them as methods on prototypes or constructors. Misuse shows up as `undefined` `this` or illegal `new`.

### Senior Questions

**Question:** Contrast concurrency and parallelism in typical browser and Node workloads.

**Answer:** Concurrency interleaves many tasks on one thread via the event loop. Parallelism runs work at the same time on multiple threads (Workers, worker_threads). I/O-heavy services stay concurrent; CPU-heavy hot paths may need workers. Trade-off: workers pay structured-clone or transfer costs—batch messages, not per-frame chatter.

---

### Question

Walk through the execution context lifecycle and what it explains when debugging.

### Strong Answer

Each invocation pushes an execution context: creation allocates bindings (hoisting, `this`, outer reference), execution runs instructions and nested calls push more contexts, teardown pops on return or throw. The active stack is what `Error.stack` reflects. Async callbacks often run after outer contexts popped, which is why async stack traces look “short” unless the engine augments them.

### Explanation

This bridges hoisting bugs, closure retention, and “where did `this` go?”—all interview signals that you think in terms of what the engine actually does, not only syntax.

### Practical Example

```js
function outer() {
  const x = 1;
  return function inner() {
    return x;
  };
}
const fn = outer(); // outer's context is retained for inner's closure
```

### What the Interviewer Is Testing

- Whether you connect stack + scopes to real debuggability.
- Awareness of async stack limitations.

### Weak Answer

“The call stack is where functions run when you call them.”

### Red Flags

- Cannot tie creation phase to hoisting/`this`.
- Thinks stacks fully explain async failures.

---

**Question:** Why can closures contribute to memory leaks, and how do you harden real codebases?

**Answer:** Closures keep whole outer environments alive if anything long-lived holds the inner function—timers, DOM listeners, module-scope caches. Fix with bounded caches, teardown hooks, `WeakMap` for ancillary metadata, and cancelable async (`AbortController`). Production-wise: monitor heap slope, diff heap snapshots under load, and review hot paths for accidental captures of large graphs.

---

**Question:** How does the dual-package hazard show up when mixing ESM and CJS in Node?

**Answer:** Two physical copies of one logical package can load—singletons double, `instanceof` breaks, identity checks fail. Mitigate with clear `"exports"`, consistent module resolution in tooling, and tests that exercise both entry paths consumers use. At lead level you sequence migrations to avoid half-converted graphs.

---

**Question:** What goes wrong if microtasks enqueue more microtasks in a tight loop?

**Answer:** The runtime keeps draining microtasks until empty, so macrotasks (paint, timer) wait indefinitely. Symptoms resemble infinite-loop freezes without blowing the stack. Breaking the chain with scheduling to macrotasks or chunking work restores fairness.

---

**Question:** How do `Promise.race` and `Promise.any` differ in failure modes?

**Answer:** `race` settles with the first settled promise—rejection wins if it arrives first. `any` fulfills on first fulfillment and only rejects if every input rejects (`AggregateError`). Use `race` for timeouts; `any` for redundant providers. Mis-picking loses timeouts or masks total outage.

---

### Question

You need bounded concurrency over thousands of tasks—how do you implement it without wedging the pool on errors?

### Strong Answer

Maintain a limit of in-flight promises, dequeue as slots free, and decrement the in-flight count in `finally` so rejections do not strand capacity. Libraries like `p-limit` encode this; hand-rolled versions must guard shared indexes atomically or use worker-style task queues.

### Explanation

Interviewers probe whether you understand backpressure and failure propagation, not whether you memorized `Promise.all`.

### Practical Example

```js
async function mapPool(items, limit, mapper) {
  const out = new Array(items.length);
  let i = 0;
  async function worker() {
    while (i < items.length) {
      const idx = i++;
      out[idx] = await mapper(items[idx]);
    }
  }
  await Promise.all(Array.from({ length: limit }, worker));
  return out;
}
```

Add `try/finally` around `mapper` if you need per-item error policy.

### What the Interviewer Is Testing

- Concurrency control + error hygiene.
- Awareness that rejections must release slots.

### Weak Answer

“Chunk the array and `Promise.all` each chunk.”

### Red Flags

- No `finally` or error path discussion.
- Ignores memory or head-of-line blocking trade-offs.

---

**Question:** When are generators or async iterators worth shipping in application code?

**Answer:** Useful for lazy pulls (pagination streams), cooperative iteration, or bridging push sources to consumers without buffering everything. Trade-off: mental overhead and debugger complexity versus simpler async functions. Avoid when a plain async pipeline with clear stages is clearer for the team.

---

**Question:** What are realistic production uses of `Proxy`, and what does it cost?

**Answer:** Proxies intercept operations for validation, revocable handles, instrumentation, or narrow reactive layers. Cost: slower property access and harder stacks. Use at module or façade boundaries, not inner loops of tight numeric code.

---

**Question:** Explain `WeakRef`/`FinalizationRegistry` without promising deterministic cleanup.

**Answer:** They let you associate cleanup or cache eviction with GC reclaim—good for non-critical caches. They must not gate correctness because finalizers run late or never under pressure. Pair with explicit caps for anything user-visible.

---

**Question:** Why can `JSON.parse(JSON.stringify(obj))` be a risky “deep clone,” and when is `structuredClone` a better fit?

**Answer:** JSON round-trips lose `Date`, `Map`, `Set`, `undefined`, functions, and cycles; numbers may lose precision. `structuredClone` preserves many built-ins and cycles but still cannot clone functions or DOM nodes. Pick based on data shape; validate with tests when switching strategies.

---

**Question:** What breaks when code assumes object key order is insertion-ordered in all engines for all operations?

**Answer:** Modern engines preserve insertion order for string keys in practice, but relying on implicit order for logic that must be portable across runtimes, serializers, or `JSON.stringify` is fragile. Prefer explicit arrays, `Map` for ordered pairs, or sorted keys when order is part of the contract.

---

### Tech Lead Questions

**Question:** How would you stage a broad CommonJS → ESM migration across many internal packages?

**Answer:** Map dependents, migrate leaves first, add `"exports"` and tests per package, use dynamic import shims where ancestors are not ready, and gate CI so hybrid states are observable. Communicate dual-package risk and timebox hybrid mode. Roll forward with soak time per wave rather than a flag-day flip.

---

### Question

Production Node drops requests under spike load—how do you triage without guessing?

### Strong Answer

Tie symptoms to metrics: event-loop lag, RSS trends, active handles, upstream latency, pool saturation, and deploy correlation. If lag tracks errors, profile or capture CPU. If heap climbs monotonically, compare snapshots. If external dependency limits match, tune pools or circuit-break. Roll back recent releases early while gathering artifacts.

### Explanation

Tests structured diagnosis versus log sprawl and whether you know Node-specific telemetry.

### Practical Example

Dashboard path: p(err rate) → p99 latency → `nodejs_eventloop_lag` → compare heap before/after → `perf` or V8 log if CPU bound.

### What the Interviewer Is Testing

- Hypothesis order and tooling literacy.
- Safety mindset (rollback + evidence).

### Weak Answer

“SSH in and add logs.”

### Red Flags

- No event-loop or heap angle.
- Refusal to consider deploy causality.

---

**Question:** How do you keep Promise rejections from reaching production silently?

**Answer:** Lint `no-floating-promises`, add unhandled-rejection handlers with structured logging, and teach that fire-and-forget Promises are akin to uncaught throws. Service policy may exit on fatal rejections with a supervisor restart; browsers should forward to monitoring. Balance: noisy handlers without lint still miss paths.

---

**Question:** What is your approach to polyfills versus dropping old browsers?

**Answer:** Use traffic analytics and contracts to set a matrix; differential serving splits modern vs legacy bundles. Libraries should not silently polyfill globals—consumers decide. Revisit quarterly because support cost is real operational load.

---

**Question:** When is streaming HTTP responses preferable to buffering everything?

**Answer:** Large or unbounded bodies keep memory bounded and start bytes sooner. Trade-off: status codes and headers are mostly fixed once bytes flow—error handling must shift to trailers, mid-stream failures, or client tolerance. Good for exports and proxies; awkward for small JSON RPC envelopes.

---

**Question:** How do you decide build-vs-buy for small utilities?

**Answer:** Prefer platform APIs first, inline truly tiny pure helpers, adopt maintained packages for subtle domains (dates, encodings, crypto), and weigh license, bundle impact, and fork risk. Document the decision in ADRs when teams disagree.

---

### Question

What conventions do you set for errors that cross HTTP, queues, and UI boundaries?

### Strong Answer

Normalize domain errors with stable codes, map them at edges to HTTP statuses or user-visible messages, log unexpected failures with `cause`, and ban `throw` literals. TypeScript callers should narrow `unknown` in `catch`. Review for missing mapping tables—otherwise every service invents its own shape.

### Explanation

Leaders are judged on consistency that scales review and on-call, not on personal try/catch style.

### Practical Example

```ts
class DomainError extends Error {
  constructor(readonly code: string, message: string, options?: ErrorOptions) {
    super(message, options);
    this.name = "DomainError";
  }
}
// Boundary: map DomainError -> 409/422, unknown -> 500 + fingerprint
```

### What the Interviewer Is Testing

- Boundary discipline and operability.
- Relationship between product messaging and internal logs.

### Weak Answer

“We log whatever the catch gives us.”

### Red Flags

- String-only errors forever.
- No monitoring contract.

---

**Question:** How do you govern third-party scripts that hurt main-thread responsiveness?

**Answer:** Measure long tasks and INP, defer nonessential loads, negotiate vendor fixes, isolate when feasible, and gate marketing tags with governance. Leadership angle: cost/benefit reviews and contracts, not only frontend tricks.

---

**Question:** What guardrails reduce leaked globals and forbidden dynamic code (`eval`)?

**Answer:** ESLint `no-eval`, CSP `script-src` constraints, reviews for `new Function`, and security sign-off for rare template engines. Pair policy with education so engineers know why stringly code breaks audits.

---

**Question:** How should feature flags be shaped so JS code stays maintainable?

**Answer:** Evaluate at route or feature shells, centralize definitions, default safe, test both paths, and sunset quickly. Track active flags to prevent stale branches that explode test matrices.

### Scenario-Based Questions

**Question:** A dashboard blocks the main thread for seconds parsing an 8 MB JSON blob. Users say the tab freezes. What is your first production-safe move?

**Answer:** Move parse off-thread (Worker) while negotiating pagination or chunked APIs with backend. Short term, worker + progressive UI; long term, contract change so payload fits UX budgets. Validate with metrics on long tasks before/after.

---

**Question:** After a deploy, memory on a long-lived gateway climbs linearly until OOM. Where do you start?

**Answer:** Confirm leak vs cache growth via snapshots minutes apart, inspect retainers for closures and timers, map to recent changes, and roll back if unclear. Add guardrails (cache TTL) once the retaining path is known.

---

**Question:** Two packages in one process import “the same” library but see different class prototypes. What happened?

**Answer:** Duplicate installation/version skew or ESM/CJS double load broke identity. Align versions, fix resolution (`exports`), and dedupe lockfile. Explain to stakeholders why this class of bug is subtle and expensive.

---

**Question:** CI flakes on timing-sensitive tests only on slow agents. How do you stabilize the suite?

**Answer:** Fake timers, deterministic awaits, isolate shared state, and ban real network in unit tests. Address ordering assumptions on object iteration. Leadership: time-box flake debt like any outage work.

---

**Question:** A vendor SDK mutates globals and breaks strict CSP. How do you respond cross-functionally?

**Answer:** Prototype isolation strategies (iframe boundaries), measure perf impact, and escalate product/vendor decisions with security in the loop. Engineering alone cannot accept perpetual CSP exceptions without risk owners.

---

**Question:** Your SPA bundles both modern and legacy builds; analytics shows legacy share is 0.3%. How do you propose dropping it?

**Answer:** Present data, QA impact, phased ramp-down, rollback plan, and comms to support. Tie to reduced build time and fewer polyfill defects. Avoid abrupt cuts without business sign-off.

### Trick Questions

**Question:** “`const` makes objects immutable—true or false?”

**Answer:** False: `const` freezes the binding, not the object’s properties. Immutability needs discipline, `Object.freeze` (shallow), or persistent data libraries. Many candidates confuse immutability marketing with JS semantics.

---

**Question:** “`==` is always unsafe, so we ban it entirely.”

**Answer:** `==` is usually avoided, but blanket bans ignore intentional coercion cases (rare) and distract from real bugs like mistaken truthiness. Prefer `===`, document any intentional coercion, and lint thoughtfully—not performatively.

---

**Question:** “We should move all heavy work to Web Workers because the event loop is slow.”

**Answer:** I/O-bound work already yields; workers help CPU-bound chunks. Misapplying workers adds copy costs and complexity. Profile first; choose the model that matches the bottleneck.

---

**Question:** “JSON.parse can be chunked to avoid blocking.”

**Answer:** Standard `JSON.parse` is atomic; chunking requires streaming parsers or format changes. Assuming chunking exists hides the real fix (smaller payloads, workers, alternate formats).

### Weak Answers and Red Flags

1. **“The event loop is multithreaded.”** It confuses concurrency with parallelism—fix with worker model clarity; red flag if they double down when corrected.
2. **“We’ll add `async` to everything so it’s non-blocking.”** `async` does not offload CPU work; red flag conflates syntax with scheduling.
3. **“Microtasks and macrotasks are the same queue.”** Shows lack of starvation intuition; likely to mis-debug UI jank.
4. **“Strict mode is only for TypeScript projects.”** Misses runtime/SM differences and ESM defaults—signals shallow fundamentals.

---

## TypeScript

### Basic Questions

**Question:** What is structural typing, and how does it differ from nominal typing?

**Answer:** Assignability depends on shape, not declared names or inheritance. You can pass a matching object without `implements`. Trade-off: accidental compatibility (“duck typing surprises”) versus flexibility. Nominal brands can encode intent when shape collisions hurt safety.

---

**Question:** When do you pick `interface` versus `type`?

**Answer:** Interfaces merge and extend cleanly for public object contracts; types express unions, intersections, mapped/conditional forms. Many teams default to `interface` for exported object shapes and `type` for unions. Consistency beats personal taste across large repos.

---

**Question:** What is type narrowing, and what triggers it?

**Answer:** Refinements from `typeof`, `instanceof`, `in`, equality guards, discriminated unions, and user-defined predicates shrink types inside branches. Without narrowing, operations on `unknown` or broad unions remain illegal—by design.

---

**Question:** How do `any` and `unknown` differ in practice?

**Answer:** `any` disables checking bidirectionally; `unknown` accepts all inputs but demands checks before use. Prefer `unknown` at boundaries, `any` should be rare and linted. Trade-off: more boilerplate vs fewer mystery crashes.

---

**Question:** What does the `never` type represent?

**Answer:** Unreachable values—exhausted switches, functions that always throw, impossible branches. It enables compile-time exhaustiveness checks. If `never` appears unexpectedly, your union handling is incomplete.

---

**Question:** What is a discriminated union and why is it valuable?

**Answer:** Objects share a literal discriminant (`kind: "a" | "b"`); switch/if narrows members safely. It replaces stringly-typed flags and catches missing cases when paired with `never` checks.

---

**Question:** What is `satisfies`, and how does it differ from assertion?

**Answer:** `satisfies` verifies a value against a constraint without widening literals; `as` overrides the checker and can lie. Use `satisfies` for config objects where you want precise literals plus validation.

---

**Question:** Why does excess property checking exist, and where does it not apply?

**Answer:** Object literals assigned to a typed target get extra-key detection to catch typos. Assigning from a widened variable skips the check—still not a runtime guarantee. Teach juniors this distinction to avoid false confidence.

---

**Question:** What does `strictNullChecks` change about everyday code?

**Answer:** `null`/`undefined` no longer silently assign to primitives; you guard, narrow, or document invariants. It is one of the highest ROI flags and often the noisiest migration—plan incremental fixes.

---

**Question:** Why is `noUncheckedIndexedAccess` worth considering?

**Answer:** Indexing returns `T | undefined`, forcing you to handle holes/unknown keys. It removes a common crash class at the cost of verbosity—pair with helpers or `.at()` thoughtfully.

---

**Question:** What happens to types after compilation?

**Answer:** They erase completely—no runtime reflection of interfaces or generics. Validation at boundaries still needs schemas or classes. Plans that assume runtime types exist will fail.

---

**Question:** What is a mapped type, and what is a common use?

**Answer:** `{ [K in keyof T]: ... }` transforms each property—think `Readonly`, `Partial`, or key remaps. Trade-off: deeply recursive mapped types can slow the checker; watch build times.

### Senior Questions

**Question:** Explain variance as it surfaces in TypeScript function assignability.

**Answer:** Returns covariant; parameters contravariant under `strictFunctionTypes` (with historical bivariance exceptions for some React handlers). Misunderstanding leads to subtle unsound callbacks—know why assigning a `(base) => void` where `(derived) => void` is expected is restricted.

---

### Question

How do distributive conditional types behave, and how do you stop distribution when needed?

### Strong Answer

A conditional `T extends U ? X : Y` distributes when `T` is a naked type parameter union, applying the condition per member. To keep the union intact, wrap in a tuple `[T] extends [U] ? X : Y`. This shows up in utility authoring and surprises people building `ToArray` helpers.

### Explanation

Interviewers want evidence you’ve been burned by—or carefully read about—conditional type expansion, not that you quote the handbook.

### Practical Example

```ts
type ToArray<T> = T extends any ? T[] : never;
type A = ToArray<string | number>; // string[] | number[]

type ToArrayNonDist<T> = [T] extends [any] ? T[] : never;
type B = ToArrayNonDist<string | number>; // (string | number)[]
```

### What the Interviewer Is Testing

- Mental model of type-level evaluation.
- Ability to control distribution intentionally.

### Weak Answer

“Conditional types are like ternaries for types.”

### Red Flags

- Cannot fix accidental distribution bugs.
- Confuses `extends` in generics with conditional `extends`.

---

**Question:** How do branded types reduce accidental cross-wiring?

**Answer:** Phantom brands make distinct nominal-like aliases over the same runtime shape—`UserId` vs `OrgId`. Creation requires factories/assertions, which is the trade-off for fewer mix-ups in large codebases.

---

**Question:** Why prefer `unknown` in `catch`, and what pattern follows?

**Answer:** Anything can be thrown; `unknown` forces narrowing (`instanceof Error`) before reading fields. With `useUnknownInCatchVariables`, you kill another `any` leak.

---

**Question:** What does `verbatimModuleSyntax` protect against in modern builds?

**Answer:** It forces explicit `import type` / `export type`, aligning TS with transpilers that might drop imports incorrectly. It prevents “this was only a type but swc erased the runtime import” incidents.

---

**Question:** How do you type higher-order functions without losing parameter/return precision?

**Answer:** Capture `T extends (...args: any[]) => any` and thread `Parameters<T>` plus `ReturnType<T>` (or `Awaited<>` for async). Verify edge cases with `any[]` constraints versus tuple preservation.

---

**Question:** What is dangerous about `Omit` with mistyped keys?

**Answer:** `Omit<User, "oops">` silently yields `User` if `"oops"` is unrelated—typos hide. Prefer `Pick` when enumerating allowed fields or constrain keys to `keyof T`.

---

### Question

How do you choose runtime validation tech for shared API boundaries?

### Strong Answer

Score integration (`z.infer`-style inference), bundle weight, error ergonomics, ecosystem fit, and team familiarity. Require a single library per repo where possible to avoid two error dialects. The schema must be authoritative—never duplicate hand-written types that can drift.

### Explanation

Leaders pick tooling that scales governance, not whichever README was read last.

### Practical Example

ADR template: options (Zod, io-ts, valibot), measured bundle deltas, migration cost, testing plan.

### What the Interviewer Is Testing

- Decision framework vs hype.
- Awareness of type/schema drift risk.

### Weak Answer

“We use whatever the blog recommends.”

### Red Flags

- No mention of single source of truth.
- Ignores bundle or FP stack coupling.

---

**Question:** How do declaration merging and module augmentation differ in placement?

**Answer:** Ambient `declare module` in script scope establishes modules; augmentations in modules extend existing exports (e.g., Express `Request`). Misplacement yields “cannot find module” churn—document patterns in onboarding.

---

**Question:** When are function overloads preferable to conditional return types?

**Answer:** Few human-readable cases favor overloads; many-branch APIs may need conditional returns—accept some `as` inside implementations after checks. Readability for maintainers is the tie-breaker.

---

**Question:** What does `as const` change at the type level, and what mistakes does it prevent?

**Answer:** It narrows literals to their literal types and makes arrays readonly tuples instead of widen-to-primitive arrays—handy for route tables and config discrim unions. Mistake: sprinkling `as const` on large mutable structures and then mutating them—TS allows fewer writes but runtime still mutates; pair with real immutability discipline.

---

**Question:** How does `enum` differ from string-literal unions plus `as const` objects in terms of emit and ergonomics?

**Answer:** Numeric `enum` emits reverse mappings and extra runtime objects; string enums and const-object patterns often tree-shake cleaner. Unions avoid surprise numeric coercion bugs but lose namespaced dot access unless you build maps. Pick per team style guide—consistency beats zealotry.

### Tech Lead Questions

**Question:** How do you migrate a very large JS codebase to strict TypeScript without freezing features?

**Answer:** Enable targeted flags, ratchet error counts in CI, scope strict dirs for new code, codem critical paths, and schedule backbone packages first. Communicate timelines; avoid big-bang “stop the world” PRs.

---

### Question

How do you keep shared FE/BE types honest as services deploy independently?

### Strong Answer

Treat compile-time types as non-authoritative across network boundaries unless generated from the same schema as runtime validation effort matches risk (internal vs external). Prefer OpenAPI/GraphQL/tRPC generation, contract tests, or shared packages with semver majors on breaks.

### Explanation

The anti-pattern is “we import the same interface therefore runtime is safe.” Deploy skew breaks that assumption.

### Practical Example

`openapi-typescript` output consumed by web and node services; breaking schema changes fail CI in both.

### What the Interviewer Is Testing

- Systems thinking about deploy order.
- Balance pragmatism vs validation overhead.

### Weak Answer

“TypeScript already guarantees the contract.”

### Red Flags

- No runtime guard story for cross-team APIs.
- No versioning plan.

---

**Question:** How do you prevent type-level “cleverness” from blocking onboarding?

**Answer:** Cap conditional depth, require tests for exotic utilities, document intent, and review types like runtime code. If a type needs a whiteboard weekly, refactor toward named aliases and fewer layers.

---

**Question:** What is your upgrade policy for TypeScript across a monorepo?

**Answer:** Pin a single version, schedule intentional upgrades with notes scanning, run full builds, and avoid drifting ranges that surprise CI. Communicate inference changes to feature teams.

---

**Question:** How do you minimize unsafe `as` casting at trust boundaries?

**Answer:** Pair lint rules, schema validation, and code review checklists. Allow narrow casts (e.g., DOM targets) with comments. Track assertion counts downward over quarters.

---

**Question:** When might you skip TypeScript for a piece of code?

**Answer:** Tiny one-off scripts, constrained runtimes without tooling, or build steps where typecheck cost dwarfs benefit—decide with explicit criteria, not ad-hoc feelings.

---

### Question

How do you shorten CI TypeScript time as the graph grows?

### Strong Answer

Split emit (`swc`/`esbuild`) from `tsc --noEmit`, adopt project references + incremental artifacts, use `skipLibCheck` knowingly, cache `*.tsbuildinfo`, and profile hot files with `--extendedDiagnostics`. Sometimes simplify pathological generics.

### Explanation

Build time is a product constraint; leaders who ignore it invite skipped local checks.

### Practical Example

Report before/after incremental timings in CI logs; alert if typecheck regresses >10% week over week.

### What the Interviewer Is Testing

- Profiling literacy.
- Knowledge of references vs monolithic projects.

### Weak Answer

“Buy bigger CI machines.”

### Red Flags

- No incremental strategy.
- Confuses transpile speed with typecheck speed.

---

**Question:** How do you publish internal libraries without surprise breaking consumers?

**Answer:** Semver discipline, API extraction checks, migration guides, deprecations with timelines, and optional codemods. Coordinate majors across many services with comms channels.

---

**Question:** How do you handle dependencies lacking types?

**Answer:** Prefer `@types`, upstream fixes, minimal local declarations for used surface, or typed adapters—avoid blanket `any` modules that silence everything.

---

**Question:** What is your stance on TC39 vs legacy decorators during ecosystem transition?

**Answer:** Follow framework guidance; mixing systems is brittle. Plan upgrades with bundler matrix awareness and avoid custom decorators ahead of platform support commitments.

### Scenario-Based Questions

**Question:** Two services share hand-written `Payment` types; production crashes on a new field. What failed?

**Answer:** Schema drift across deploys—types lied. Introduce generated schema + validation or contract tests and align release notes. Short term: feature flag risky payloads.

---

**Question:** A dev uses `as any` to unblock a release overnight—now it spreads. What process fixes it?

**Answer:** Lint regression, ticket with owner, time-box removal, and education on narrowing/`unknown`. Leaders treat `any` like incident debt with visible burn-down.

---

**Question:** Strict null adoption explodes errors in legacy forms—team morale tanks. What path preserves velocity?

**Answer:** Focus high-risk modules first, add helpers, allow pragmatic assertions with tickets, and mix strict islands. Celebrate incremental metrics, not binary completion.

---

**Question:** Editor performance tanks after a fancy mapped type lands in a shared util. What now?

**Answer:** Profile checker cost, break types into aliases, reduce recursion depth, and add guidance on acceptable complexity. Possibly move validation runtime-side if types attempted too much.

---

**Question:** `exactOptionalPropertyTypes` breaks many builds—should you enable org-wide day one?

**Answer:** Pilot in new packages, document migration patterns (`delete` vs assign), and assess library interactions. Broad enable without training floods support noise.

---

**Question:** A contractor adds `declare module "*"` with `any` exports to silence errors. What is the risk and fix?

**Answer:** You lose all safety for untyped imports—replace with minimal truthful declarations, prioritize critical paths, and review dependency policies.

### Trick Questions

**Question:** “Generics exist at runtime so we can branch on `T`.”

**Answer:** Generics erase; runtime branching needs values (discriminants), `instanceof`, or schema tags. Candidates stuck here misunderstand TS’s compile-only model.

---

**Question:** “Structural typing means two interfaces with identical fields are always interchangeable in every API.”

**Answer:** Mostly true for shape, but branding, private fields, and conditional types can still distinguish intent. Also, excess checks differ for literals vs widened values.

---

**Question:** “`enum` is the best default for string constants.”

**Answer:** Const objects + `as const` unions often compile cleaner, avoid runtime objects you did not intend, and tree-shake better—`enum` has niche uses but is not a default without trade-off discussion.

---

**Question:** “If `strict` is on, no validation is needed.”

**Answer:** Types vanish at runtime; external data remains untrusted. Strict mode helps in-editor, not across the wire.

### Weak Answers and Red Flags

1. **“We’ll fix types later; ship `any` now.”** Without a ratchet, later never comes—signals weak governance.
2. **“Interfaces are faster than types.”** Perpetuates trivia-level reasoning instead of measurable build profiling.
3. **“Tests replace the need for strict null.”** Orthogonal guarantees—red flag if used to dodge compiler aid.
4. **“We share DTOs via Slack.”** Manual sync always drifts—shows immature engineering process.

---

## Angular

### Basic Questions

**Question:** How does Angular’s hierarchical injection resolve a service token?

**Answer:** The lookup walks component injectors toward parents until a provider is found, else optional/null or error. `providedIn: 'root'` registers a singleton with tree-shake friendly scope. Trade-off: component-scoped providers isolate state but increase memory if overused.

---

**Question:** What distinguishes a component from a directive?

**Answer:** Components own templates and create elements; directives augment existing nodes (attribute or structural). Pick components for cohesive UI pieces; directives for cross-cutting DOM behavior.

---

**Question:** What triggers change detection under `OnPush`?

**Answer:** Input reference changes, events originating in the component, explicit `markForCheck`, async pipe emissions, signal reads used by the template. Mutation pitfalls and zone escapes are common bug sources.

---

**Question:** Why is the `async` pipe recommended for Observables in templates?

**Answer:** It subscribes/unsubscribes with component lifecycle and nudges `OnPush` when values arrive—reducing leak patterns from manual subscriptions.

---

**Question:** Why prefer `ngOnInit` over the constructor for input-dependent setup?

**Answer:** Inputs are not guaranteed in constructors; `ngOnInit` runs after binding setup. Constructors stay for DI wiring only in many style guides.

---

**Question:** What are standalone components and how do they change architecture?

**Answer:** `standalone: true` components declare imports locally without NgModule wiring—leaner graphs and improved tree-shaking. Teams migrate route configs toward `loadComponent` patterns.

---

**Question:** What problem does lazy loading solve in Angular apps?

**Answer:** Splits routes into chunks to shrink initial bundles and improve time-to-interactive. Requires thoughtful route boundaries and preload strategies.

---

**Question:** How does Zone.js relate to change detection historically?

**Answer:** It monkey-patches async APIs to notify Angular when to run CD. It simplifies DX at the cost of overhead—modern signal/zoneless directions aim to reduce surprises from async “invisible” to Angular.

---

**Question:** What is the new control-flow syntax (`@if`, `@for`, `@switch`)?

**Answer:** Built-in blocks replace structural directives with clearer branching; `@for` mandates `track` for efficient reconciliation—similar concerns to React keys.

---

**Question:** What does `providedIn: 'root'` buy you versus NgModule `providers`?

**Answer:** Single tree-shakable registration site; avoids importing modules solely for providers and clarifies singleton intent.

### Senior Questions

### Question

Describe `OnPush` pitfalls and how you coach a team to avoid them.

### Strong Answer

Triggers require new input references or explicit signals to CD; mutating arrays/objects in place stalls updates unless you signal. Zone escapes from third-party callbacks need `NgZone.run` or `markForCheck`. Pair OnPush with immutable data patterns and code review rules—default schematic, not optional lore.

### Explanation

Interviewers want demonstration of teaching + enforcement, not one-line definitions.

### Practical Example

```ts
// Bad: mutates array in place; OnPush may not refresh
this.items.push(next);
// Better: new reference
this.items = [...this.items, next];
```

### What the Interviewer Is Testing

- Knowledge of triggers and failure modes.
- Leadership via defaults and review norms.

### Weak Answer

“OnPush always makes apps faster.”

### Red Flags

- Cannot list triggers.
- Claims automatic immutability.

---

**Question:** How do you prevent RxJS subscription leaks in sizable apps?

**Answer:** Prefer `async` pipe, `takeUntilDestroyed`, finite operators, and lint/review rules for raw `subscribe`. Audit hot spots (router events, WebSockets, intervals) and validate with heap snapshots in severe cases.

---

**Question:** When do signals beat `BehaviorSubject` locally, and where does RxJS remain?

**Answer:** Signals excel at synchronous component state and derived values (`computed`). RxJS remains for HTTP composition, streams, throttling, multicasting. Plan incremental migration rather than declaring one “winner.”

---

**Question:** How do functional HTTP interceptors differ from class-based ones?

**Answer:** `HttpInterceptorFn` chains compose as functions with clearer ordering; aligns with inject() style. Teams standardize on modern APIs for consistency.

---

**Question:** Why must `inject()` run in an injection context?

**Answer:** Angular resolves tokens while constructing injectables; calling `inject()` later throws—prevents nondeterministic service lookup. Education reduces mysterious runtime errors.

---

**Question:** How does `track` in `@for` relate to list performance?

**Answer:** Stable keys reuse DOM nodes; missing track forces churn like React key issues. Choose business identifiers, not indices for volatile lists.

---

### Question

How do you test Angular with a sensible pyramid and tooling?

### Strong Answer

Fast unit tests for services/pipes without TestBed when possible; component tests with TestBed/RTL patterns; harnesses for Material; Playwright/Cypress for few golden flows. Mock boundaries, not implementation trivia.

### Explanation

Demonstrates balancing cost versus confidence—not reaching for TestBed by reflex.

### Practical Example

Use `TestBed.createComponent` for template behavior, plain `new Service(mockDep)` for logic-heavy services.

### What the Interviewer Is Testing

- Practical cost awareness.
- Knowledge of CDK harnesses.

### Weak Answer

“E2E covers us.”

### Red Flags

- No unit/component balance.
- Brittle CSS selectors everywhere.

---

**Question:** How do you structure reactive forms for scale?

**Answer:** Typed groups, validators colocated with definitions, async validators debounced, shared validator modules, `FormArray` for dynamic lists. Consider state-machine patterns for wizards.

---

**Question:** What is your `ng update` practice across majors?

**Answer:** One major at a time, update satellite libs first, run migrations, test thoroughly, and never skip unsupported version jumps—schedule budget and comms.

---

**Question:** How does `@defer` change how you think about bundle boundaries versus route-level lazy loading?

**Answer:** `@defer` targets template sections with triggers (viewport, idle, interaction), splitting those dependencies into chunks without a full route navigation—good for below-the-fold widgets. Trade-off: more places to reason about loading states than a single `loadComponent`; still needs skeleton/UX discipline.

### Tech Lead Questions

**Question:** How do you set team defaults for change detection and state migration?

**Answer:** Codify OnPush + signals roadmap, training, and incremental migration metrics; align lint/architecture rules so reviews reinforce strategy.

---

**Question:** How do you govern bundle size budgets?

**Answer:** `angular.json` budgets in CI, `source-map-explorer` audits, lazy routes by default, dependency policy for heavy libs. Tie regressions to design review.

---

**Question:** When do you allow NgModules to linger versus forcing standalone?

**Answer:** Risk-based migration: new work standalone, legacy modules replaced opportunistically with tracked milestones—avoid endless hybrid confusion.

---

**Question:** How do you align Rx-heavy legacy code with signal-first guidance?

**Answer:** Interop incrementally, document boundaries, train on mental models, and prioritize hot paths user-visible perf data highlights.

---

**Question:** Resolver vs component fetch—how do you decide?

**Answer:** Resolvers for must-have data before render; component fetch for progressive experiences—match UX and loading skeleton strategy.

---

**Question:** How does content projection vs composition affect library design?

**Answer:** Multi-slot `<ng-content select="...">` APIs enable flexible design systems; misuse increases coupling—document intended projection contracts for consumers.

---

**Question:** What metrics prove a DI or CD refactor worked?

**Answer:** INP/LCP field data, main-thread profiling, error rates, and developer-reported complexity—all > gut feel.

---

**Question:** How do you handle third-party widgets that fight Zone.js?

**Answer:** Strategies include `runOutsideAngular`, patching, vendor fixes, or encapsulation; measure before global hacks.

### Scenario-Based Questions

**Question:** After lazy-loading a giant admin module, first navigation still spikes CPU. What investigation order do you lead?

**Answer:** Profile main thread, inspect module graphs for eager heavy imports, verify preloading strategy, check devtools network for accidental eager vendors—optimize based on evidence.

---

**Question:** A critical screen shows stale data under OnPush after websocket updates. What is the likely class of bug and fix?

**Answer:** Updates occur outside Angular zone or mutate state without new references/signals—wrap with zone, use immutable updates, or `markForCheck` sparingly with documented rationale.

---

**Question:** Two libraries pull different RxJS internals due to version skew—what breaks and how do you fix?

**Answer:** Observable identity issues and operator bugs from duplicate versions—dedupe with resolutions aligned to Angular’s supported range.

---

**Question:** QA reports intermittent duplicate POSTs on rapid clicks despite UI guards. What Angular/Rx pattern helps?

**Answer:** `exhaustMap` or disable + `finalize` patterns on submit streams; ensure HTTP layer not retried dangerously—coordinate with API idempotency.

---

**Question:** Leadership mandates zoneless readiness—what is your staged plan?

**Answer:** Inventory Zone triggers, migrate hot paths to signals, test third-party compatibility, profile edge runtimes, train team on new debugging—avoid flip without instrumentation.

### Trick Questions

**Question:** “`async` pipe always cancels in-flight HTTP when the component destroys—so we skip HttpClient cancel.”

**Answer:** Unsubscribe stops consumers but does not automatically abort fetches unless you wire `AbortSignal`—clarify the difference to avoid race bugs.

---

**Question:** “Standalone means no more DI graph to reason about.”

**Answer:** Still hierarchical; imports change packaging, not injection rules—beware new developer confusion.

---

**Question:** “Signals remove the need for any RxJS in enterprise Angular.”

**Answer:** Many async integrations still benefit from Observable pipelines; blanket removal is unrealistic.

### Weak Answers and Red Flags

1. **“We fixed perf by defaulting to Default CD everywhere.”** Confuses safety with performance—signals shallow understanding.
2. **`subscribe` without cleanup “because the component is short-lived.”** Fragile assumption—red flag in production codebases.
3. **“RxJS is deprecated now.”** Misreads roadmap nuance— indicates buzz-driven learning.

---

## React

### Basic Questions

**Question:** What is JSX compiling to, and what mismatches with HTML trip beginners?

**Answer:** JSX desugars to `React.createElement` (or `_jsx`), producing element objects—not strings. Use `className`, mind self-closing rules, and children composition differs from templating languages.

---

**Question:** How do props differ from state psychologically and mechanically?

**Answer:** Props flow down read-only; owning component state triggers re-renders locally and downstream. Lifting state shares siblings but deep props hint architecture smells.

---

**Question:** Why must hooks be called unconditionally at the top level?

**Answer:** React matches hook state by call order across renders—branching breaks the association and corrupts state. Lint rules enforce this invariant.

---

**Question:** What role do keys play in lists?

**Answer:** Stable keys let reconciler preserve identity across moves; index keys lie when data reorders—stateful children malfunction.

---

**Question:** When is a component “controlled” vs “uncontrolled”?

**Answer:** Controlled: value driven by React state. Uncontrolled: DOM stores value, read via refs—pick based on validation needs and form complexity.

---

**Question:** What are two legitimate `useRef` uses?

**Answer:** DOM imperative handles and mutable boxes that should not trigger renders—distinct mental models; mixing them confuses juniors.

---

**Question:** How does Context propagate updates, and what is its cost?

**Answer:** Provider value changes re-render all consuming descendants—even if only one slice changed unless split/memoized. High-frequency data belongs elsewhere (external stores/selectors).

---

**Question:** What guarantees does an error boundary provide?

**Answer:** Catches render/lifecycle errors in children, not event handler or async faults alone—placement at route/feature boundaries contains blast radius.

---

**Question:** What is Suspense used for in modern apps?

**Answer:** Coordinates loading fallbacks with `React.lazy` and data libraries that support suspended reads—nested boundaries localize spinners.

---

**Question:** Differentiate `useEffect` from event-handler side effects.

**Answer:** Effects synchronize after render with external systems; user-driven work often belongs in handlers to avoid redundant render cycles and races.

---

**Question:** What is hydration and what mismatch symptoms appear?

**Answer:** Client attaches to server HTML; text/attribute differences warn and may re-render—often timezone/random data bugs.

---

**Question:** What is automatic batching in modern React, and why care?

**Answer:** Multiple `setState` calls in the same outer event batch to one render—fewer paints; async boundaries still need thought when expectations assume immediate DOM commits.

### Senior Questions

### Question

Which `useEffect` patterns do you flag in review, and why?

### Strong Answer

Untracked fetches without cancellation race; derived state updated via effects causes double renders; effect chains syncing two states encode hidden coupling—prefer derived values inline. Effects should synchronize React with *external* systems.

### Explanation

Shows you teach mental models, not only dependency lint errors.

### Practical Example

```tsx
// Prefer: derive during render
const fullName = `${first} ${last}`;
// Not: useEffect(() => setFullName(`${first} ${last}`), [first, last]);
```

### What the Interviewer Is Testing

- Ability to spot subtle perf/logic bugs.
- Communication style for mentoring.

### Weak Answer

“Effects are for API calls.”

### Red Flags

- No mention of races/cleanup.
- Encourages effect-only derivations.

---

**Question:** When does memoization (`useMemo`, `memo`) earn its keep?

**Answer:** When profiling shows expensive child renders or prop identity instability on memoized children—not preemptively everywhere. Compare memo overhead vs saved work.

---

**Question:** How does reconciliation use type and keys?

**Answer:** Different element types replace subtrees; same types diff props; keys disambiguate list moves—O(n) heuristics rely on developer-supplied keys.

---

**Question:** How do you attack “too many re-renders” systematically?

**Answer:** Profiler first; then parent state placement, memoization, context splitting, selector stores—verify improvements with traces, not guesses.

---

### Question

How do you architect server state vs client state in React apps?

### Strong Answer

Server state is remote, cacheable, and stale-able—libraries like TanStack Query handle dedupe, retries, and revalidation. Client/UI state stays local or in targeted stores. Putting remote JSON in Redux without cache semantics duplicates effort and bugs.

### Explanation

Tests whether you understand product-scale data flow, not Redux dogma.

### Practical Example

```tsx
const { data } = useQuery({ queryKey: ["user", id], queryFn: fetchUser });
```

### What the Interviewer Is Testing

- Clear separation of concerns.
- Operational traits (stale data) understanding.

### Weak Answer

“Everything goes in global state.”

### Red Flags

- No mention of caching or staleness.
- Conflates remote data with UI toggles.

---

**Question:** How do Context performance issues surface, and mitigations?

**Answer:** Broad contexts rerender frequently—split contexts, memo provider values, or adopt fine-grained stores for hot data.

---

**Question:** When choose `useReducer` over `useState`?

**Answer:** Coordinated multi-field updates, explicit transition guards, easier testability of reducer logic—skip for trivial booleans.

---

**Question:** What is `useLayoutEffect`’s niche?

**Answer:** Synchronous post-DOM work before paint—measuring layout or preventing flicker; misuse blocks painting.

---

**Question:** How do you test custom hooks cleanly?

**Answer:** `renderHook` + act, assert observable behavior, validate cleanup on unmount—avoid testing hidden state fields.

---

### Question

How do you layer error handling from button click to app shell?

### Strong Answer

Local try/catch around async handlers, feature error boundaries with retry, app-level boundary + monitoring, query-layer errors mapped to UI—never silent catches in production paths.

### Explanation

Leadership signal: operability and UX consistency.

### Practical Example

TanStack Query `isError` rendering + Sentry capture in boundary fallback.

### What the Interviewer Is Testing

- Completeness vs “wrap root in try/catch.”
- Monitoring awareness.

### Weak Answer

“ErrorBoundary handles everything.”

### Red Flags

- Ignores async/event errors.
- No observability hook.

---

**Question:** Why is TanStack Query more than “fetch helper”?

**Answer:** Cache keying, dedupe, cancellation, retries, background refresh—recreating it ad hoc usually fails under navigation stress.

---

**Question:** What is the split between React’s render and commit phases, and where do you spend time when “re-renders” hurt?

**Answer:** Render (pure-ish) builds the element tree and runs component functions; commit applies DOM updates and runs layout effects. Profilers showing expensive render work point to memoization/state placement; commit hotspots often mean huge DOM churn or synchronous layout reads. Understanding the split avoids “memo everything” without knowing which phase hurts. `startTransition` marks updates as non-urgent to keep inputs responsive—useful for deferring heavy tree work, not a substitute for fixing algorithmic cost or synchronous correctness requirements (focus management, validation timing).

### Tech Lead Questions

**Question:** How do you decide RSC adoption depth for a product org?

**Answer:** Start at leaf interactive islands, measure bundle wins, train teams on boundaries, and align design systems—avoid forcing client-only patterns into server files without education.

---

**Question:** What policy prevents context misuse at scale?

**Answer:** Document allowed contexts, require provider audits in review, and supply alternatives (query clients, stores) when update frequency is high.

---

**Question:** How do you integrate accessibility into delivery?

**Answer:** Semantic HTML first, limited ARIA, jest-axe in critical components, keyboard audits for overlays, CI gates where feasible—pair with design reviews.

---

**Question:** How do you stop infinite re-render loops in junior code without banning hooks?

**Answer:** Education on derived state, lint rules, code templates, and mandatory profiling reproduction attachments in bug tickets.

---

**Question:** What is your stance on form libraries vs hand-rolled state?

**Answer:** Scale complexity with React Hook Form or similar when performance and validation schemas matter; keep simple forms simple to reduce abstraction tax.

---

### Question

How do you lead composition patterns that kill prop drilling?

### Strong Answer

Prefer children/render props for cross-cutting layout, augment with context only for stable data, and teach teams to spot “pass-through props” smells early—document exemplar layouts in the design system.

### Explanation

Looks for architecture mentorship, not naming patterns only.

### Practical Example

```tsx
<Modal>
  <Modal.Header title="..." />
  <UserForm userId={id} />
</Modal>
```

Parents stop forwarding dozens of unrelated props.

### What the Interviewer Is Testing

- Teaches structural thinking.
- Distinguishes composition vs global state.

### Weak Answer

“Use context for everything.”

### Red Flags

- Cannot articulate render-prop/children wins.
- Context as default hammer.

---

**Question:** How would you phase out a deprecated global store to queries + local state?

**Answer:** Module-boundary migration, dual-write windows with metrics, codem risky selectors, train teams on stale data semantics—communicate timelines.

---

**Question:** What observability is mandatory for React SPAs you lead?

**Answer:** Boundary + client error reporting, Web Vitals telemetry, API latency dashboards, and correlation IDs—tie to product KPIs.

---

**Question:** How do you review performance PRs without bikeshedding memo?

**Answer:** Demand profiler evidence for hot paths; enforce budgets (bundle/LCP) via CI; coach patterns, not reflexive `memo`.

---

**Question:** When do you allow client-only data fetching without a cache library?

**Answer:** Isolated low-traffic surfaces with clear lifetime—still document escape hatch and risks; default to shared cache patterns for networked entities.

### Scenario-Based Questions

**Question:** After launch, Sentry shows a spike in “Cannot update unmounted component” warnings—what changed and how do you respond?

**Answer:** Likely async races post-navigation—audit effects for cancellation flags/`AbortController`, ensure state updates guard mount status, and reproduce with fast route churn.

---

**Question:** Marketing adds a carousel that ruins INP—what cross-team path do you drive?

**Answer:** Measure long tasks, propose deferral or alternate UX, negotiate with stakeholders using field metrics, and enforce bundle budgets.

---

**Question:** A hydration mismatch appears only for logged-in users—where do you look first?

**Answer:** Compare server vs client renders for auth-dependent branches, cookie timing, date/time localization, and random IDs—reproduce with SSR logs.

---

**Question:** Two features fetch the same entity with separate caches—UI flickers contradict. What architectural fix?

**Answer:** Consolidate on a shared query key strategy or store with dedupe—document entity ID conventions.

---

**Question:** Concurrent rendering exposes a non-pure render in a third-party wrapper—how do you mitigate?

**Answer:** Isolate component, patch upstream or fork temporarily, add strict mode coverage, and file actionable bug reports with repros.

---

**Question:** A designer demands all modals trap focus; your wrapper broke screen readers. Next steps?

**Answer:** Pair with accessibility SME, add tests harnesses, prefer proven primitives (Radix/React ARIA) over bespoke—schedule hardening sprint.

### Trick Questions

**Question:** “`useCallback` always reduces renders.”

**Answer:** It only helps when child memoization depends on stable identities; otherwise it adds comparison overhead for no win.

---

**Question:** “Error boundaries catch onClick errors.”

**Answer:** They do not—handlers need local handling; misunderstanding leaves production holes.

---

**Question:** “Server Components can import Client Components freely without bundle impact.”

**Answer:** Client imports still serialize client boundaries—incorrect mental models underestimate JS shipped.

---

**Question:** “Keys only need to be unique, not stable.”

**Answer:** Uniqueness alone is not enough: unstable keys (random per render) force full remounts and destroy internal state. Keys should be stable identifiers tied to domain entities for the lifetime of that row.

### Weak Answers and Red Flags

1. **“Virtual DOM compares to the real DOM directly.”** Misstates reconciliation—likely shallow understanding.
2. **“Hooks replaced the need for keys.”** Unrelated concepts—signals fundamental confusion.
3. **“Redux is required for enterprise.”** Ignores modern data-layer specialization—architecture stagnation.
4. **“StrictMode bugs are React bugs—disable it.”** Often hides impure components—red flag for quality culture.

---

## Next.js

### Basic Questions

**Question:** How do SSG, SSR, and ISR differ on freshness and cost?

**Answer:** SSG serves build-time HTML cheaply but stale until rebuild; SSR computes per request—fresher, costlier; ISR blends static delivery with timed/on-demand revalidation. Choose per-route based on data cadence and personalization.

---

**Question:** What is an App Router layout responsible for?

**Answer:** Shared UI and data wrappers that persist across navigations within their segment—must include `html`/`body` at root; misuse causes remount bugs.

---

**Question:** What does `"use client"` demarcate?

**Answer:** It defines the client boundary—everything imported into that module ships for hydration/interaction; misuse balloon bundles.

---

**Question:** What is a Server Action responsibility-wise?

**Answer:** Server-only mutation entrypoints invoked from the client—must validate and authorize like any RPC; never trust implicit safety.

---

**Question:** How does Next middleware differ from route handlers?

**Answer:** Middleware runs early at the edge for redirects, cookies, rewrites; route handlers define HTTP APIs—different limits (runtime APIs, duration).

---

**Question:** What does request memoization of `fetch` accomplish?

**Answer:** Deduplicates identical requests during a single render pass—NOT a cross-request cache by itself; understand layering with data cache options.

---

**Question:** What is the RSC payload?

**Answer:** Serialized tree instructions distinct from HTML enabling partial updates without shipping server component source—contrast with classic hydration JSON myths.

---

**Question:** Why use `next/image`?

**Answer:** Automatic resizing, modern formats, lazy loading, CLS control—self-hosting needs configuration. Trade-off: domain allowlisting complexity.

---

**Question:** What is `generateMetadata` for?

**Answer:** Declarative SEO metadata tied to routes—can be async for dynamic titles; replaces older head management patterns cleanly.

---

**Question:** How do route groups `(...)` change URLs?

**Answer:** They organize segments without path segments—helpful for separate layouts; beginners assume parentheses appear in routes.

### Senior Questions

### Question

How do Next caching layers interact, and how do you debug stale UI?

### Strong Answer

Reason about fetch cache, full-route cache, router cache, and server component memoization together. `router.refresh` addresses client router cache symptoms; tags/paths revalidate data/full routes; marking routes dynamic avoids accidental static caching. Document per-route strategies—defaults shifted across versions, so explicit options beat assumptions.

### Explanation

Tests systems reasoning beyond repeating `revalidate`.

### Practical Example

After a Server Action mutation, pair `revalidatePath("/items")` with understanding whether list page was static or dynamic.

### What the Interviewer Is Testing

- Layered mental model.
- Version-aware caution.

### Weak Answer

“Set revalidate to 0.”

### Red Flags

- Single-knob thinking.
- No mention of router cache vs data cache.

---

**Question:** How do you place Server vs Client components for bundle health?

**Answer:** Keep pages server-hosted, push interactivity leafward, never import server-only modules into client files—compose via children props to avoid illegal imports.

---

**Question:** When pick streaming/Suspense vs blocking server render?

**Answer:** Multiple slow independent queries benefit from progressive HTML; uniformly fast pages may not justify skeleton complexity.

---

**Question:** How should auth be enforced in App Router apps?

**Answer:** Middleware for coarse gating, server checks for data access, action validation for mutations—never client-only protection.

---

**Question:** What trade-offs does the edge runtime impose?

**Answer:** Fast cold starts vs missing Node APIs/native modules—use for thin guards, not heavy DB drivers without compatible clients.

---

### Question

How do you migrate Pages Router apps without a big-bang rewrite?

### Strong Answer

Run routers side-by-side, move low-risk static routes first, map `getStaticProps`/`getServerSideProps` to RSC/ISR/SSR thoughtfully, verify caches per route, freeze new Pages features, and set deadlines to retire duality.

### Explanation

Leadership is sequencing + stopping the bleed, not heroics.

### Practical Example

Track a board: inventory pages, classify data pattern, note revalidation behavior, assign owners.

### What the Interviewer Is Testing

- Incremental planning.
- Awareness of caching regressions.

### Weak Answer

“Rewrite all routes in a week.”

### Red Flags

- No verification of caching after port.
- Allows indefinite dual router use.

---

**Question:** How do App Router forms integrate with cache coherence?

**Answer:** Server Actions should validate, mutate, then `revalidatePath/Tag`—tie UX (`useFormStatus`) to deterministic server outcomes.

---

**Question:** How do you manage `NEXT_PUBLIC_` env exposure?

**Answer:** Treat as browser-visible; validate config at boot; document `.env.example`; never ship secrets through client vars.

---

**Question:** What does calling `cookies()`, `headers()`, or `searchParams` in a Server Component imply for caching and dynamism?

**Answer:** These APIs tie rendering to the current request’s inputs, typically forcing dynamic rendering (or at least disabling static assumptions) because outputs vary per user or request. Expect cache misses unless you explicitly shape segments as static and avoid request-specific reads. Trade-off: freshness versus TTFB and origin load—document the choice per route.

---

**Question:** When is `generateStaticParams` insufficient, and how do you combine it with on-demand generation?

**Answer:** When the slug universe is huge or unknown at build time, prebuilding every path is costly or impossible. Pair partial `generateStaticParams` with explicit `dynamicParams` choices so unknown slugs either materialize on first request or return 404 predictably, and protect origin with rate limits. Revalidate after writes so long-tail paths stay manageable.

### Tech Lead Questions

**Question:** How do you explicit-configure `fetch` caching after default shifts between releases?

**Answer:** Set `cache`, `revalidate`, or `no-store` deliberately per call, document in code comments, and add tests/monitoring for unexpected backend load spikes.

---

**Question:** What is your strategy for Core Web Vitals in Next?

**Answer:** Image/font hygiene, server rendering strategy per route, client island sizing, bundle analyzer gates, RUM dashboards—not only Lighthouse lab scores.

---

**Question:** How do you govern parallel and intercepting routes for modals?

**Answer:** Teach conventions, set templates, and QA back/forward behavior—the APIs are expressive but easy for teams to fork inconsistently without shared patterns.

---

**Question:** When choose Route Handlers versus Server Actions?

**Answer:** Public HTTP APIs/webhooks vs internal mutations from UI—security models differ (CSRF surfaces, auth patterns).

---

**Question:** How do you coach teams on illegal Server→Client import direction?

**Answer:** Lint/review playbooks, composite pattern examples, and internal docs with counterexamples—prevents recurrent build failures.

---

**Question:** What operational metrics do you require per deployment?

**Answer:** Error rates, latency p95/p99, ISR staleness alerts, edge cold start metrics—tie to customer journeys.

---

**Question:** How do you evaluate self-hosted vs Vercel for image and edge features?

**Answer:** TCO of image optimizer workers, CDN integration, and ops burden—decisions affect `next/image` config and middleware limits.

---

**Question:** How do you document rendering mode per route for onboarding?

**Answer:** Maintain a table in repo: route, mode, cache tags, revalidate windows, personalization—reduces tribal knowledge risk.

### Scenario-Based Questions

**Question:** After upgrading Next, an “always fresh” dashboard suddenly hammers the DB—what broke?

**Answer:** Fetch default caching semantics may have flipped—audit calls, add explicit `cache`/`revalidate`, and load-test.

---

**Question:** A Server Action works locally but 403s in staging—what checklist do you walk?

**Answer:** Verify cookies/host headers, CSRF expectations, deployment middleware, and environment variables—reproduce with curl mimicking prod.

---

**Question:** Marketing requests perfect preview drafts on ISR product pages—how do you design it?

**Answer:** Combine draft mode, on-demand revalidation, and auth-guarded routes—avoid polluting public cache.

---

**Question:** A client component import ballooned the bundle after a “small” refactor—what happened?

**Answer:** Likely dragged server-only data modules or heavy deps across the client boundary—rewire composition or dynamic import.

---

**Question:** Users see stale carts after checkout—where do you investigate?

**Answer:** Router cache vs tagged data vs external payment webhooks—trace mutation path then revalidate correct tags/paths.

### Trick Questions

**Question:** “Server Components eliminate all client JavaScript.”

**Answer:** Interactivity and client boundaries still ship JS; RSC reduces boilerplate but does not delete the need for hydration where required.

---

**Question:** “Middleware is the right place for heavy DB auth lookups.”

**Answer:** Edge limits/timeouts bite—keep heavy logic in server components/handlers unless proven suitable.

---

**Question:** “`fetch` dedupe caches across users automatically.”

**Answer:** Per-request memoization ≠ shared data cache unless configured—misunderstanding causes architecture errors.

### Weak Answers and Red Flags

1. **“ISR means data is always live.”** Ignores stale-while-revalidate windows—product expectations misaligned.
2. **“Edge runtime is default best.”** Ignores Node API constraints—ops incidents follow.
3. **“Client Components cannot render on the server.”** False—SSR+hydration model still applies; reveals missing RSC mental model.


## Node.js

### Basic Questions

**Question:** What problem does the Node.js event loop solve, and what still runs off the main JavaScript thread?

**Answer:** The event loop schedules non-blocking I/O callbacks on one JavaScript thread so thousands of connections can share one process cheaply. libuv still uses a thread pool for file I/O, some DNS, crypto, and zlib; network I/O uses OS async primitives. Production implication: CPU-heavy synchronous work still blocks every request sharing that loop.

---

**Question:** Why does `pipeline()` from `node:stream/promises` beat chaining `.pipe()` for production streams?

**Answer:** `pipeline()` propagates errors, destroys all stages on failure, and can return a Promise you await. Raw `.pipe()` often leaks handles or leaves buffers growing if an error occurs in the middle. Example: file → gzip → HTTP response should use `pipeline` so a client disconnect tears down the readable. Trade-off: marginally more ceremony than `.pipe()` for trivial scripts.

---

**Question:** How do `process.nextTick` and `setImmediate` differ in scheduling?

**Answer:** `nextTick` runs before the event loop continues to the next phase; it can starve I/O if used recursively. `setImmediate` runs in the check phase after poll. In interviews, explain phase ordering instead of claiming one is universally “faster.” Use `setImmediate` to yield without preempting I/O work.

---

**Question:** What is back-pressure in streams, and what breaks if you ignore it?

**Answer:** A slow consumer signals the producer to pause so internal buffers do not grow without bound. If `.write()` returns `false` and you keep pushing, memory spikes and the process can OOM. Pair pause/resume with the `drain` event, or rely on `pipeline` for the wiring.

---

**Question:** What is the libuv thread pool used for, and how do you size it?

**Answer:** Defaults to four threads for file system access, `dns.lookup`, some crypto, and compression—not for typical TCP sockets. Tune with `UV_THREADPOOL_SIZE` when profiling shows queueing there; raising it increases memory and context switching. Wrong tool for CPU work: prefer worker threads or a separate service.

---

**Question:** Why do unhandled promise rejections matter in modern Node.js?

**Answer:** Since Node 15, the default is to terminate on unhandled rejections (configurable), aligning with treating them as bugs. In production, a stray floating promise can crash pods. Operational fix: centralized `async` wrappers, consistent error middleware, and monitoring on `unhandledRejection`.

---

**Question:** How does CommonJS interoperability differ from native ES modules in Node?

**Answer:** CommonJS loads synchronously via `require`; ESM uses `import` with asynchronous loading and static analysis-friendly exports. Interop is awkward: CJS cannot `import` ESM synchronously. Pick one style per service where possible; mixing increases bundler and tooling friction.

---

**Question:** What is the practical role of `AsyncLocalStorage` in HTTP services?

**Answer:** It carries request-scoped context (trace ID, tenant, user) across async continuations without threading parameters everywhere. Pair with structured logging so every line includes correlation fields. Trade-off: misuse can hide implicit coupling; document the context contract for the team.

---

**Question:** Why prefer Fastify-style JSON Schema at the route over ad hoc validation?

**Answer:** Schemas compile once at startup into fast validators and serializers, cutting CPU per request versus repeated runtime validation. You pay with stricter upfront schema design. For high-RPS APIs, that compile step often wins; for tiny internal tools, the benefit may not justify the rigor.

---

**Question:** When is `cluster` still relevant versus horizontal scaling with containers?

**Answer:** `cluster` forks processes to use multiple cores on one host. In Kubernetes you usually run one process per pod and scale replicas; `cluster` adds memory duplication per worker and complicates metrics. It can still help on single-VM deployments or explicit worker tuning before orchestration exists.

---

**Question:** What does worker_threads solve that the thread pool does not?

**Answer:** Worker threads give you isolated V8 isolates for CPU-heavy tasks (parsing giant buffers, image transforms) without blocking the main event loop. Message passing and `SharedArrayBuffer` are the contracts. Trade-off: serialization overhead and harder debugging—still cheaper than blocking every HTTP request.

---

**Question:** What is an idempotency key at the HTTP layer, and where must state live?

**Answer:** A client-supplied key lets the server deduplicate POST-like operations after retries. Store `(key → response or job status)` in a database or Redis with TTL and use locking or unique constraints to close races. Production requirement: same status/body on replay—for payments, this is non-negotiable.

### Senior Questions

**Question:** How do you implement graceful shutdown for a Node service behind Kubernetes?

**Answer:** Trap SIGTERM/SIGINT, stop accepting (`server.close()`), finish in-flight work with a bounded wait, drain queues, close pools (DB/Redis), flush logs, then exit 0. Add `preStop` sleep so the Service removes endpoints before SIGTERM. Trade-off: overly long drains delay rollouts; tune against SLAs and load balancer behavior.

---

**Question:** Walk through diagnosing rising event loop lag in production.

**Answer:** Export `monitorEventLoopDelay()` metrics; alert on p99. Correlate with deploys, GC, or dependency slowdowns. Profile with sampling (`clinic`, `--prof`) for synchronous hotspots: large `JSON.parse`, `pbkdf2Sync`, regex on attacker-controlled strings. Fix by streaming, async APIs, workers, or input caps. Leadership angle: add lag to the default dashboard for every service.

---

### Question

You expose a streaming download that fans out from a database cursor. Users report OOMs during big exports. How do you fix it?

### Strong Answer

Use `pipeline` from `node:stream/promises` to connect the cursor-backed readable to the HTTP response. Ensure the cursor-based readable respects flow control: pause the DB driver when `write` back-pressures, resume on `drain`. Set response timeouts and row limits for abusive queries. Add memory and heap metrics alerts; consider moving very large exports to async jobs with object storage and signed URLs.

### Explanation

This shows you connect Node’s concurrency model to resource limits: unbounded buffering defeats the point of streams.

### Practical Example

```typescript
import { pipeline } from "node:stream/promises";
// pg-query-stream or similar → zlib.createGzip() → res
await pipeline(cursorStream, gzip, res);
```

### What the Interviewer Is Testing

Streams literacy, back-pressure, operational safety for bulk IO.

### Weak Answer

“We already use streams, so it should be fine.”

### Red Flags

- No mention of `pipeline`, pause/resume, or DB driver behavior
- Suggests increasing container memory as the primary fix

---

**Question:** How do you choose ORM vs raw SQL at different layers of a service?

**Answer:** ORMs accelerate CRUD and migrations; raw SQL or query builders win for heavy joins, window functions, or vendor-specific features. Common pattern: ORM + escape hatches for hot paths. Trade-off: mixed styles need code review standards so raw SQL stays parameterized and tested.

---

**Question:** What breaks when request-scoped state is injected into singletons in NestJS?

**Answer:** Singletons live across requests; hiding per-request data there causes cross-request leaks and flaky tests. Fix scopes (`REQUEST` scope sparingly) or pass context explicitly. Team policy: ban request-scoped providers inside singletons unless the framework guarantees safe lifetimes.

---

**Question:** How do you implement fair distributed rate limiting for Node APIs?

**Answer:** Centralize in Redis with atomic Lua or gateway enforcement; use sliding window or token bucket per tenant/user. Return `429` with `Retry-After` and limit headers. Trade-off: Redis failure mode—fail open risks abuse; fail closed risks outage; document the org’s choice.

---

### Question

Your Nest/Express fleet returns five different error JSON shapes. External partners are angry. What is your platform fix?

### Strong Answer

Publish a shared error package and global filter/middleware mapping `AppError` subclasses to one schema (e.g., RFC 9457 fields + stable `code`). Separate operational errors (expected, logged with context) from programmer errors (fail fast, crash, alert). Add contract tests that snapshot error bodies. Roll out service-by-service with a deprecation deadline.

### Explanation

This tests standardization thinking and how you reduce integration tax across teams.

### Practical Example

Envelope like `{ "type": "/errors/validation", "title": "Invalid input", "status": 422, "detail": "email format", "instance": "/v1/users" }` with extension `fieldErrors`.

### What the Interviewer Is Testing

Governance, consistency for API consumers, operational vs programmer errors.

### Weak Answer

“Document the differences in Confluence.”

### Red Flags

- No shared library or CI enforcement
- Hiding programming bugs as generic 500s without alerting

---

**Question:** How do you harden file uploads in Node without buffering whole files?

**Answer:** Stream to object storage (`busboy`, multipart plugins), cap sizes, verify magic bytes, sanitize names, virus-scan if required, and issue presigned GET for delivery. Trade-off: streaming increases code complexity versus quick demo implementations.

---

**Question:** What changes when WebSockets must work across multiple Node replicas?

**Answer:** You need shared pub/sub (Redis, NATS) for broadcasts, sticky sessions or connection-aware routing, heartbeats, connection caps, and graceful closes during deploys. Monitor connections per pod. Trade-off: operational complexity versus long-polling/SSE for one-way needs.

---

**Question:** How do you tune caching to avoid stampedes?

**Answer:** Combine TTL with single-flight refresh, stale-while-revalidate, or jittered TTL. Layer: CDN/HTTP for public reads, Redis for shared hot keys, in-memory for immutable config. Instrument hit ratio and origin QPS—without metrics you cannot prove the cache helps.

---

**Question:** How do you hunt a suspected memory leak in a long-running Node API?

**Answer:** Confirm RSS/heap trends in metrics; take paired heap snapshots and diff retainers; look for global Maps, listener leaks, undisposed streams, or caches without TTL. Set `max-old-space-size` below the cgroup limit so failures are visible, not silent OOM kills. Pair fixes with CI guidance to prevent regressions.

---

**Question:** How do you operate BullMQ (or similar) safely in production?

**Answer:** Separate queues by workload, cap concurrency, configure exponential backoff + DLQ, trim completed keys with TTL, run workers in distinct processes or pods, monitor depth/age-of-oldest job, and treat poison messages as platform incidents—not silent retries forever.

### Tech Lead Questions

**Question:** Monolith vs microservices for a new product with eight engineers—how do you decide?

**Answer:** Default to modular monolith with strict module boundaries and ADRs. Extract services when independent scaling, isolation, or ownership friction is measured—not anticipated. Quote operational costs: separate CI/CD, observability, and on-call per service. Polyglot and distributed transactions are last resorts.

---

**Question:** How do you roll out an Express → Nest migration safely?

**Answer:** Strangler routing, migrate module by module, shadow traffic or parallel run comparisons, freeze scopes for shared domains, and keep observability identical. Train the team with templates; track performance regressions. Trade-off: dual stacks lengthen maintenance until cutover completes.

---

### Question

During peak, p95 is flat but p99 spikes after warm deploys. Leadership wants “more pods.” What do you do?

### Strong Answer

Reject scaling until the spike is classified. Compare traces pre/post deploy: cold JIT, cache emptiness, connection pool recreate, lazy clients, or lock contention often explain tail-only regressions. Mitigate with warm-up traffic, pre-warmed pools, tuned GC flags, and readiness that includes dependency checks. If the service is CPU-saturated at peak, horizontal scale; if not, adding pods wastes money.

### Explanation

Shows tail-latency literacy and cost-aware leadership.

### Practical Example

Add synthetic canary requests post-deploy; watch pool checkout time and event loop delay histograms, not only CPU.

### What the Interviewer Is Testing

Statistical thinking, deployment pathology, FinOps awareness.

### Weak Answer

“Autoscale harder.”

### Red Flags

- Conflates throughput fixes with tail latency
- No trace-based evidence

---

**Question:** How do you prevent slow dependencies from stalling the whole fleet?

**Answer:** Aggressive timeouts, bulkheads, circuit breakers, half-open retries with jitter, and queued async work for non-critical paths. Standardize client libraries in an internal wrapper. Track dependency SLIs and alert before user-visible SLO burn.

---

### Question

How do you standardize observability for new Node services org-wide?

### Strong Answer

Ship an internal bootstrap: pino JSON logs with redaction, OpenTelemetry traces, RED metrics, `/health/live` vs `/health/ready`, and exemplars on histograms. Encode in templates and CI checks; block merges missing routing IDs. Teach on-call how to pivot from metric → trace → log. Revisit sampling when cost grows.

### Explanation

Tests whether you treat platform concerns as productized defaults.

### Practical Example

AsyncLocalStorage fills `trace_id`, `span_id`, `user_id`; middleware refuses traffic if readiness dependencies fail.

### What the Interviewer Is Testing

Platform engineering, SRE collaboration, prevention of “snowflake” services.

### Weak Answer

“Teams can pick Datadog or Prometheus themselves.”

### Red Flags

- No correlation fields across telemetry
- Health checks that only return 200 if process is alive

---

**Question:** How do you govern database migrations across many squads?

**Answer:** Expand-and-contract migrations, separate migration job from app start, CI applies to disposable DBs, and Tech Lead review for destructive steps. Document backfills and locking strategy (`CONCURRENTLY` where applicable). Communication beats surprise schema breaks.

---

**Question:** When do you choose REST vs GraphQL for a Node API ecosystem?

**Answer:** REST + OpenAPI for cacheable resource APIs and external partners; GraphQL when many heterogeneous clients need shaped reads and you can fund DataLoader, complexity limits, and operational guardrails. BFF GraphQL over stable REST services is common. Decide with data on consumers and caching needs, not headlines.

---

**Question:** Secrets rotation keeps forcing rollouts. What architectural response is appropriate?

**Answer:** Load secrets from a manager with refresh hooks; support overlap of signing keys (`kid`), rotate DB credentials by creating new pool while draining old, and centralize config validation. Never bake secrets in images. Trade-off: more code in bootstrap, fewer emergency redeploys.

---

**Question:** How do you run a monorepo with dozens of Node packages without CI collapse?

**Answer:** pnpm workspaces, Turborepo/Nx affected pipelines, shared eslint/tsconfig packages, enforced module boundaries, and Changesets for versioning. Fail PRs when unrelated projects rebuild. Trade-off: upfront tooling investment versus slower per-team velocity without it.

---

**Question:** How would you roll out asynchronous processing for work trapped in synchronous request handlers?

**Answer:** Identify side-effect-heavy paths, enqueue the same business function behind a stable contract, return `202`/status resources for clients that need completion signals, ship workers with DLQ and metrics, and run shadow comparisons before cutting request-thread work. Plan rollback to synchronous mode if brokers misbehave.

### Scenario-Based Questions

**Question:** A marketing push will 10× traffic for an hour on a 2k-RPS service. What is the hour-zero plan?

**Answer:** Pre-scale pods, enable gateway rate limits and WAF rules, offload reads to cache, enqueue non-critical writes, and communicate `Retry-After` semantics. Run a rehearsal load test with realistic cache warmth. Post-mortem template ready if limits trip.

---

**Question:** A REST API must accept 100k webhooks per hour with at-least-once delivery semantics. Sketch the Node edge.

**Answer:** Edge handlers validate signatures quickly, enqueue to durable broker, return 200 fast; workers process idempotently with dedupe keys and DLQ. Scale workers on queue depth; alert on age-of-oldest message.

---

**Question:** Observability vendor shows flat CPU but users see timeouts during bulk CSV export. What do you check?

**Answer:** Event loop delay, stream back-pressure, DB pool waits, and synchronous JSON serialization on huge payloads. Move export to async job + object storage; keep HTTP path thin.

---

**Question:** After introducing GraphQL, DB CPU doubled. What happened?

**Answer:** Likely resolver N+1 or unbounded query depth. Add DataLoader batching, complexity/cost limits, persisted queries, and tracing per resolver. Consider caching layers field-by-field with explicit staleness rules.

---

**Question:** Kubernetes kills pods mid-request during deploy. Business complains about errors. Fix?

**Answer:** Implement graceful shutdown, readiness removal before SIGTERM, sane `terminationGracePeriodSeconds`, and `preStop` delays. Confirm load balancers respect probes—not only code changes.

---

**Question:** Two teams ship conflicting API error formats to the same mobile app. Resolve?

**Answer:** Introduce gateway normalization, shared client SDKs versioned per app release, sunset timeline, and CI diff on gateway mocks. Decide ownership: platform vs product API committee.

### Trick Questions

**Question:** “Node is single-threaded, so it cannot handle concurrency.” What is wrong?

**Answer:** JavaScript runs on one thread, but concurrent I/O multiplexes via the event loop plus libuv threads; true parallelism needs workers or multiple processes. Many candidates confuse thread count with request concurrency.

---

**Question:** Does `setTimeout(..., 0)` always run before `setImmediate`?

**Answer:** Order depends on context; inside I/O callbacks `setImmediate` often wins. Treat phase rules as the answer, not a race-to-guess benchmark.

---

**Question:** Is Express “async-safe” if you `async` handlers without wrappers?

**Answer:** Classic Express drops rejected promises unless you wrap or use a version with native support—users see hung requests. The trap is assuming frameworks magically handle promises.

---

**Question:** Is network I/O handled by the libuv thread pool?

**Answer:** Typical TCP uses non-blocking syscalls; the pool is for blocking-ish work like filesystem and some DNS. Saying “everything is in the pool” is a common mistake.

### Weak Answers and Red Flags

1. **“We’ll scale horizontally if Node is slow.”** Horizontal scale does not fix CPU-bound hotspots on each instance; it can amplify broken patterns and cost without lowering tail latency.
2. **“Streams mean we cannot OOM.”** Without `pipeline` and back-pressure discipline, streams still buffer indefinitely.
3. **“We use `console.log` because it’s easier.”** Unstructured logs break search, sampling, and PII controls—signals greenfield-only experience.
4. **“Microservices first for a clean architecture.”** Ignores team size, operational maturity, and measured pain—often resume-driven design.

---

## Python

### Basic Questions

**Question:** What is the CPython GIL, and when does it actually limit you?

**Answer:** The GIL allows one thread to execute Python bytecode at a time in a process, simplifying refcounting. It releases around I/O, so threaded I/O-bound code still overlaps waits. CPU-bound numeric work needs multiprocessing, native extensions, or another runtime. Trade-off: threads are lighter than processes but share memory unsafely with C-extensions that release the GIL unpredictably.

---

**Question:** When do generators beat materialized lists?

**Answer:** Generators yield lazily—constant memory over large files or network bodies. Lists materialize everything. Use generators for one-pass consumption; lists when you need random access or reuse. Gotcha: reading a generator twice silently gives nothing unless teeing or replaying source.

---

**Question:** How do Pydantic models differ from `dataclasses` in typical services?

**Answer:** Pydantic validates and coerces at boundaries—ideal for HTTP JSON and config. Dataclasses (often `frozen`) model internal trusted data without repeated validation cost. Mixing them wrongly either double-validates or allows untrusted dicts deep in the domain.

---

**Question:** What does `asyncio` buy you if everything still calls `requests.get`?

**Answer:** Nothing—blocking the loop freezes all coroutines. Replace with `httpx.AsyncClient`, `asyncpg`, etc., or push sync work to `run_in_executor`. Team lint rules can flag `requests` imports inside async modules.

---

**Question:** Why are lock files non-negotiable for Python services?

**Answer:** They pin transitive versions for reproducible CI/prod parity. `pip freeze` alone conflates layers. Poetry/uv/pip-tools each work—pick one org-wide. Trade-off: occasional slow resolution until you cache artifacts.

---

**Question:** What is ASGI compared to WSGI?

**Answer:** ASGI is async-first—Starlette/FastAPI/Django Channels. WSGI is sync request/response—Flask/Django classic. Deployment picks workers accordingly (`gunicorn` + `uvicorn.workers.UvicornWorker` is common).

---

**Question:** Explain `Protocol` typing briefly.

**Answer:** Structural subtyping: anything with matching methods satisfies the protocol without inheritance—similar to Go interfaces. Useful for test doubles and plugin boundaries.

---

**Question:** Why can `@lru_cache` without `maxsize` be dangerous?

**Answer:** Unbounded cache growth when arguments vary widely (e.g., raw strings per request) leads to memory leaks. Always bound or use explicit TTL caches for hot functions.

---

**Question:** What is the walrus operator’s legitimate use?

**Answer:** `:=` assigns in expressions to avoid duplicate work, e.g., `if (n := len(items)) > LIMIT:`. Overuse harms readability—reserve for clear wins.

---

**Question:** How should `if __name__ == "__main__"` be used in libraries vs scripts?

**Answer:** Guard CLI behavior so imports do not execute heavy side effects. Libraries should expose `main()` functions tested separately from argv parsing.

### Senior Questions

### Question

How should a large Python codebase adopt typing without freezing delivery?

### Strong Answer

Layer the rollout: enable non-blocking mypy on annotated modules, then tighten boundary packages with `strict`, expand per-directory, and require strict on new files only via CI allowlists. Pair with pyright in IDE for fast feedback. Track coverage percent and exempt legacy areas explicitly.

### Explanation

Shows incremental migration literacy—big-bang typing fails politically and technically.

### Practical Example

`mypy --follow-imports=silent` early; later `[[tool.mypy.overrides]]` paths graduating to strict.

### What the Interviewer Is Testing

Pragmatic quality programs, developer experience, measurable gates.

### Weak Answer

“We’ll add mypy strict repo-wide next sprint.”

### Red Flags

- No incremental path
- No distinction between public modules vs internals

---

**Question:** How do you pick FastAPI vs Django for a new product?

**Answer:** Django when admin, ORM maturity, and synchronous CRUD velocity dominate; FastAPI for typed async APIs, automatic OpenAPI, and high-concurrency I/O. DRF can straddle but has different perf characteristics. Decide on operational needs, not novelty.

---

**Question:** How do you configure production settings safely?

**Answer:** `pydantic-settings` (or equivalent) to validate env at startup, separate secrets from config, fail fast on missing keys, freeze an immutable settings object. `.env` only for local dev. Trade-off: stricter boot can lengthen container restarts—worth predictable failures.

---

**Question:** How do dependency executors bridge blocking libraries in async apps?

**Answer:** `loop.run_in_executor` for unavoidable sync calls; cap thread pool size to protect memory. Long term, replace with native async clients. Monitor thread saturation as a leading indicator of mis-layered stack.

---

### Question

Python async service shows flat p50 but awful p99. What is your triage order?

### Strong Answer

Check DB pool contention, slow queries added recently, blocking calls (`time.sleep`, disk reads), GC pauses, and dependency timeouts. Enable asyncio debug mode for slow callbacks; attach `py-spy`. Fix the dominant span before debating autoscaling.

### Explanation

Demonstrates async production debugging distinct from sync mental models.

### Practical Example

Prometheus: graph `asyncio` task duration if instrumented; DB: `pg_stat_activity` wait events.

### What the Interviewer Is Testing

Narrowing tail latency in asyncio systems.

### Weak Answer

“Add uvicorn workers.”

### Red Flags

- Ignores loop blocking evidence
- No DB pool metrics

---

**Question:** Poetry vs uv vs pip-tools—how does a Tech Lead choose?

**Answer:** All need lockfiles and CI parity. Poetry: batteries included. pip-tools: minimal, pip-native. uv: fastest installs/resolution, great for large graphs. Standardize one; allow uv in CI even if Poetry declares deps. Trade-off: velocity vs familiarity.

---

**Question:** How should ML code sit next to FastAPI handlers?

**Answer:** Isolate models behind a narrow interface (Pydantic IO contracts), load artifacts from versioned stores, mock in tests, and observe inference latency/failures separately. Never sprinkle untracked notebooks into prod paths.

---

**Question:** How do you size `gunicorn` workers for async workloads?

**Answer:** Async needs fewer workers than sync-per-request models; start near CPU count and validate with load tests constrained by DB pool limits. More workers than pool capacity increases queueing without throughput gains.

### Tech Lead Questions

**Question:** A stakeholder demands rewriting a Python service in Go based on “speed.” Your response?

**Answer:** Require profiles proving Python CPU dominates and optimizations (queries, caching, algorithms) are exhausted. Build a TCO spreadsheet: rewrite calendar time, dual-stack operational cost, hiring risk. Offer targeted native extensions or sidecar workers first if a hotspot is proven.

---

### Question

How do you standardize Python for a team jumping 5 → 25 engineers?

### Strong Answer

Sequence: automated format+lint in CI, lockfile + template repo, optional then mandatory typing gates, pytest standards + coverage floors, shared Docker base, observability scaffold. Document in ADRs. Reserve time for teaching async pitfalls. Measure onboard time to “first prod PR” as success metric.

### Explanation

Tests prioritized governance—you cannot paste a standards doc and expect compliance.

### Practical Example

Cookiecutter with ruff+mypy+otel prewired; GitHub org ruleset requiring status checks.

### What the Interviewer Is Testing

Change management, sequencing, measurable outcomes.

### Weak Answer

“Weekly architecture meetings.”

### Red Flags

- No automation or templates
- No metrics on adoption

---

**Question:** Packaging chaos—every repo uses different tools. Fix?

**Answer:** Pick a default stack, provide migrator scripts, block new repos without template compliance, and run bots for drift detection. Offer office hours; punish exceptions via review churn, not surprise.

---

### Question

When should Python stay the org’s default backend language vs admitting polyglot services?

### Strong Answer

Default to Python when I/O APIs, data/ML adjacency, and hiring outweigh perf limits. Allow another language when latency/CPU evidence clears a high bar *and* staffing/ops can absorb it. Encode the exception process in an RFC/ADR to avoid casual drift.

### Explanation

Interviewers want economic reasoning, not tribal loyalty.

### Practical Example

Latency SLO <20ms sustained with profiling showing interpreter-bound CPU might justify Rust for one path—not the whole estate.

### What the Interviewer Is Testing

Constraint-based leadership and FinOps pairing with architecture.

### Weak Answer

“Best tool for the job every time.”

### Red Flags

- Ignores operational tax of polyglot
- No quantitative triggers

---

**Question:** How do you secure the Python supply chain in CI?

**Answer:** Hashed installs, private index optional, `pip-audit`, review of new deps, forbid unsafe YAML loaders, ban pickle on untrusted bytes, block debug flags in prod configs.

---

**Question:** How do you teach mock usage without brittle tests?

**Answer:** Prefer fakes for your own boundaries; mock only true externals. Use dependency overrides in FastAPI tests instead of patching globals. Keep factories composable.

---

**Question:** How do you lead a staged async migration for a large Flask + gunicorn estate?

**Answer:** Start with uvicorn + thread-backed handlers where needed, convert top-traffic routes to async drivers first, codify `run_in_executor` escape hatches, measure pool limits jointly with DBAs, and train teams on debug mode—never promise a single “flag day.”

---

**Question:** How do you define observability baselines every new Python service must ship with?

**Answer:** Require structured JSON logs, OTel traces with ASGI auto-instrumentation, RED metrics, `/health/ready` dependency checks, and redaction policies in the shared template; block deploy without them in platform review.

### Scenario-Based Questions

**Question:** Monthly p99 doubled on a FastAPI + PostgreSQL API—no code change suspected.

**Answer:** Data volume shift, missing index after cardinality change, dependency version drift, infra resize, lock waits, or cold cache. Gather query plans, row counts, and dependency lockfiles; profile a sampled workload.

---

**Question:** You must stream a 10M-row CSV into PostgreSQL nightly.

**Answer:** Generator reads, batched `COPY`/`executemany`, DLQ file for poison rows, metrics on throughput, idempotent reruns, and alerts on SLA breach.

---

**Question:** Celery tasks disappear “silently.” What do you verify?

**Answer:** Worker liveness, queue name mismatches, serialization errors, result backend config, time limits, and broker visibility (Flower/metrics). Reproduce with `task_always_eager` locally.

---

**Question:** Third-party LLM calls take 30–60s. How should the HTTP surface behave?

**Answer:** SSE streaming if token deltas matter; else 202 + job polling with backoff, strict client timeouts, idempotent job IDs, cost controls on retries, and provider quota monitoring.

---

**Question:** Two services fight over incompatible internal library versions.

**Answer:** Enforce SemVer on internal libs, widen compatibility ranges intentionally, or replace shared lib with versioned API boundary; monorepo affected testing if coupling is high.

### Trick Questions

**Question:** Is Python “single-threaded”?

**Answer:** The language has threads, but CPython’s GIL limits parallel bytecode execution; use processes or native extensions for CPU parallelism. Async is concurrent on one thread.

---

**Question:** Are type hints enforced at runtime by default?

**Answer:** No—unless frameworks like Pydantic/FastAPI or explicit runtime checkers consume annotations.

---

**Question:** Does `asyncio.gather` parallelize CPU work?

**Answer:** It interleaves I/O waits concurrently, not parallel CPU—still one interpreter thread by default.

### Weak Answers and Red Flags

1. **“Async fixes all performance problems.”** Without removing blocking calls, asyncio can perform worse than threaded sync servers.
2. **“Typing is optional because Python is dynamic.”** At scale, missing types explode maintenance cost and block automated refactors.
3. **“We’ll use pandas for all ETL because it’s familiar.”** Loading multi-gigabyte tables into RAM is an operational incident waiting to happen.

---

## API Design

### Basic Questions

**Question:** What are REST’s practical constraints—not the acronym trivia?

**Answer:** Resource-oriented URLs, meaningful verbs, stateless servers, cache-friendly GETs, and uniform error/status semantics so intermediaries behave predictably. Most “REST” APIs are Level 2; hypermedia everywhere is rare.

---

**Question:** Why do clients care about idempotent POST semantics?

**Answer:** Retries happen on mobiles and gateways. Without idempotency keys, payments and inventory mutations double-apply. Mandate keys for mutating endpoints with clear TTL and stored outcomes.

---

**Question:** 401 vs 403—how do you explain to a client team?

**Answer:** 401: authenticate; 403: authenticated but denied. Sometimes return 404 instead of 403 for existence leakage—document the policy consistently.

---

**Question:** Why prefer cursor pagination for large tables?

**Answer:** Keyset scans stay O(log n + page) versus OFFSET scanning discarded rows; cursors remain stable under concurrent inserts. Trade-off: no arbitrary page jumps—offer admin-only offset with caps if needed.

---

**Question:** What does Problem Details (`application/problem+json`) buy you?

**Answer:** Machine-readable, consistent error envelope (`type`, `title`, `status`, `detail`) aids client SDKs and support automation. Pair with extension fields for validation issues.

---

**Question:** When is a BFF justified?

**Answer:** Multiple client shapes, chatty service graphs per screen, and frontend team ownership of aggregation. Not for one thin client—avoid extra hop cost without need.

---

**Question:** What is HMAC webhook verification guarding?

**Answer:** Integrity and authenticity of payloads; combine with timestamp anti-replay, idempotent processing, and fetching critical state via authenticated APIs—not trusting body alone.

---

**Question:** GraphQL’s main ops trade-off versus REST CDN caching?

**Answer:** Flexible reads versus loss of trivial HTTP cache semantics and need for complexity controls. Often pair: public REST + internal GraphQL or persisted queries for safe GET caching.

---

**Question:** What headers belong in a mature rate-limit response?

**Answer:** `RateLimit-*`, `Retry-After`, and body explaining policy tier; log correlation IDs for disputes.

---

**Question:** Why define backward compatibility explicitly?

**Answer:** Additive optional fields and looser validation usually safe; removals, type changes, enum shrinkage break clients. Enforce with OpenAPI diff in CI.

### Senior Questions

**Question:** Design idempotent POST for payment capture.

**Answer:** Require `Idempotency-Key`, store in transactional outbox or strong DB constraint, return identical responses on replay, propagate key to PSP, reconcile in-doubt rows via polling PSP APIs, monitor duplicate key rates.

---

### Question

How do you enforce API governance across dozens of teams without becoming a committee bottleneck?

### Strong Answer

Combine automated rules (Spectral/Redocly), breaking-change CI on OpenAPI, generated clients, and lightweight design office hours for ambiguous cases. Publish golden examples and error taxonomies. Escalate only cross-cutting platform decisions; let squads ship within guardrails.

### Explanation

Tests automation-first governance and realistic org dynamics.

### Practical Example

CI fails when `operationId` missing or pagination not cursor-based per standard; allow waivers via tagged ADR link in spec extension.

### What the Interviewer Is Testing

Scaling quality through systems, not hero reviews.

### Weak Answer

“Central architecture board approves every endpoint.”

### Red Flags

- No automated linting
- No consumer contract tests

---

**Question:** How do you migrate a breaking v1 → v2 publicly?

**Answer:** Run dual versions, measure traffic, communicate timeline, add `Sunset` headers, offer SDK helpers, enforce 410 after deadline only with telemetry proving zero critical usage.

---

**Question:** When is POST + search body better than GET for search APIs?

**Answer:** Complex nested filters exceed URL limits and hurt logging; still enforce allowlisted fields, cap page sizes, and index behind the scenes.

---

### Question

A dependency consistently times out. How do you protect callers?

### Strong Answer

Apply per-dependency timeouts, bulkheads, circuit breakers, partial responses where safe, and retry budgets with jitter only on idempotent operations. Surface degradation mode in API docs; alert on breaker open frequency.

### Explanation

Demonstrates resilience patterns at the API edge, not only code-level try/except.

### Practical Example

Return 503 with `Retry-After` plus Problem Details `type` indicating upstream timeout; include `instance` URL.

### What the Interviewer Is Testing

Cascading failure prevention and honest client contracts.

### Weak Answer

“Increase the timeout to 30s.”

### Red Flags

- endless retries
- No breaker or budget

---

**Question:** SSE vs WebSockets—decision rule?

**Answer:** SSE for server→client feeds over normal HTTP infra; WebSockets when you need low-latency duplex. SSE is easier operationally; WS needs sticky sessions or pub/sub bridging.

---

**Question:** How do you version internal mesh APIs differently from public ones?

**Answer:** Path versions for public clarity; header or package versions for tightly coupled internal services **if** discovery tooling supports it—still enforce CI diffs either way.

---

**Question:** How do you model long-running jobs in a REST surface?

**Answer:** Return `202 Accepted`, `Location` to a status resource, emit webhooks on completion, publish `Retry-After` for pollers, and ensure idempotent replays of the submission—never hold HTTP connections open past LB limits.

---

**Question:** Where does consumer-driven contract testing fit in your CI gates?

**Answer:** Providers verify Pact (or similar) artifacts on every merge; failures block deployment when a consumer’s expectation breaks. Complement—not replace—OpenAPI diffing for semantic gaps.

---

**Question:** How do you make webhook delivery reliable at high volume?

**Answer:** Persist-before-send, bounded exponential retries, DLQs, signing + dedupe keys, health dashboards per subscriber, and disable noisy endpoints after sustained failure to protect the fleet.

### Tech Lead Questions

**Question:** Partner APIs clash post-acquisition—what is the migration pattern?

**Answer:** Do not big-bang. Map capabilities, maintain adapters, deprecate old routes with metrics, align new features only on canonical spec, and give multi-quarter runway for externals.

---

### Question

How do you compare REST vs GraphQL vs gRPC for a greenfield platform?

### Strong Answer

Score consumer type (external vs internal), caching needs, browser constraints, schema rigidity, team skill, and ops budgets. Default REST/OpenAPI for wide HTTP ecosystem; gRPC for high-throughput internal RPC with protobuf discipline; GraphQL where multiple clients need shaped reads and you fund safeguards. Document the decision matrix in an ADR.

### Explanation

Shows multi-style literacy without fanboyism.

### Practical Example

Mobile + web + partner NEED different slices → GraphQL BFF possible; public partner webhooks remain REST with signed callbacks.

### What the Interviewer Is Testing

Trade-off articulation and operational honesty.

### Weak Answer

“GraphQL replaces REST.”

### Red Flags

- Ignores caching and abuse surfaces
- No mention of persisted queries or cost limits

---

**Question:** How do you price/limit a tiered API product fairly?

**Answer:** Align limits with infrastructure cost-to-serve; expose dashboards; distinguish burst (token bucket) from monthly quota; graduate limits with sales oversight; alert product when organic traffic hits ceilings.

---

**Question:** Public GraphQL—what extra gates are mandatory?

**Answer:** Depth/cost limits, persisted or allowlisted queries, disable introspection in prod if needed, auth per field, and query-cost based rate limits.

---

**Question:** Docs always drift—systems fix?

**Answer:** Schema-first or code-gen from annotated handlers, CI response validation against examples, publish site from repo artifact, automated changelog from diff.

---

**Question:** An API platform’s egress bill spikes after a mobile release. What do you investigate?

**Answer:** Uncompressed payloads, chatty pagination, N+1 client patterns, image assets proxied through the API instead of CDN, and missing `Accept-Encoding`. Pair infra data with per-endpoint payload size metrics to prioritize fixes.

---

**Question:** Two product teams want different versioning cadences for the same consolidated API—how do you govern that?

**Answer:** Decouple service deploy from contract version: maintain stable external routes, use feature flags for internal rollouts, automate breaking-change detection, negotiate cross-team SLAs for migrations, and never let one team silently break another’s build.

---

**Question:** A public partner deliberately abuses flexible search filters. What is your layered response?

**Answer:** Progressive tighten: validate allowlists, per-client query cost budgets, cap fan-out depth, dynamic blocks with human review, and contractual escalation—balance fraud prevention with false positives.

### Scenario-Based Questions

**Question:** Build payments API with charges, refunds, webhooks.

**Answer:** Nouns + commands carefully, mandatory idempotency, PSP-aligned status machine, signed webhooks with replay IDs, sandbox keys, Problem Details for declines, cursor lists, vaulting rules documented.

---

**Question:** Multi-tenant SaaS API isolation.

**Answer:** Tenant resolved from token, middleware enforces scoping, RLS optional defense-in-depth, per-tenant rate limits, logs redact cross-tenant IDs.

---

**Question:** Mobile screen needs five microservice calls.

**Answer:** BFF with parallel fan-out and timeouts, or GraphQL with batchers; measure p95 with partials—never sequential waterfalls by default.

---

**Question:** 5 GB upload API.

**Answer:** Multipart or presigned multipart to blob storage; complete/abort APIs; virus scan stream; integrity checksums; chargeback-friendly audit metadata.

---

**Question:** Need search API with nested boolean filters.

**Answer:** `POST /search` JSON DSL with allowlisted ops, pagination, explain slow queries, protect with cost caps.

### Trick Questions

**Question:** Is PUT always safe to retry blindly?

**Answer:** Spec-wise idempotent on server state, but buggy server-side upserts or auto fields can surprise you—still client responsibility to send full intended resource for PUT.

---

**Question:** Is REST “just CRUD”?

**Answer:** CRUD maps loosely to HTTP verbs, but REST also encodes caching, statelessness, and uniform interfaces—RPC-shaped “REST” loses benefits.

---

**Question:** Return 200 with `{found:false}` for missing user?

**Answer:** Hides semantics from intermediaries and clients; prefer 404 (or masked 404 for authz). Collections may return `[]` with 200.

### Weak Answers and Red Flags

1. **“We skip versioning—we own all clients.”** App store lag and partner integrations break that assumption instantly.
2. **“POST everything for simplicity.”** Sacrifices caching, semantics, and safe retries without compensating controls.
3. **“Rate limit inside each microservice only.”** Inconsistent policies and duplicated bugs—centralize at edge unless specialized local limits are documented.

---

## System Design

### Basic Questions

**Question:** Distinction between SLI, SLO, SLA?

**Answer:** SLI measures behavior; SLO targets it internally; SLA is contractual with teeth. Not every service needs an SLA; every prod service benefits from SLOs and error budgets.

---

**Question:** Latency vs throughput?

**Answer:** Latency is per-request time (use percentiles); throughput is sustained RPS. Fixes differ: throwing servers at throughput does not cure tail latency dominated by slow queries.

---

**Question:** Horizontal vs vertical scaling trade-off?

**Answer:** Vertical hits HW ceilings and fault domains; horizontal needs statelessness, partitioning strategy, and more ops complexity. Most cloud-native stacks prefer horizontal with controlled state stores.

---

**Question:** What is consistent hashing used for?

**Answer:** Distribute keys across nodes while minimizing reshuffle on membership change—caches, sharded brokers, some data stores. Watch hotspot virtual nodes can still skew.

---

**Question:** Define back-pressure at system level.

**Answer:** Mechanism slowing producers when consumers saturate—`<429, Retry-After>`, queue rejections, or stream flow control. Without it, queues grow until memory/disk failure.

---

**Question:** Queue vs log (Kafka) quickly?

**Answer:** Queue: work distribution, often delete-on-ack. Log: replay, multiple consumer groups, time retention. Pick based on coupling + audit needs.

---

**Question:** What is a circuit breaker protecting?

**Answer:** Failing dependencies from soaking threads, connections, or thread pools—opens fast-fail path while recovering.

---

**Question:** CAP in one interview-ready sentence?

**Answer:** Under partition, choose between strong consistency (may reject) and availability (may serve stale); PACELC adds latency vs consistency even without partitions.

---

**Question:** RPO vs RTO?

**Answer:** RPO bounds acceptable data loss window; RTO bounds downtime to recover. They drive replication and drill requirements.

---

**Question:** Read-through vs cache-aside?

**Answer:** Cache-aside: app manages population; read-through: cache fetches on miss—simpler app vs smarter cache integration.

---

**Question:** What is a saga and why not 2PC?

**Answer:** Sequence of local txs with compensations—2PC across microservices is brittle, slow, and couples availability; sagas accept interim visibility.

---

**Question:** Why tail latency matters in fan-out?

**Answer:** Probability that at least one child is slow rises with branch count; overall p99 approaches worst child behavior—design budgets per hop.

### Senior Questions

**Question:** Design cache layer for 10k read RPS with 95% hit target—how is cache not an SPOF?

**Answer:** Clustered Redis with replicas + automatic failover, warm caches after deploy, mutex/single-flight against stampede, fallback to DB with known capacity headroom, monitor hit ratio/evictions.

---

**Question:** Strong vs eventual consistency by subsystem?

**Answer:** Money movements and inventory locks need linearizable paths or careful read-your-writes patterns; social feeds may lag seconds. Mix models per domain with explicit user-visible guarantees.

---

### Question

Hot key on one shard—what now?

### Strong Answer

Detect via shard metrics, identify key or skewed tenant. Mitigate with local caching for read-hot keys, splitting counters, randomized write sharding, rerouting mega-tenants, or rate limiting abusive accessors. Long term fix schema/partition strategy; short term add circuit breakers on that key path.

### Explanation

Shows you know resharding alone does not cure hotspot semantics.

### Practical Example

Celebrity fan counter → shard into `count:{id}:i` slices, read sums cached briefly.

### What the Interviewer Is Testing

Data-plane debugging and pragmatic mitigation ladders.

### Weak Answer

“Add shards.”

### Red Flags

- Thinks more shards automatically spread a single hot key
- No cache or admission control talk

---

**Question:** Cross-service consistency without distributed transactions?

**Answer:** Outbox + CDC, sagas with idempotent consumers, materialized views for reads, explicit staleness SLAs to product.

---

**Question:** Evaluate monolith → microservices proposal.

**Answer:** Quantify pain, try modular monolith + faster CI, check observability/on-call readiness, strangler extract with contracts—reject hype-driven splits.

---

### Question

Multi-region: compare active-passive vs active-active with data in mind.

### Strong Answer

Active-passive: simpler, cheaper, longer failover, RPO/RTO depends on replication lag and drills. Active-active: lower regional latency and faster failover but needs conflict resolution, split-brain safeguards, and often higher write latency if synchronizing widely. Layer compliance: data residency may forbid global copies—route users to home region.

### Explanation

Interviewers want partition tolerance plus business constraints.

### Practical Example

EU users’ PII never replicated in US—local enforcement in routing + storage.

### What the Interviewer Is Testing

Geo-distributed reasoning, compliance hooks, ops realism.

### Weak Answer

“Route53 failover between regions.”

### Red Flags

- No replication/consistency story
- No mention of data locality laws

---

**Question:** Zero-downtime DB migrations outline?

**Answer:** Expand-and-contract, dual writes with verified backfill, online index creation, phased read shifts, then drop legacy column after monitoring.

---

**Question:** Capacity plan for 10× yearly growth?

**Answer:** Baseline metrics → model growth drivers (fan-out?) → identify first bottlenecks (conn limits, hotspots) → staged hardening with threshold playbooks + load tests.

---

**Question:** Share data without shared DB—patterns?

**Answer:** Events + local projections (default), sync API for fresh small reads, read-only replica views only with eyes open to coupling.

---

**Question:** Observability baseline for many services?

**Answer:** RED metrics, trace propagation, structured logs with shared trace IDs, SLO alerts on symptoms, runbooks per alert, SLI burn dashboards.

---

**Question:** How do you design a fair distributed rate limiter?

**Answer:** Shared store (often Redis) with atomic scripts, token bucket or sliding window per identity, gateway placement when possible, explicit fail-open vs fail-closed policy during store outages, and standard headers for client backoff.

---

**Question:** How do you isolate noisy neighbors in a multi-tenant data plane?

**Answer:** Per-tenant quotas on API and async work, separate pools for enterprise tenants when contracts demand it, row-level scoping + optional RLS, and fairness controls on hot consumers of shared topics.

### Tech Lead Questions

**Question:** 100k concurrent users in six months with five engineers—bootstrap architecture?

**Answer:** Modular monolith, managed DB/cache, minimal services, horizontal-ready stateless app, defer multi-region/kafka sprawl until metrics demand; invest in CI and observability templates.

---

### Question

How do you arbitrate “ship features” vs “fix reliability” publicly to execs?

### Strong Answer

Use error budgets: healthy budget → feature bias; exhausted → reliability gate with communicated ETA. Tie narrative to revenue/risk, not engineering preference. Pair with incident trend drivers.

### Explanation

Demonstrates SRE product management, not dogma.

### Practical Example

99.9% monthly budget ≈ 43m—burning 80% in week two triggers feature freeze checklist.

### What the Interviewer Is Testing

Stakeholder communication with measurable policy.

### Weak Answer

“20% of every sprint is quality.”

### Red Flags

- Fixed percentages ignoring live risk
- Cannot explain error budgets

---

**Question:** Evaluate adopting Kafka—framework?

**Answer:** Problem fit, team ops skill, TCO vs managed alternative, lock-in/exit, perf PoC with explicit success criteria captured in ADR.

---

**Question:** DR plan for regulated payments—non-negotiables?

**Answer:** Clear RPO/RTO, synchronous replication justification, automated failover drills, backups with restore tests, dependency SLAs, comms playbook.

---

**Question:** Cost management program?

**Answer:** Tagging, anomaly detection, right-sizing, architectural wins (cache vs replicas), lifecycle archival, chargeback to teams.

---

### Question

Design a URL shortener for ~50k redirects/s—numbers first.

### Strong Answer

Estimate read:write ratio; primary key or hashed lookups; Redis fronting DB with stampedede controls; optional prewarm; choose 301 vs 302 based on analytics need; horizontal stateless layer; cluster Redis; monitor hit ratio and DB QPS after cache. Mention multi-region only if latency goals require edge presence.

### Explanation

Checks estimation + realistic hot-read path.

### Practical Example

50k RPS * 5% miss * 1KB payload still trivial if DB stays sub-5k QPS—state math defends Redis.

### What the Interviewer Is Testing

Order-of-magnitude reasoning, caching, HTTP semantics trade-offs.

### Weak Answer

“Use Dynamo because NoSQL scales.”

### Red Flags

- No arithmetic
- Technology label instead of bottlenecks

---

**Question:** How do you run an architecture review that actually changes outcomes?

**Answer:** Frame five checks—problem fit, trade-offs named, failure modes, operability/runbooks, TCO—and end with an ADR. Reviews question assumptions instead of enforcing personal taste.

---

**Question:** How should technical debt register connect to system design?

**Answer:** Quantify drag (incident frequency, lead time), tie remediation to SLO risk, reserve standing capacity, attach debt paydown to features touching the area, and communicate ROI to product in their vocabulary.

---

**Question:** What is your template for evaluating new infrastructure tech?

**Answer:** Problem statement with metrics, ops readiness, 3-year TCO, exit strategy, compliance posture, and time-boxed PoC with predeclared success/failure gates—document in ADR either way.

---

**Question:** How do you run game days for regional failover without customer harm?

**Answer:** Start in staging with fault injection, rehearse comms trees, validate RPO/RTO with measured replay, graduate to limited prod drills with feature-flagged drains, and file concrete remediation tickets from gaps.

### Scenario-Based Questions

**Question:** Ride matching nearby drivers under low latency.

**Answer:** Geospatial index (geohash/S2), neighbor cell expansion, atomic assignment with optimistic locking, regional partitions, reassignment timeouts.

---

**Question:** Global game leaderboard ~10M players real-time.

**Answer:** Redis sorted sets, pipelined updates, persistence strategy, sharding by season/region if memory-bound, avoid SQL `ORDER BY` hot paths.

---

**Question:** Payment retries safe against double charge.

**Answer:** Idempotency keys + gateway keys + reconciliation worker + state machine visible to support.

---

**Question:** Regional outage—traffic shift expectations?

**Answer:** Drill-driven failover, data replication limits, staleness messaging, avoid dual writes without CRDT/conflict plan; verify stateless tiers burst in DR region.

---

**Question:** Content moderation 10M posts/day.

**Answer:** Kafka partition strategy, ML+human tiers, reviewer throughput math, feedback loop for false positives/negatives, SLA per content type.

---

**Question:** Sudden cache cluster failure mid-peak.

**Answer:** Shed load, fail to origin if sized, enable single-flight, temporarily widen TTL elsewhere, communicate user-visible delays, post-incident fix autoscaling of origin + cache replica tiers.

### Trick Questions

**Question:** Does adding servers cut p99 if CPU is 30%?

**Answer:** Not if latency is from locks or external dependencies—profile first.

---

**Question:** Are messages “processed exactly once” easy?

**Answer:** End-to-end exactly-once is elusive; design idempotent consumers with at-least-once brokers.

---

**Question:** Is Kafka ordering global?

**Answer:** Ordering per partition; cross-partition totals unordered—design keys deliberately.

---

**Question:** Can you “solve” CAP by picking CA?

**Answer:** Partition tolerance is a fact of networks—reframe tradeoffs as latency/consistency during partitions.

### Weak Answers and Red Flags

1. **“Microservices because we need scale.”** Scale follows measured bottlenecks; premature distribution multiplies failure budgets.
2. **“We’ll use strong consistency everywhere.”** Ignores latency, availability, and regional replication costs.
3. **“Load tests on mini staging proved we handle Black Friday.”** Mis-sized environments lie—capacity claims need representative topology + data volume.
4. **“Active-active multi-region is always better.”** Conflicts, cost, and compliance often make passive DR the adult choice.

---

## Software Architecture

### Basic Questions

**Question:** Coupling vs cohesion in one breath?

**Answer:** Prefer loose coupling between modules and high cohesion inside—splitting cohesive units raises coupling across API surfaces.

---

**Question:** What is a bounded context and why split there?

**Answer:** Language + model boundary where terms mean different things; aligns services/modules with independent evolution.

---

**Question:** ADR minimum useful content?

**Answer:** Context, decision, options, trade-offs, consequences, status—without rejected alternatives you cannot revisit intelligently.

---

**Question:** Strangler fig pattern?

**Answer:** Incrementally route workloads from legacy to new via edge seams until legacy starves—reversible steps.

---

**Question:** What does a fitness function automate?

**Answer:** Architectural invariants (forbidden imports, latency budgets, schema ownership) checked in CI to stop erosion under schedule pressure.

---

**Question:** Database-per-service rule?

**Answer:** Each service owns its datastore; others integrate via API/event, not SQL peeks—to keep schema autonomy.

---

**Question:** Anti-corruption layer role?

**Answer:** Translates messy external models into your domain language so upstream quirks do not cascade inward.

---

**Question:** Modular monolith vs distributed monolith?

**Answer:** Modular uses one deploy with enforced boundaries; distributed monolith couples remote services like a monolith without independent value—worst of both worlds.

---

**Question:** CQRS in one line?

**Answer:** Separate write model from read-optimized projections—accept eventual consistency tax for read scaling.

---

**Question:** Conway’s Law implication?

**Answer:** Org graph shapes system graph—align intentional team ownership with architecture or fight constant friction.

### Senior Questions

### Question

How do you draw service boundaries that survive reorgs?

### Strong Answer

Start from domain language + change coupling, overlay team ownership (two-pizza), validate deploy independence with metrics (who blocks whom), and refuse entity-splits that ignore interaction graphs. Document reversible merges as well as splits.

### Explanation

Tests DDD + org awareness.

### Practical Example

If Order + Shipping always co-change, keep together until separate SLAs prove value.

### What the Interviewer Is Testing

Boundary literacy beyond nouns.

### Weak Answer

“Microservice per table.”

### Red Flags

- No mention of change coupling or team topology

---

**Question:** Monolith deploy at 45m blocks teams—first interventions?

**Answer:** Modularize + ownership, parallel CI, affected tests, feature flags for decoupled release, only then consider extraction with contracts.

---

**Question:** Event sourcing—when worth it?

**Answer:** Regulatory audit, time travel, replay-based recovery; otherwise prefer simpler append-only audit logs. Price schema evolution + snapshot strategy upfront.

---

**Question:** Saga without 2PC—what must be true?

**Answer:** Idempotent steps, compensations, visible intermediate states, monitoring per saga, timeouts, and human escalation paths.

---

**Question:** Microservice readiness checklist?

**Answer:** Independent CI/CD, tracing/logging/metrics, on-call + runbooks, versioning/contracts, clear data ownership, game days—not “we use k8s.”

---

### Question

How do you deprecate a two-year-old ADR that no longer fits?

### Strong Answer

Trigger reviews on scale/team/cost/regulatory changes—not novelty. Write superseding ADR referencing prior context, migrate with phased plan, communicate to teams consuming the decision, and archive old status explicitly.

### Explanation

Architecture stewardship is lifecycle management.

### Practical Example

ADR-17 “Postgres only” superseded when analytics isolates OLAP with read replicas + lake export—document blast radius.

### What the Interviewer Is Testing

Governance maturity, respect for history.

### Weak Answer

“Delete the old ADR quietly.”

### Red Flags

- Technology-chasing without context delta
- No communication path

---

**Question:** Compare event notification vs carried-state transfer.

**Answer:** Notification couples consumers to producer APIs for details; ECST duplicates data but decouples runtime—choose by fan-out, freshness, payload size.

---

**Question:** When do you default to synchronous HTTP vs topic-based integration?

**Answer:** Synchronous when the caller needs an immediate answer and downstream is reliable inside your latency budget; asynchronous when work can decouple, bursts must be absorbed, or many subscribers react independently—never async “for purity” without clarity on consistency.

---

**Question:** When is CQRS worth the complexity—and what breaks if you misapply it?

**Answer:** Worth it when read models need heavy denormalization or independent scaling from writes. Breaks when teams underestimate projection lag, miss sync monitoring, or apply CQRS to simple CRUD—fuel for subtle production bugs.

---

**Question:** Outline legacy migration with strangler plus data consistency.

**Answer:** Route at edge, dual-write or CDC with reconciliation jobs, compare outputs per slice, sunset legacy module only when metrics and contracts prove parity—never flip entire tables in one night.

### Tech Lead Questions

**Question:** One team begs to peel their module into a service in a modular monolith org-wide—your rubric?

**Answer:** Necessity (measured scale/deploy pain), readiness (CI/observability/contracts), cost (months + ongoing ops). Reject resume-driven requests; offer boundary cleanup first.

---

### Question

How do you run RFC/ADR discussions when the team splits 50/50?

### Strong Answer

Classify reversibility: delegate low-stakes; for irreversible, publish competing ADRs with scored criteria, time-box debate, record dissent + triggers to revisit, decide transparently to avoid design-by-committee paralysis.

### Explanation

Leadership without abdication or tyranny.

### Practical Example

Hashing algorithm or logging library → team choice; new multi-master data store → ADR + security + SRE sign-off.

### What the Interviewer Is Testing

Decision process quality under disagreement.

### Weak Answer

“Let’s vote.”

### Red Flags

- No accountability after vote
- No documented criteria

---

**Question:** Communicate modular monolith decision to execs?

**Answer:** Tie to delivery speed now, risk-managed extraction triggers later, dollars saved on fewer on-call surfaces—translate jargon.

---

**Question:** Platform team vs embedded infra work—when spin up?

**Answer:** After duplicated pain hits 3+ teams on undifferentiated plumbing; fund self-service templates—not ticket takers.

---

**Question:** Ten-year legacy, no tests—first modernization moves?

**Answer:** Observability + characterization tests, domain interviews, strangler on clearest seam, parallel validation, don’t freeze legacy maintenance prematurely.

---

**Question:** How do you protect architectural bandwidth while product demands accelerate?

**Answer:** Publish a visible 15–20% standing allocation, attach refactors to features touching an area, and tie every pitch to measurable velocity or risk reduction so stakeholders see the opportunity cost of skipping it.

---

**Question:** How do you make architecture standards stick without you reviewing every PR?

**Answer:** Automate fitness functions for import rules, performance budgets, and schema ownership; use architecture guild for social reinforcement; treat ADRs as searchable precedents developers query before debating again.

---

**Question:** Walk through a build-vs-buy decision for identity/payments infrastructure.

**Answer:** Score strategic differentiation (usually low for auth), 3-year TCO including on-call, compliance attestations, switching cost via abstraction boundaries, and pace-of-innovation needs—default to managed specialists unless you truly differentiate on fraud modeling.

### Scenario-Based Questions

**Question:** Food delivery platform architecture at 12 vs 40 engineers.

**Answer:** Modular monolith early with explicit contexts; later extract high-churn geospatial/dispatch bounded contexts with event contracts.

---

**Question:** SaaS tenants demand custom workflows/fields.

**Answer:** Workflow engine + JSONB extension points + feature flags; forbid per-tenant forks; isolate with strong tenant scoping/RLS.

---

**Question:** Acquisition integration mismatch.

**Answer:** ACL, map concepts, choose SoT per entity, CDC/event sync, phased decommission, strangler routing.

---

**Question:** Real-time collaborative doc MVP.

**Answer:** Pick CRDT library or OT carefully, WebSockets + pub/sub fanout, snapshot persistence cadence, offline semantics expectation setting.

---

**Question:** Notification system 1M/day with priorities.

**Answer:** Priority queues/workers per channel, DLQs, idempotency, quiet hours, observability on age-of-message, vendor rate limits abstracted.

### Trick Questions

**Question:** “Microservices guarantee faster delivery.” True?

**Answer:** Only with mature platform; otherwise coordination + debugging overhead slows teams—measure lead time.

---

**Question:** Shared DB “for now” between two squads—fine?

**Answer:** Creates hidden coupling—violates bounded autonomy; pay down with ACL + eventual extraction plan.

---

**Question:** “We’ll use CQRS everywhere.” Smart?

**Answer:** Usually overkill—apply where read/write asymmetry justifies complexity tax.

### Weak Answers and Red Flags

1. **“Architecture diagrams in Confluence equal governance.”** Without automated fitness functions and reviews tied to outcomes, docs rot instantly.
2. **“We standardize tech with zero exceptions.”** Ignores legitimate divergence (batch vs realtime paths) and fosters shadow IT.
3. **“Rewrite the legacy since it’s messy.”** Big-bang rewrites fail quietly for years—incremental strangler plus risk metrics wins audits.


## Security

### Basic Questions

**Question:** How do you explain the difference between authentication and authorization to a product stakeholder?

**Answer:** Authentication establishes who someone is (credentials, MFA, tokens). Authorization decides what they may do (roles, policies, resource checks). Systems often get the first right and still leak data when the second is wrong—e.g., a valid session reading another tenant’s records. Framing them separately shapes where you test and review: identity pipelines vs. every API boundary.

---

**Question:** What is defense in depth, and why is “one strong control” not enough?

**Answer:** Defense in depth stacks independent controls (network, transport, identity, app validation, data protection). If one layer fails—misconfigured WAF, leaked secret, buggy parser—others still limit damage. Trade-off: more layers mean more operational cost and coordination; the goal is meaningful coverage, not checklist sprawl.

---

**Question:** What does the OWASP Top 10 represent for a Tech Lead?

**Answer:** A shared risk vocabulary for web apps (injection, broken access control, crypto failures, etc.). You use it to map controls, prioritize training, and speak credibly with security and auditors—not as a substitute for threat modeling your actual architecture.

---

**Question:** How does SameSite on cookies relate to CSRF?

**Answer:** `SameSite` restricts when browsers attach cookies on cross-site requests. `Lax`/`Strict` blocks many classic CSRF flows where another site triggers a state-changing POST with ambient credentials. It does not replace authorization checks or fix XSS; it narrows one browser-driven attack class.

---

**Question:** Why are parameterized queries the standard fix for SQL injection?

**Answer:** They separate SQL structure from user-supplied data so inputs are always data, never syntax—even if strings contain SQL keywords. ORMs help, but raw SQL and dynamic builders can still reintroduce risk; code review and scanners still matter.

---

**Question:** What is SSRF, and what is a typical high-impact target?

**Answer:** Server-side request forgery: the server is tricked into calling attacker-chosen URLs, often reaching internal IPs or cloud metadata endpoints. Impact includes credential theft and lateral movement. Mitigations include URL allowlists, blocking RFC1918/link-local ranges, DNS rebinding checks, and network egress controls.

---

**Question:** What is the threat model behind storing refresh tokens in HttpOnly cookies?

**Answer:** HttpOnly hides cookies from `document.cookie`, reducing XSS exfiltration of session material compared to tokens in JS-accessible storage. You still need secure transport, rotation, replay detection, and tight CORS—cookies are not a universal win for SPAs if architecture pushes tokens elsewhere.

---

**Question:** What is an SBOM, and when does it earn its keep?

**Answer:** A Software Bill of Materials lists components (direct and transitive). It accelerates triage when a CVE drops (“are we affected?”), supports compliance, and pairs with scanners and attestations. Without CI generation and ownership, it becomes shelfware.

---

**Question:** How does zero trust differ from “trusted internal network”?

**Answer:** Zero trust verifies identity and policy per request regardless of network origin—VPN membership is not proof of legitimacy. It pairs with least privilege, segmentation, and short-lived credentials. Trade-off: more infra (mTLS, IdP, policy engines) versus legacy perimeter simplicity.

---

**Question:** What is envelope encryption at a high level?

**Answer:** Data keys encrypt payloads; a KMS-protected key encrypts those keys. Rotation and blast-radius management improve versus one static master password in-app. Cost and KMS dependency are the operational trade-offs.

---

**Question:** Why does OIDC sit “on top of” OAuth 2.0 in many systems?

**Answer:** OAuth 2.0 focuses on delegated access (tokens for APIs). OIDC adds identity artifacts (ID token, standard user claims) so clients know who signed in without inventing custom profile endpoints. Treat access tokens and ID tokens differently in validation and storage.

---

**Question:** What is credential stuffing, and how does it differ from brute force?

**Answer:** Credential stuffing replays username/password pairs from unrelated breaches; brute force guesses passwords for one account. Stuffing is distributed, low success per attempt but effective at scale. Mitigations: MFA, breached-password checks, bot detection, IP/account throttles.

---

### Senior Questions

### Question

How would you run a lightweight threat modeling session for a new “user file upload” feature?

### Strong Answer

Scope the asset, trust boundaries (browser → API → object store → CDN), and adversaries. Use STRIDE-style prompts: spoofing uploads, tampering with content type or extension, denial via huge files, information disclosure via metadata or overly broad ACLs, elevation if files become executable. Turn mitigations into concrete acceptance criteria: server-side content sniffing, size quotas, virus scanning where required, random object keys, `Content-Disposition`, stripping EXIF, blocking dangerous SVG/HTML, signed URLs, and tests that prove one user cannot read another’s objects.

### Explanation

Interviewers want structured thinking, not encyclopedic STRIDE recitation. Link each threat class to realistic controls and tests.

### Practical Example

Require `application/octet-stream` re-validation with libmagic, store outside web root, serve via CDN with separate domain, deny `text/html` unless explicitly sanitized.

### What the Interviewer Is Testing

Threat modeling fluency, secure-by-default design, and ability to translate risks into delivery work.

### Weak Answer

“We’ll validate file extensions on the client and use HTTPS.”

### Red Flags

- No trust-boundary discussion  
- Client-only validation  
- Ignores SSRF/XSS via SVG or stored content  

---

**Question:** How do you decide between session cookies and bearer access tokens for a BFF vs. pure SPA talking to APIs?

**Answer:** Cookie sessions shine when you need fast revocation, server affinity, and can harden CSRF/CORS. Bearer tokens fit heterogeneous clients and service meshes where gateways validate JWTs. Hybrids need explicit storage, rotation, XSS, and CSRF analysis—there is no default “more secure,” only fit to architecture.

---

**Question:** Describe safe refresh-token handling at a systems level.

**Answer:** Short-lived access tokens, long-lived refresh tokens bound to device, rotation on use, reuse detection to kill token families, store hashes server-side, rate-limit refresh, and monitor anomaly. For browsers, prefer HttpOnly cookies for refresh where threat model allows; never log tokens.

---

**Question:** How do you respond to a scanner reporting hundreds of dependency findings?

**Answer:** Group by component, dedupe transitive repeats, score exploitability (reachable code, network exposure, privileges), set SLAs by severity, automate ticket creation, and block merges on critical in reachable paths. Allow documented false positives with expiry. Prevents paralysis and rubber-stamping.

---

**Question:** What goes into securing a CI/CD pipeline end-to-end?

**Answer:** OIDC over static cloud keys, pinned third-party actions/images by digest, branch protection and CODEOWNERS on workflow files, least-privilege job tokens, secret scanning, artifact signing and verification, SBOM export, and separation of build vs. deploy credentials. Assume workflow files are application code with blast radius.

---

**Question:** How do you prevent SSRF in outbound webhook or “fetch URL” features?

**Answer:** Block private IP ranges and metadata IPs, resolve then re-check IPs, short timeouts, disable redirects to internal hosts, optional domain allowlists, and isolate egress via hardened proxies or serverless with constrained networking. Log decisions without storing raw user URLs verbatim in insecure logs.

---

**Question:** What are SAST and DAST each good—and bad—at?

**Answer:** SAST finds dangerous patterns in source quickly but produces noise and misses runtime config issues. DAST exercises running systems for real HTTP behaviors but is slower and environment-dependent. Run SAST on PRs; layer DAST selectively on staging or pre-release; neither replaces threat modeling or pentest for novel logic bugs.

---

**Question:** How would you isolate tenants in a shared Postgres?

**Answer:** Mandatory `tenant_id`, middleware-derived session context, Row-Level Security policies, tests asserting cross-tenant reads fail, and connection-pool settings compatible with per-request context. Consider per-tenant crypto only when contracts demand it—operational cost rises fast.

---

**Question:** What is algorithm confusion in JWTs, and how do you avoid it?

**Answer:** Servers that accept both symmetric and asymmetric algorithms may let attackers forge tokens by misusing a public key as an HMAC secret. Fix by allowing an explicit algorithm allowlist, using vetted libraries, validating `iss`/`aud`, and centralizing token issuance—not reimplementing crypto ad hoc.

---

**Question:** What does HSTS achieve, and which classes of attacks remain afterward?

**Answer:** HSTS forces HTTPS for a browser once the header is seen, shrinking SSL-stripping and mixed-content downgrade windows. It does not stop application bugs (XSS, IDOR), stolen tokens, or server-side TLS misconfiguration on first visit—still pair with secure cookies, CSP, and patching.

---

**Question:** How do fixed-window and sliding-window rate limits differ for abuse protection?

**Answer:** Fixed windows are simple but allow burst exploitation at boundaries; sliding (or token-bucket) windows smooth enforcement and better approximate sustained abuse budgets. For auth endpoints, favor keys that combine IP + account with conservative thresholds and observability on blocks.

---

**Question:** What operational concerns accompany encryption at rest and backups?

**Answer:** Encrypted data is only as strong as key governance: rotation, IAM separation, and encrypted backups with independent keys. Restore drills must prove you can decrypt; accidental key loss equals data loss—document custody, break-glass, and scanning for cleartext dumps.

---

### Tech Lead Questions

### Question

How do you grow security practice in an engineering org without becoming the team bottleneck?

### Strong Answer

Automate first: SAST, dependency and container scan, secret scanning, IaC policy. Encode the top recurring issues into PR checklists and linters. Train security champions per squad for escalation. Time-box threat models on high-risk changes (payments, auth, data exports). Measure vuln SLAs and MTTR. Escalate process failures, not individuals—blameless reviews when controls miss issues.

### Explanation

Maturity shows in systems that scale—delegation plus automation—not hero reviews.

### Practical Example

Semgrep rules for dangerous patterns, reusable GitHub Actions templates with mandatory scans, weekly vuln triage ritual with product representation.

### What the Interviewer Is Testing

Influence without authority, prioritization, and operationalizing security.

### Weak Answer

“I personally review anything security-sensitive.”

### Red Flags

- Single-person gate  
- No metrics or automation  
- Punitive tone toward developers  

---

### Question

A critical CVE hits a shared library used by many services—walk through your first 24 hours.

### Strong Answer

Confirm versions in runtime images vs. lockfiles, assess exploitability in your context (attack surface, sandboxing), communicate a single status channel, assign owners per service, ship coordinated bumps or interim mitigations (WAF, feature kill-switch), verify with scans or exploit PoCs where ethical, and schedule post-incident hardening (pinning strategy, shared wrapper). Prioritize internet-facing and high-privilege paths first.

### Explanation

Tests triage judgment, coordination, and risk-based sequencing—not panic patching.

### What the Interviewer Is Testing

Cross-team orchestration, pragmatic security, and communication.

### Weak Answer

“Merge Dependabot everywhere ASAP.”

### Red Flags

- No exploitability thinking  
- No sequencing or verification  
- Ignores operational blast radius  

---

**Question:** How do you align SOC 2 / GDPR work with shipping velocity?

**Answer:** Map controls to engineering artifacts: IaC for change management, CI logs for segregation of duties signals, automated access reviews tickets, data inventory linked to code modules. Push controls into paved-road tooling so compliance is evidenced by normal work, not end-of-quarter scavenger hunts.

---

**Question:** What is your stance on Kubernetes Secrets in env vars?

**Answer:** Env vars are easy but leak via `/proc`, logs, and dumps—prefer mounted files with tight permissions, encryption at rest in etcd, external secret operators, and scoped identities. Classify config vs. secret; not everything needs Vault, but production secrets deserve more than base64 in Pod specs alone.

---

**Question:** How do you define vulnerability SLAs across squads?

**Answer:** Severity rubric mapped to reachability, CVSS as input not gospel, automated ticketing with due dates, escalation paths, exception process with compensating controls, dashboards by owner, and periodic trend reviews to fix systemic classes (shared library upgrades).

---

**Question:** What decisions go into microservice-to-microservice authZ/authN?

**Answer:** mTLS or signed tokens, identity for workloads, central policy vs. localized checks, network policies, observability for auth failures, secret rotation stories, and blast-radius limitation when one service is compromised—avoid long-lived shared API keys across twelve services.

---

**Question:** How do you run an incident tabletop for a leaked signing key or cloud admin credential?

**Answer:** Pre-script roles, inject realistic log snippets, practice revoke/rotate sequencing, communications templates, and legal/compliance triggers in a timed exercise. Output actions to tooling gaps (missing break-glass accounts, slow revocation) rather than slides alone.

---

**Question:** When is cloud KMS mandatory versus application-managed data keys?

**Answer:** KMS shines when you need centralized auditing, HSM-backed roots, envelope patterns, and uniform rotation—especially for regulated data. App-managed keys add operational burden and often fail open; small systems may start with provider-managed keys but plan migration before compliance deadlines harden.

---

### Scenario-Based Questions

**Question:** An AWS key was pushed to GitHub—what is your order of operations?

**Answer:** Assume compromise: revoke keys immediately, audit CloudTrail for usage, contain resources created, rotate adjacent credentials, notify stakeholders if data touched, then post-mortem secret scanning hooks, pre-commit tools, and least-privilege reduction.

---

**Question:** Pentest finds stored XSS in rich text—fix timeline?

**Answer:** Short-term CSP tightening and input rate limits if needed, forensics on stored payloads, server-side sanitization allowlist, migration path to structured content (Markdown/JSON AST), purge or sanitize historical records, add regression tests and lint rules.

---

**Question:** Design audit logging for regulated healthcare reads.

**Answer:** Immutable append-only store, who/what/when/where/patient context, tamper resistance, retention per regulation, access controls on auditors, monitoring for bulk access, break-glass flows with heightened alerts.

---

**Question:** Former employee still has production access—what now?

**Answer:** Cut IdP, cloud, VPN, CI tokens immediately; session kill; access log review for exfil; legal/compliance if sensitive data touched; fix offboarding automation and access reviews; document timeline.

---

**Question:** Proposed design: symmetric HS256 shared across all microservices for JWT—concerns?

**Answer:** Any compromised verifier can forge tokens for all services; key rotation requires lockstep deploys; asymmetric keys with issuer-only signing reduce blast radius—plan phased migration with `kid` and dual validation window.

---

**Question:** How would you roll out CSP on a legacy monetized web app?

**Answer:** Report-only first, collect violations, iteratively tighten, replace inline handlers, use nonces/hashes, partner with frontend on third-party scripts, then enforce while monitoring reports for regressions.

---

### Trick Questions

**Question:** Is HTTPS enough to call the app “secure”?

**Answer:** No—TLS protects transport, not logical flaws (IDOR, XSS, business logic). It is necessary, not sufficient.

---

**Question:** Are JWT payloads encrypted by default?

**Answer:** No—JWS is signed and Base64url-encoded, not confidential. Treat claims as public to any holder; use HTTPS and avoid sensitive fields, or use JWE where appropriate.

---

**Question:** Does an ORM eliminate SQL injection?

**Answer:** It eliminates many classes via parameterization, but unsafe raw queries, string-built dynamic SQL, or ORM bugs can reopen the hole—discipline still required.

---

**Question:** Is longer password maximum length better?

**Answer:** Excessively low max lengths suggest legacy hashing bugs; absurdly high lengths enable DoS unless bounded. Reasonable high limits (e.g., 1–8 KB) with slow hashing protect users passphrases without accepting multi-megabyte denial payloads.

---

### Weak Answers and Red Flags

1. **“We hash passwords with SHA-256—it's a cryptographic hash.”** Fast hashes are for integrity; passwords need slow salted KDFs (Argon2, bcrypt). This signals fundamental misuse of primitives.  
2. **“Internal APIs skip auth—we’re behind the corporate VPN.”** VPNs authenticate network membership, not callers; lateral movement after one breach is trivial—signals zero-trust gap.  
3. **“Security is handled in a hardening sprint before launch.”** Security is architectural; bolt-on sprints miss design flaws and accumulate retrofit debt.  
4. **“JWTs mean we don’t do session management.”** Tokens still need lifecycle, rotation, revocation strategy, audience checks, and storage threat analysis—another oversimplification.

---

## Testing and Quality

### Basic Questions

**Question:** What is the testing pyramid, and why do teams argue about its shape?

**Answer:** The pyramid suggests many fast isolated tests, fewer integration tests, and even fewer E2E tests for cost vs. confidence balance. Critics note UI-heavy systems may need more focused integration/E2E coverage (trophy/honeycomb shapes). The useful idea: push cheap tests wide where they catch real failures; adjust shape to your architecture and flake budget.

---

**Question:** When is a unit test the wrong tool?

**Answer:** When confidence requires real I/O semantics—migrations, lock behavior, network partitions—or when tests only mirror implementation detail and break on every refactor without catching user-visible bugs.

---

**Question:** Contrast integration and contract tests.

**Answer:** Integration tests validate your service against real-ish dependencies (DB, broker) together. Contract tests lock consumer expectations and provider capabilities so teams evolve APIs without silent breakage—especially valuable across org boundaries when full E2E is heavy.

---

**Question:** What is the main role of smoke tests post-deploy?

**Answer:** Fast checks that the system is “up enough”: health, critical read paths, config wiring. They catch obvious breakages cheaply, not business correctness exhaustively.

---

**Question:** Name purposes of performance vs. chaos testing.

**Answer:** Performance tests characterize latency/throughput under load for capacity and regressions. Chaos/resilience tests validate failure handling—timeouts, retries, degraded modes—before production incidents do it for you.

---

**Question:** Define stub, mock, fake, and spy—when reach for each?

**Answer:** Stubs return canned data; mocks assert interactions; fakes are working lightweight implementations (in-mem repo); spies record calls while using real collaborators. Over-mocking encodes false assumptions; fakes shine when behavior matters.

---

**Question:** What is property-based testing?

**Answer:** Generate inputs against invariant properties (“decode(roundtrip(x)) == x”) to explore edge cases humans miss. Great for parsers, serializers, state machines—needs thoughtful shrinking and performance tuning.

---

**Question:** When is high code coverage misleading?

**Answer:** When tests execute lines without asserting behavior, when critical branches remain untested, or when integration gaps hide failures despite green coverage dashboards.

---

**Question:** List common flaky test causes.

**Answer:** Real time dependencies, shared mutable state, nondeterministic ordering, leaky environment variables, reliance on external services without containers, and data races—fix with hermeticity, deterministic clocks, isolation, and quarantine policies with SLAs.

---

**Question:** How should test data be managed at scale?

**Answer:** Factories/fixtures, synthetic generation, anonymized snapshots, tenant-scoped datasets, cleanup hooks, and never relying on “whatever was already in staging” for correctness.

---

### Senior Questions

### Question

How do you diagnose and fix an intermittently failing test in CI?

### Strong Answer

Reproduce locally with same seed/env; classify flake vs. infra; capture artifacts (logs, screenshots); bisect recent changes; replace sleeps with condition polling; remove cross-test coupling; containerize dependencies; mark quarantine only with owner + deadline; add telemetry on flake rate. If still flaky after two attempts, rewrite test around observable outcomes, not incidental implementation detail.

### Explanation

Shows discipline: quarantine without accountability is how green CI dies.

### Practical Example

Use Testcontainers for Postgres instead of shared staging row IDs; inject fake clock for expiry logic.

### What the Interviewer Is Testing

Debugging rigor, infra awareness, and team policy thinking.

### Weak Answer

“Re-run until green.”

### Red Flags

- Reruns as policy  
- No root-cause tracking  
- Quarantine without ownership  

---

**Question:** Compare classical vs. consumer-driven contracts for microservices.

**Answer:** Classical integration tests may spin many services—brittle at scale. Consumer-driven contracts encode minimal expected interactions so providers verify without full stacks. Trade-off: contract maintenance discipline and tooling (Pact-like) overhead vs. reduced E2E tax.

---

**Question:** How do you use coverage metrics without gaming them?

**Answer:** Trend coverage on critical modules, diff coverage on PRs, pair with mutation testing spot checks in core domains, and refuse to treat any global percentage as a target—treat it as a tripwire when unexplained drops occur.

---

**Question:** What belongs in PR CI vs. post-merge pipelines?

**Answer:** Fast deterministic gates: lint, types, unit, fast integration, security scans. Heavy multi-service journeys, load tests, and cross-repo suites run post-merge or nightly with alert-backed ownership—document failures block release, not necessarily every merge.

---

**Question:** How do you test async/event-driven flows?

**Answer:** In-process fakes, embedded brokers where feasible, contract tests on message schemas, idempotency + replay tests, and observability assertions (ordering, poison handling) where pure unit tests fall short.

---

**Question:** What is a characterization test in legacy code?

**Answer:** Captures current behavior before refactor so you know when output changes—bridge until clearer specs exist; retire once domain rules are explicit and covered intentionally.

---

**Question:** When do snapshot tests help vs. hurt?

**Answer:** Helpful for stable serializer/interpreter outputs; harmful when they freeze noise (generated IDs, timestamps) and cause churn—pair with focused matchers or structural assertions.

---

**Question:** How do you approach security-focused automated testing in CI quality gates?

**Answer:** Combine dependency scanning, secret scanning, targeted SAST rules, SBOM diff, optional DAST stages on staging, and manual pen tests for logic—balance false positives with waiver workflow.

---

**Question:** Where do chaos or fault-injection tests fit relative to the pyramid?

**Answer:** They validate assumptions integration tests often skip—timeouts, retry storms, partial outages—but need guardrails: run in staging or tightly scoped production experiments with blast-radius caps and abort switches. Complement, don’t replace, deterministic tests.

---

**Question:** When is mutation testing worth the CPU cost?

**Answer:** On small, high-risk modules (pricing, authz rules, serialization) to expose tests that only execute code without asserting behavior. Skip repo-wide runs in every PR—use nightly or sampled scopes because runtime explodes on large codebases.

---

### Tech Lead Questions

### Question

How do you set quality gates that speed teams up instead of slowing them?

### Strong Answer

Gate on outcomes (security criticality, contracts, smoke) not vanity metrics; automate fixers for style; enforce merge queue or trunk policies so feedback is trustworthy; keep PR loop under ~10 minutes where possible via sharding/cache; allow asynchronous heavy suites with release train owners; revisit brittle gates quarterly; tie exceptions to risk tickets with expiry.

### Explanation

Elite performers optimize signal-to-noise—blocking builds people distrust erodes quality culture faster than loosening gates.

### What the Interviewer Is Testing

Systems thinking, DevEx empathy, and metrics literacy.

### Weak Answer

“Remove flaky tests from CI so we can ship.”

### Red Flags

- Gate removal without compensating controls  
- No merge queue / broken main tolerance  
- Treating quality as an individual not system property  

---

### Question

How do you operationalize SLOs, error budgets, and review quality together?

### Strong Answer

Link reliability SLOs to release policy—budget spent freezes risky features; clarify review focus areas from past incidents; automate checks that encode past mistake classes; track escaped defect rate and time-to-detect; use review checklists only where they change outcomes, not boilerplate everywhere.

### What the Interviewer Is Testing

Bridging reliability economics with engineering practice.

### Weak Answer

“SLOs are an SRE thing unrelated to code review.”

### Red Flags

- Siloed quality ownership  
- Checklist theater with no feedback loops  

---

**Question:** How do you coach teams off of “100% coverage required”?

**Answer:** Show diminishing returns charts, encourage risk-based targets, introduce mutation testing demos on payment modules, and align leadership on outcome metrics (defect escape rate) instead of a single scalar.

---

**Question:** Multi-team backend—testing strategy?

**Answer:** Contract tests at boundaries, targeted integration for risky queries, minimal happy-path E2E, synthetic canaries in staging/production, and observability-backed assertions for side effects.

---

**Question:** QA budget cut—what stays?

**Answer:** Automated regression of critical paths, security scans, performance guardrails on hotspots, manual exploratory on major releases only—document explicit risk acceptance.

---

**Question:** How do you test feature-flagged code without combinatorial explosion?

**Answer:** Pair states with matrices for active transitions, default-off tests, remove flags after bake-in, static analysis for orphaned branches, and environment parity checks.

---

**Question:** What is your flaky test SLA policy?

**Answer:** Track flake rate; quarantine with ticket + owner + deadline; fail builds that reintroduce known flakes; weekly hygiene slot; escalate chronic modules for redesign.

---

**Question:** How do you measure quality outcomes beyond test counts?

**Answer:** Track escaped defect rate by severity, MTTR for test-discovered vs production-discovered issues, flaky test percentage, and correlation between gate changes and incidents—review with product and SRE so metrics drive gate adjustments, not vanity scorecards.

---

### Scenario-Based Questions

**Question:** E2E suite takes 90 minutes and fails often—what do you change?

**Answer:** Profile stages, parallelize, replace redundant cases with integration/contract coverage, stub third parties, invest in data setup speed, move non-gating journeys post-merge, and delete tests that duplicate cheaper signal.

---

**Question:** New service with five downstream dependencies—how test before prod?

**Answer:** Contract tests per dependency, chaos on timeouts, load test the fan-out path, synthetic monitors on deploy, feature-flagged ramp with canary metrics.

---

**Question:** Team wants to delete all integration tests as “slow.”

**Answer:** Quantify which defects only integration caught historically, propose tiered strategy, optimize runtime with containers, and risk-sign the rollback plan if removed.

---

**Question:** Legacy module with zero tests and daily outages?

**Answer:** Add characterization + narrow golden paths, tighten observability, freeze risky refactors until harness exists, schedule incremental extraction with consumer contracts.

---

**Question:** QA finds bug missed by thousands of unit tests—post-mortem?

**Answer:** Map gap—wrong abstraction layer tested, missing integration clause, unrealistic fixtures, ignored analytics—then add one targeted test class and CI signal so class repeats rarely.

---

### Trick Questions

**Question:** Are 100% covered lines a guarantee of quality?

**Answer:** No—coverage measures execution, not assertion strength; mutation testing and production feedback reveal hollow tests.

---

**Question:** Should every external HTTP call be mocked in unit tests?

**Answer:** No—over-mocking hides integration failures; use contract tests or hermetic containers for behavioral truth while keeping units fast.

---

**Question:** If CI is green, is main always releasable?

**Answer:** Not if post-merge suites lag, data migrations untested, feature flags incomplete, or flaky reruns mask failures—merge queues and release readiness checks still matter.

---

### Weak Answers and Red Flags

1. **“We’ll add E2E tests for everything so we’re safe.”** Cost and flake explode; shows misunderstanding of trade-offs.  
2. **“Coverage is low—tell juniors to write more tests.”** No risk targeting or mentoring model—metric chasing without strategy.  
3. **“Integration tests are integration tests—run them manually before release.”** Defeats continuous delivery feedback; human bottlenecks return.  

---

## CI/CD and DevOps

### Basic Questions

**Question:** Continuous Delivery vs Continuous Deployment—what changes?

**Answer:** CDelivery keeps production deployable with optional human approval; CDeployment automates that last step. CDeployment demands strong automation, observability, and cultural trust—approval gates remain valid in regulated contexts.

---

**Question:** Why promote immutable artifacts across environments?

**Answer:** The tested bits equal the released bits; prevents “works in staging” drift from rebuilds with different dependency resolution or compiler flags.

---

**Question:** Explain blue/green vs rolling deploys.

**Answer:** Blue/green swaps entire stacks—fast rollback, double capacity cost. Rolling incrementally replaces instances—less overhead, needs backward-compatible releases during overlap.

---

**Question:** What problem does GitOps solve?

**Answer:** Declarative desired state in Git reconciled by cluster agents—audit trail, drift detection, and reduced long-lived CI cluster credentials—but adds operator complexity.

---

**Question:** Name four DORA metrics and one cause of lead-time friction.

**Answer:** Deployment frequency, lead time for changes, change failure rate, MTTR. Friction examples: review queues, flaky CI, manual change controls, or poor staging parity.

---

**Question:** What is expand-and-contract for schema changes?

**Answer:** Add new shape compatible with old readers/writers, migrate traffic/data, then remove old shape—avoids coupled code/schema deploy outages.

---

**Question:** Why pin CI actions/containers by digest?

**Answer:** Tags are mutable supply-chain risk; digest pinning ties execution to audited content.

---

**Question:** Define drift detection for IaC.

**Answer:** Scheduled plans comparing live cloud state to code; catches manual console edits undermining reviews.

---

**Question:** What is OIDC federation for CI?

**Answer:** Short-lived cloud credentials minted per run from trust relationship with CI IdP—shrinks secret sprawl vs static keys.

---

**Question:** Purpose of deploy freeze with exceptions?

**Answer:** Reduce change risk during sensitive windows while preserving documented path for security/regulated fixes.

---

### Senior Questions

### Question

How would you design CI for a 20-service monorepo?

### Strong Answer

Use graph-aware task runners to build/test only affected nodes plus dependents; remote cache layers; shared workflow templates; parallel quality jobs; split Docker builds with layer caching; schedule heavy integration separately; enforce merge queue so green PRs compose; document ownership per path. Target sub-10-minute PR signal for typical edits.

### Explanation

Demonstrates scaling CI beyond naive “run everything.”

### Practical Example

`nx affected -t test` with remote cache, path filters on deploy workflows, fan-out matrix for shards.

### What the Interviewer Is Testing

Monorepo literacy, cost awareness, and developer throughput.

### Weak Answer

“Forty-five-minute pipeline is acceptable at our size.”

### Red Flags

- No affected detection  
- Accepts long blocking waits  
- No merge queue strategy  

---

**Question:** How do database migrations co-exist with rolling deploys?

**Answer:** Only backward-compatible migrations across waves; expand schema first; dual-write/read phases; feature flags; reversible scripts tested in staging; never drop columns until traffic gone.

---

**Question:** How do you speed up a 40-minute pipeline engineers ignore?

**Answer:** Profile stages, parallelize lint/type/test, cache deps and build outputs, split tests, move slow suites post-merge with alerts, optimize Dockerfiles, and enforce branch protection so skipping is impossible—then communicate SLA for fixes.

---

**Question:** Rollout strategy if canary shows errors?

**Answer:** Auto rollback via health metrics, keep artifacts for fast revert, document metric thresholds beforehand, include migration forward-fix playbook if schema involved.

---

**Question:** When choose self-hosted runners?

**Answer:** Needs GPUs, large persistent caches, private network assets, or cost curves past managed pricing—accept operational toil explicitly.

---

**Question:** How inject secrets safely into pipelines?

**Answer:** OIDC > short-lived secrets > vault integration; never echo secrets; mask logs; scope secrets per environment/branch; rotate regularly.

---

**Question:** How verify IaC changes?

**Answer:** Static analysis (lint/policy), plan posted to PR, selective env integration tests for shared modules, peer review for destructive ops.

---

**Question:** Manage feature flags at 15 services?

**Answer:** Central flag service, SDK consistency, audit trail, owners, TTL on release flags, automated stale detection, flag cleanup KPIs.

---

**Question:** How do feature flags change release versus deploy in CD pipelines?

**Answer:** Deploy pushes immutable artifacts continuously while flags gate customer-visible behavior—pipelines should still run full smoke on merged code even if flags are off, and flag state should be observable to avoid debugging “old binary + wrong flag” puzzles.

---

**Question:** What signals belong in an automated canary analysis step?

**Answer:** Golden signals for the service (errors, latency percentiles vs baseline), business KPIs where available, saturation cues, and comparison windows long enough to catch cold-cache effects—paired with automatic rollback and a playbook if metrics disagree.

---

### Tech Lead Questions

### Question

How do you reduce change failure rate without throttling deploy frequency?

### Strong Answer

Shrink batch size, invest in integration tests on critical journeys, automated canary analysis, progressive delivery, observability-backed rollbacks, blameless postmortems with templated guardrails, and pairing/mentorship on risky domains—DORA shows elite teams excel on both dimensions when quality loops tighten.

### Explanation

Challenges the false trade-off that slower deploys mean safety.

### What the Interviewer Is Testing

Systems leadership and metric fluency.

### Weak Answer

“Freeze deploys before big releases.”

### Red Flags  

- Big-bang releases as default  
- No automated detection/rollback  

---

**Question:** How do you govern shared CI templates across ten squads without bottlenecks?

**Answer:** Versioned reusable workflows with mandatory security stages, self-service knobs within guardrails, automated audits for drift, SemVer template changes with migration windows, and metrics on overrides.

---

**Question:** Who should own “the pipeline as a product,” and what does that entail?

**Answer:** Platform or enablement engineers curate templates, reliability, and cost; product teams own gates’ meaning and tests. Ownership includes SLOs for CI availability, quarterly template roadmaps, and developer support SLAs—not throwing YAML over the wall.

---

**Question:** When do you choose blue/green over progressive canary delivery?

**Answer:** Blue/green fits homogeneous releases needing instant traffic swap and tolerates double infra; canaries suit heterogeneous traffic, long warm-ups, or nuanced metric guardrails. Cost, data compatibility, and rollback simplicity drive the choice—sometimes combine (canary inside green pool).

---

**Question:** VP demands 40% CI cost cut—approach?

**Answer:** Cost attribution by job type, cache hit rates, runner SKUs, retention policies; optimize graph execution; consider spot/self-hosted for steady load; present risk trade matrix if cuts touch security timing.

---

**Question:** When is GitOps the wrong fit?

**Answer:** Non-Kubernetes estates, teams lacking operational depth for reconcilers, or workflows needing imperative one-off orchestration beyond CRDs—evaluate honestly.

---

**Question:** How coordinate multi-region deploy?

**Answer:** Serial or constrained parallel rollouts with per-region health checks, latency-aware data dependencies, feature flags per region, and automation preventing “all regions at once.”

---

**Question:** How measure pipeline ROI?

**Answer:** Before/after DORA metrics, minutes saved × engineer hourly cost, incident reduction $ impact, and vendor spend—tie narrative to business outcomes.

---

### Scenario-Based Questions

**Question:** Migration dropped column still read by old binary mid-canary—response?

**Answer:** Roll app back forward-fix schema if needed, restore expand/contract process, add migration linter blocking destructive ops without dual-phase proof.

---

**Question:** Staging passes, prod fails every time—first checks?

**Answer:** Artifact parity, config diff, secret scoping, data shape/volume, dependency endpoints, autoscaling/IAM deltas, feature flags.

---

**Question:** IaC emergency console tweak—policy?

**Answer:** Time-bound change, ticket, import into IaC within SLA, drift alert verifies closure—treat exceptions as debt with owner.

---

**Question:** Building net-new service pipeline in week one—scope?

**Answer:** Minimal lint/test CI, container build/push, staging deploy smoke, security scans before prod traffic—iterate, don’t gold-plate before users.

---

**Question:** Org wants same pipeline for mobile, data, and backend teams—your view?

**Answer:** Standardize interface (stages, security baselines) not identical jobs—respect different artifacts, simulators, and release cadences.

---

### Trick Questions

**Question:** Is higher deploy frequency always better?

**Answer:** Only when quality signals and rollback muscle match; spamming deploys without controls increases incidents.

---

**Question:** Does IaC remove all manual operations?

**Answer:** No—break-glass, state repair, provider bugs, and rare one-offs remain; policy is reconcile quickly back to codebase.

---

**Question:** Should every team use identical YAML?

**Answer:** Shared templates yes, copy-paste monolith no—allow necessary customization under governance.

---

### Weak Answers and Red Flags

1. **“We SSH to servers and git pull for production.”** No reproducible artifacts, rollback, or audit—pre-cloud anti-pattern.  
2. **“Same AWS key for every pipeline.”** Shared long-lived blast radius; ignores OIDC and least privilege.  
3. **“We skip staging; customers will tell us.”** Confuses observability with validation; invites reputation hits.  

---

## Observability

### Basic Questions

**Question:** Define logs, metrics, traces—and how they reinforce each other.

**Answer:** Metrics aggregate for alerting/trends; traces explain latency across calls; logs add rich context events. Correlation IDs/OTel unify them for investigations.

---

**Question:** Monitoring vs observability?

**Answer:** Monitoring watches known signals; observability supports ad-hoc questions via rich instrumentation—monitoring is a slice of observability, not a competitor.

---

**Question:** SLI vs SLO vs SLA?

**Answer:** SLI measures user-perceived goodness ratio; SLO is internal target; SLA is contractual consequence—SLO tighter than SLA for margin.

---

**Question:** What is an error budget in practice?

**Answer:** Permissible unreliability window; guides release aggressiveness and reliability investments when exhausted.

---

**Question:** Why percentiles for latency?

**Answer:** Means obscure tail pain; SLO users care about p95/p99; fan-out amplifies tail effects.

---

**Question:** Cardinality—why cap labels?

**Answer:** Each label combo is a time series; unbounded dimensions (user IDs) explode cost and dest Prometheus.

---

**Question:** What is OpenTelemetry’s value?

**Answer:** Vendor-neutral instrumentation and collector pipelines—reduce lock-in, standardize propagation, reuse exporters.

---

**Question:** RED suite?

**Answer:** Rate, Errors, Duration for request-driven services—baseline golden signals.

---

**Question:** Head vs tail sampling?

**Answer:** Head cheap but may miss rare traces; tail keeps interesting traces post-hoc—needs buffering; combine often.

---

**Question:** Burn-rate alerting?

**Answer:** Alert on accelerated budget consumption across windows—cuts noise vs static thresholds.

---

### Senior Questions

### Question

How design SLOs for a new service with sparse history?

### Strong Answer

Start modest (e.g., 99.5% availability, provisional latency threshold), instrument true user journeys, review after cohort of traffic, tighten based on empirical percentiles and business expectation, define error budget policy upfront—even loose targets teach operational muscle.

### Explanation

Shows iterative SRE thinking vs aspirational 99.99% theater.

### Practical Example

Synthetic probes + server-side SLI on key APIs; adjust after two windows of data.

### What the Interviewer Is Testing

SLO process maturity and avoidance of alert fatigue.

### Weak Answer

“We set five nines because enterprise.”

### Red Flags

- Numbers without measurement  
- Ignores cost of false pages  

---

**Question:** Cut observability spend 40%—plan?

**Answer:** Break down logs/metrics/traces costs, drop DEBUG noise, tune retention tiers, reduce sample rates with tail capture, drop unused dashboards/metrics, cardinality audits, negotiate alternate backfills (logs for rare diagnostics).

---

**Question:** Async + queues tracing?

**Answer:** Propagate context in message headers, monitor lag/age/DLQ depth, use correlation IDs when trace breaks, stitch via span links.

---

**Question:** Histogram vs summary in Prometheus?

**Answer:** Histograms aggregate across instances; client-side summaries don’t compose—prefer histograms for service-level percentiles.

---

**Question:** Lower MTTD tactics?

**Answer:** SLO burn alerts, high-signal SLIs per endpoint, canary metrics, synthetic checks, and tracing on critical paths—not CPU-only alarms.

---

**Question:** Runbook essentials?

**Answer:** Meaning of alert, triage dashboards/queries, common causes, mitigation/rollback, escalation criteria—test quarterly.

---

**Question:** Observability during risky migration?

**Answer:** Temporary dual-write metrics, population gauges, tighter SLO windows, post-cutover soak before removing old signals.

---

**Question:** Validate alerting rules?

**Answer:** Staging fault injection, replay historical incidents, shadow alert pipelines during vendor migrations.

---

**Question:** How do USE metrics complement RED for a Node or JVM service?

**Answer:** USE (utilization, saturation, errors) targets resources—CPU, disk, NIC—while RED covers request work. Pair high p99 latency with low CPU to spot I/O waits; pair high utilization with low saturation to find headroom mistakes—avoid paging on raw CPU alone without user-facing SLI context.

---

**Question:** What are exemplars and when are they preferable to high-cardinality metric labels?

**Answer:** Exemplars attach a trace ID to histogram buckets so you can jump from aggregated latency to a concrete trace without exploding time-series cardinality—useful for exploratory drill-down while keeping bounded labels.

---

### Tech Lead Questions

### Question

Standards for 20 JavaScript microservices—how enforce observability?

### Strong Answer

Ship shared bootstrap library (structured logging, OTel auto-instrument, RED metrics), template dashboards, SLO boilerplate, cardinality budgets, sampling policies, service catalog links, automated conformance scanner, and SLO review in production readiness checklist—monitor the observability tier as Tier-0 with its own SLO.

### What the Interviewer Is Testing

Platform thinking and governance without bottlenecks.

### Weak Answer

“Teams pick their own tools freely.”

### Red Flags  

- Fragmentation prevents incident correlation  
- No readiness gates  

---

**Question:** VP wants deep per-customer metrics—response?

**Answer:** Explain cardinality blast; propose traces/logs/exemplars, sampled analytics warehouse, or isolated tenant metrics tier with strict budgets.

---

**Question:** Where do synthetic checks fit with SLOs—what can they miss?

**Answer:** Synthetics provide proactive coverage of critical user journeys from edge locations—great for DNS/TLS/regional routing regressions—but they miss long-tail workflows and cannot replace distributed tracing across internal hops; keep them narrow and version-controlled like code.

---

**Question:** Multi-region telemetry architecture?

**Answer:** Regional ingestion for residency, global query federation for SLIs, separate alerts on global vs regional burns, watch cross-region replication lag in traces.

---

**Question:** Balance PII and rich telemetry?

**Answer:** Scrub/processors in collector, allowlisted log fields, pseudonymous IDs, classification-based retention, legal review for new fields.

---

**Question:** On-call drowning in pages—plan?

**Answer:** Audit alert, dedupe routes, SLO-based sym alerts, convert noisy thresholds to tickets, mandate runbooks, track pages per shift KPI.

---

**Question:** Error budget nearly gone—product wants big launch?

**Answer:** Present burn math, options: delay, dark launch behind flag, aggressive canary, freeze other risky changes—leadership chooses with data.

---

**Question:** How do you adjust trace and log sampling when traffic temporarily increases by an order of magnitude?

**Answer:** Lower head-sampling rates on the hottest services while keeping tail sampling for errors, temporarily widen collector buffers, watch exporter backpressure, and document that rare non-error investigations may need ad hoc traces—coordinate with finance before silently dropping logs.

---

### Scenario-Based Questions

**Question:** Dashboard green but users see errors—what now?

**Answer:** Validate LB vs app errors, ensure SLI matches user path, check label holes, pivot to traces/logs with exemplars, patch observability gaps after mitigation.

---

**Question:** engineer wants `customer_id` metric label—reply?

**Answer:** Cardinality hazard; use traces/logs or high-card analytics store; exemplars bridge metrics to traces.

---

**Question:** Critical service lacks observability and “no time”—ask?

**Answer:** Offer minimal bootstrap in days (structured logs, RED metrics, one SLO, smoke alert) vs cost of multi-hour mystery outages.

---

**Question:** Prometheus down mid-incident?

**Answer:** Fallback runbook: LB logs, cloud metrics, kubectl logs, maintain HA for monitoring stack, postmortem both app and observability failures.

---

**Question:** Finance demands spend cut—negotiate?

**Answer:** Present tiered options with risk statements, automate least-valuable volume removals first, document investigation limitations accepted.

---

### Trick Questions

**Question:** Need 100% tracing always?

**Answer:** No—sample judiciously + tail for errors/low-traffic services can afford higher sample rates.

---

**Question:** Alert every graph?

**Answer:** No—noise kills signal; alert on SLO/user pain, dashboard the rest.

---

**Question:** More logs always better?

**Answer:** No—volume raises cost, hides signal, slows queries; sample and level-gate.

---

### Weak Answers and Red Flags

1. **“We grep servers when needed.”** No shared signals—MTTD explodes at scale.  
2. **“We alert on CPU for every box.”** Symptomless cause alerts yield fatigue and miss user impact.  
3. **“Our availability SLO is 100%.”** Mathematically incoherent for distributed systems—signals misunderstanding of budgets.  

---

## Performance and Scalability

### Basic Questions

**Question:** Latency vs throughput?

**Answer:** Time per unit of work vs units per time—optimize different bottlenecks; batch systems may prioritize throughput over low latency.

---

**Question:** Why p99 matters in microservice fan-out?

**Answer:** Probability of hitting at least one slow dependency grows with call count—even rare tails dominate user latency.

---

**Question:** Describe back-pressure.

**Answer:** Mechanism signaling producers to slow when consumers lag—bounded queues, load shedding, HTTP 429, flow control—prevents unbounded memory growth.

---

**Question:** Cache stampede?

**Answer:** Thundering herd on expiration—mitigate with jitter, single-flight, stale-while-revalidate.

---

**Question:** Hot key in Redis cluster?

**Answer:** Disproportionate shard load—split read replicas, in-process caching, or subkey randomization patterns with care.

---

**Question:** Vertical vs horizontal scaling trade-off?

**Answer:** Vertical simpler until HW ceiling/HA demands; horizontal needs statelessness and coordination.

---

**Question:** Connection pooling value?

**Answer:** Amortizes handshake costs and caps DB connections—mis-sized pools cause wait latency or DB overload.

---

**Question:** N+1 queries?

**Answer:** ORM lazy loads cause repeated queries—batch/eager load, or redesign data access.

---

**Question:** CDN responsibilities?

**Answer:** Edge caching for static and some API payloads—invalidation and security headers must be correct to avoid poisoning or data leaks.

---

**Question:** Autoscaling cooldown rationale?

**Answer:** Prevents oscillation thrash when metrics are spiky—tune against workload type.

---

**Question:** Load vs soak tests?

**Answer:** Load validates peak behavior; soak reveals leaks and GC drift over hours/days.

---

**Question:** Write-through vs write-behind caching?

**Answer:** Through maintains strong consistency with added write latency; behind improves write latency with durability risk—choose by consistency tolerance.

---

### Senior Questions

### Question

Explain cache stampede mitigation in a distributed cache.

### Strong Answer

Combine request coalescing (single-flight via short-lived lock), TTL jitter to desynchronize expiries, protective timeouts, optional stale-while-revalidate to serve slightly old data while refresh completes, and monitor hot keys. For mega-hot keys, consider local LRU front-cache with bounded memory.

### Explanation

Shows operational depth beyond “increase TTL.”

### What the Interviewer Is Testing

Real-world resiliency design.

### Weak Answer

“Set TTL to a day.”

### Red Flags  

- Coordinated expiry still possible  
- Ignores coordinated thundering herd math  

---

**Question:** How prioritize DB optimizations?

**Answer:** Correlate slow queries to user journeys, EXPLAIN on replica, weigh index vs write amplification, estimate ROI, watch pool wait metrics vs query time.

---

**Question:** Detect pool exhaustion vs head-of-line blocking?

**Answer:** Pool metrics (waiters, checkout times) vs connection-level queueing in traces/HTTP version effects—remedies differ.

---

**Question:** Cut tail latency in 20-call fan-out graph?

**Answer:** Parallelize independent fetches, aggressive timeouts with graceful defaults, hedging sparingly, caching stable reads, reduce fan-out via aggregation services.

---

**Question:** Memory leak workflow in Node services?

**Answer:** RSS trends, heap snapshots diffed, listener/closure/cache audits, soak tests, alerts before OOM.

---

**Question:** Redis vs in-process cache?

**Answer:** In-proc microsecond and partition-tolerant staleness vs Redis millisecond shared truth—often layer them.

---

**Question:** Rate limiting multi-tenant APIs?

**Answer:** Token bucket per tenant + global safety valve, fair Retry-After headers, differentiated tiers, gateway enforcement.

---

**Question:** When not to cache?

**Answer:** Ultra-fresh data, per-request uniqueness, strict consistency domains, or negligible origin latency—avoid blind caching.

---

**Question:** Performance regression vs capacity issue?

**Answer:** Same-load latency jump post-deploy vs gradual degradation with traffic growth—different fixes (rollback/optimize vs scale/shape traffic).

---

**Question:** Flash sale ingress plan?

**Answer:** Pre-scale, cache warming, bot controls, graceful degradation toggles, queueing checkout-critical paths, postmortem capacity model update.

---

**Question:** Choose shard vs replica?

**Answer:** Replicas offload reads; shards partition writes—pick when primary write throughput or data size breaks single node.

---

**Question:** How do you size JDBC/Node pools against database `max_connections` and fleet size?

**Answer:** Model worst-case concurrent requests × pool-per-instance, include admin jobs, compare to Postgres/MySQL limits, add PgBouncer or RDS Proxy when multiplication exceeds headroom, and validate under soak tests—raise alarms on pool wait time and checkout latency.

---

### Tech Lead Questions

### Question

How do you communicate performance trade-offs to executives?

### Strong Answer

Translate p99 to customer pain ($ abandon rate anecdote + monitored funnel), present option bundles with cost/time/risk (CDN tweak vs rewrite), show charts tying infra spend to latency goals—avoid raw jargon without business frame.

### Explanation

Executives optimize cost, risk, and revenue—tie latency improvements to conversion/support tickets and gate big rewrites behind data from RUM and controlled experiments.

### Practical Example

Show two options: “Edge cache + image tuning in one sprint improves median LCP 400ms for $X/month” versus “SSR rewrite spans two quarters for an extra 200ms gain.”

### What the Interviewer Is Testing

Stakeholder management plus technical depth.

### Weak Answer

“Lighthouse score went up.”

### Red Flags  

- No linkage to revenue/support metrics  
- Single metric advocacy  

---

**Question:** How do you assign performance ownership across microservices teams?

**Answer:** Each service owns its latency/error SLO; share an end-to-end trace dashboard allocating budget per hop; run joint incident reviews using span evidence to avoid opinion duels; escalate systemic coupling issues to architecture forum.

---

**Question:** 10x traffic program—outline?

**Answer:** Measure current knee of curve, strengthen edge caching, horizontal app tier, DB scaling path (replicas, partition), queues for non-critical work, cost sensitivity, phased load tests, canary ramp.

---

**Question:** When hire dedicated performance specialists?

**Answer:** When cross-cutting interactions exceed any single team’s scope, tooling gaps block progress, or incidents concentrate in performance—embed practices first, specialize as load grows.

---

**Question:** Architecture-level caching across services?

**Answer:** Edge, shared Redis per bounded context, event-driven invalidation, no peeking into others’ caches, KPI reviews on hit ratio and staleness budgets.

---

**Question:** Technical debt slowing p99—govern?

**Answer:** Classify by blast radius/user impact, quantify user-hour cost, carve reliable sprint capacity, trend metrics to leadership.

---

**Question:** Monolith split caused latency regression—why?

**Answer:** In-proc calls became network chatter and serialization—optimize chatty interfaces, collocate data, async non-critical paths, binary payloads on hot paths, revisit service boundaries.

---

**Question:** PM demands zero latency increase—response?

**Answer:** Impossible universally—negotiate SLO headroom, measure prototype impact, rollback plan, scope perf CI assertions.

---

**Question:** PM: precompute every search variant in Redis—evaluation?

**Answer:** Discuss space, refresh throughput, Zipf popularity—likely pre-warm hot tail only, cache-aside tail long tail.

---

**Question:** Global users far from region—mitigations?

**Answer:** CDN first, read replica closer, payload minimization, optional regional footprint exploration with cost/benefit, not reflexive full active-active.

---

### Scenario-Based Questions

**Question:** p99 2s vs 300ms SLO for read API—plan?

**Answer:** Trace tail, attack DB scans/N+1/external IO, verify indexes, add caching post-diagnosis, load test, guard with SLO alerts.

---

**Question:** Throughput cliff at 7k RPS?

**Answer:** Check pool saturation, thread/goroutine caps, CPU vs IO wait, downstream rate limits—reproduce and remove cliff with evidence.

---

**Question:** Add in-proc cache layer proposal?

**Answer:** Quantify Redis latency contribution, hit ratio upside, consistency tolerance, memory footprint across pods—reject if savings dwarf complexity.

---

**Question:** 30% Redis keys never read?

**Answer:** Pattern analysis, remove eager population, shorten TTL for garbage, instrument write/read ratios, chase owner teams.

---

**Question:** Flash traffic + marketing campaign?

**Answer:** Coordinate pre-scale, lock down non-essential endpoints, prioritize payment/auth paths, observability war room, cost ceilings discussed upfront.

---

**Question:** Database CPU high but no replica budget?

**Answer:** Target top queries, indexing, caching hot reads, batch offline workloads, pooler multiplexing, kill wasteful polling before hardware talks.

---

### Trick Questions

**Question:** More caching always helps?

**Answer:** No—invalidation complexity, stale data risk, memory/network overhead can hurt; profile first.

---

**Question:** Horizontal always beats vertical?

**Answer:** No—distributed systems carry coordination costs; vertical still valid especially for data layers early on.

---

**Question:** Are averages enough?

**Answer:** Rarely for user-facing latency—tails drive SLAs and SLOs.

---

**Question:** Async always feels faster?

**Answer:** Wrong if user waits for final outcome—async helps decouple non-critical post-work, not every interaction.

---

### Weak Answers and Red Flags

1. **“We’ll add Redis everywhere.”** No evidence of bottleneck or invalidation strategy.  
2. **“Average latency is 50ms—we’re good.”** Hides miserable tail and violates SLO thinking.  
3. **“We only observe production, never load test.”** Customers become test harness; predictable failures missed.  
4. **“We always pick the biggest instance.”** Costly, hits ceilings, avoids architectural fixes.  

---

## Git and Engineering Workflow

### Basic Questions

**Question:** Merge vs rebase philosophy?

**Answer:** Merge preserves parallel history; rebase rewrites feature branch for linear review—avoid rebasing shared published history without coordination.

---

**Question:** Trunk-based vs GitFlow drivers?

**Answer:** Release cadence—continuous web vs multi-version mobile/on-prem—determines long-lived branches necessity.

---

**Question:** Feature flags’ workflow role?

**Answer:** Merge small slices safely, decouple deploy from customer exposure, enable controlled experiments and kill switches.

---

**Question:** CODEOWNERS purpose?

**Answer:** Route reviews by domain expertise, encode ownership, reduce lottery reviewers.

---

**Question:** Conventional commits benefits?

**Answer:** Automated release notes, consistent bisect messages, tooling hooks for changelog and SemVer.

---

**Question:** `git revert` vs `reset` on shared branches?

**Answer:** Revert adds forward fix commit safe for shared history; reset rewrites—avoid on collaborative branches.

---

**Question:** Purpose of `--force-with-lease`?

**Answer:** Safer force push—fails if remote advanced unexpectedly.

---

**Question:** Why squash merge?

**Answer:** Tidy main history when branch commits messy—trade-off vs fine-grained bisect targets on main.

---

**Question:** ADR vs RFC?

**Answer:** RFC proposes/gets feedback; ADR records decided context for posterity—timeline differs.

---

**Question:** PR review SLA why?

**Answer:** Keeps WIP low, encourages small PRs, prevents stale integration debt.

---

### Senior Questions

### Question

Merge conflicts spiking in 20-person team—root causes and fixes?

### Strong Answer

Attack branch lifetime (integrate daily), modularize ownership to reduce hotspot files, enforce small PRs, optionally enable `rerere`, teach conflict resolution patterns. Conflicts are symptoms of integration and boundary issues—not only Git mechanics.

### What the Interviewer Is Testing

Org/process diagnosis vs “use better communication.”

### Weak Answer

“Tell people to coordinate on Slack.”

### Red Flags  

- Ignores structural code ownership problems  
- No metrics on branch age or PR size  

---

**Question:** Monorepo vs polyrepo—criteria?

**Answer:** Shared change frequency, CI sophistication, autonomy desires, dependency drift tolerance, and team scale.

---

**Question:** Raise code review throughput without lowering bar?

**Answer:** Automate style/types/tests, separate blocking vs nits, size guidelines, rotate reviewers, track time-to-first-review.

---

**Question:** Hotfix procedure under pressure?

**Answer:** Branch from prod tag, minimal diff, fast CI slice, deploy, backport to main, postmortem on prevention—drills ahead of need.

---

**Question:** Manage internal library breaking change across 15 services?

**Answer:** Expand/contract APIs, deprecation warnings, tracked migrations, coordinated release, verify consumer adoption before removal.

---

**Question:** Keep docs fresh?

**Answer:** Co-locate docs with code, generate API docs from source, exercises via drills, PR checklist coupling, delete unused pages.

---

**Question:** Feature flag cleanup strategy?

**Answer:** Owner, expiry, CI warnings on stale flags, dashboards, hard limits forcing grooming.

---

**Question:** CODEOWNERS growth plan?

**Answer:** Evolve from team-wide to directory scoped, platform paths protected, remove departed reviewers quarterly.

---

**Question:** Semantic release setup?

**Answer:** commitlint + release bot, squash message discipline using PR title, handle multi-type commits, guard empty releases.

---

**Question:** When do you rebase a feature branch versus merge main into it?

**Answer:** Rebase locally (before sharing) to keep review linear and resolve conflicts in-place; merge main into long-lived branches if multiple collaborators depend on the tip—never rewrite public shared tips without coordination; default policy should be written to avoid endless debates.

---

### Tech Lead Questions

### Question

Design engineering workflow for 25 engineers across four squads.

### Strong Answer

Pick branching fitting release (likely trunk/GitHub Flow), mandatory CI, merge queue, CODEOWNERS per domain, conventional commits, flag discipline, RFC/ADR cadence, DORA + PR metrics, quarterly retros on workflow debt, explicit mono vs polyrepo stance with tooling budget.

### What the Interviewer Is Testing

Holistic systems leadership beyond “enable branch protection.”

### Weak Answer

“Use GitHub defaults—people know Git.”

### Red Flags  

- No operational metrics  
- Ignores feature-flag/mono trade-offs  

---

**Question:** Introduce conventional commits to skeptics?

**Answer:** Problem-first story (bisect pain), RFC buy-in, warn-only rollout, CI enforcement, measure compliance, pair through friction.

---

**Question:** Measure team flow without toxic productivity metrics?

**Answer:** DORA quartet, PR aging, size distribution—avoid per-developer commit counts.

---

**Question:** Onboarding slow first PR—dig?

**Answer:** Inspect local setup scripts, starter issues, CI access, review bottlenecks, documentation clarity—fix system not person.

---

**Question:** 10GB mono + 45m CI—strategy?

**Answer:** Separate history bloat remediation (LFS/filter) from CI graph acceleration (affected builds, caching, sharding), articulate payback.

---

**Question:** Doc scope policy?

**Answer:** Must-have runbooks/ADRs/contracts/onboarding vs nice-to-have vs delete—tie maintenance cost to incident risk.

---

**Question:** Tooling vs feature roadmap dispute?

**Answer:** Quantify engineer-hour payback, spike uncertain bets, avoid false dichotomy—frame as compound interest.

---

**Question:** Resolve standards debates?

**Answer:** Classify facts vs taste vs trade-off; automate trivial; time-box decisions; ADR outcomes with revisit triggers.

---

### Scenario-Based Questions

**Question:** GitFlow pain with continuous product—move?

**Answer:** Assess release needs; likely retire develop, shorten branches, add flags, strengthen CI, measure conflict and stabilization time drop.

---

**Question:** Accidental force-push to main—recover?

**Answer:** Restore tip via reflog/CI pointers, enforce branch protection, blameless review adding guards.

---

**Question:** Monorepo CI slow—teams want split?

**Answer:** Discover pain (latency vs autonomy), try affected builds & ownership boundaries before splitting—extract only with clear ROI.

---

**Question:** No review norms—intervention?

**Answer:** Metrics baseline, CODEOWNERS rollout, size guidelines, automation, SLAs, cultural modeling from leads.

---

**Question:** Main broken with passing PRs—prevention?

**Answer:** Merge queue/merge train or batched merges against latest main; post-merge verification with revert readiness.

---

### Trick Questions

**Question:** Does Git store diffs?

**Answer:** Logical model is snapshot objects; diffs are computed views—packfiles use deltas for storage optimization only.

---

**Question:** Is a branch a copy of files?

**Answer:** No—branch is a ref to a commit; cheap pointer, not a duplicate tree.

---

**Question:** Does rebase delete old commits instantly?

**Answer:** Leaves unreachable objects until GC; reflog aids recovery—still avoid rewriting shared branches.

---

### Weak Answers and Red Flags

1. **“Rebase is always unsafe—never use it.”** Signals misunderstanding of appropriate local rebase workflows.  
2. **“Branching strategy doesn’t matter.”** Tech Leads own integration risk—this abdicates a core lever.  
3. **“Skip review for tiny changes.”** Tiny config edits can cause major outages—risk-based review, not size-based skipping blindly.  

## AI Usage in Software Engineering

### Basic Questions

**Question:** What is a model hallucination when generating code, and why is it different from an ordinary bug?

**Answer:** Hallucination is plausible output that is not grounded in reality—imports for non-existent APIs, wrong signatures, or “correct-looking” logic that misstates behavior. It differs from bugs because the model is optimizing likelihood of tokens, not truth; there is no compiler for facts inside the model. In production, hallucinated dependencies or auth checks can ship if review and CI do not catch them, so teams treat AI output as **untrusted draft** until verified.

---

**Question:** How does an agentic coding workflow differ from inline completion or a one-shot chat?

**Answer:** Agentic tools run a loop: read files, edit, run tests or commands, observe, iterate. Completion and chat are single-turn or narrowly scoped. Autonomy increases speed but also **blast radius**—wrong plans can touch many files—so permissions, sandboxes, and human review become first-class design concerns.

---

**Question:** What problem does Retrieval-Augmented Generation (RAG) solve for internal tools?

**Answer:** RAG grounds answers in **current, citeable documents** instead of stale parametric knowledge. You chunk and embed sources, retrieve top matches for a query, and inject them into the prompt. Trade-off: retrieval quality becomes the ceiling; bad chunking or metadata hurts more than a larger LLM. Ops-wise you must handle freshness, access control on sources, and citation hygiene.

---

**Question:** What is an embedding, and where does it show up in an engineering stack?

**Answer:** An embedding is a dense vector representing text or code such that similar meaning tends to be closer in vector space. Used for semantic search, clustering, deduplication, and as the retrieval key in RAG (often with cosine similarity on normalized vectors). Choosing the embedding model and dimension trade latency, cost, and domain fit (e.g. code-specific vs general).

---

**Question:** What is prompt injection, and why can “ignore previous instructions” not be the whole fix?

**Answer:** Prompt injection is untrusted input that changes model behavior—analogous in spirit to injection attacks elsewhere. Models do not enforce a hard boundary between instructions and data. **System prompts alone are insufficient**; you need structured roles/delimiters, input and output validation, least-privilege tools, and monitoring. Defense in depth matters because creative payloads bypass naive filters.

---

**Question:** What is a context window, and what operational effects does size create?

**Answer:** The context window caps prompt + completion tokens per request. Larger windows let you paste more code and docs but raise **cost, latency, and distraction**—irrelevant tokens can steer the model wrong. Teams manage context deliberately: scoped files, summaries, and RAG instead of dumping the whole monolith.

---

**Question:** What is tool use / function calling in LLM products?

**Answer:** The model emits structured calls (e.g. JSON) for defined tools—search, DB query, HTTP—rather than pretending it executed them. The runtime runs the tool and returns observations. This enables grounded actions but requires strict schemas, timeouts, authz on each tool, and logging for audit and incident review.

---

**Question:** What are guardrails in production AI features?

**Answer:** Guardrails constrain inputs and outputs: block secrets/PII exfil patterns, enforce response schema, cap rate and cost, route high-risk queries to human review, or run secondary checks. They reduce abuse and policy violations but add latency and can frustrate users if tuned without clear product rules. Tech Leads align guardrails with legal (DPA), security reviews, and observability.

---

**Question:** How do RAG and fine-tuning differ in cost, freshness, and auditability?

**Answer:** **RAG** pulls updated docs at query time—cheaper to refresh, supports citations, weaker if retrieval fails. **Fine-tuning** bakes style or narrow knowledge into weights—higher setup and retrain cost, weaker transparency for compliance, better for stable proprietary phrasing or classification. Many products combine constrained prompts + RAG before considering fine-tune.

---

**Question:** Why is chunk overlap meaningful when building a RAG index?

**Answer:** Overlap between adjacent chunks preserves sentences split across boundaries so neither chunk alone looks irrelevant. Without overlap, recall drops for concepts that span chunks. Trade-off: more storage and some redundancy; teams tune overlap vs chunk size using offline evals (hit rate, MRR) on real questions.

### Senior Questions

### Question

How would you design an internal documentation or runbook assistant using RAG so answers are trustworthy enough for on-call use?

### Strong Answer

Treat it as a **search product** with an LLM on top, not “chat with wiki.” **Ingestion:** chunk (often hundreds of tokens), overlap, clean boilerplate, attach metadata (team, service, env, last_updated, ACL). **Embeddings:** pick a model suited to technical text; consider separate indices for prose vs code. **Retrieval:** top-k with metadata filters (e.g. only `prod` runbooks), optionally cross-encoder re-ranking. **Prompting:** require citations tied to chunk IDs; instruct the model to refuse when context is insufficient. **Serving:** enforce document-level auth so the retriever never surfaces forbidden chunks. **Ops:** log queries, retrieved IDs, and thumbs-up/down; track staleness alerts when sources age out.

### Explanation

Shows end-to-end RAG literacy, security, and operability—not only vector DB buzzwords.

### Practical Example

Runbook asks “how to fail over Region A DB?” If retrieval returns a draft page marked `staging` only, filters should exclude it; if nothing passes threshold, the UI returns “no verified procedure found” plus link to escalation instead of a invented checklist.

### What the Interviewer Is Testing

RAG architecture, grounding, citations, authz, failure handling, and metrics.

### Weak Answer

“We’ll embed Confluence and plug it into GPT.”

### Red Flags

- No chunking, ACL, or stale-doc strategy  
- No citation or abstention behavior  
- Treats the LLM as source of truth  

---

### Question

How do you evaluate AI-generated code in review beyond “tests are green”?

### Strong Answer

Apply normal engineering bar **plus** hallucination and coupling checks. Verify every import and API against real deps. Prefer behavioral tests over snapshots that lock implementation. Require the author to explain invariants and edge cases—if they cannot, treat as high risk. Watch for subtle security issues (authz gaps, logging PII) that tests miss. For large diffs from agents, consider risk-based review: critical paths get two reviewers or a security pass.

### Explanation

Demonstrates that AI shifts burden to **verification**, not removes it.

### Practical Example

A PR adds `requests.get` retry helper tests that assert exact sleep sequence; reviewer asks for contract-based tests around “fails after N attempts” and verifies the `Retry-After` header behavior against RFC expectations.

### What the Interviewer Is Testing

Review discipline, security mindset, test design, ownership.

### Weak Answer

“If CI passes, it’s good—AI is faster than humans anyway.”

### Red Flags

- No import/API verification  
- Tests as sole oracle  
- Author cannot explain changes  

---

### Question

What metrics would you use to measure real productivity impact of AI coding tools for a team?

### Strong Answer

Ignore vendor headline percentages. Track **cycle time** (start → prod), **defect rate** in AI-touched vs untouched PRs, **rework** (commits after review, revert rate), **review latency and reviewer load**, and qualitative **developer experience** (trust, frustration). Run short controlled comparisons on similar tasks. Segment by domain: boilerplate may win; auth flows may lose. Report trade-offs to leadership with uncertainty, not hype.

### Explanation

Shows skepticism, systems thinking, and fairness to reviewers.

### Practical Example

Writing time drops 20% but review time rises 25% and production bugs uptick in payment module—net negative; you tighten policy for sensitive modules and keep AI for internal tooling.

### What the Interviewer Is Testing

Measurement design, avoidance of vanity metrics, stakeholder honesty.

### Weak Answer

“Lines of code per sprint or number of PRs merged.”

### Red Flags

- LOC as success  
- No quality or review-side effects  
- No controlled comparison  

---

**Question:** Where do AI coding assistants tend to add negative value despite confident output?

**Answer:** High-risk areas: authentication/authorization, crypto, novel architecture with few public patterns, regulated business rules, and **live incidents** where misunderstanding a “fix” prolongs outage. Also junior-heavy learning phases where shortcuts skip skill formation. Trade-off: speed vs correctness; policy often routes AI away from Tier-0 paths and mandates pairing or senior review there.

---

**Question:** How would you mitigate skill atrophy if the team leans heavily on AI?

**Answer:** Require understanding in review, periodic exercises without AI on small scoped tasks, and hiring/levelling signals that test fundamentals. Pair AI with **teaching**: use it to explain errors after the human attempts a solution. Balance avoids both denial of useful tools and uncritical dependency.

---

**Question:** How do you reduce leakage risk when engineers use third-party AI services?

**Answer:** DPAs, enterprise data retention settings, allow/deny lists for repos, secret scanning pre-submit, and education on pasting customer data. For strict environments: self-hosted models or air-gapped tooling. Monitor policy drift with occasional audits. Trade-off: tighter policy slows experimentation; align with legal and security early.

---

**Question:** What is temperature, and how would you set it for code vs brainstorming copy?

**Answer:** Temperature scales randomness of sampling. Low (0–0.2) for deterministic code and migrations; higher for ideation where diversity helps. In production APIs, fix seeds or temperature per task type and record them for reproducibility when debugging bad outputs.

---

**Question:** What is your default stance on LLM-as-judge for evaluating outputs?

**Answer:** Useful for scale and triage, but biased toward the judge model’s preferences. Calibrate against human labels on a gold set; use rubrics and blind comparisons. Never let LLM-judge be the only gate for safety-critical behavior.

---

**Question:** When is “ask the model to critique its own output” worth doing—and when is it misleading?

**Answer:** Self-critique can surface shallow mistakes the model “knows” but skipped on first pass—cheap extra pass before human review. It is **not** a correctness proof: the same blind spots often repeat. Use for lint-level issues and test ideas; never substitute for tests, security review, or domain expert sign-off on regulated logic.

---

**Question:** Where do human-in-the-loop checkpoints belong in an AI-augmented SDLC?

**Answer:** At every **trust boundary**: before merge (human code review), before prod config changes, before customer-visible answers ship, and when tools can mutate data. Automate pre-checks (schemas, secret scan) but keep human judgment on novelty and ethics. Trade-off: latency vs safety—tier by risk class.

### Tech Lead Questions

### Question

How would you roll out an org-wide policy for AI-assisted development without killing velocity or ignoring compliance?

### Strong Answer

Run it as a **change program**: align security/legal on data classes; define tiered allow lists (public libs vs customer DB schemas); standardize approved tools; provide **prompt and review playbooks** in-repo; train on hallucination and secret paste risks; pilot with two teams, measure cycle time/quality/review burden; widen based on evidence. Make the default safe: block paste of secrets in IDE plugins where possible; require human owners on agent-opened PRs. Revisit quarterly as models and contracts change.

### Explanation

Shows governance plus adoption mechanics—TL scope is both technical and organizational.

### Practical Example

Policy: “No third-party AI on payment repo paths; internal model for summaries only; all agent PRs need `risk:agent` label and code owner from security for auth files.”

### What the Interviewer Is Testing

Risk management, stakeholder alignment, pilot discipline, operational follow-through.

### Weak Answer

“Everyone can use whatever tool they want as long as they’re smart.”

### Red Flags

- No data classification  
- No pilot or metrics  
- “Smart engineers” as policy  

---

### Question

How would you architect permissions and guardrails for an autonomous coding agent integrated into CI?

### Strong Answer

**Least privilege:** read repo, write branch, run tests—not deploy, not prod credentials. **Sandbox** execution with network egress controls and secret vault separation. **Budgets:** token, time, and iteration caps with automatic stop. **Attestation:** PR must list files touched, commands run, and test logs. **Human merge** with checklist for risky paths. **Observability:** structured logs for tool calls for post-incident review. Escalate permission only via break-glass with approval.

### Explanation

Separates demo agents from production-safe automation design.

### Practical Example

Agent loop halts after ten test failures; outputs diff only; cannot `git push` to `main`; secrets injected via OIDC short-lived tokens—not copied into prompts.

### What the Interviewer Is Testing

Security architecture, blast radius, DevEx realism.

### Weak Answer

“Give it admin access so it isn’t blocked.”

### Red Flags  

- Production credentials in agent context  
- No iteration limits  
- Direct merge without human gate  

---

### Question

When would you choose prompt engineering only, RAG, fine-tuning, or a small specialized model—and how would you decide?

### Strong Answer

Start with **baseline prompts** and eval harness. Add **RAG** when knowledge changes often or you need citations. Consider **fine-tuning** when you need consistent format/style on narrow tasks with abundant labeled data and stable requirements. Consider **smaller local models** when privacy, cost at scale, or latency dominates. Decision drivers: volatility, eval scores, compliance, cost envelope, and team skill to operate infra. Document the choice in an ADR with rollback.

### Explanation

Demonstrates economic and operational reasoning, not trend-chasing.

### Practical Example

Internal SQL dialect helper: RAG over style guide + offline evaluated prompts beats expensive fine-tune when dialect docs change monthly.

### What the Interviewer Is Testing

Trade-offs, ADR thinking, maintenance foresight.

### Weak Answer

“Always fine-tune the biggest model for quality.”

### Red Flags

- Single-hammer bias  
- Ignores evaluation and maintenance  
- No compliance angle  

---

**Question:** How do you coach engineers to write prompts that survive real codebases?

**Answer:** Teach **constraint-first** prompts: interfaces, error strategy, libraries allowed, invariants, links to examples from the repo. Maintain shared templates for tests, refactors, and incidents. Trade-off: longer prompts cost tokens but reduce rework; reviewers can reject vague AI output that skipped constraints.

---

**Question:** How do you handle a stakeholder who wants “AI everywhere” based on vendor marketing?

**Answer:** Translate to hypotheses and metrics; propose a bounded pilot with success criteria tied to business outcomes; surface risks (IP, quality). Offer leadership a dashboard: cycle time, defects, review time, engineer NPS. Escalate ethics and reliability limits clearly.

---

**Question:** What is your approach to testing AI features that face end users (support bots, copilots)?

**Answer:** Offline eval sets, shadow mode, gradual rollout, guardrails, human escalation paths, and monitoring for injection attempts and topic drift. Tie releases to SLOs on resolution quality and safety incidents.

---

**Question:** How do you decide between blocklisting certain modules from AI assistance versus training reviewers on those paths only?

**Answer:** **Blocklist** when blast radius is high and mistakes are subtle (authz, crypto, regulated data) until tooling and review capacity catch up. **Reviewer training-only** when errors are visible in tests and experts are scarce—pair with extra CI checks. Revisit quarterly: blocklists can hide knowledge if overused.

---

**Question:** A vendor announces their model now “trains on your data by default” unless you opt out—what steps do you take?

**Answer:** Treat as security incident review: read contract addendum with legal, inventory which integrations still send data, flip enterprise retention settings, communicate to teams within hours, document evidence for audits. Freeze new integrations until clarified.

### Scenario-Based Questions

**Question:** A junior merges a large AI-generated PR that passes tests but changes authorization middleware subtly. How do you respond as TL?

**Answer:** Mitigate production risk first (feature flag/rollback). Run targeted auth review and differential tests; turn the event into a learning moment: update review checklist for security paths, consider required reviewer for `auth` paths, and coach the junior on verifying invariants—not only happy-path tests.

---

**Question:** Your RAG assistant keeps citing outdated architecture pages after a migration. Users trust it and bad decisions follow.

**Answer:** Treat as data incident: freeze harmful guidance banner, bump freshness scoring, add “last reviewed” metadata filters, alert owners when docs stale, and add user feedback loop. Post-incident: governance on owning canonical docs.

---

**Question:** During Sev-1, someone pastes logs into a public cloud LLM containing session tokens.

**Answer:** Revoke/rotate credentials, contain data per vendor process, notify security/legal per policy, preserve evidence, run blameless review on why secrets were in logs and why tooling allowed paste. Short-term comms; long-term DLP-style guardrails in IDE.

---

**Question:** Two teams use different AI vendors; security demands one standard.

**Answer:** Convene security, legal, finance; compare DPAs and features; pick primary with exception process; define migration timeline; provide wrappers so engineers keep workflow while routing to approved backend.

---

**Question:** An agent opened 30 PRs overnight; CI is saturated and reviewers overwhelmed.

**Answer:** Pause agent jobs, batch changes, require upfront plan approval for broad refactors, tighten rate limits, and prioritize critical services first—incident response pattern applied to automation.

### Trick Questions

**Question:** “We added RAG, so hallucinations are solved.” What is wrong?

**Answer:** RAG reduces but does not eliminate hallucination: models can misread context, use wrong chunks, or cite irrelevant passages confidently. Retrieval mistakes become silent failures without evals and abstention.

---

**Question:** “Keep temperature high for production code to get more creative solutions.”

**Answer:** High temperature increases variance and subtle bugs; production generation should be low-variance with tests and pinned configs. Creativity belongs in design sessions, not unpredictable codegen defaults.

---

**Question:** “Our LLM will replace senior reviewers because it catches many nits.”

**Answer:** Nit-picking ≠ architecture, domain correctness, or judgement under business constraints. Over-reliance hollows review culture and misses context only humans prioritize; use bots as first pass only.

### Weak Answers and Red Flags

1. **“The model is trained on the internet—our stack is probably in there.”** Why weak: Confuses correlation with correctness; private APIs and versions won’t match; invites hallucination acceptance.  
2. **“We’ll rely on the system prompt: ‘never reveal secrets.’”** Why weak: Prompts are not security boundaries; injection and tool misuse remain. Shows naive threat model.  
3. **“Disable AI reviews—it’s all hype.”** Why weak: Ignores measured gains and organizational reality; leadership needs balanced risk management, not denial.

---

## Soft Skills

### Basic Questions

**Question:** What is the STAR structure, and what failure modes does it prevent?

**Answer:** **Situation, Task, Action, Result**—concise context, your responsibility, what *you* did (not a vague “we”), and measurable outcome. Prevents rambling and unfalsifiable claims like “I’m good with conflict.” Trade-off: can feel mechanical; brief signposting keeps it natural.

---

**Question:** What is BLUF and why does it matter in engineering comms?

**Answer:** **Bottom line up front**—recommendation or ask first, then evidence. Execs and busy peers skim; burying the conclusion loses the decision. Pair with headings for scan-ability.

---

**Question:** Define active listening in a technical dispute.

**Answer:** Paraphrase, ask clarifying questions, surface assumptions, confirm understanding before rebutting. Goal is accurate mental model, not waiting your turn to win. Trade-off: takes time upfront, saves thrash later.

---

**Question:** How does SBI differ from “negative feedback”?

**Answer:** **Situation–Behavior–Impact** ties comments to observable events and consequences, not character. Reduces defensiveness compared with “you’re careless.” Still needs clear ask/follow-up.

---

**Question:** What is radical candor’s core axes and common engineering failure mode?

**Answer:** Care personally + challenge directly. Many engineers land in **ruinous empathy**—avoiding hard truths to be nice, letting performance or design debt fester. Obnoxious aggression is the opposite failure.

---

**Question:** What is psychological safety—not and is?

**Answer:** Not politeness or avoiding accountability; it is **low interpersonal cost** to raise risks, ask questions, and disagree with data. Needed for incident learning and design debate.

---

**Question:** What is disagree-and-commit?

**Answer:** Debate vigorously before the decision; once made, execute fully even if you preferred another path—without undermining. Prevents endless consensus hunts and passive resistance.

---

**Question:** Type 1 vs Type 2 decisions?

**Answer:** **Type 1** costly/irreversible—slow down, broaden input. **Type 2** reversible—bias to speed and experiment. Mistake: treating library picks like database rewrites.

---

**Question:** What is expectation management in delivery contexts?

**Answer:** Set **ranges** with assumptions, surface slippage early, update on “no change” weeks too. Surprise is more expensive than an imperfect date.

---

**Question:** Stakeholder map—why bother?

**Answer:** Segment by influence vs interest to tune cadence and depth—prevents spamming low-power groups while starving decision-makers of signal.

### Senior Questions

### Question

Two senior engineers split on architecture—both credible, deadline in two weeks. How do you move?

### Strong Answer

Expose **hidden constraints** (scale, ops, compliance). Require short written comparisons same headings (trade-offs, failure modes, cost). Facilitate decision on **criteria**, not egos. If still tied, you decide with transparent rationale, assign owners, enforce disagree-and-commit. Avoid mushy “merge the designs” without criteria—that often yields worst-of-both.

### Explanation

Shows facilitation + accountability, not generic “collaborate harder.”

### Practical Example

Redis vs Postgres for cache: align on latency budget and staffing; pick Postgres if ops constrained; document rollback if SLO missed.

### What the Interviewer Is Testing

Conflict resolution structure, technical judgement, decision velocity.

### Weak Answer

“Let them figure it out—they’re seniors.”

### Red Flags

- No written comparison  
- Chronic compromise  
- Fear of choosing  

---

### Question

How do you explain a serious technical risk to non-technical executives so they fund mitigation?

### Strong Answer

Translate to **money, legal, customer, or time-at-risk** with ranges; show current burn or exposure; offer **options** (full fix, iterative, monitor-only) with costs and residual risk; tie to strategic goals. Bring visuals sparingly; invite questions early. Follow with written decision log.

### Explanation

Tests business communication, not “dumbing down tech.”

### Practical Example

Message loss in queue → dollars unreconciled / month, regulatory angle if applicable, two remediation tracks with timelines.

### What the Interviewer Is Testing

Stakeholder fluency, credibility, option thinking.

### Weak Answer

Long infrastructure lecture ending “we should fix it.”

### Red Flags  

- No quantified impact  
- Single take-it-or-leave-it option  

---

### Question

How do you give hard feedback upward or laterally without torching the relationship?

### Strong Answer

Anchor on **patterns and impact**, not personality. For managers, connect dots to team outcomes (“When timelines shift late, downstream teams idle—here are two instances and the cost”). For peers, use curiosity first (“Am I missing context on why X missed review?”) then SBI-style specifics. Agree on observable next steps and a check-in. If power dynamics block honesty, involve your EM with shared facts—not hallway venting.

### Explanation

Demonstrates SBI/radical candor without either avoidance or aggression.

### Practical Example

Peer repeatedly cancels design reviews; explain impact on integration testers, propose protected slots or async review with deadlines.

### What the Interviewer Is Testing

Candor under hierarchy, relationship repair, professionalism.

### Weak Answer

“I’d stay positive and hope they get the hint.”

### Red Flags

- Vague “be constructive”  
- Feedback sandwich as crutch  
- No concrete behavior cited  

---

**Question:** A strong contributor often finishes late while delivering excellent quality. How do you respond?

**Answer:** Diagnose before judging: estimation gaps, gold-plating, unclear DoD, or WIP overload. Use sprint data to show variance; explain downstream blocking effects. Co-create fixes—scope tiers, pairing on estimates, thinner slices—while protecting high standards on high-impact work. Trade-off: some tasks need polish; many need “good enough” predictability.

---

**Question:** How do you protect deep work when your calendar fragments?

**Answer:** Classify meetings (decide vs inform vs optional), decline politely, batch contiguous blocks, and defend recurring focus time as you would a senior review. Track % unscheduled time; if chronically low, you are in reactive mode—not leading.

---

**Question:** How do you write design docs people actually read before the review?

**Answer:** BLUF + skim-friendly headings; same template per option; numbered open questions with owners; circulate 48h early with explicit asks to named reviewers; meeting resolves threads, not first read-through.

---

**Question:** Your skip-level challenges your decision in a public forum—how do you respond in the room?

**Answer:** Stay calm, restate constraints and options, invite new data; if they surface unknown budget or risk, offer timed re-analysis; debrief your manager after. Authority is not the goal—correct decision is.

---

**Question:** How does cultural difference show up on distributed teams?

**Answer:** Silence can mean consent or deep dissent. Rotate meeting times; prefer async docs; explicitly invite dissent; avoid interpreting one communication style as the norm.

---

**Question:** Mentoring vs coaching when developing future Tech Leads?

**Answer:** **Mentoring** transfers experience; **coaching** pulls out their trade-off analysis. Use both: stories where useful; questions to build judgment on ambiguous calls.

---

**Question:** You receive sharp feedback you initially disagree with—what do you do next?

**Answer:** Pause defensiveness; ask for concrete examples; check whether the *signal* is true even if delivery stung; run a short experiment on changed behavior and measure results. Trade-off: ego vs learning speed—strong leaders bias toward learning.

### Tech Lead Questions

### Question

Product demands a fixed date; engineering sees a scope cliff. How do you negotiate without eroding trust on either side?

### Strong Answer

Make the **scope–time–quality** frame explicit; refuse silent quality cuts—negotiate scope and interim milestones. Propose scenario table: MVP now, phase two later, with risks spelled out. Pair with EM on stakeholder comms; document decisions. Use reference-class forecasting for credibility.

### Explanation

Shows principled negotiation and partnership with PM/EM.

### Practical Example

Ship read-only analytics slice by date; mutating workflows slide to next release with feature flag kill-switch ready.

### What the Interviewer Is Testing

Influence without authority, expectation management, structural clarity.

### Weak Answer

“We’ll work harder and hit the date.”

### Red Flags

- Hero culture  
- Hidden cuts to testing/observability  

---

### Question

How do you handle chronic passive aggression in meetings (eye-rolls, sarcasm) that chills participation?

### Strong Answer

Address **observable behavior** privately with SBI, tie to team norm (psychological safety), clarify impact. Offer channels for direct critique. If pattern persists, involve EM with HR guidance as needed. Public callouts in front of the group usually backfire.

### Explanation

Leadership hygiene without avoidance or theatrics.

### Practical Example

After snide comment shuts down junior, privately: “When X happened, Y stopped contributing—that loses us bugs caught early.”

### What the Interviewer Is Testing

Culture stewardship, difficult conversations.

### Weak Answer

“I’ll joke in Slack later so tension goes away.”

### Red Flags

- Ignores impact on quieter members  
- Drama in public channels  

---

### Question

EM wants faster feature output and suggests skipping blameless post-mortems—how do you respond?

### Strong Answer

Explain **second-order costs**: repeat incidents, attrition, audit exposure. Propose lighter-weight interim learning (async timeline + five whys) while still protecting psychological safety. Quantify recent incident drag if possible. Partner on sustainable pace rather than opposing EM in binary way.

### Explanation

Balances empathy for delivery pressure with system integrity.

### Practical Example

Time-box post-mortem to 45 minutes with pre-filled template; track action completion rate as metric.

### What the Interviewer Is Testing

Stakeholder alignment, systems thinking, resilience engineering values.

### Weak Answer

“Compliance says we need them—deal with it.”

### Red Flags  

- Hiding behind policy not reasoning  
- Dismissing EM pressures outright  

---

**Question:** How do you run a blameless post-mortem that produces real change?

**Answer:** Timeline with evidence, no individual blame fields, systemic “five whys,” owned actions with dates, exec summary of learning. Track completion in retro 30 days later—otherwise ritual is theater.

---

**Question:** How do you deliver “no” to an influential stakeholder requesting a risky shortcut?

**Answer:** Explain constraints in their vocabulary, offer alternatives with trade-offs, show blast radius, involve sponsor if needed. Document decision. Saying no without options reads as obstruction.

---

**Question:** Cross-team dependency is slipping—how do you escalate without burning bridges?

**Answer:** Quantify impact, propose joint mitigation, written interface agreements, exec sponsor only after peer TL path exhausted; offer help (capacity, clarity) not only complaints.

---

**Question:** How do you brief executives after a visible customer-facing incident without sounding defensive or alarmist?

**Answer:** BLUF on customer impact and current status; timeline of actions; confirmed vs suspected cause; next mitigation steps; what you are monitoring overnight. Separate facts from hypotheses. Offer one-page follow-up with owned actions—tone calm, accountable, specific.

---

**Question:** How do you sustain collaboration when your team is frustrated with another org that “throws work over the wall”?

**Answer:** Name the pattern with data, propose interface working group, document SLAs, escalate jointly with their TL to **shared** leadership with suggested structural fixes—not anonymous blame. Celebrate small wins when handoffs improve.

### Scenario-Based Questions

**Question:** A release train leaves in 48h; security flags a medium CVE in a transitive dependency. PM says ignore.

**Answer:** Triage exploitability in your context; propose minimal upgrade path, time-box spike, or documented compensating control; escalate residual risk in writing with EM/security—never silent “ignore.”

---

**Question:** Two ICs escalate interpersonal conflict to you with conflicting stories.

**Answer:** Separate conversations, behaviors not motives, seek artifacts (Slack/PR timeline), restate norms, mediated session if safe, HR if harassment threshold—decide based on observed impact to delivery and culture.

---

**Question:** Leadership announces reorg mid-quarter; morale dips and velocity stalls.

**Answer:** Transparent listening sessions, clarify what is/is not decided, shrink WIP, protect milestones that anchor certainty, partner with EM on comms cadence—acknowledge grief without false certainty.

---

**Question:** You must cut roadmap 30%—how do you workshop with Product?

**Answer:** Stack-rank by outcome metrics, map dependencies, identify reversible vs irreversible deferrals, communicate customer narrative, align engineering capacity to new critical path—avoid silent descoping of quality workstreams.

---

**Question:** Customer support floods engineers with interrupts; roadmap burns.

**Answer:** Define interrupt budget, triage tier, on-call vs roadmap ownership, automate FAQs, staffing trade discussion with leadership—solve structurally not by heroics.

### Trick Questions

**Question:** “Radical candor means always saying what you think immediately.”

**Answer:** Timing and setting matter; candor without care reads as aggression. Prepare, choose private vs forum, pair challenge with support.

---

**Question:** “Psychological safety means nobody gets tough feedback.”

**Answer:** Safety enables honest feedback and accountability; absence of performance standards erodes trust for high performers.

---

**Question:** “STAR stories should always cast you as sole hero.”

**Answer:** Interviewers want *your* actions (I) but credible collaboration; claiming you alone saved the day signals inflation.

### Weak Answers and Red Flags

1. **“I don’t really have conflicts—I get along with everyone.”** Why weak: Unfalsifiable; signals avoidance or lack of senior scope.  
2. **“I gave feedback once—they didn’t change, so I gave up.”** Why weak: No iteration, coaching, or escalation path—ownership gap.  
3. **“I always tell people exactly what I think—brutal honesty works.”** Why weak: Confuses obnoxious aggression with candor; ignores care and timing.

---

## Tech Lead Skills

### Basic Questions

**Question:** Tech Lead vs Engineering Manager—split of responsibilities?

**Answer:** TL drives **technical direction, delivery, and risk**; EM owns **people systems** (growth, hiring, comp). Healthy partner model: TL flags capacity and skill gaps; EM staffs and develops. Combined-role orgs blur lines—clarify decision rights in writing.

---

**Question:** What is a risk register and who owns updates?

**Answer:** Living list of threats with likelihood, impact, mitigation, owner, review cadence. TL typically **accountable** for technical risks; whole team contributes discoveries. Stale registers are liabilities—review in milestones.

---

**Question:** Define technical debt in a way stakeholders understand.

**Answer:** **Deferred work that taxes future speed/ reliability**—sometimes deliberate trade for time. Problem is invisible unmanaged debt. TL quantifies drag (CI time, incident frequency, lead time) not only “messy code.”

---

**Question:** What is progressive delegation?

**Answer:** Stages from “I decide and explain” → “you propose, I refine” → “you decide, inform me.” Matches authority to demonstrated judgment—opposite is abdication.

---

**Question:** Why should a TL stay in on-call rotation?

**Answer:** Ground-truths operational pain; earns credibility; surfaces architecture blind spots. Can reduce frequency but not disappear into ivory tower.

---

**Question:** RACI at a glance for a release decision?

**Answer:** Clarify who is **accountable** vs **responsible**; consult legal/security when needed; inform support/sales. Ambiguous A/R creates last-minute thrash.

---

**Question:** Two-week test for calibrating TL technical involvement?

**Answer:** If two-week absence blocks all progress, you are a bottleneck; if absence causes architecture drift, tune direction mechanisms (reviews, principles). Aim for resilient team with steer, not dependency.

---

**Question:** Bus factor—how improve it?

**Answer:** Pairing on critical services, rotate ownership, ADRs, runbooks, deliberate mentoring. Trade-off: short-term duplication for long-term resilience.

---

**Question:** Fitness function in architecture?

**Answer:** Automated checks that architecture rules hold—module boundaries, SLO tests, latency budgets in CI. Turns intent into enforcement with escape hatches documented.

---

**Question:** Production readiness checklist—minimum ideas?

**Answer:** Health endpoints, structured logs/metrics/traces, alerts tied to SLOs, rollback story, runbook, load test summary, security review for exposure—gate releases on evidence not vibes.

### Senior Questions

### Question

Tech debt backlog grows; leadership wants “features only” for two quarters. What is your play?

### Strong Answer

Reframe as **portfolio risk**: tie debt to measurable drag (MTTR, CI, incidents, onboarding). Negotiate **explicit deferral with recorded consequences** or minimal “keep the lights on” buffer (e.g., 10–15%). If denied, forecast predictable outage or attrition scenario with ranges—leadership chooses risk knowingly. Internally, ruthlessly prioritize debt that compounds.

### Explanation

Balances realism with fiduciary framing.

### Practical Example

8-minute CI costing 15 min/PR × 20 engineers → weekly tax—pitch incremental cache fix.

### What the Interviewer Is Testing

Executive communication, risk literacy, backbone.

### Weak Answer

“We’ll chip away when we can.”

### Red Flags

- No quantification  
- Covert quality cuts  

---

### Question

You lead through a Sev-1—what is your default stance in the first minutes?

### Strong Answer

**Roles:** commander, primary debugger, comms lead—avoid same person debugging and writing exec updates. **Mitigate before perfect diagnosis** when rollback/feature flag viable. Maintain timestamped timeline for later learning. Post-incident: blameless review with tracked actions and verification.

### Explanation

Incident command literacy separate from raw debugging skill.

### Practical Example

Bad deploy suspected—rollback at minute 3 while other track heap in staging replica.

### What the Interviewer Is Testing

Operational leadership, calm under pressure, learning culture.

### Weak Answer

“I jump into logs with everyone—more eyes faster.”

### Red Flags  

- Role soup  
- Analysis paralysis before mitigation  

---

### Question

Greenfield estimate with no reference class—how proceed without lying about certainty?

### Strong Answer

List unknowns; time-box spikes; give **ranges** with explicit assumptions; schedule re-estimation gates after spikes/milestones; track actuals to tighten forecasts. Transparency beats false precision.

### Explanation

Honest estimation under uncertainty—TL accountability.

### Practical Example

Kafka + unfamiliar payment API → two-day spikes each; widen range until learning lands.

### What the Interviewer Is Testing

Planning rigor, stakeholder trust.

### Weak Answer

“Add 30% buffer to Gantt—we’ll be fine.”

### Red Flags  

- Single-point guesses  
- No learning plan  

---

**Question:** Senior engineer challenges every architectural call—what patterns do you try?

**Answer:** Separate valid critique from process exclusion; structured written alternatives; Type1/Type2 differentiation; change your mind publicly when wrong; 1:1 on meta-pattern if obstructive.

---

**Question:** How choose what stays on your plate vs delegates?

**Answer:** **Impact × replaceability** matrix; keep irreversible direction and cross-org alignment; delegate with progressive trust; never assign judgment calls beyond engineer readiness.

---

**Question:** Velocity down three sprints—first diagnostics?

**Answer:** Unplanned work %, scope churn, debt hotspots, people factors (burnout, staffing), dependency delays—use data before pep talks.

---

**Question:** Major tech migration—how reduce failure odds?

**Answer:** RFC, PoC with kill criteria, incremental strangler pattern, learning budget, rollback triggers, comms to stakeholders on transient slowdown.

---

**Question:** New external dependency is on the critical path—what do you lock down before coding spreads?

**Answer:** Written interface contract (OpenAPI/proto), SLA dates, single DRI per side, mock/fallback for dev, risk register entry with escalation path. Relationship: short standing sync between TLs—prevents “we thought you meant March” failures.

---

**Question:** How do you run a code review calibration exercise without demoralizing the team?

**Answer:** Same diff, silent review, then compare comments in a blameless session—align blocking vs nit, document outcomes in working agreement. Frame as quality equity, not scoring people. Time-box; end with clear rubric updates.

---

**Question:** Reference-class forecasting is thin ground—what adjacent signal do you still use?

**Answer:** Proxy classes (different domain, similar integration count), expert judgment bands, and spike outcomes—**triangulate** rather than pretend precision. Record how wrong you were to build future reference class.

### Tech Lead Questions

### Question

You inherit a team skeptical of “another Tech Lead.” How earn authority in 90 days?

### Strong Answer

Listen deeply (1:1s, history docs), **ship one team-chosen fix** demonstrating competence, publish decision rationale transparently, avoid whirlwind rewrites. Show vulnerability on misses. Authority follows **predictable judgment**, not title.

### Explanation

Onboarding pattern that avoids vision-washing.

### Practical Example

Stabilize flaky CI cited in every retro—measurable morale win.

### What the Interviewer Is Testing

Trust building, patience, execution.

### Weak Answer  

“Present my roadmap in week one.”

### Red Flags  

- Change before context  
- Leadership-by-deck  

---

### Question

Matrixed project: peer Tech Lead ignores API contract; your team blocked. No shared boss—what now?

### Strong Answer

Private, facts-based conversation; written SLA proposal; joint demo of breakage; escalate together to product/architecture forum with customer impact; offer concrete help (types contract, paired integration test). Avoid escalation theater before good-faith tech path.

### Explanation

Leading without authority across teams.

### Practical Example

Propose temporary adapter in your service **only** with dated removal once their fix lands—documented debt.

### What the Interviewer Is Testing

Negotiation, technical diplomacy, patience.

### Weak Answer  

“Tell my VP to tell their VP.”

### Red Flags  

- Instant political routing  
- No direct engineering dialogue  

---

### Question

New mandate: adopt org-wide GenAI coding assistants next sprint—you own team rollout. Plan?

### Strong Answer

Align to security classification, pick pilot scope, train on review expectations, measure cycle time/quality, define forbidden paths (auth/core financial), instrument audits, gather friction, iterate policy—connect to AI governance chapter concretely.

### Explanation

Synthesis of TL delivery + AI risk surfaced in user brief.

### Practical Example

Start with internal tooling repo; forbid agent merges on payment service until checklist passed.

### What the Interviewer Is Testing

Change leadership, risk-aware adoption.

### Weak Answer  

“Turn it on for everyone day one.”

### Red Flags  

- No guardrails or metrics  

---

**Question:** EM insists you code critical path solo “for speed”—how respond?

**Answer:** Explain bus factor and review throughput trade-off; propose pairing or incremental handoff; link to sustainable velocity; escalate risk acceptance if they insist—document.

---

**Question:** How onboard senior hire who will co-lead architecture?

**Answer:** Shared ownership map, explicit decision areas, joint reviews first month, conflict process pre-agreed—avoid shadow power struggles.

---

**Question:** How institutionalize code review quality without bottling on TL?

**Answer:** Calibration sessions, rubrics, lint/CI for mechanical checks, delegate domain experts as owners, spot-audit—scale standards via systems not heroics.

---

**Question:** Board asks you to “guarantee zero outages next quarter”—how reply?

**Answer:** Explain reliability economics: SLOs, error budgets, and residual failure modes; commit to **process outcomes** (MTTR, incident reduction, pre-mortems) not miracles. Offer investment trade-offs—cannot promise zero without infinite cost or scope halt.

---

**Question:** Acquisition integration lands duplicate platforms on your team—how prioritize consolidation without stopping revenue work?

**Answer:** Risk-weight the overlap (data corruption, double run-cost); pick strangler sequence with clear kill dates; carve dedicated fraction of capacity; align PM on customer-visible milestones; track progress publicly to prevent eternal parallel systems.

### Scenario-Based Questions

**Question:** Launch feature flag stuck 50% due to unexplained latency regression—PM pushes GA.

**Answer:** Define SLO delta, profile, choose constrained ramp or kill criteria, communicate business risk numerically—no silent GA.

---

**Question:** Contract engineer’s PRs solid but ignores team conventions—friction rises.

**Answer:** Document conventions, friendly review comments, 1:1 on collaboration expectations, involve vendor mgmt if needed—treat as team integration issue.

---

**Question:** Metrics show rising error budget burn after “quick” cache addition.

**Answer:** Freeze risky deploys, rollback/cache toggle, assign owner to model coherence vs source of truth, post-incident on bypassed reviews.

---

**Question:** You discover silent shadow DB writes by analytics job violating integrity.

**Answer:** Stop job, assess data corruption scope, coordinate repair, tighten data contracts and monitoring—legal/comms if customer data affected.

---

**Question:** Team split on hybrid work norms affecting pairing.

**Answer:** Facilitate working agreement refresh—core hours, pairing cadence, documentation compensations—document and revisit quarterly.

### Trick Questions

**Question:** “Tech Lead should be the top committer to stay credible.”

**Answer:** Credibility comes from judgment and unblocking; excessive coding starves strategy and delegation—balance shifts by team maturity.

---

**Question:** “We can skip design docs because we move fast.”

**Answer:** Fast orgs use **short** docs; zero docs externalize cost to the next engineer and to incidents—right-size, not zero.

---

**Question:** “Velocity is the primary health metric.”

**Answer:** Velocity without quality predictability misleads; pair with defect rates, SLOs, lead time, survey signals—avoid local optimization.

### Weak Answers and Red Flags

1. **“I decide architecture; others execute my blueprint.”** Why weak: Disempowers experts; creates single point of failure; poor learning culture.  
2. **“Incidents are mostly Ops’ problem once code ships.”** Why weak: TL owns lifecycle outcomes; breeds siloed reliability.  
3. **“I’ll protect the team by hiding bad news from leadership.”** Why weak: Surprise destroys trust; mature TL frames risk early with options.

---

## Cross-Domain Tech Lead Questions

### Question

How would you introduce a secure, scalable direct-to-cloud file upload (e.g., user-generated documents) while balancing cost, malware risk, and privacy?

### Strong Answer

Use pre-signed URLs or short-lived tokens for client → object storage; virus scanning pipeline; size/type limits; encryption at rest with KMS; least-privilege IAM; PII classification driving retention and logging redaction. **Communication:** PM/legal on data residency; **people:** training support on incident path if malicious file executes downstream job. Load-test multipart uploads; cost alerts on egress/abuse.

### Explanation

Joins architecture, security, org comms, operational readiness.

### Practical Example

S3 + ClamAV Lambda + async metadata row; block if scan pending; lifecycle policy to Glacier after N days per DPA.

### What the Interviewer Is Testing

Systems design + governance + stakeholder vocabulary.

### Weak Answer

“Store files in the app server disk—it’s easier.”

### Red Flags

- No scanning or authz on object access  
- Ignores compliance  

---

### Question

An API p99 latency doubled after a release—stack is Node.js, PostgreSQL, Redis, Kubernetes, CloudWatch. How diagnose end-to-end?

### Strong Answer

**Blameless triage:** verify canary vs full rollout; check error vs latency correlation; trace requests (APM/trace IDs); inspect DB slow queries and pool saturation; Redis hit ratio and hot keys; Node event-loop lag and GC; pod CPU throttling/HPA; compare CloudWatch/K8s metrics timeline. **People:** assign incident roles; **comms:** status updates with ETA—not speculative root cause early. Form hypothesis, test, document.

### Explanation

Shows full-stack methodical debugging plus incident leadership.

### Practical Example

Found pool exhaustion from unreleased connections after ORM upgrade—rollback + patch.

### What the Interviewer Is Testing

Breadth, metric literacy, calm coordination.

### Weak Answer  

“Scale the pods until it’s fast again.”

### Red Flags  

- Random scaling without diagnosis  
- No DB/cache check  

---

### Question

Greenfield workload—when choose serverless functions vs containers vs Kubernetes?

### Strong Answer

Map to **traffic shape, ops maturity, state, latency, vendor lock appetite**. Spiky intermittent with low ops: functions maybe. Long-lived stateful services with bespoke networking: k8s if org has platform team; else managed containers/ECS. Discuss cold starts, local dev ergonomics, cost model (per request vs steady cluster), and team skill. **Stakeholder:** translate idle cost vs burst savings.

### Explanation

Trade-off reasoning beyond fad labels.

### Practical Example

Event ingestion transforms: functions; core OLTP API with sidecars: k8s.

### What the Interviewer Is Testing

Architecture decision discipline, honesty about ops constraints.

### Weak Answer  

“Always Kubernetes.”

### Red Flags  

- One-size-fits-all  
- Ignores team capability  

---

### Question

Finance asks for 20% cloud savings without touching reliability—your approach?

### Strong Answer

Rightsizing, autoscaling tuning, storage tiers, idle env teardown, reserved/savings plans where baseline proven; optimize hot queries before compute brute force; **risk:** validate against SLO tests; **people:** show engineers savings fund reinvestment—avoid naive “turn off monitoring.”

### Explanation

Cost engineering with reliability and morale in view.

### Practical Example

Nonprod schedules off nights/weekends; savings tracked; error budget unchanged in prod.

### What the Interviewer Is Testing

FinOps + engineering judgment.

### Weak Answer  

“Delete all staging clusters.”

### Red Flags  

- Cuts that blind operations  

---

### Question

How roll out org-wide AI coding assistants without leaking IP or lowering review quality?

### Strong Answer

Classify data, legal/DPA path, approved tools, training, pilot metrics (quality, review time), critical-path code paths with stricter rules, secret prevention hooks, mandatory explanation in review for AI-touched security files—iterate policy from evidence.

### Explanation

Merges AI usage, security, change management.

### Practical Example

Internal repos first; customer-schema repos blocked from external LLM until enterprise tier vetted.

### What the Interviewer Is Testing

Holistic governance.

### Weak Answer  

“Trust engineers not to paste secrets.”

### Red Flags  

- Policy by optimism  

---

### Question

Legacy frontend blocks releases—how modernize without stopping feature delivery?

### Strong Answer

Strangler pattern behind flags, slice vertical features, establish contract tests with backend, incremental design-system adoption, parallel track for tooling (build, CI); **people:** clear comms to PM on capacity split; **risk:** perf budgets each slice.

### Explanation

Architecture + product negotiation + team sustainability.

### Practical Example

Replace checkout wizard module-by-module; old path fallback until metrics match.

### What the Interviewer Is Testing  

Roadmapping under constraint.

### Weak Answer  

“Big-bang rewrite after we freeze features.”

### Red Flags  

- Unbounded business stop  

---

### Question

Vendor API outage during peak—customers blame you. Playbook?

### Strong Answer

External comms transparency, internal severity process, enable cached degraded mode if safe, queue/retry with fairness, **post-incident:** resilience patterns (bulkheads, timeouts), contractual credits discussion—coordinate PM/legal/comms.

### Explanation

Technical resilience plus soft-skill crisis comms.

### Practical Example

Read-only storefront mode with banner; orders queued with ETA email.

### What the Interviewer Is Testing  

Ownership under dependency failure.

### Weak Answer  

“Not our fault—the vendor messed up.”

### Red Flags  

- Deflection externally  
- No customer mitigation  

---

### Question

Regulatory project demands auditable model behavior—Product wants a chatbot on customer data. Path?

### Strong Answer

Data minimization, RAG with ACL-aware retrieval, logging redaction, human escalation, evaluation harness, legal sign-off on retention; maybe on-prem smaller models; document limitations and abstention. **People:** train support on disclaimers.

### Explanation

Compliance × ML design × comms.

### Practical Example

Retrieve only snippets customer entitled to; cite doc versions in answers stored with audit ID.

### What the Interviewer Is Testing  

Risk-adjusted product sense.

### Weak Answer  

“Fine-tune GPT on full export.”

### Red Flags  

- Train on raw PII without analysis  

---

### Question

Two squads ship conflicting events to same analytics topic—data science outputs wrong Board metrics. Fix?

### Strong Answer

Stop-the-line moment: schema registry versioning, compatibility tests in CI, TTL on bad consumers, replay strategy; **people:** align PMs on definition of KPI; **process:** RFC for event contracts; communicate incident to execs with corrected numbers path.

### Explanation  

Org design + data architecture + communication.

### Practical Example

Temporary dual topics v1/v2 with consumer migration deadline.

### What the Interviewer Is Testing  

System ownership across teams.

### Weak Answer  

“Tell data science to clean it.”

### Red Flags  

- Pushing quality downstream  

---

### Question

You lack hire headcount but scope grows—how protect sustainability?

### Strong Answer

Evidence pack for leadership (lead time, incident rate, survey); ruthless prioritization with PM; buy vs build for commodity; raise contractor/loan policy; **team:** reset WIP, cancel low-value meetings; document risk acceptance if forced—pair EM on staffing narrative.

### Explanation  

People + portfolio + exec storytelling.

### Practical Example  

Defer nice-to-have integrations; keep single reliability epic funded.

### What the Interviewer Is Testing  

Resource advocacy without martyrdom.

### Weak Answer  

“We’ll do crunch this quarter only.”

### Red Flags  

- Normalizing crunch  

---

## Final Interview Preparation Checklist

### One Week Before

- Map the company’s stack and public architecture hints; prepare two STAR stories per pillar (delivery, conflict, incident, influence without authority, AI/tooling change if relevant).  
- Re-read JD; align talking points to **their** vocabulary (SRE, product-partner, FinOps).  
- Draft three questions for them that show judgment (release process, on-call philosophy, tech debt norms).  
- If take-home exists, plan environment parity and timebox polish; rehearse live walkthrough narrative.  
- Sleep, exercise, and reduce parallel stressors—cognitive bandwidth is part of prep.

### Day Before

- Dry-run stories aloud ≤2 minutes each; trim jargon; verify metrics in your STAR results.  
- Prepare small notebook with numbers you must not misremember (scale, team size, outcomes).  
- Pack machine + charger + hotspot; test IDE/fonts if virtual whiteboard.  
- Skim your own résumé for exaggeration landmines—be ready to go deeper honestly.  
- Early night—the interview is an endurance event as much as a knowledge event.

### During the Interview

- Clarify ambiguous questions before solving; state assumptions explicitly when designing systems.  
- Narrate trade-offs (cost, ops, security, people); avoid premature convergence.  
- For behavioral prompts, default to **STAR**; credit collaborators without erasing *your* actions.  
- When stuck, think aloud and propose fallback paths—signal for “pairing” style collaboration.  
- Ask your prepared questions when invited; note names/teams for thank-you notes.

### After the Interview

- Send concise thank-you within 24h referencing specific discussion threads—not generic fluff.  
- Jot private retro: what went well, surprises, gaps to study; update flashcards while memory fresh.  
- If multi-round, adjust stories to avoid repetition fatigue; thread continuity (“as I mentioned in system design…”).  
- Follow up politely if comms stall past stated window; maintain other pipeline momentum.  
- Regardless of outcome, archive insights—patterns repeat across companies.
