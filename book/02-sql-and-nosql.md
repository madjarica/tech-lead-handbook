# SQL and NoSQL Databases

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can model data correctly for a workload,
read and reason about a query plan, choose a database family with a
defensible trade-off, and explain consistency models without confusing
CAP folklore with PACELC.

## Why This Matters for a Tech Lead

The database is usually the hardest thing to change later. A wrong
choice here multiplies cost, on-call pain, and migration risk. Tech
Leads must defend a database choice in front of architecture review.

## Mental Model

> TODO: Mental model "the database is a query optimizer + a storage
> engine + a transaction manager", and a Mermaid sketch of those
> three layers.

## Core Terminology

> TODO: ACID, BASE, MVCC, isolation levels, replication, sharding,
> CAP, PACELC, write amplification, hot partition, secondary index,
> covering index, materialized view.

## Theoretical Foundation

> TODO: Cover:
>
> - Relational model and normalization (1NF–3NF, BCNF mention).
> - Indexes: B-tree, hash, partial, covering, multi-column, full-text,
>   GIN/GiST in passing.
> - Query planner basics: scan vs seek, join orders.
> - `EXPLAIN`/`EXPLAIN ANALYZE` reading.
> - Transactions: ACID, isolation levels (RU/RC/RR/SER), MVCC,
>   serialization anomalies (lost update, write skew).
> - Locking: row, range, intention, deadlocks.
> - Replication: primary/replica, multi-primary, logical vs physical,
>   failover.
> - Sharding: range, hash, directory; resharding pain.
> - NoSQL families: key-value, document, wide-column, graph,
>   time-series; what each is good and bad at.
> - Consistency models: strong, eventual, causal, read-your-writes,
>   monotonic reads.
> - CAP and PACELC; the framing in real systems.

## Practical Usage

> TODO: Workload shapes -> database fit (OLTP, OLAP, HTAP, document
> store with mixed access, append-only event log).

## Examples

> TODO:
>
> - A slow query and the index that fixes it.
> - An N+1 query in an ORM and the eager-load fix.
> - A partial index for a hot status column.
> - DynamoDB single-table design example, with access patterns.
> - A `pg_stat_statements` snippet.

## Common Mistakes

> TODO:
>
> 1. Treating NoSQL as "no schema". (It is "schema in the application".)
> 2. Adding an index per column.
> 3. Using `SELECT *` in production hot paths.
> 4. Trusting `READ COMMITTED` without checking for write skew.
> 5. Sharding too early.

## Trade-offs

> TODO: Table comparing OLTP RDBMS, document DB, wide-column,
> key-value, graph, time-series.

## Production Considerations

> TODO:
>
> - Backup, PITR, restore drills.
> - Connection pooling and `max_connections`.
> - Schema migration tooling and online DDL.
> - Cost: managed vs self-hosted.

## How to Explain This in an Interview

> TODO: How to answer "SQL vs NoSQL" without being trapped into a
> false dichotomy.

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Pick a database for a chat app".

## Tech Lead Checklist

- [ ] Each service documents its access patterns and chosen DB.
- [ ] Slow query log is reviewed regularly.
- [ ] Backup/restore is tested, not assumed.
- [ ] Schema changes go through a reviewed migration tool.
- [ ] Index growth is monitored.

## Interview Questions and Answers

### Basic

> TODO: "What is an index?"

### Senior

> TODO: "Explain isolation levels and where they hurt."

### Tech Lead

> TODO: "How do you choose between a single shared DB and DB-per-service?"

### Scenario-based

> TODO: "Design the data layer for a SaaS multi-tenant app."

### Trick Questions

> TODO: "Is NoSQL faster than SQL?"

### Red Flags

> TODO: Candidates who confuse CAP with PACELC, or claim eventual
> consistency means "stale forever".

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Designing Data-Intensive Applications" by Kleppmann; the
> Postgres docs on isolation; the DynamoDB best practices guide.

---

### Generation Notes

- Cross-link to chapter 13 (System Design) for sharding and replication
  in the context of a system.
- Cross-link to chapter 19 (Performance) for caching layers.
- Avoid version-pinning specific Postgres/MySQL/Mongo features unless
  verified.
