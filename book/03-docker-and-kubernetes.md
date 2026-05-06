# Docker and Kubernetes

## Chapter Goal

After reading this chapter, an experienced engineer can write a
production-ready Dockerfile with proper layer caching and non-root
execution, explain the Kubernetes control loop and object model on a
whiteboard, reason about scheduling, probes, and rollout strategies,
design resource allocation and multi-tenancy for a shared cluster,
troubleshoot common pod failure modes, and decide when Kubernetes earns
its operational cost versus simpler alternatives.

## Why This Matters for a Tech Lead

Containers and orchestration are infrastructure decisions with
multi-year consequences:

- **Operational cost compounds.** A poorly configured cluster wastes
  40-60% of compute budget on idle resources. The Tech Lead owns
  resource strategy (requests, limits, HPA thresholds) because
  engineering teams rarely optimize what they cannot see.
- **Complexity is the real cost.** Kubernetes solves hard problems
  (scheduling, rollouts, self-healing) but introduces new ones (RBAC,
  networking, upgrade cadence, YAML sprawl). The Tech Lead decides
  whether the complexity is justified for the team's scale.
- **The blast radius is the entire platform.** A misconfigured
  admission controller, a bad cluster upgrade, or an OOM-killed
  control plane component affects every service. The Tech Lead owns
  the risk assessment.
- **Team skill requirements change.** Adopting Kubernetes means every
  engineer needs container literacy. The Tech Lead must plan training,
  hiring criteria, and abstraction layers (Helm, internal platforms)
  that reduce the Kubernetes surface area for application developers.
- **Vendor lock-in hides in details.** EKS, GKE, and AKS differ in
  networking, IAM integration, and add-on lifecycle. The Tech Lead
  evaluates portability versus managed convenience.

A Tech Lead who says "we use Kubernetes because everyone does" is a
red flag. The correct answer is always conditional on team size, service
count, and operational maturity.

## Mental Model

**Containers** are process-level isolation using Linux namespaces (PID,
network, mount, user) and cgroups (CPU, memory limits). Think of a
container as a process that believes it has its own filesystem,
network, and process tree — but shares the host kernel.

**Kubernetes** is a reconciliation loop: you declare desired state
(YAML), and controllers continuously push actual state toward it. The
cluster never "finishes" — it constantly reconciles.

```mermaid
flowchart LR
    User["Engineer"] -->|kubectl apply| API["API Server"]
    API -->|stores| ETCD["etcd\n(desired state)"]
    CTRL["Controller Manager"] -->|watches| API
    CTRL -->|creates/updates| API
    SCHED["Scheduler"] -->|assigns pods to nodes| API
    KUBELET["kubelet\n(per node)"] -->|watches| API
    KUBELET -->|runs containers| CRT["Container Runtime"]
    KUBELET -->|reports status| API
```

The key insight: Kubernetes is not imperative ("start this container
on this node"). It is declarative ("ensure 3 replicas of this
container are running"). The scheduler and controllers decide *how* to
achieve that. When a node dies, the reconciliation loop notices the
deviation and schedules replacements — no human intervention needed.

**Mental model for troubleshooting:** If something is wrong, ask: "Is
the desired state correct?" (check the YAML). "Is the controller
reconciling?" (check controller logs). "Is the kubelet executing?"
(check node status and pod events).

**Traffic flow: Pod → Service → Ingress:**

```mermaid
flowchart LR
    Internet -->|HTTPS| IC[Ingress Controller]
    IC -->|routes by host/path| SVC[Service\nClusterIP]
    SVC -->|load-balances| P1[Pod 1]
    SVC --> P2[Pod 2]
    SVC --> P3[Pod 3]
    P1 --> DB[(Database)]
    P2 --> DB
    P3 --> DB
```

External traffic enters through the Ingress controller (layer 7:
host-based and path-based routing, TLS termination). The controller
forwards to a Service (layer 4: stable virtual IP, label-selector-
based pod discovery). The Service distributes traffic across healthy
pods (only those passing readiness probes appear in endpoints).

## Core Terminology

| Term | Definition |
| --- | --- |
| **Image** | An immutable, layered filesystem snapshot packaged as an OCI artifact. Contains application code, dependencies, and runtime. |
| **Container** | A running instance of an image — an isolated process with its own filesystem view, network namespace, and resource constraints. |
| **Layer** | A single filesystem diff in an image. Layers are cached and shared between images. Each Dockerfile instruction creates a layer. |
| **OCI** | Open Container Initiative — the standard for container image format and runtime. Docker, containerd, and CRI-O all implement OCI. |
| **Pod** | The smallest deployable unit in Kubernetes. One or more containers sharing network namespace (same IP) and storage volumes. |
| **Deployment** | A controller that manages ReplicaSets, providing declarative updates, rollouts, and rollbacks for stateless workloads. |
| **ReplicaSet** | Ensures a specified number of pod replicas are running. Managed by Deployments — rarely created directly. |
| **Service** | A stable network endpoint (virtual IP) that load-balances traffic to a set of pods selected by labels. |
| **Ingress** | A layer-7 (HTTP) routing rule that maps external hostnames/paths to internal Services. Requires an Ingress controller. |
| **ConfigMap** | A key-value store for non-sensitive configuration, injected into pods as environment variables or mounted files. |
| **Secret** | Like ConfigMap but for sensitive data. Base64-encoded by default (not encrypted — encryption at rest requires additional configuration). |
| **Namespace** | A virtual partition within a cluster for resource isolation, RBAC boundaries, and resource quotas. |
| **HPA** | Horizontal Pod Autoscaler — adjusts replica count based on metrics (CPU, memory, custom metrics). |
| **PV / PVC** | Persistent Volume (cluster resource) and Persistent Volume Claim (pod's request for storage). Decouples storage provisioning from consumption. |
| **DaemonSet** | Ensures one pod per node (or subset). Used for node-level agents: log collectors, monitoring, CNI plugins. |
| **StatefulSet** | Like Deployment but with stable network identity and ordered, persistent storage. For databases and stateful workloads. |
| **Helm** | A package manager for Kubernetes. Charts are parameterized YAML templates. |
| **Kustomize** | A template-free YAML customization tool. Applies patches and overlays without Go templating. Built into kubectl. |

Distinguish closely related terms:

- **Container vs Pod**: A container is a single process. A pod is one
  or more containers sharing a network namespace. Most pods have one
  container, but sidecar patterns (logging, proxies) add more.
- **Deployment vs StatefulSet**: Deployments treat pods as
  interchangeable (stateless). StatefulSets give each pod a stable
  identity and ordered lifecycle (stateful).
- **Service vs Ingress**: A Service is layer-4 (TCP/UDP, internal
  routing). Ingress is layer-7 (HTTP path/host routing, TLS
  termination, external access).
- **ConfigMap vs Secret**: ConfigMaps for non-sensitive config.
  Secrets for sensitive data. Both are key-value stores, but Secrets
  have stricter RBAC defaults and can be encrypted at rest.
- **Requests vs Limits**: Requests are the guaranteed minimum (used
  for scheduling). Limits are the enforced maximum (OOM-killed if
  exceeded for memory, throttled for CPU).

## Theoretical Foundation

### Containers vs VMs

Virtual machines virtualize hardware — each VM runs a full OS kernel.
Containers virtualize the OS — they share the host kernel but isolate
the process view using Linux namespaces and cgroups.

| Property | VMs | Containers |
| --- | --- | --- |
| **Isolation** | Hardware-level (hypervisor) | Process-level (kernel namespaces) |
| **Startup time** | Seconds to minutes | Milliseconds to seconds |
| **Image size** | GBs (full OS) | MBs (application + dependencies) |
| **Density** | 10s per host | 100s per host |
| **Security boundary** | Strong (separate kernel) | Weaker (shared kernel) |
| **Use case** | Multi-tenant hosting, legacy apps | Microservices, CI/CD, dev/prod parity |

**Practical usage:** Containers dominate microservice deployments,
CI/CD pipelines (build agents run in containers for reproducibility),
and development environments (Docker Compose replicates production
topology locally). VMs remain for workloads requiring strong isolation
(multi-tenant hosting, running untrusted code) or legacy
applications that cannot be containerized.

**Common mistake:** Treating containers as VMs — running SSH daemons
inside containers, installing monitoring agents per container,
running multiple processes without a proper init system. Containers
are single-process by design. Use orchestration (Kubernetes,
Compose) for multi-process workflows, not multi-process containers.

**Security consideration:** The shared kernel is the primary attack
surface. A container escape (CVE in runc, kernel exploit) gives host
access. Mitigations: run as non-root, drop all Linux capabilities
(`--cap-drop=ALL`), use seccomp profiles, enable AppArmor/SELinux,
use gVisor or Kata Containers for untrusted workloads (adds a kernel
boundary without full VM overhead).

**Operational consideration:** Container density means one host
failure affects many services. Design for: node failure (replicas on
multiple hosts), resource contention (cgroups enforce limits), and
observability (containers are ephemeral — centralize logs, do not
rely on local files).

**Tech Lead decision:** When to use VMs over containers: running
untrusted customer code (sandboxing), compliance requirements
mandating hardware-level isolation, legacy Windows services, or
kernel-version-sensitive workloads. The decision is risk-based, not
technology-preference-based.

**Interview framing:** "Containers are not lightweight VMs — they are
isolated processes sharing the host kernel. The security boundary is
the kernel itself, which means defense in depth (non-root, seccomp,
read-only filesystem) is not optional, it is compensating for the
weaker isolation boundary compared to a hypervisor."

### Images, layers, and registries

An OCI image is a stack of read-only filesystem layers. Each
Dockerfile instruction (RUN, COPY, ADD) creates a new layer. Layers
are content-addressed (SHA256) and shared between images — if two
images share the same base layer, it is stored once.

**Layer caching:** Docker builds top-down. If a layer's input has not
changed, the cached layer is reused. This means: put things that
change rarely (base image, system packages) at the top of the
Dockerfile, and things that change frequently (application code) at
the bottom.

**Registries** store and distribute images. Docker Hub is public.
ECR, GCR, ACR, and GitHub Container Registry are private options.
Images are identified by `registry/repository:tag` or by digest
(`@sha256:...`). Tags are mutable (`:latest` can point to different
images over time). Digests are immutable.

**Common mistake:** Assuming layers are independent — they are
additive. A `RUN rm /app/secrets.json` does not remove the file from
the image; the file still exists in the previous layer. Secrets
written in any layer remain in the final image (inspect with
`docker history`). Use multi-stage builds or BuildKit secret mounts
to avoid embedding secrets.

**Security consideration:** Pull images only from trusted registries.
Enable Docker Content Trust (image signing) or use Cosign (Sigstore)
to verify image provenance. A compromised base image on Docker Hub
affects every image built on top of it. Pin by digest, not tag, for
reproducibility and supply-chain security.

**Operational consideration:** Large images slow CI (upload/download
time), increase registry storage cost, and slow pod startup in
Kubernetes (image pull time). Track image size as a metric. Alert when
images exceed a threshold (e.g., 500MB for a Node.js service suggests
missing multi-stage or oversized base).

**Production checklist:**
- [ ] Base images pinned by digest or exact semver tag.
- [ ] Private registry with access control (ECR, GCR, or self-hosted).
- [ ] Image scanning integrated in CI (block on critical CVEs).
- [ ] Retention policy on registry (delete untagged images after 30
      days).
- [ ] Layer caching in CI (BuildKit remote cache or registry-backed
      cache).

**Tech Lead decision:** Choose between Docker Hub (free, rate-limited),
cloud-provider registry (ECR/GCR — tight IAM integration, no rate
limits), and self-hosted (Harbor — full control, air-gapped
environments). Decision factors: compliance (data residency), cost
(ECR charges per GB), and integration (IRSA for EKS pull
authentication vs ImagePullSecrets).

**Interview framing:** "Images are layered, immutable, and
content-addressed. Layers are shared between images (storage and
transfer efficiency), but they are additive — anything written in a
layer persists even if deleted in a later layer. This is why
multi-stage builds exist: the final image only contains what is
explicitly copied from previous stages."

### Dockerfile patterns and multi-stage builds

```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS production
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY package*.json ./
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/main.js"]
```

**Multi-stage build:** The `build` stage has all dev dependencies and
build tools. The `production` stage copies only the built artifacts.
Result: smaller image, fewer vulnerabilities, no build tools in
production.

**Layer ordering for cache efficiency:**
1. `COPY package*.json` — changes only when dependencies change.
2. `RUN npm ci` — cached unless package.json changed.
3. `COPY . .` — changes on every code change, but previous layers
   are cached.

**Non-root execution:** `USER node` drops root privileges. If the
container is compromised, the attacker has limited filesystem access.
The `node` user exists in the Alpine Node.js image by default.

**HEALTHCHECK:** Tells the container runtime (and Docker Compose)
when the application is healthy. In Kubernetes, use liveness/readiness
probes instead (Kubernetes ignores Dockerfile HEALTHCHECK).

**Common mistake:** Using `npm install` instead of `npm ci` in Docker
builds. `npm install` can modify the lock file and produce
non-deterministic results. `npm ci` uses the lock file exactly,
failing if it is out of sync with `package.json` — this guarantees
reproducible builds. Another mistake: `RUN npm ci && npm run build`
in one layer (combining dependency install and build) — this
invalidates the dependency cache on every code change.

**Security consideration:** Every instruction in a Dockerfile runs as
root by default during build. `USER node` must come after all
filesystem operations (COPY, RUN) that require root. BuildKit secret
mounts (`RUN --mount=type=secret,id=npm_token ...`) allow using
private registry credentials during build without embedding them in
any layer.

**Operational consideration:** Multi-stage builds produce smaller
images (100-200MB vs 1-2GB) that pull faster, start faster, and
consume less registry storage. In CI, use `--target=build` to run
tests in the build stage without producing the final image.
BuildKit's `--cache-from` and `--cache-to` enable cross-CI-run
caching (critical for mono-repo builds).

**Production checklist:**
- [ ] Multi-stage build separates build tools from production
      artifact.
- [ ] `npm ci` (or equivalent deterministic install) used in all
      builds.
- [ ] `USER nonroot` or `USER node` specified before CMD.
- [ ] `HEALTHCHECK` defined (for Compose) or probes configured (for
      K8s).
- [ ] No secrets in any layer (use BuildKit `--mount=type=secret`).
- [ ] `.dockerignore` excludes node_modules, .git, .env, test files.
- [ ] Base image pinned by specific version tag or digest.

**Tech Lead decision:** Standard Dockerfile vs Buildpacks vs Nixpacks.
Dockerfiles give full control but require maintenance. Buildpacks
(Paketo, Google) auto-detect language and produce images without a
Dockerfile — less control but zero maintenance. Decision: use
Dockerfiles for services that need custom build steps or specific
runtime tuning; use Buildpacks for simple services where image
hygiene is handled by the platform team.

**Interview framing:** "Multi-stage builds are non-negotiable for
production. They separate the build environment (compilers, dev
dependencies, source code) from the production artifact (just the
compiled output and runtime dependencies). The result is 5-10× smaller
images with dramatically fewer CVEs, because every package not in the
image is a package that cannot be exploited."

### Build context and .dockerignore

The build context is everything sent to the Docker daemon when running
`docker build`. A missing or incomplete `.dockerignore` sends
`node_modules`, `.git`, test fixtures, and secrets to the daemon —
slowing builds and risking secret leakage into image layers.

```text
# .dockerignore
node_modules
.git
.env
.env.*
*.log
dist
coverage
.nyc_output
**/*.test.ts
**/*.spec.ts
docker-compose*.yml
```

**Common mistake:** Not having a `.dockerignore` at all. A typical
Node.js project with `node_modules` sends 500MB+ to the daemon on
every build — even though `npm ci` reinstalls everything inside the
container. Another mistake: including `.env` files in the build
context (secrets end up in image layers via `COPY . .`).

**Security consideration:** Build context can leak secrets into
images. If `.env`, private keys, or credentials are in the build
directory and `.dockerignore` does not exclude them, `COPY . .`
embeds them in a layer. Even if deleted in a subsequent `RUN`, they
remain in the image history. Use `docker history --no-trunc` to audit.

**Operational consideration:** Build context size directly affects CI
build time (network transfer to daemon). For monorepos, use
BuildKit's `--file` flag to specify the Dockerfile while keeping the
context minimal, or use `.dockerignore` per service subdirectory.

**Interview framing:** "The build context is the attack surface of
your build process. Everything not excluded by `.dockerignore` is
sent to the daemon and potentially embedded in layers. I treat
`.dockerignore` as a security control, not a convenience — it must
exclude secrets, test files, and local artifacts."

### Docker volumes and storage

Containers have ephemeral filesystems — data written inside a
container is lost when the container stops. Volumes persist data
outside the container lifecycle.

| Volume type | Use case | Lifecycle |
| --- | --- | --- |
| **Named volume** | Database storage, persistent state | Survives container removal |
| **Bind mount** | Development (mount source code) | Tied to host filesystem |
| **tmpfs** | Sensitive data that must not touch disk | In-memory, lost on stop |

**Common mistake:** Using bind mounts for production databases. Bind
mounts depend on the host filesystem path existing — fragile across
hosts and incompatible with orchestration. Use named volumes for
persistent data. Another mistake: assuming data in the container
filesystem survives restarts (it does not — any file not on a volume
is lost when the container is recreated).

**Security consideration:** Bind mounts can expose the host
filesystem to the container. A bind mount of `/` gives the container
full host access. In production, use named volumes with specific
paths. For sensitive data that should never touch disk (tokens,
ephemeral keys), use `tmpfs` mounts.

**Operational consideration:** Named volumes are not automatically
backed up. Include volume backup in the disaster recovery plan
(scheduled `docker run --volumes-from` with tar, or use volume
plugins that support snapshots). In Kubernetes, volumes map to
PersistentVolumeClaims — the storage lifecycle is managed by the
cluster.

**Tech Lead decision:** Bind mounts are acceptable for development
(hot-reload source code). Named volumes for any persistent data
(databases, file uploads). tmpfs for secrets that must not persist
to disk. In production Kubernetes, all persistent state should use
PVCs with appropriate StorageClasses and backup policies.

**Interview framing:** "Containers are ephemeral by design — anything
written to the container filesystem is lost on restart. Volumes
decouple data lifecycle from container lifecycle. The choice between
named volumes, bind mounts, and tmpfs depends on persistence
requirements and security sensitivity of the data."

### Docker networking

| Network mode | Behavior | Use case |
| --- | --- | --- |
| **bridge** (default) | Containers on same bridge can communicate. Isolated from host. | Single-host development |
| **host** | Container shares host network namespace. No port mapping needed. | Performance-critical, no isolation |
| **overlay** | Multi-host networking (Docker Swarm). | Rarely used with Kubernetes |
| **none** | No networking. | Batch jobs, security-critical |

**Practical usage:** In Docker Compose, services on the same network
resolve each other by service name (built-in DNS). The `api` service
reaches the database at `db:5432`. No IP addresses needed. Custom
networks isolate groups of services — a `frontend` network and a
`backend` network prevent the frontend from directly accessing the
database.

**Common mistake:** Exposing ports unnecessarily. `ports: "5432:5432"`
publishes the database to the host network (accessible from outside).
For inter-container communication, containers on the same Docker
network can reach each other without port mapping. Only expose ports
needed for external access.

**Security consideration:** The default bridge network allows all
containers to communicate. Create custom networks to isolate services.
Never use `--network=host` in production unless performance demands it
(eliminates network namespace isolation entirely). In Kubernetes,
NetworkPolicies replace Docker network isolation.

**Operational consideration:** DNS resolution in Docker networks can
cause brief failures during container restarts (stale DNS cache). Use
healthchecks and retry logic in application code. In production
Kubernetes, Services provide stable DNS regardless of pod lifecycle.

**Network isolation pattern:**

```yaml
# docker-compose.yml with network segmentation
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge

services:
  nginx:
    image: nginx:alpine
    ports:
      - "443:443"
    networks:
      - frontend

  api:
    build: .
    networks:
      - frontend   # nginx can reach api
      - backend    # api can reach db
    volumes:
      - uploads:/app/uploads   # named volume for persistence

  db:
    image: postgres:16-alpine
    networks:
      - backend    # only api can reach db, not nginx
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:          # database storage survives container recreation
  uploads:         # user uploads persist across deploys
```

**What this does:** Network segmentation: nginx (reverse proxy) is
on the `frontend` network only. The database is on the `backend`
network only. The API bridges both. Nginx cannot directly reach the
database — it must go through the API. Named volumes persist data
outside container lifecycle.

**Why it is useful:** Models production network topology locally.
Frontend services cannot bypass the API to reach the database —
this mirrors Kubernetes NetworkPolicies. Named volumes ensure data
survives `docker compose down && docker compose up`.

**Common mistake:** Using a single flat network for everything (all
services can reach all other services). Using bind mounts for
database data (breaks across hosts, depends on absolute paths).

**Interview framing:** "Docker networking uses Linux network
namespaces. The default bridge gives all containers connectivity, but
custom networks provide isolation. The key pattern: containers
communicate by service name (DNS), not IP. In Kubernetes, this
concept evolves into Services — stable DNS names over ephemeral pod
IPs."

### Docker Compose

Docker Compose defines multi-container applications in a single YAML
file. It is a development and testing tool — not a production
orchestrator.

```yaml
services:
  api:
    build:
      context: .
      target: production
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://user:pass@db:5432/app
      REDIS_URL: redis://cache:6379
      NODE_ENV: production
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3000/health"]
      interval: 10s
      timeout: 3s
      retries: 3
    networks:
      - backend

  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: app
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 5
    networks:
      - backend

  cache:
    image: redis:7-alpine
    command: redis-server --maxmemory 128mb --maxmemory-policy allkeys-lru
    volumes:
      - redisdata:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 3
    networks:
      - backend

volumes:
  pgdata:
  redisdata:

networks:
  backend:
    driver: bridge
```

**What this does:** A complete local development stack: Node.js API,
PostgreSQL database, and Redis cache, connected via an explicit
backend network. Every service has a healthcheck. The API starts only
after both dependencies are healthy.

**Why it is useful:** Replicates production topology locally. New
developers run `docker compose up` and have a working environment
without installing PostgreSQL or Redis on their machine.

**Common mistake:** Omitting the explicit network — all services land
on the default bridge and can communicate freely. With explicit
networks, you can isolate frontend from database (frontend only
reaches API, not directly to PostgreSQL).

**How this changes in production:** Production does not use Docker
Compose. PostgreSQL becomes RDS/Cloud SQL, Redis becomes
ElastiCache/Memorystore, and the API runs on Kubernetes. The Compose
file is for local development and CI integration tests only.

**Tech Lead check:** Ensure no real secrets are committed (use
`.env` with gitignored values), healthchecks match production probe
logic, and the `build.target` references the correct multi-stage
stage.

**Common mistake:** Using `depends_on` without `condition:
service_healthy`. Without the health condition, Compose only waits for
the container to *start* — not for the application inside to be ready.
The database container starts in 100ms but PostgreSQL takes 2-5
seconds to accept connections. Result: the API fails on startup
because the database is not ready.

**Security consideration:** Compose files often contain hardcoded
passwords in `environment` blocks (acceptable for local development).
Never commit production Compose files with real secrets. Use `.env`
files (gitignored) or Docker secrets for sensitive values. In CI, use
Compose for integration tests but inject secrets from CI variables.

**Operational consideration:** Compose V2 (the `docker compose`
plugin) replaced the standalone `docker-compose` binary. Use
`docker compose up -d --wait` to start services and block until all
healthchecks pass — essential for CI integration tests. Use `profiles`
to define optional services (e.g., a debug container only started when
explicitly requested).

**Production checklist:**
- [ ] Healthchecks defined for every service.
- [ ] `depends_on` uses `condition: service_healthy` (not bare).
- [ ] Named volumes for all persistent data.
- [ ] No real secrets in committed Compose files.
- [ ] `.env` file gitignored; `.env.example` committed as template.
- [ ] `docker compose down -v` documented for clean teardown.

**Tech Lead decision:** Compose is for local development and CI
integration tests — not production orchestration. If a team uses
Compose in production (common for small self-hosted services), they
must add restart policies (`restart: unless-stopped`), resource
limits, and a health monitoring solution. For production container
orchestration, use Kubernetes, ECS, or Cloud Run.

**Interview framing:** "Docker Compose is a development-time
orchestrator that defines multi-container applications declaratively.
It solves the 'works on my machine' problem by encoding the entire
service topology (databases, caches, queues) in a single file. The
key production gap: Compose has no built-in scaling, load balancing,
or self-healing — that is what Kubernetes provides."

### Image tagging strategy

| Strategy | Example | Trade-off |
| --- | --- | --- |
| **Semantic version** | `api:1.4.2` | Clear versioning, rollback to exact version |
| **Git SHA** | `api:a1b2c3d` | Traces image to exact commit, immutable |
| **Branch + SHA** | `api:main-a1b2c3d` | Shows branch context |
| **latest** | `api:latest` | Convenient for dev, dangerous for production (mutable) |

**Production rule:** Never deploy `:latest` to production. Use
immutable tags (semver or git SHA) that map to a specific build.
Tag at build time in CI, push to registry, reference the exact tag
in deployment manifests.

**Common mistake:** Using mutable tags (`:latest`, `:stable`) in
Kubernetes Deployments. With `imagePullPolicy: IfNotPresent`
(default for non-latest tags), different nodes may run different
versions of the "same" tag. With `:latest`, Kubernetes always pulls
(adds latency and registry dependency to every pod startup). Use
immutable tags + `imagePullPolicy: IfNotPresent` for fast,
deterministic deploys.

**Security consideration:** Tags can be overwritten. An attacker
with registry write access can replace `api:1.4.2` with a
malicious image. Mitigation: use image signing (Cosign/Notary) and
admission controllers (Kyverno, OPA) that reject unsigned or
unsigned images. For maximum security, reference images by digest
(`api@sha256:abc123...`).

**Operational consideration:** Maintain a retention policy — old
tags accumulate in registries and cost storage. Keep the last 30
tags per repository (or 90 days). Use lifecycle policies (ECR
lifecycle rules, GCR retention policies) to automate cleanup.
Always keep tags referenced by active deployments.

**Tech Lead decision:** Choose between semver (better for humans,
clearer release history) and git SHA (better for traceability,
impossible to confuse). Many teams use both: semver for release
tags, git SHA for CI builds. Decision: if the team has formal
releases (mobile, on-prem), use semver. If continuous deployment,
git SHA is simpler and equally traceable.

**Interview framing:** "Image tags are pointers — they are mutable
unless you treat them as immutable by convention. The `:latest` tag
is an anti-pattern in production because it defeats rollback,
traceability, and reproducibility. I tag with git SHA in CI (ties
image to exact commit) and enforce immutable tags in deployment
manifests via admission policies."

### Docker security best practices

**Non-root containers:**

```dockerfile
FROM node:20-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --chown=app:app . .
USER app
CMD ["node", "server.js"]
```

Running as root inside a container means: if an attacker achieves
remote code execution, they have root access to the container
filesystem and any mounted volumes. With non-root, the attacker
cannot write to most paths, cannot bind to privileged ports (<1024),
and cannot install tools.

**Read-only filesystem:** Run containers with `--read-only` (Docker)
or `readOnlyRootFilesystem: true` (Kubernetes pod security context).
Applications that need write access use specific volume mounts
(`/tmp`, `/var/log`) while the rest of the filesystem is immutable.
This prevents attackers from dropping tools, modifying binaries, or
creating reverse shells.

**No privileged mode:** `--privileged` gives full host access (all
capabilities, all devices, no seccomp). Never use in production.
Legitimate use cases (building Docker images inside containers) have
safer alternatives: kaniko (builds without Docker daemon), BuildKit
rootless mode, or dedicated build nodes.

**Image scanning:**

```yaml
# CI step: scan before push
- name: Scan image
  uses: aquasecurity/trivy-action@0.28.0
  with:
    image-ref: ${{ env.IMAGE_TAG }}
    severity: HIGH,CRITICAL
    exit-code: 1
    ignore-unfixed: true
```

Scan at three points: (1) CI build (fail on critical CVEs), (2)
registry (periodic re-scan for newly published CVEs), (3) runtime
(detect vulnerable images already deployed). Tools: Trivy (open
source, fast), Grype (open source), Snyk Container (commercial with
fix suggestions).

**Minimal base images:**

| Base image | Size | CVEs (typical) | Use case |
| --- | --- | --- | --- |
| `node:20` | ~1GB | 100-300 | Development only |
| `node:20-alpine` | ~180MB | 10-30 | General production |
| `gcr.io/distroless/nodejs20` | ~130MB | 5-15 | Hardened production |
| `scratch` | 0 bytes | 0 | Static binaries (Go) |

Distroless images have no shell, no package manager, and no
unnecessary binaries. An attacker who achieves RCE cannot easily
execute commands because there is no shell to invoke.

**Secret management in builds:**

```dockerfile
# BAD: secret visible in image history
ARG NPM_TOKEN
RUN echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > .npmrc
RUN npm ci
RUN rm .npmrc   # still in previous layer!

# GOOD: BuildKit secret mount (never persisted)
RUN --mount=type=secret,id=npm_token \
    NPM_TOKEN=$(cat /run/secrets/npm_token) \
    npm ci --registry https://registry.npmjs.org
```

Build with: `docker build --secret id=npm_token,src=.npmrc .`

The secret is available only during that `RUN` instruction and never
written to any image layer.

**Pin base images:** Tags like `node:20-alpine` can point to
different images over time (security patches, minor updates). Pin by
digest for reproducibility:
`node:20-alpine@sha256:1a2b3c...`. Update digests intentionally
(Renovate/Dependabot can automate this).

**Common mistake:** Relying on image scanning alone. Scanning catches
known CVEs but not: misconfigurations (running as root, writable
filesystem), hardcoded secrets in layers, or zero-day
vulnerabilities. Defense in depth: scanning + non-root + read-only
filesystem + minimal base + seccomp + network isolation.

**Operational consideration:** Image scanning generates noise.
Without severity filtering and ignore files for accepted risks,
teams suffer alert fatigue and start ignoring results. Configure:
fail on CRITICAL/HIGH, report MEDIUM as informational, suppress
known false positives with `.trivyignore` or equivalent.

**Production checklist:**
- [ ] All production images run as non-root (`USER` in Dockerfile +
      `runAsNonRoot: true` in K8s).
- [ ] Read-only root filesystem enabled (with explicit writable
      mounts where needed).
- [ ] No `--privileged` in any production workload.
- [ ] Image scanning in CI with fail-on-critical policy.
- [ ] Base images pinned and updated via automated dependency bot.
- [ ] Secrets never in build args or COPY instructions (use BuildKit
      secret mounts).
- [ ] Container capabilities dropped (`--cap-drop=ALL`, add back only
      needed ones).
- [ ] Seccomp profile applied (default Docker seccomp blocks ~44
      dangerous syscalls).

**Tech Lead decision:** Balance security hardening against developer
experience. Distroless images prevent `kubectl exec` debugging (no
shell). Solution: use debug images in non-production
(`gcr.io/distroless/nodejs20:debug` adds a shell) or Kubernetes
ephemeral debug containers (`kubectl debug`). Do not weaken
production security for debugging convenience.

**Interview framing:** "Docker security is defense in depth: minimal
base images (small attack surface), non-root execution (limited
blast radius), read-only filesystem (prevents persistence), dropped
capabilities (blocks privilege escalation), and image scanning
(detects known vulnerabilities). No single control is sufficient —
they are layers that compensate for each other's gaps. See
[Security](./15-security.md) for the broader application security
strategy."

### Environment variables and configuration

Environment variables are the primary mechanism for runtime
configuration in containers (12-factor app principle):

```dockerfile
# Dockerfile: define defaults
ENV NODE_ENV=production
ENV PORT=3000

# docker-compose.yml: override per environment
environment:
  DATABASE_URL: postgres://user:pass@db:5432/app
  LOG_LEVEL: info
  FEATURE_NEW_CHECKOUT: "true"
```

**Practical usage:** Use environment variables for: connection strings,
feature flags, log levels, service URLs, and non-sensitive
configuration. In Kubernetes, use ConfigMaps for env vars (change
without image rebuild) and Secrets for sensitive values.

**Common mistake:** Using environment variables for secrets in Docker
Compose and committing the file to Git. Another mistake: relying on
`ENV` in Dockerfile for runtime config — `ENV` is baked into the
image and cannot change per deployment. Use `ENV` for static defaults
only; pass runtime configuration via `-e` flags or ConfigMaps.

**Security consideration:** Environment variables are visible via
`docker inspect`, `/proc/1/environ` inside the container, and
Kubernetes `kubectl describe pod`. For true secrets, use Docker
secrets (Swarm), Kubernetes Secrets, or external secret managers.
Never pass database passwords, API keys, or tokens as plain
environment variables in CI logs or Compose files committed to Git.

**Operational consideration:** Environment variable explosion is a
common pain point (30+ variables per service). Use structured
configuration files (mounted via ConfigMap or volume) for complex
config. Reserve environment variables for values that truly differ
between environments (URLs, credentials, feature flags).

**Tech Lead decision:** Standardize configuration approach across
services: which config goes in env vars vs files vs remote config
service (Consul, Parameter Store). Document the hierarchy (defaults
in code → env vars → config files → remote config) so developers
know where to look.

**Interview framing:** "Environment variables implement the 12-factor
app config principle: strict separation of config from code. They
enable the same image to run in dev, staging, and production with
different behavior. The key constraint: env vars are not secure for
secrets (they are visible in process listings and inspect output) —
use dedicated secret stores."

### Docker secrets and sensitive data

Docker provides secrets management for Swarm mode (`docker secret`),
but in most production environments, Kubernetes Secrets or external
managers (Vault, AWS Secrets Manager) replace this:

```yaml
# docker-compose.yml with secrets (Swarm or Compose v3.1+)
services:
  api:
    image: api:1.4.2
    secrets:
      - db_password
      - jwt_key

secrets:
  db_password:
    file: ./secrets/db_password.txt
  jwt_key:
    external: true   # managed outside Compose
```

Secrets are mounted as files at `/run/secrets/<name>` inside the
container — not as environment variables. The application reads the
file at startup.

**Common mistake:** Passing secrets as environment variables in Docker
Compose (`environment: DB_PASSWORD=hunter2`). These are visible in
`docker inspect`, in the container's process environment, and often
logged by frameworks that dump env on startup. File-based secrets
(mounted at `/run/secrets/`) are more controlled.

**Security consideration:** Docker Compose file-based secrets are not
encrypted — they are plain files on disk. In production, use:
Kubernetes Secrets with encryption at rest, or External Secrets
Operator syncing from Vault/AWS Secrets Manager. Never commit secret
files to Git. Use `.gitignore` and secret scanning (GitLeaks,
GitHub secret scanning) as safety nets.

**Operational consideration:** Secret rotation requires restarting
containers (they read the secret at startup). Design applications
to re-read secrets periodically or respond to file change signals.
In Kubernetes, mounted Secrets update in-place (kubelet syncs within
~60 seconds) — applications that watch the file get rotation without
restart.

**Tech Lead decision:** For local development: use `.env` files
(gitignored) with dummy values. For CI: use CI platform secrets
(GitHub Actions secrets, GitLab CI variables). For production: use a
dedicated secret manager with audit logging and rotation. Standardize
the approach so all services handle secrets the same way.

**Interview framing:** "Secrets must never be in environment
variables in production (visible via inspect and process listing),
never in image layers (persistent in history), and never in Git
(persistent in history forever). The pattern is: external secret
manager → injected at runtime as a mounted file → application reads
on startup. This gives rotation, audit, and access control."

### Container healthchecks

Healthchecks tell the runtime whether the application inside the
container is functioning:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1
```

```yaml
# docker-compose.yml healthcheck
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
  interval: 10s
  timeout: 3s
  start-period: 15s
  retries: 3
```

**Practical usage:** In Docker Compose, healthchecks enable
`depends_on: condition: service_healthy` (start order based on actual
readiness). In Docker standalone, healthchecks update the container
status (`healthy`/`unhealthy`). In Kubernetes, HEALTHCHECK is ignored
— use liveness/readiness/startup probes instead.

**Common mistake:** Health endpoint that checks external dependencies
(database, cache). If the database is down and the healthcheck fails,
Docker restarts the container, which tries to connect to the still-down
database — restart loop. Health endpoints should check: "is this
process alive and responding?" External dependency checks belong in
readiness logic (Kubernetes readiness probe).

**Security consideration:** Health endpoints should not expose
internal state (memory usage, connection counts, error details) to
unauthenticated callers. In production, bind the health endpoint to
localhost only (not exposed via Ingress) or require authentication
for detailed status endpoints. The basic `/health` returns 200 OK
with no body.

**Operational consideration:** Set `start-period` to accommodate
application startup time (database migrations, cache warming). Without
it, slow-starting applications are killed before they finish
initializing. Monitor health status in alerting — a container stuck
in `unhealthy` without restarting indicates a configuration issue.

**Production checklist:**
- [ ] Every service has a health endpoint (`/health` or `/healthz`).
- [ ] Health endpoint checks internal state only (not external deps).
- [ ] `start-period` accommodates worst-case startup time.
- [ ] In Kubernetes: separate liveness, readiness, and startup probes
      (not a single health endpoint for all three).

**Interview framing:** "Healthchecks are how the runtime distinguishes
'the container process is running' from 'the application is
functioning.' A container can have PID 1 alive but be deadlocked,
out of memory, or unable to serve requests. The healthcheck tells the
orchestrator whether to send traffic (readiness) or restart
(liveness)."

### Container logs

Containers log to stdout/stderr by default. The container runtime
captures these streams and stores them (Docker: json-file driver,
Kubernetes: node filesystem at `/var/log/containers/`):

```ts
// Application: log to stdout (structured JSON)
const logger = pino({ level: process.env.LOG_LEVEL || "info" });
logger.info({ requestId, method, path, statusCode, duration }, "request completed");
```

**Practical usage:** The logging pipeline is: application → stdout →
container runtime captures → log collector (Fluent Bit, Fluentd)
ships → centralized store (Elasticsearch, Loki, CloudWatch). The
application should never write to files inside the container (they
are lost on restart and not collected by the pipeline).

**Common mistake:** Writing logs to files inside the container (`/app/
logs/app.log`). These files: (1) are lost when the container restarts,
(2) consume container disk (causing eviction if using ephemeral
storage limits), (3) are not collected by the standard logging
pipeline. Always log to stdout/stderr and let the infrastructure
handle collection and shipping.

**Security consideration:** Logs must not contain secrets (passwords,
tokens, API keys, PII). Use structured logging with explicit field
selection — never log full request/response bodies. In production,
add log-level filtering (no DEBUG in production) and PII detection
in the log pipeline. See [Security](./15-security.md) for audit
logging patterns.

**Operational consideration:** Docker's default json-file log driver
grows unbounded. Set `max-size` and `max-file` in daemon.json or
per-container:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m",
    "max-file": "3"
  }
}
```

Without this, a verbose container fills the disk and crashes the host.
In Kubernetes, kubelet handles log rotation, but ephemeral storage
limits (`ephemeral-storage` in resource limits) prevent log-induced
evictions.

**Tech Lead decision:** Standardize log format across services
(structured JSON with consistent fields: timestamp, level, service,
requestId, message). This enables cross-service correlation in the
centralized log store. Enforce via shared logging library — do not
allow each team to invent their own format.

**Interview framing:** "Containers log to stdout/stderr — this is the
12-factor app logging principle. The application is not responsible
for log routing, storage, or rotation. It writes structured events to
stdout, and the infrastructure (Docker log driver, Fluent Bit,
centralized store) handles the rest. This decouples the application
from the logging infrastructure."

### Kubernetes architecture (cluster and nodes)

The control plane manages cluster state:

- **API Server (kube-apiserver):** The front door. All communication
  (kubectl, controllers, kubelet) goes through it. RESTful, validates
  and persists to etcd.
- **etcd:** Distributed key-value store holding all cluster state.
  The source of truth. Losing etcd means losing the cluster.
- **Scheduler (kube-scheduler):** Assigns unscheduled pods to nodes
  based on resource requests, affinity, taints, and topology.
- **Controller Manager:** Runs controllers (Deployment, ReplicaSet,
  Node, Job controllers). Each controller watches desired state and
  reconciles actual state.

The data plane runs workloads:

- **kubelet:** Agent on each node. Watches for pod assignments,
  pulls images, starts containers, reports status.
- **kube-proxy:** Manages network rules (iptables/IPVS) for Service
  routing on each node.
- **Container Runtime:** containerd or CRI-O (Docker is no longer
  the default runtime since Kubernetes 1.24).

**Practical usage:** A cluster is the complete Kubernetes environment
(control plane + worker nodes). A node is a machine (VM or bare-metal)
that runs pods. In managed Kubernetes (EKS, GKE, AKS), the cloud
provider operates the control plane; the user manages node groups.
Node pools allow heterogeneous hardware (CPU-optimized, memory-
optimized, GPU) in the same cluster.

**Common mistake:** Treating the control plane as infinitely available.
etcd has write throughput limits (~10K writes/sec). A poorly written
controller that watches all resources or creates thousands of objects
can overwhelm the API server. Another mistake: running workloads on
control plane nodes in self-managed clusters (starving etcd of
resources during load spikes).

**Security consideration:** The API server is the attack surface of
the cluster. Restrict access: private API endpoint (no public
internet), OIDC authentication (no client certificates for humans),
audit logging enabled, and admission controllers enforcing policies.
Node security: keep OS patched, enable containerd AppArmor, use
managed node groups that handle OS updates automatically.

**Operational consideration:** Monitor node health: `NotReady` status
means kubelet has lost contact with the API server (network issue,
kubelet crash, node overload). Set up alerting on node conditions.
Cluster autoscaler adds/removes nodes based on scheduling pressure
— but it cannot scale below `minReplicas` of node groups.

**Production checklist:**
- [ ] Control plane HA (3+ etcd replicas for self-managed; managed
      services provide this by default).
- [ ] etcd backup runs hourly to external storage (S3, GCS).
- [ ] Node auto-scaling configured (Cluster Autoscaler or Karpenter).
- [ ] Node health monitoring with alerting on NotReady status.
- [ ] API server audit logging enabled and shipped to SIEM.
- [ ] Private API endpoint (no public access in production).

**Tech Lead decision:** Managed vs self-managed control plane.
Managed (EKS, GKE, AKS) eliminates etcd operations, HA setup, and
upgrade coordination for the control plane — choose this unless
specific compliance or customization requirements mandate
self-management. Node pool strategy: separate pools for stateless
workloads (spot-friendly), stateful workloads (on-demand, specific
AZ), and system components (monitoring, ingress controllers).

**Interview framing:** "A Kubernetes cluster is a control plane (API
server, etcd, scheduler, controller manager) plus worker nodes. The
control plane stores desired state and runs reconciliation loops. The
nodes run kubelet, which watches for pod assignments and manages the
container runtime. The key insight: the cluster is not static — it
continuously reconciles. If a node fails, the controller detects
missing pods and the scheduler places replacements on healthy nodes."

### Pods

A pod is the atomic scheduling unit. One or more containers share:
- Network namespace (same IP, communicate via localhost).
- Storage volumes (shared filesystem paths).
- Lifecycle (all containers in a pod start and stop together).

**Why pods, not containers?** The sidecar pattern: a main application
container plus helper containers (logging agent, proxy, config
reloader) that need to share network and filesystem.

Pod lifecycle: `Pending` → `Running` → `Succeeded`/`Failed`. Pods
are ephemeral — they are not rescheduled. Controllers (Deployments)
manage pod recreation.

**Practical usage:** Most production pods contain one application
container. Multi-container pods for: sidecar proxies (Envoy in
service mesh), log forwarders (Fluent Bit sidecar), config reloaders
(watches ConfigMap changes), and init containers (database migrations,
dependency checks before the main container starts).

**Common mistake:** Creating bare pods (without a controller). Bare
pods are not rescheduled if the node fails — they just die. Always
use a Deployment, Job, or DaemonSet. Another mistake: putting
tightly coupled services in the same pod ("they need to communicate").
Services communicate via Kubernetes Services (network) — co-locating
them in one pod makes them scale, deploy, and fail together.

**Security consideration:** Pod security context controls: `runAsNonRoot`,
`runAsUser`, `fsGroup`, `readOnlyRootFilesystem`,
`allowPrivilegeEscalation: false`, and capabilities drop. Apply at
pod level (affects all containers). Use Pod Security Standards
(restricted profile) enforced via admission controller to reject pods
that violate baseline security.

**Operational consideration:** Pod termination follows a sequence:
(1) pod marked for deletion, (2) endpoints removed (traffic stops),
(3) `preStop` hook runs, (4) SIGTERM sent to containers, (5) grace
period countdown, (6) SIGKILL. If the application does not handle
SIGTERM, requests in flight are dropped. Ensure graceful shutdown
handling in every service.

**Tech Lead decision:** Pod topology: when to use sidecars vs
separate services. Sidecars share the pod's lifecycle and network
(good for proxies, log agents). Separate services scale
independently (good for distinct business logic). The sidecar
pattern adds complexity (shared resource limits, coupled restarts)
— use it when network locality or filesystem sharing is genuinely
required.

**Interview framing:** "A pod is not a container — it is a group of
containers sharing network and storage. The key architectural insight
is the sidecar pattern: a main application with helper containers
that augment it (proxy, logging, config reload). Pods are ephemeral
and never rescheduled — controllers create new pods when old ones
die. This is why you never create bare pods in production."

### Deployments and ReplicaSets

A Deployment manages ReplicaSets which manage Pods:

```text
Deployment
  └── ReplicaSet (current)
       ├── Pod 1
       ├── Pod 2
       └── Pod 3
  └── ReplicaSet (previous, scaled to 0)
```

Deployments provide:
- **Declarative updates:** Change the pod template → new ReplicaSet
  is created → pods are rolled out gradually.
- **Rollback:** `kubectl rollout undo` reverts to the previous
  ReplicaSet.
- **Scaling:** Change `replicas` field → ReplicaSet adjusts pod count.

**Practical usage:** Deployments are the standard workload object for
stateless services (APIs, web servers, background workers). Never
create ReplicaSets directly — Deployments manage them and add rollout
and rollback capabilities on top. Use `revisionHistoryLimit: 5-10` to
control how many old ReplicaSets are retained (each consumes etcd
storage).

**Common mistake:** Editing a live pod directly (`kubectl edit pod`)
instead of updating the Deployment. Direct edits are overwritten on
the next reconciliation. Another mistake: not setting
`revisionHistoryLimit`, causing unlimited old ReplicaSets to
accumulate (etcd bloat and confusing `kubectl get rs` output).

**Security consideration:** Use `spec.template.spec.serviceAccountName`
to assign a dedicated ServiceAccount per Deployment (not the default
ServiceAccount). Set `automountServiceAccountToken: false` unless the
pod actually needs to call the Kubernetes API. This limits blast
radius if a pod is compromised.

**Operational consideration:** Monitor rollout status:
`kubectl rollout status deployment/api` blocks until complete or
failed. In CI/CD, fail the pipeline if the rollout does not complete
within a timeout (indicates crash loop or readiness failure). Set
`progressDeadlineSeconds` (default 600s) — Kubernetes marks the
Deployment as failed if progress stalls beyond this.

**Production checklist:**
- [ ] Every stateless workload uses a Deployment (not bare pods or
      ReplicaSets).
- [ ] `revisionHistoryLimit` set explicitly (5-10 revisions).
- [ ] `progressDeadlineSeconds` configured for CI/CD rollout timeout.
- [ ] Dedicated ServiceAccount per Deployment with minimal RBAC.
- [ ] Labels include `app`, `version`, and `team` for observability
      and cost attribution.

**Tech Lead decision:** Deployment vs StatefulSet vs DaemonSet:
Deployments for stateless workloads (the default). StatefulSets for
workloads needing stable identity and persistent storage (databases,
message brokers). DaemonSets for node-level agents (monitoring, log
collection). If a service needs persistent storage but not stable
identity, a Deployment with PVC is often simpler than a StatefulSet.

**Interview framing:** "A Deployment is a declarative controller that
manages ReplicaSets which manage Pods. The three-layer hierarchy
enables rolling updates: the Deployment creates a new ReplicaSet with
the updated pod template, scales it up gradually, and scales the old
one down. Rollback is instant — just point back to the previous
ReplicaSet. This gives zero-downtime deployments with automated
rollback capability."

### Services

A Service provides a stable IP (ClusterIP) and DNS name for a set
of pods selected by labels. Pods are ephemeral — their IPs change.
Services abstract this away.

| Type | Accessibility | Use case |
| --- | --- | --- |
| **ClusterIP** | Internal only | Service-to-service communication |
| **NodePort** | External via node IP:port | Testing, non-cloud environments |
| **LoadBalancer** | External via cloud LB | Production external traffic |
| **ExternalName** | DNS CNAME to external service | Bridging to external systems |

**How it works:** kube-proxy programs iptables/IPVS rules on each
node. Traffic to the Service ClusterIP is load-balanced across
healthy pod endpoints. Endpoints are automatically updated when pods
start/stop.

**Practical usage:** Every microservice gets a ClusterIP Service for
internal communication. DNS resolution: `<service>.<namespace>.svc.
cluster.local`. LoadBalancer Services for external traffic (each
creates a cloud LB — cost consideration). Headless Services
(`clusterIP: None`) expose individual pod IPs — used by StatefulSets
for direct pod addressing.

**Common mistake:** Creating a LoadBalancer Service per service
(expensive — each provisions a cloud LB at $15-25/month). Use one
Ingress controller with a single LoadBalancer, routing to multiple
services by hostname/path. Another mistake: relying on Service DNS
resolution without readiness probes — endpoints include unready pods
if no readiness probe is configured, causing failed requests.

**Security consideration:** By default, any pod in the cluster can
reach any Service. Use NetworkPolicies to restrict which pods can
access which Services. For sensitive services (databases, internal
APIs), create NetworkPolicies that allow traffic only from known
consumer pods/namespaces.

**Operational consideration:** Service endpoints update when pods
pass/fail readiness probes. If readiness probe is too aggressive
(fails on transient load), pods are removed from endpoints under
load — amplifying the problem (remaining pods get more traffic,
fail readiness, cascade). Set `failureThreshold: 3` minimum to
avoid flapping.

**Tech Lead decision:** Service topology: ClusterIP for internal,
Ingress for HTTP external, LoadBalancer for non-HTTP external (gRPC,
TCP). Evaluate service mesh (Istio, Linkerd) only when you need:
mTLS between services, traffic splitting for canary, or circuit
breaking. A service mesh adds operational complexity — do not adopt
it "just in case."

**Interview framing:** "Services abstract pod ephemerality — they
provide a stable IP and DNS name that load-balances across healthy
pods. The key insight: Services use label selectors, not explicit pod
references. This means any pod matching the labels automatically
joins the Service's endpoint list. This decouples deployment from
routing — new pods are discoverable immediately."

### Ingress

Ingress is layer-7 (HTTP) routing. It maps external
hostnames and paths to internal Services:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  annotations:
    nginx.ingress.kubernetes.io/rate-limit: "100"
spec:
  ingressClassName: nginx
  tls:
    - hosts: [api.example.com]
      secretName: api-tls
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /v1
            pathType: Prefix
            backend:
              service:
                name: api-service
                port:
                  number: 80
```

**Key point:** Ingress is just a routing rule. It requires an Ingress
controller (nginx-ingress, Traefik, AWS ALB Ingress Controller) to
actually implement the routing. Without a controller, Ingress
resources do nothing.

**Practical usage:** Ingress consolidates multiple services behind
one load balancer (cost savings vs LoadBalancer-per-service). Use
annotations for controller-specific features: rate limiting, CORS
headers, authentication, SSL redirect, request size limits. TLS
termination via `spec.tls` references a Kubernetes Secret containing
the certificate (commonly managed by cert-manager for auto-renewal).

**Common mistake:** Creating Ingress resources without verifying an
Ingress controller is installed. The resources are accepted (valid
YAML) but have no effect — traffic never reaches the services.
Another mistake: using `pathType: Exact` when `Prefix` is needed
(or vice versa), causing 404 errors for valid paths.

**Security consideration:** Ingress is the external attack surface.
Apply: rate limiting (per-IP), request size limits (prevent large
payload DoS), TLS with modern cipher suites, HSTS headers, and WAF
rules (if the cloud LB supports it). Block access to internal paths
(health endpoints, metrics) from external traffic via Ingress path
rules or annotations.

**Operational consideration:** Ingress controller is a shared
resource — a misconfiguration (bad regex in path, invalid TLS
secret) can affect all services routed through it. Use separate
Ingress controllers for internal vs external traffic. Monitor
Ingress controller logs and metrics (request rate, error rate,
latency) as a platform service.

**Tech Lead decision:** Ingress controller choice: nginx-ingress
(widely supported, flexible annotations), Traefik (automatic TLS,
middleware), AWS ALB Ingress Controller (tight EKS integration,
no separate deployment). For new Kubernetes installations, consider
the Gateway API (successor to Ingress — more expressive, multi-
controller support). Evaluate based on team's existing cloud
provider and feature requirements.

**Interview framing:** "Ingress is the layer-7 routing layer — it
maps external hostnames and paths to internal Services. The key
architectural decision is Ingress controller choice, which determines
available features (rate limiting, auth, traffic splitting). The
cost insight: one Ingress controller with a single LoadBalancer
replacing N LoadBalancer Services saves N×$20/month."

### ConfigMaps and Secrets

ConfigMaps store non-sensitive configuration:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  LOG_LEVEL: "info"
  MAX_CONNECTIONS: "100"
  config.yaml: |
    server:
      port: 3000
      timeout: 30s
```

Secrets store sensitive data (base64-encoded, not encrypted by
default):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
type: Opaque
data:
  username: cG9zdGdyZXM=
  password: c2VjcmV0MTIz
```

**Critical distinction:** Kubernetes Secrets are base64-encoded, not
encrypted. Anyone with RBAC access to read Secrets in a namespace can
decode them. For production: enable encryption at rest (EncryptionConfiguration),
use external secret managers (Vault, AWS Secrets Manager, GCP Secret
Manager) with operators like External Secrets Operator.

**Practical usage:** ConfigMaps for: feature flags, connection
parameters (non-sensitive), application config files, nginx
configuration. Secrets for: database passwords, API keys, TLS
certificates, OAuth client secrets. Both can be consumed as
environment variables or mounted as files (file mounts allow updates
without pod restart — kubelet syncs within ~60 seconds).

**Common mistake:** Storing Secrets in Git manifests (even base64-
encoded — trivially decoded). Use Sealed Secrets (encrypted in Git,
decrypted in cluster) or External Secrets Operator (references only
in Git, values from Vault/AWS). Another mistake: using ConfigMaps for
sensitive data (no encryption at rest, no RBAC differentiation,
visible in `kubectl get cm -o yaml`).

**Security consideration:** RBAC for Secrets should be more
restrictive than for ConfigMaps. Use `get` without `list` (prevents
enumerating all secrets). Enable etcd encryption at rest
(EncryptionConfiguration with KMS provider). Audit log all Secret
access. In EKS, use envelope encryption with AWS KMS.

**Operational consideration:** ConfigMap changes do not trigger pod
restarts (unlike image changes). Options for applying config changes:
(1) Volume-mounted ConfigMaps auto-update (~60s delay) — application
must watch the file. (2) Use `stakater/Reloader` to trigger rolling
restart on ConfigMap change. (3) Use a hash annotation in the pod
template (`configmap-hash: <sha>`) so any ConfigMap change triggers
a new rollout.

**Production checklist:**
- [ ] No Secrets in Git (use External Secrets Operator or Sealed
      Secrets).
- [ ] Encryption at rest enabled for etcd (KMS provider).
- [ ] RBAC restricts Secret access per namespace (no cluster-wide
      Secret read).
- [ ] ConfigMap changes have a reload strategy (file watch, Reloader,
      or hash annotation).
- [ ] Secrets rotation automated (External Secrets Operator can sync
      rotated values).

**Tech Lead decision:** External Secrets Operator vs Sealed Secrets
vs Vault Agent Injector. External Secrets: simplest, works with any
cloud secret manager, syncs values into K8s Secrets. Sealed Secrets:
encrypt-in-Git approach, no external dependency. Vault Agent: most
feature-rich (dynamic secrets, leases) but adds sidecar complexity.
Choose based on existing infrastructure: if using AWS, External
Secrets + Secrets Manager is the path of least resistance.

**Interview framing:** "ConfigMaps and Secrets are the Kubernetes
configuration injection mechanism — they decouple configuration from
images. The critical trap: Secrets are base64-encoded, not encrypted.
Production requires encryption at rest (KMS), strict RBAC, and
ideally an external secret manager (Vault, AWS Secrets Manager) with
an operator that syncs values. Never commit Secrets to Git."

### Namespaces

Namespaces partition a cluster into virtual sub-clusters:
- **RBAC boundary:** Roles and RoleBindings are namespace-scoped.
- **Resource quotas:** Limit CPU, memory, and object count per
  namespace.
- **Network policies:** Restrict traffic between namespaces.
- **Team isolation:** Each team or environment gets a namespace.

Default namespaces: `default`, `kube-system`, `kube-public`,
`kube-node-lease`. Production workloads should never run in `default`.

**Practical usage:** Common namespace strategies: namespace-per-team
(`team-alpha`, `team-beta`), namespace-per-environment
(`staging`, `production`), or hybrid (`team-alpha-prod`,
`team-alpha-staging`). Namespace-per-team is most common for shared
clusters — each team gets RBAC access, resource quotas, and network
boundaries within their namespace.

**Common mistake:** Using namespaces as a hard security boundary.
Namespaces provide soft isolation (RBAC, quotas) but not strong
isolation. A pod in namespace A can still reach pods in namespace B
unless NetworkPolicies explicitly deny it. For hard tenant isolation,
use separate clusters or dedicated node pools with taints.

**Security consideration:** Apply default-deny NetworkPolicies per
namespace (no ingress, no egress except DNS). Add explicit allow
rules for known communication paths. Restrict cross-namespace traffic
to shared services only (monitoring, logging, ingress controller).
Use ResourceQuotas to prevent namespace from consuming unlimited
cluster resources (DoS protection against a single team).

**Operational consideration:** ResourceQuota per namespace is
essential for multi-tenant clusters:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-quota
  namespace: team-alpha
spec:
  hard:
    requests.cpu: "20"
    requests.memory: 40Gi
    limits.cpu: "40"
    limits.memory: 80Gi
    pods: "100"
    services.loadbalancers: "2"
```

Without quotas, one team can schedule all available capacity, leaving
other teams with Pending pods.

**Production checklist:**
- [ ] Every team has a dedicated namespace (not `default`).
- [ ] ResourceQuota set per namespace (CPU, memory, pod count).
- [ ] LimitRange set per namespace (default requests/limits for pods
      without explicit values).
- [ ] NetworkPolicy default-deny applied per namespace.
- [ ] RBAC Roles scoped per namespace (no cluster-admin for app
      teams).

**Tech Lead decision:** Namespace strategy depends on trust level.
Single team, multiple services: one namespace (simplest). Multiple
teams on shared cluster: namespace-per-team with RBAC and quotas.
Regulated/untrusted tenants: separate clusters (hard isolation).
Avoid environment-based namespaces in production clusters (`dev` and
`prod` on same cluster is risky — prefer separate clusters for
production).

**Interview framing:** "Namespaces are Kubernetes' multi-tenancy
primitive — they provide RBAC boundaries, resource quotas, and
network policy scope. They are soft isolation, not hard isolation.
For production multi-tenancy, I combine namespaces with
ResourceQuotas (prevent resource exhaustion), LimitRanges (enforce
defaults), and NetworkPolicies (restrict traffic). Hard isolation
requires separate clusters."

### Probes (health checks)

| Probe | Purpose | Failure action |
| --- | --- | --- |
| **Liveness** | Is the container alive? (deadlock detection) | Container is restarted |
| **Readiness** | Can the container serve traffic? | Pod removed from Service endpoints |
| **Startup** | Has the container finished initializing? | Liveness/readiness disabled until startup passes |

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 3000
  initialDelaySeconds: 10
  periodSeconds: 15
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /ready
    port: 3000
  periodSeconds: 5
  failureThreshold: 2

startupProbe:
  httpGet:
    path: /healthz
    port: 3000
  failureThreshold: 30
  periodSeconds: 2
```

**Critical mistake:** Making the liveness probe check external
dependencies (database, Redis). If the database is down, the
liveness probe fails, Kubernetes restarts the pod, the pod tries to
connect to the still-down database, fails again — restart loop. The
liveness probe should only check internal health (is the process
alive and not deadlocked). External dependencies belong in the
readiness probe.

**Practical usage:** Separate health endpoints per probe type:
`/healthz` for liveness (returns 200 if the process is alive, checks
internal state only), `/ready` for readiness (returns 200 if the
service can handle requests — may check database connectivity, cache
availability, warmup completion). Use startup probes for services
with long initialization (database migrations, large cache loading)
— `failureThreshold × periodSeconds` defines the maximum startup
time allowed.

**Common mistake:** Setting `initialDelaySeconds` too low on liveness
(kills pods during startup) or too high (dead pods serve traffic for
too long before restart). Use startup probes instead of large
`initialDelaySeconds` — they are purpose-built for slow startup and
do not interfere with liveness after initialization. Another mistake:
liveness and readiness pointing to the same endpoint — they serve
different purposes and should have different failure criteria.

**Security consideration:** Health endpoints should not expose
sensitive information (stack traces, internal error details, memory
dumps). Return minimal responses: `200 OK` with empty body or
`{"status":"healthy"}`. Bind health endpoints to the pod IP only
(not exposed through Ingress). Detailed health information should
require authentication (a separate `/debug/health` endpoint with
RBAC).

**Operational consideration:** Probe timing parameters determine
detection and recovery speed:

| Parameter | Liveness | Readiness | Startup |
| --- | --- | --- | --- |
| `periodSeconds` | 15s (not too aggressive) | 5s (fast traffic removal) | 2s (fast startup detection) |
| `failureThreshold` | 3 (avoid false restarts) | 2 (remove from traffic quickly) | 30 (allow long startup) |
| `timeoutSeconds` | 3s | 3s | 3s |

**Production checklist:**
- [ ] Every pod has liveness and readiness probes configured.
- [ ] Liveness checks internal state only (no external deps).
- [ ] Readiness checks ability to serve (including external deps).
- [ ] Startup probe configured for services with >10s initialization.
- [ ] Probe endpoints return within timeout (3s) even under load.
- [ ] No sensitive information in health endpoint responses.

**Tech Lead decision:** Probe type selection: HTTP probes for web
services (most common), TCP probes for non-HTTP services (databases,
message brokers), exec probes for complex health checks (script that
verifies state). Prefer HTTP probes — they are the most observable
(response codes appear in events and logs). Avoid exec probes when
possible (they fork a process on each check — resource overhead at
scale).

**Interview framing:** "Probes are how Kubernetes distinguishes 'the
container is running' from 'the application is healthy.' Liveness
detects deadlocks (restart the container). Readiness detects inability
to serve (remove from traffic). Startup protects slow-starting apps
from premature liveness kills. The critical rule: never check external
dependencies in liveness probes — it causes cascading restart loops
when a shared dependency fails."

### Resource requests and limits

```yaml
resources:
  requests:
    cpu: "250m"
    memory: "256Mi"
  limits:
    cpu: "1000m"
    memory: "512Mi"
```

- **Requests:** The scheduler uses requests to find a node with
  enough capacity. The pod is guaranteed these resources.
- **Limits:** The enforced ceiling. Memory over limit → OOM-killed.
  CPU over limit → throttled (not killed).

**Sizing strategy:**
1. Start with requests = observed P95 usage (from monitoring).
2. Set memory limit = 1.5-2× request (headroom for spikes).
3. Set CPU limit = 2-4× request (CPU throttling is better than
   OOM-kill).
4. Review monthly — over-requesting wastes money; under-requesting
   causes evictions.

**QoS classes:** Based on how requests and limits are set:
- **Guaranteed:** requests == limits (highest priority, last evicted).
- **Burstable:** requests < limits (evicted before Guaranteed).
- **BestEffort:** no requests or limits (first evicted — avoid in
  production).

**Practical usage:** Use VPA (Vertical Pod Autoscaler) in
recommendation mode to analyze actual resource usage and suggest
right-sized requests. Set requests based on P95 actual usage (from
Prometheus `container_memory_working_set_bytes` and
`container_cpu_usage_seconds_total`). Review quarterly — workload
patterns change with feature releases and traffic growth.

**Common mistake:** Setting memory request == limit for all workloads
(Guaranteed QoS). This wastes resources because pods cannot burst
above their request even when nodes have spare capacity. Use
Guaranteed QoS only for critical low-latency services where
predictable performance matters. For most services, Burstable
(request < limit) provides better cluster utilization.

Another common mistake: not setting any resources (BestEffort). These
pods are scheduled on any node regardless of available capacity and
are the first evicted under memory pressure — causing unpredictable
restarts.

**Security consideration:** Resource limits are a security control.
Without CPU limits, a compromised pod can crypto-mine using all node
CPU (noisy neighbor attack). Without memory limits, a memory bomb
can OOM-kill other pods on the same node. In multi-tenant clusters,
enforce LimitRanges to require minimum requests and maximum limits
per pod.

**Operational consideration:** CPU throttling (CFS enforcement) can
cause latency spikes even when average CPU usage looks low. This
happens because CFS enforces quotas in 100ms periods — a burst that
exceeds the quota within a single period is throttled regardless of
average utilization. Monitor `container_cpu_cfs_throttled_periods_total`
to detect throttling. Some teams remove CPU limits entirely (use
requests for scheduling but allow unlimited burst) — this trades
predictability for performance.

**Production checklist:**
- [ ] Every production pod has memory requests and limits set.
- [ ] CPU requests set for all pods (scheduling input).
- [ ] No BestEffort pods in production namespaces (enforce via
      LimitRange).
- [ ] Memory limit ≤ 2× request (prevent extreme burst causing node
      pressure).
- [ ] CPU throttling monitored (alert if >20% periods throttled).
- [ ] VPA recommendations reviewed quarterly for right-sizing.
- [ ] LimitRange set per namespace with sane defaults.

**Tech Lead decision:** The CPU limit controversy: some teams
(including Google's internal practice) omit CPU limits to avoid
throttling-induced latency. This is safe when: (1) requests are
accurately sized (scheduling is correct), (2) nodes are not over-
committed, (3) noisy-neighbor risk is accepted. Decision: keep CPU
limits for multi-tenant clusters (prevent abuse). Remove CPU limits
for dedicated clusters where the team owns all workloads and
optimizes for latency over isolation.

**Interview framing:** "Requests are the scheduling contract —
Kubernetes guarantees these resources. Limits are the enforcement
ceiling — exceeding memory limits causes OOM-kill, exceeding CPU
limits causes CFS throttling. The sizing strategy: requests at P95
actual usage, memory limit at 1.5-2× request, CPU limits debatable
(they cause throttling that can hurt latency). QoS classes determine
eviction priority: Guaranteed is evicted last, BestEffort first."

### Horizontal Pod Autoscaler (HPA)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  minReplicas: 3
  maxReplicas: 20
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Percent
          value: 25
          periodSeconds: 60
```

**Key decisions:**
- **Target utilization:** 70% CPU is typical. Too low → wasted
  resources. Too high → no headroom for spikes.
- **Scale-down stabilization:** Prevents flapping. A 5-minute window
  means the HPA waits before scaling down.
- **Custom metrics:** For I/O-bound services, scale on queue depth or
  request latency instead of CPU.

**Practical usage:** HPA requires the metrics-server to be installed
(provides CPU/memory utilization). For custom metrics (request rate,
queue depth, latency), deploy Prometheus Adapter which exposes
Prometheus metrics to the Kubernetes metrics API. Combine HPA with
Cluster Autoscaler — HPA adds pods, Cluster Autoscaler adds nodes
when pods cannot be scheduled.

**Common mistake:** Setting `minReplicas: 1` for production services.
If the single pod fails, there is zero capacity until a replacement
starts. Set `minReplicas ≥ 2` for any service with availability
requirements. Another mistake: scaling on memory for applications
with growing memory (e.g., caches that fill over time) — HPA keeps
adding replicas because memory never decreases.

**Security consideration:** HPA can be exploited as an amplification
vector: if an attacker can generate load, HPA scales up, consuming
cluster resources and increasing cloud cost. Set `maxReplicas` as a
hard cap. Add request rate limiting at the Ingress layer to prevent
attack-driven scaling. Alert when replicas hit maxReplicas.

**Operational consideration:** HPA evaluates metrics every 15 seconds
(default `--horizontal-pod-autoscaler-sync-period`). Scale-up is
fast (usually within 30s). Scale-down is deliberately slow
(`stabilizationWindowSeconds`) to prevent flapping. Monitor
`kube_hpa_status_current_replicas` vs `kube_hpa_spec_max_replicas`
— if current consistently equals max, the service is under-scaled.

**Production checklist:**
- [ ] HPA configured for all user-facing services.
- [ ] `minReplicas ≥ 2` for production (HA).
- [ ] `maxReplicas` set as cost protection cap.
- [ ] Scale-down stabilization ≥ 300s (prevents flapping).
- [ ] Custom metrics for I/O-bound services (not CPU-based).
- [ ] Alert when current replicas == maxReplicas (scaling ceiling hit).
- [ ] Cluster Autoscaler configured to provision nodes for new pods.

**Tech Lead decision:** HPA metric selection: CPU-based for CPU-bound
services (compute-heavy APIs). Custom-metric-based for I/O-bound
services (database-backed APIs where CPU is low but latency is high).
Multi-metric HPA (CPU + custom) provides the most responsive scaling
but is harder to tune. Start with CPU for simplicity, move to custom
metrics when CPU-based scaling does not match traffic patterns.

**Interview framing:** "HPA adjusts replica count based on observed
metrics. The critical design decisions are: which metric to scale on
(CPU for compute-bound, request rate or latency for I/O-bound), what
target utilization to aim for (70% balances headroom and cost), and
scale-down behavior (5-minute stabilization prevents flapping). HPA
works with Cluster Autoscaler: HPA adds pods, Cluster Autoscaler adds
nodes when pods are unschedulable."

### Rolling updates and rollbacks

Default strategy for Deployments is `RollingUpdate`:

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  minReadySeconds: 10
  progressDeadlineSeconds: 300
```

- **maxSurge:** How many extra pods above desired count during update.
- **maxUnavailable:** How many pods can be down during update.
- **minReadySeconds:** How long a new pod must be Ready before it
  counts as available (prevents premature progression).
- **progressDeadlineSeconds:** How long before a stalled rollout is
  marked failed.

**Rollback:** `kubectl rollout undo deployment/api` reverts to the
previous ReplicaSet. Kubernetes keeps a history (default: 10
revisions). Check status with `kubectl rollout status deployment/api`.

**Blue/green and canary:** Not native to Kubernetes Deployments.
Achieved via:
- Service label selectors (manual blue/green).
- Argo Rollouts or Flagger (canary with traffic splitting).
- Service mesh (Istio, Linkerd) for weighted routing.

**Practical usage:** For zero-downtime deployments: set
`maxUnavailable: 0` (no existing pod is removed until a new one is
ready). Combined with readiness probes, this ensures traffic always
has available pods. The `preStop` lifecycle hook (typically `sleep 5`)
gives load balancers time to deregister the pod before it terminates.

**Common mistake:** Using default `maxSurge: 25%, maxUnavailable: 25%`
for critical services. This allows 25% of pods to be simultaneously
unavailable during rollout — acceptable for large deployments but
causes outages for 3-pod services (1 unavailable = 33% capacity loss).
For small services: `maxSurge: 1, maxUnavailable: 0`. Another mistake:
not setting `progressDeadlineSeconds` — a stuck rollout (crash loop)
hangs indefinitely without being marked as failed.

**Security consideration:** Rollbacks are only possible if
`revisionHistoryLimit > 0` and old images are still in the registry.
If a vulnerable image is deployed, rollback to the previous version
while fixing. Never delete old image tags — maintain at least 10
previous versions in the registry for emergency rollback.

**Operational consideration:** The pod termination sequence is
critical for zero-downtime:

```text
1. Pod marked for deletion
2. Pod removed from Service endpoints (no new traffic)
3. preStop hook runs (sleep 5-10s for LB deregistration)
4. SIGTERM sent to container processes
5. Application handles SIGTERM (drain connections, finish requests)
6. terminationGracePeriodSeconds countdown
7. SIGKILL (forced termination)
```

If `terminationGracePeriodSeconds` (default 30s) is shorter than the
time needed to drain in-flight requests, connections are dropped.
Set it to at least: preStop sleep + max request duration + buffer.

**Production checklist:**
- [ ] `maxUnavailable: 0` for zero-downtime deployments.
- [ ] `minReadySeconds: 10-30` to catch early crashes.
- [ ] `progressDeadlineSeconds` set for CI/CD timeout detection.
- [ ] `preStop` hook with sleep (5-10s) for LB deregistration.
- [ ] `terminationGracePeriodSeconds` covers drain time.
- [ ] Application handles SIGTERM gracefully (connection drain).
- [ ] Rollout status monitored in CI/CD (fail pipeline on timeout).
- [ ] PodDisruptionBudget configured to protect against simultaneous
      voluntary disruptions.

**Tech Lead decision:** Rolling updates (default, simple, always
available) vs canary (catch issues with small traffic percentage
before full rollout) vs blue/green (instant switch, expensive —
double capacity during deploy). Decision framework: rolling update
for most services (sufficient with good probes and monitoring).
Canary (via Argo Rollouts) for high-traffic services where a bad
deploy has significant business impact. Blue/green for services
requiring instant rollback without pod termination (e.g., stateful
connections).

**Interview framing:** "Rolling updates work by creating a new
ReplicaSet and gradually scaling it up while scaling the old one
down. Zero-downtime requires: `maxUnavailable: 0` (never remove pods
before replacements are ready), readiness probes (ensure new pods
can serve traffic), and a `preStop` hook (give load balancers time
to deregister). Rollback is instant — Kubernetes reverts to the
previous ReplicaSet. The key operational risk: if the new pods crash-
loop, the rollout stalls (detected via `progressDeadlineSeconds`)
and the old pods continue serving."

### Scheduling: taints, tolerations, and affinity

The Kubernetes scheduler places pods on nodes using a two-phase
process: filtering (eliminates unsuitable nodes) then scoring (ranks
remaining nodes).

**nodeSelector** — simplest constraint. Matches a pod to nodes with
specific labels:

```yaml
spec:
  nodeSelector:
    workload-type: compute-intensive
```

**Taints and tolerations** — nodes repel pods unless the pod
tolerates the taint. Pattern: taint GPU nodes so only GPU workloads
schedule there. Taint spot/preemptible nodes so only fault-tolerant
workloads run on them.

**Node affinity** — expressive rules (required or preferred) for
node placement. Replaces nodeSelector with richer logic
(`In`, `NotIn`, `Exists`).

**Pod anti-affinity** — prevents pods from co-locating. Ensures
replicas of the same service spread across nodes or zones:

```yaml
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app: api
          topologyKey: topology.kubernetes.io/zone
```

**Common mistake:** Using `requiredDuringScheduling` anti-affinity
with more replicas than available zones. If 3 zones exist and 5
replicas are requested, 2 pods remain Pending forever. Use
`preferred` for soft spreading and `topologySpreadConstraints` for
guaranteed even distribution.

**Security consideration:** Taints enforce workload isolation.
Compliance-sensitive workloads (PCI, HIPAA) can be restricted to
dedicated node pools via taints — only pods with the correct
toleration schedule there.

**Tech Lead decision:** Use taints for hard isolation (GPU, spot,
compliance). Use `topologySpreadConstraints` for zone distribution
(replaces pod anti-affinity for most cases — simpler and more
predictable). Avoid complex affinity rules unless there is a
measurable scheduling requirement.

**Interview framing:** "Taints repel pods from nodes; tolerations
are the opt-in. Affinity attracts pods to nodes (or away from other
pods). The practical pattern: taint specialized nodes (GPU, spot,
compliance), use `topologySpreadConstraints` for zone distribution,
and avoid complex affinity rules that make scheduling unpredictable."

### RBAC and service accounts

Role-Based Access Control restricts who can do what:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: team-alpha
  name: developer
rules:
  - apiGroups: ["apps"]
    resources: ["deployments"]
    verbs: ["get", "list", "update", "patch"]
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: api-sa
  namespace: team-alpha
automountServiceAccountToken: false
```

**Key objects:**
- **ServiceAccount:** Identity for pods. Each pod runs as a
  ServiceAccount.
- **Role / ClusterRole:** Defines permissions (namespace-scoped or
  cluster-wide).
- **RoleBinding / ClusterRoleBinding:** Binds a Role to a user,
  group, or ServiceAccount.

**Practical usage:** RBAC governs two access paths: (1) Human
access — developers use kubectl (authenticated via OIDC, mapped to
groups, bound to Roles per namespace). (2) Pod access — pods use
ServiceAccounts to call the Kubernetes API (e.g., config reloaders,
operators). Most application pods need no API access — disable token
mounting. For cloud integration, use IRSA (EKS) or Workload Identity
(GKE) to grant pods access to cloud resources (S3, Secrets Manager)
without static credentials.

**Common mistake:** Granting `cluster-admin` to application teams
("it was easier to debug"). cluster-admin bypasses all RBAC — a
compromised pod with cluster-admin can take over the entire cluster.
Another mistake: using the `default` ServiceAccount for all pods
(shared identity = shared blast radius). A third mistake: granting
`list` + `watch` on Secrets cluster-wide (allows reading all
secrets in all namespaces).

**Security consideration:** RBAC is the primary access control layer.
Audit: (1) no ClusterRoleBindings to cluster-admin for non-platform
users, (2) no wildcard verbs (`*`) in production Roles, (3) Secrets
access is namespace-scoped and audited, (4) ServiceAccounts are
per-workload (not shared). Use `kubectl auth can-i --list --as=
system:serviceaccount:ns:sa` to audit effective permissions.

**Operational consideration:** RBAC changes are immediate (no pod
restart needed). Use groups (OIDC groups or Kubernetes groups) rather
than individual user bindings — this makes onboarding/offboarding
consistent. For break-glass scenarios, maintain a limited
`cluster-admin` binding to a dedicated emergency group with MFA
and audit logging.

**Production checklist:**
- [ ] Every pod has a dedicated ServiceAccount (not `default`).
- [ ] `automountServiceAccountToken: false` unless API access needed.
- [ ] No `cluster-admin` bindings for application teams.
- [ ] Roles use namespace-scoped permissions (not ClusterRoles for
      app workloads).
- [ ] IRSA/Workload Identity for cloud resource access (no static
      keys in Secrets).
- [ ] RBAC audit: quarterly review of bindings and permissions.

**Tech Lead decision:** RBAC strategy: namespace-scoped Roles for
application teams (can deploy, view pods/logs, cannot modify cluster
resources). Platform team gets broader ClusterRoles (manage nodes,
namespaces, CRDs). Break-glass access via separate binding with
short-lived credentials and mandatory audit. Use RBAC-manager or
policy-as-code (Kyverno) to automate and enforce RBAC at scale.

**Interview framing:** "RBAC is Kubernetes' authorization layer — it
controls who can do what to which resources. I enforce least privilege:
each workload gets a dedicated ServiceAccount with minimal permissions,
application teams get namespace-scoped Roles (deploy, view pods, read
logs), and platform teams manage cluster-wide resources. The critical
gap: RBAC controls API access, but NetworkPolicies control data-plane
traffic. Both are needed for defense in depth."

### Persistent volumes

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-data
spec:
  accessModes: [ReadWriteOnce]
  storageClassName: gp3-encrypted
  resources:
    requests:
      storage: 50Gi
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3-encrypted
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  encrypted: "true"
  kmsKeyId: arn:aws:kms:us-east-1:123:key/abc-123
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

**Access modes:**
- `ReadWriteOnce` (RWO): Single node read-write. Standard for
  databases.
- `ReadOnlyMany` (ROX): Many nodes read-only. Shared config or
  static assets.
- `ReadWriteMany` (RWX): Many nodes read-write. Requires NFS or
  similar (EFS, GlusterFS).

**StorageClass** defines the provisioner (EBS, EFS, local, Ceph) and
parameters (IOPS, encryption). Dynamic provisioning creates PVs
automatically when PVCs are created.

**Practical usage:** Use `volumeBindingMode: WaitForFirstConsumer` to
delay volume provisioning until a pod is scheduled — this ensures the
volume is created in the same AZ as the pod (prevents cross-AZ
attachment failures). Use `allowVolumeExpansion: true` to resize PVCs
without recreating them (expand storage without downtime). Use
VolumeSnapshots for point-in-time backups (CSI driver must support it).

**Common mistake:** Using `reclaimPolicy: Delete` for database
volumes. When the PVC is deleted, the underlying volume (and all data)
is destroyed. Use `Retain` for any volume containing important data
— manual cleanup is safer than accidental deletion. Another mistake:
requesting RWX when RWO is sufficient — RWX requires NFS-type storage
which has lower performance and higher cost.

**Security consideration:** Enable encryption on all StorageClasses
(EBS encryption with KMS, GCE PD encryption). Without encryption,
data at rest on cloud volumes is accessible if the underlying disk
is compromised or snapshotted. Use KMS-managed keys (not AWS-managed
keys) for audit and rotation control.

**Operational consideration:** PVC-node affinity: EBS volumes are
AZ-bound — if a pod moves to a different AZ, the PVC cannot attach.
Use `WaitForFirstConsumer` to co-locate volume and pod. Monitor disk
usage: alert at 80% capacity (PVC expansion takes effect on next pod
restart for some CSI drivers). Plan backup strategy: VolumeSnapshots
or application-level backup (pg_dump, mongodump).

**Production checklist:**
- [ ] `reclaimPolicy: Retain` for all database and stateful volumes.
- [ ] Encryption enabled on all StorageClasses (KMS-managed keys).
- [ ] `WaitForFirstConsumer` to prevent cross-AZ binding failures.
- [ ] `allowVolumeExpansion: true` for all StorageClasses.
- [ ] VolumeSnapshot schedule for critical data (or app-level backup).
- [ ] Disk usage alerting at 80% capacity per PVC.
- [ ] Tested recovery procedure: restore from snapshot/backup.

**Tech Lead decision:** Where to store state: managed database (RDS,
Cloud SQL) vs self-managed on Kubernetes (with PVCs). Managed services
eliminate PVC management, backup orchestration, and failover
complexity. Use Kubernetes PVCs for: non-critical caches
(Redis with persistence), internal tools, or when cost savings at
scale justify the operational investment. Default to managed for
databases unless there is a compelling portability or cost argument.

**Interview framing:** "Persistent volumes decouple storage lifecycle
from pod lifecycle. The key design decisions: StorageClass selection
(performance tier, encryption, reclaim policy), access mode (RWO for
most databases, RWX only when truly needed), and binding mode
(WaitForFirstConsumer for AZ-aware scheduling). The operational
challenge: backups, capacity monitoring, and the AZ-binding constraint
for cloud block storage."

### Helm

Helm is a package manager. A Helm chart is a parameterized set of
Kubernetes manifests:

```text
my-chart/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── _helpers.tpl
└── charts/         (sub-chart dependencies)
```

**values.yaml** provides defaults. Users override with
`--set key=value` or `-f custom-values.yaml`.

**Trade-offs:**
- Pro: Reusable, versioned packages. Community charts for common
  software (PostgreSQL, Redis, Prometheus).
- Con: Go templating is complex and hard to debug. `helm template`
  renders locally for review.

**Practical usage:** Helm for third-party software (install
Prometheus, PostgreSQL, cert-manager with one command and a values
file). Helm for internal platform charts (standardized Deployment +
Service + Ingress + HPA template that all teams use). Use `helm
diff` plugin to preview changes before applying. Use `helm test` for
post-deploy validation.

**Common mistake:** Never inspecting what a Helm chart actually
deploys. Community charts include hundreds of lines of YAML —
security misconfigurations, default passwords, and excessive RBAC
are common. Always `helm template` locally and review before
installing. Pin chart versions in `Chart.lock` — never deploy
`latest` chart version without review.

**Security consideration:** Helm chart repositories can serve
malicious charts. Use trusted repos only. Verify chart integrity
(Helm provenance files). Review chart values for: default passwords
(`--set adminPassword=admin`), permissive RBAC (many charts request
cluster-admin), and container images pulled from untrusted registries.

**Operational consideration:** Helm stores release state in Kubernetes
Secrets (by default). A failed `helm upgrade` can leave a release in
a "pending-upgrade" state that blocks future operations. Fix with:
`helm rollback <release> <revision>`. Keep Helm release history
limited (`--history-max 10`) to prevent Secret accumulation.

**Production checklist:**
- [ ] Chart versions pinned in `Chart.lock` or CI pipeline.
- [ ] `helm template` output reviewed before first install.
- [ ] Values files are environment-specific (values-prod.yaml,
      values-staging.yaml).
- [ ] Secrets not stored in values files (use External Secrets or
      `--set` from CI secrets).
- [ ] `helm diff` used before every upgrade (preview changes).
- [ ] Release history limited (`--history-max 10`).

**Tech Lead decision:** Helm for chart distribution and third-party
software. Evaluate Kustomize (below) for internal services where
the team owns the YAML. Do not mix Helm and Kustomize for the same
service — pick one. If maintaining many internal services, a shared
Helm chart (company-standard Deployment template) reduces YAML
duplication across teams.

**Interview framing:** "Helm is a package manager for Kubernetes —
parameterized YAML templates with versioning and dependency management.
I use it for third-party software (community charts) and internal
platform charts (shared templates). The key risk: Helm chart
complexity hides what is actually deployed. I always `helm template`
locally and review the rendered YAML, especially for RBAC, security
contexts, and images."

### Kustomize

Kustomize is template-free. It applies patches and overlays to base
manifests:

```text
base/
├── kustomization.yaml
├── deployment.yaml
└── service.yaml
overlays/
├── dev/
│   └── kustomization.yaml
└── prod/
    ├── kustomization.yaml
    └── replicas-patch.yaml
```

```yaml
# overlays/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
patchesStrategicMerge:
  - replicas-patch.yaml
namespace: production
commonLabels:
  env: production
```

**Trade-offs vs Helm:**
- Kustomize: no templating language, plain YAML, built into kubectl.
  Better for teams that own their manifests.
- Helm: parameterized packages, better for distributing software to
  others (open-source charts, internal platform charts).

**Practical usage:** Kustomize is built into kubectl (`kubectl apply
-k overlays/prod/`). No external tool needed. Use overlays for
environment differences: production has more replicas, different
resource limits, different config. Use `configMapGenerator` and
`secretGenerator` to create ConfigMaps/Secrets from files with
automatic hash suffixes (triggers pod restart on config change).

**Common mistake:** Overusing patches until they are harder to read
than the original YAML. If overlays contain more lines than the base,
consider restructuring. Another mistake: using `commonLabels` which
applies labels to selectors — this can break existing Deployments (
selector labels are immutable after creation).

**Security consideration:** Kustomize renders plain YAML — what you
see is what you deploy. No hidden templating logic. This
transparency is a security advantage over Helm (easier to audit).
However, Kustomize's `secretGenerator` creates Secrets in plain YAML
(visible to anyone with repository access) — still need external
secret management.

**Operational consideration:** Use `kubectl diff -k overlays/prod/`
to preview changes before applying. Combine with GitOps (Argo CD
natively supports Kustomize). Pin image tags in overlays to prevent
drift between environments.

**Tech Lead decision:** Choose Kustomize when: (1) the team owns all
manifests (no distribution requirement), (2) environment differences
are small (replicas, resources, namespace), (3) the team values
readability over abstraction. Choose Helm when: distributing charts
to others, managing complex third-party software, or needing Go
template logic (conditionals, loops). Standardize one approach per
team — mixing creates confusion.

**Interview framing:** "Kustomize is template-free YAML
customization — patches and overlays without a templating language.
The base contains the common manifests, overlays add environment-
specific differences. Built into kubectl, no external tooling needed.
I prefer Kustomize for internal services (transparent, auditable)
and Helm for third-party software (parameterized packages)."

### kubectl troubleshooting

Essential debugging flow:

```bash
# 1. Check pod status
kubectl get pods -n team-alpha

# 2. Describe pod for events (scheduling failures, image pull errors)
kubectl describe pod api-7f8b9c-x4k2n -n team-alpha

# 3. Check logs (current container)
kubectl logs api-7f8b9c-x4k2n -n team-alpha

# 4. Check logs (previous crashed container)
kubectl logs api-7f8b9c-x4k2n -n team-alpha --previous

# 5. Execute into running container for debugging
kubectl exec -it api-7f8b9c-x4k2n -n team-alpha -- sh

# 6. Check resource usage
kubectl top pods -n team-alpha

# 7. Check events across namespace
kubectl get events -n team-alpha --sort-by='.lastTimestamp'

# 8. Debug a distroless/crashed container with ephemeral container
kubectl debug api-7f8b9c-x4k2n -n team-alpha \
  --image=busybox --target=api -- sh
```

**Common pod states and causes:**

| State | Likely cause | Fix |
| --- | --- | --- |
| **Pending** | No node has enough resources | Check requests, add nodes, or fix taints |
| **ImagePullBackOff** | Image not found or auth failure | Verify image name, tag, and pull secrets |
| **CrashLoopBackOff** | Container exits immediately | Check logs (--previous), fix startup |
| **OOMKilled** | Memory limit exceeded | Increase memory limit or fix memory leak |
| **Evicted** | Node under resource pressure | Right-size requests, add nodes |
| **ContainerCreating** (stuck) | Volume mount failure or slow image pull | Check events, PVC status, pull secrets |

**Practical usage:** The troubleshooting funnel: (1) `get pods` →
identify the unhealthy pod and its status. (2) `describe pod` →
check Events section (scheduling, image pull, probe failures). (3)
`logs --previous` → see why the previous instance crashed. (4) `top
pods` → identify resource pressure. (5) `get events` → cluster-wide
context (node issues, quota violations). Most issues are diagnosed
within these 5 steps.

**CrashLoopBackOff deep-dive:**

CrashLoopBackOff means the container starts and exits repeatedly.
Kubernetes applies exponential backoff (10s, 20s, 40s... up to 5
minutes) between restart attempts. Common causes:

1. **Application error on startup:** Missing config, invalid
   environment variable, unresolvable DNS. Fix: check `logs
   --previous` for the error message.
2. **OOMKilled immediately:** Memory limit too low for the
   application's base footprint. Fix: increase memory limit.
3. **Missing dependency:** ConfigMap or Secret referenced in env does
   not exist. Fix: `describe pod` shows `CreateContainerConfigError`.
4. **Wrong CMD/entrypoint:** Dockerfile CMD is incorrect or
   references a missing file. Fix: override with `command` in the
   pod spec for debugging.
5. **Permission denied:** Non-root user cannot read mounted files.
   Fix: set `fsGroup` in security context.

**Common mistake:** Increasing `initialDelaySeconds` to "fix"
CrashLoopBackOff. This only delays detection — it does not fix the
underlying crash. Always check logs first. Another mistake: running
`kubectl delete pod` to "fix" it — the controller creates a new pod
that crashes the same way.

**Security consideration:** `kubectl exec` into running containers is
a broad-access operation and potentially dangerous. Restrict via RBAC: only allow
exec for debugging roles, not default developer roles. Audit all exec
commands. In production, prefer `kubectl debug` (ephemeral debug
containers) over exec into the application container — this avoids
modifying the running process.

**Operational consideration:** Set up kubectl aliases and plugins for
faster debugging: `kubectl-tree` (shows resource hierarchy),
`kubectl-neat` (removes managed fields from output), `kubectl-
sniff` (captures pod traffic). For on-call, maintain a runbook per
pod state (Pending, CrashLoopBackOff, OOMKilled) with step-by-step
resolution.

**Production checklist:**
- [ ] On-call runbook covers: Pending, CrashLoopBackOff, OOMKilled,
      ImagePullBackOff, node NotReady.
- [ ] RBAC restricts `exec` access in production namespaces.
- [ ] Ephemeral debug containers available (Kubernetes 1.25+).
- [ ] Events are shipped to centralized logging (not just visible
      via kubectl).
- [ ] Alerting configured for pods in CrashLoopBackOff > 5 minutes.
- [ ] Pod restart count monitored and alerted on (frequent restarts
      indicate instability).

**Tech Lead decision:** Observability investment for troubleshooting:
centralized logging (Loki, Elasticsearch) so developers do not need
kubectl access to read logs. Metrics dashboards (Grafana) showing
pod restarts, OOMKills, and pending duration. Event exporter that
ships Kubernetes events to the alerting system. The goal: most
debugging happens in dashboards, not via kubectl in production.

**Interview framing:** "My debugging approach is systematic:
(1) identify the pod state, (2) describe for events, (3) check
previous logs, (4) check resource usage. CrashLoopBackOff means the
container starts and exits repeatedly with exponential backoff —
the fix is always in the logs, not in restarting the pod. For
production, I invest in observability so debugging happens in
dashboards rather than requiring kubectl access to the cluster."

**Troubleshooting specific failures:**

```bash
# ImagePullBackOff: verify image exists and credentials are valid
kubectl describe pod <pod> -n <ns> | grep -A5 "Events:"
# Look for: "Failed to pull image" with reason
kubectl get secret <pull-secret> -n <ns> -o jsonpath='{.data.\.dockerconfigjson}' | base64 -d
# Verify: correct registry URL, valid credentials, image:tag exists

# Failing readiness probe: check endpoint is reachable from pod
kubectl exec <pod> -n <ns> -- wget -qO- http://localhost:3000/ready
# If timeout: application not listening on expected port
kubectl describe pod <pod> | grep -A3 "Readiness:"
# Check: correct port, correct path, appropriate timeout

# Networking: service not routing to pods
kubectl get endpoints <service> -n <ns>
# If empty: label selector mismatch between Service and Pod
kubectl get pods -n <ns> --show-labels
kubectl get svc <service> -n <ns> -o yaml | grep selector -A5
# DNS: verify resolution from another pod
kubectl exec <debug-pod> -- nslookup <service>.<ns>.svc.cluster.local
```

**What these commands do:** Targeted debugging sequences for the
three most common "networking is broken" reports: image cannot be
pulled, traffic is not reaching the pod, or services cannot find
each other.

**Why this is useful:** On-call engineers often spend 30 minutes
guessing. These sequences diagnose the specific failure in under 5
minutes by checking the exact point of failure.

**Common mistake:** Assuming networking issues are cluster-wide when
they are usually namespace-scoped (missing NetworkPolicy allow rule,
wrong label on pod, missing Service endpoints).

**How this changes in production:** Replace ad-hoc kubectl debugging
with Grafana dashboards showing: endpoint count per Service (empty =
broken), probe failure rate per Deployment, and image pull error
events. kubectl debugging becomes the fallback, not the first step.

**Tech Lead check:** Ensure the team has a runbook linking symptoms
to these diagnostic sequences, RBAC allows read-only troubleshooting
(get, describe, logs) without write access, and debug tooling
(ephemeral containers, kubectl-debug) is available.

## Practical Usage

### Production readiness

A Kubernetes deployment is production-ready when it can handle failure,
scale under load, and be operated safely by on-call engineers.

**Production readiness checklist (full):**

```yaml
# Production readiness requirements per Deployment
readiness:
  availability:
    - replicas >= 2 (HA)
    - PodDisruptionBudget configured
    - spread across AZs (topologySpreadConstraints)
  reliability:
    - liveness probe (internal health only)
    - readiness probe (dependency checks)
    - startup probe if init > 10s
    - graceful shutdown (SIGTERM handling + preStop hook)
  scalability:
    - HPA configured (or explicit reason for fixed replicas)
    - resource requests based on actual usage
    - resource limits set (memory mandatory, CPU debatable)
  security:
    - dedicated ServiceAccount (not default)
    - automountServiceAccountToken: false
    - runAsNonRoot: true
    - readOnlyRootFilesystem: true
    - no privileged containers
    - NetworkPolicy (default-deny + explicit allow)
  observability:
    - structured logs (JSON, correlation ID)
    - metrics endpoint (Prometheus scrape)
    - traces (OpenTelemetry)
    - alerts for: error rate, latency P99, restart count
  operations:
    - rollout strategy defined (maxSurge, maxUnavailable)
    - progressDeadlineSeconds set
    - resource budgets reviewed quarterly
    - runbook exists for common failure modes
```

**Common mistake:** Treating production readiness as a one-time
checklist rather than a continuous practice. Services degrade over
time: traffic patterns change, dependencies evolve, resource usage
grows. Schedule quarterly reviews of resource sizing, alert
thresholds, and deployment strategies.

**Security consideration:** Production readiness includes security
posture: Pod Security Standards (restricted level), RBAC audit,
image scanning in CI, and runtime security monitoring. A service
is not production-ready if it runs as root, uses default
ServiceAccount, or has no NetworkPolicy.

**Operational consideration:** Gate production deployments on
readiness criteria. Use admission webhooks (Kyverno, OPA
Gatekeeper) to enforce: required labels, resource requests,
probes, security context. This prevents "it worked in dev" from
reaching production without the required operational safeguards.

**Tech Lead decision:** Define a "golden path" that encodes
production readiness into templates. If every service starts from
a shared Helm chart or Kustomize base that includes probes, security
context, and resource templates, production readiness becomes the
default rather than an afterthought. The platform team maintains the
golden path; application teams customize within its constraints.

**Interview framing:** "Production readiness is not a single
checklist — it is a set of capabilities: the service must handle
failure (probes, restarts, PDB), scale (HPA, resource sizing),
be observable (logs, metrics, traces), and be secure (RBAC, non-root,
NetworkPolicy). I enforce this through platform templates and
admission policies rather than manual review."

### When Kubernetes earns its cost

Kubernetes makes sense when:
- **Multiple teams deploy independently.** The shared platform with
  namespaces, RBAC, and resource quotas enables self-service.
- **Service count exceeds 10-15.** The operational overhead of
  managing individual deployment pipelines, networking, and
  scaling per service becomes unsustainable.
- **The team needs auto-scaling and self-healing.** HPA, node
  auto-scaling, and pod restarts handle traffic spikes without human
  intervention.
- **Consistency across environments matters.** The same manifests run
  in dev, staging, and production with only configuration differences.

### When Kubernetes is overkill

- **Fewer than 5 services, team smaller than 8 engineers.** A simpler
  platform (ECS, Cloud Run, Railway, Render) provides 80% of the
  benefit with 20% of the complexity.
- **The team has no ops experience.** Operating Kubernetes requires
  understanding networking, RBAC, upgrades, etcd backup, and node
  management. Without this skill, the cluster becomes a liability.
- **Serverless fits the workload.** Event-driven, low-traffic, or
  bursty workloads often fit Lambda/Cloud Functions better — no idle
  resources, no cluster to maintain.
- **The startup is pre-product-market-fit.** Spending 6 months
  building a Kubernetes platform before validating the product is
  premature optimization.

**Decision framework for interviews:**

| Signal | Kubernetes | Simpler alternative |
| --- | --- | --- |
| <5 services, <8 engineers | Overkill | ECS/Fargate, Cloud Run |
| 10+ services, 3+ teams | Justified | — |
| Stateless microservices | Good fit | — |
| Single monolith | Overkill | A single VM or ECS service |
| Need GPU scheduling | Good fit | — |
| Event-driven, low traffic | Wrong tool | Lambda, Cloud Functions |
| Strict multi-tenancy | Good fit | — |
| No ops engineers on team | Risky | Managed PaaS |

**Practical usage:** The decision is not binary. Managed Kubernetes
(EKS, GKE, AKS) reduces operational burden significantly compared to
self-managed. EKS Fargate eliminates node management entirely. The
trade-off shifts from "Kubernetes vs not" to "how much of Kubernetes
do we need to manage ourselves."

**Common mistake:** Adopting Kubernetes because "everyone uses it"
without calculating total cost of ownership: engineer time learning
the platform, YAML maintenance, cluster upgrades, networking
complexity, debugging time. Another mistake: the reverse — refusing
Kubernetes at 20+ services and 5 teams because of past complexity
fears, while each team reinvents service discovery, scaling, and
deployment pipelines independently.

**Security consideration:** Simpler platforms (ECS, Cloud Run) have
smaller attack surfaces and fewer misconfiguration opportunities.
Kubernetes has a large API surface that requires RBAC, NetworkPolicy,
Pod Security Standards, and continuous patching. If security expertise
is limited, a simpler platform reduces risk.

**Operational consideration:** Track the "platform tax" — what
percentage of engineering time is spent on cluster operations vs
product development. If the platform team spends more than 20% of
total engineering capacity on Kubernetes maintenance, reevaluate
whether the complexity is justified by the workload.

**Tech Lead decision:** Frame the decision economically. Calculate:
(1) cost of platform engineers needed to operate Kubernetes, (2) cost
of managed alternatives (ECS/Fargate per-service), (3) developer
velocity impact (faster deploys on simpler platforms vs consistency
on Kubernetes). Kubernetes pays for itself at scale (50+ services,
5+ teams) where the platform amortizes across many consumers.

**Interview framing:** "Kubernetes is justified when the platform
cost is amortized across enough teams and services. For fewer than
5 services, managed container platforms (ECS, Cloud Run) provide
similar capabilities with less operational overhead. The decision
factors are: team count, service count, ops expertise, and whether
the workload benefits from Kubernetes-specific features (HPA, RBAC,
namespaces, custom operators)."

### GitOps

GitOps treats Git as the single source of truth for cluster state.
A controller (Argo CD, Flux) watches a Git repository and
continuously reconciles the cluster to match:

1. Engineer pushes manifest change to Git.
2. Argo CD detects the change.
3. Argo CD applies the change to the cluster.
4. Drift detection alerts if someone modifies the cluster directly.

**Benefits:** Audit trail (Git history), review process (PRs for
infra changes), rollback (Git revert). See
[CI/CD and DevOps](./17-ci-cd-and-devops.md) for pipeline
integration.

## Examples

### Production-ready Dockerfile for a Node.js service

```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --ignore-scripts
COPY tsconfig.json ./
COPY src ./src
RUN npm run build && npm prune --production

FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./
USER nonroot:nonroot
EXPOSE 3000
CMD ["dist/main.js"]
```

**What this does:** Two-stage build — the first stage installs all
dependencies, compiles TypeScript, then prunes dev dependencies. The
second stage uses a distroless base (no shell, no package manager)
and runs as non-root.

**Why it is useful:** Distroless images have ~10× fewer CVEs than
full OS images. No shell means an attacker who achieves RCE cannot
easily escalate. The non-root user prevents writing to most
filesystem paths.

**Common mistake:** Using `node:20` as the production base (includes
apt, curl, bash — full attack surface). Using `npm install` instead
of `npm ci` (non-deterministic, ignores lock file discrepancies).

**Production change:** Pin the base image by SHA digest for
reproducibility. Add `--mount=type=secret` for private registry auth.
Add labels for traceability (`org.opencontainers.image.revision`).

### Kubernetes Deployment with probes and resource management

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: team-alpha
spec:
  replicas: 3
  revisionHistoryLimit: 5
  selector:
    matchLabels:
      app: api
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: api
        version: v1.4.2
    spec:
      serviceAccountName: api-sa
      automountServiceAccountToken: false
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
      containers:
        - name: api
          image: registry.example.com/api:v1.4.2
          ports:
            - containerPort: 3000
          env:
            - name: NODE_ENV
              value: production
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: password
          resources:
            requests:
              cpu: 250m
              memory: 256Mi
            limits:
              cpu: 1000m
              memory: 512Mi
          livenessProbe:
            httpGet:
              path: /healthz
              port: 3000
            initialDelaySeconds: 10
            periodSeconds: 15
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /ready
              port: 3000
            periodSeconds: 5
            failureThreshold: 2
          startupProbe:
            httpGet:
              path: /healthz
              port: 3000
            failureThreshold: 30
            periodSeconds: 2
      topologySpreadConstraints:
        - maxSkew: 1
          topologyKey: topology.kubernetes.io/zone
          whenUnsatisfiable: DoNotSchedule
          labelSelector:
            matchLabels:
              app: api
```

**What this does:** A production Deployment with: non-root security
context, dedicated ServiceAccount with no auto-mounted token,
separate liveness/readiness/startup probes, resource requests and
limits, topology spread across availability zones, and zero
max-unavailable for zero-downtime deploys.

**Common mistake:** Omitting `topologySpreadConstraints` — all pods
land on the same node or zone. One zone failure takes down the
entire service.

**Production change:** Add PodDisruptionBudget to prevent voluntary
disruptions from draining too many pods simultaneously during
cluster upgrades.

**Tech Lead check:** Verify: security context enforces non-root,
resource requests match observed P95 usage, probes point to correct
endpoints (liveness ≠ readiness), image tag is immutable (not
`:latest`), and topology spread covers the failure domain.

### Service and Ingress for the API

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api
  namespace: team-alpha
spec:
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 3000
      protocol: TCP
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ingress
  namespace: team-alpha
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - api.example.com
      secretName: api-tls
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: api
                port:
                  number: 80
```

**What this does:** A ClusterIP Service routes internal traffic to
API pods on port 3000. The Ingress exposes it externally at
`api.example.com` with TLS (cert-manager auto-provisions
certificates), rate limiting (100 req/min), and forced HTTPS
redirect.

**Why it is useful:** Separates concerns: the Service handles
internal load balancing (pod discovery), the Ingress handles external
routing (TLS, rate limiting, path-based routing). New endpoints
require only an Ingress path rule — no infrastructure changes.

**Common mistake:** Creating one LoadBalancer Service per service
(each provisions a cloud LB at $15-25/month). A single Ingress
controller with multiple Ingress rules routes all traffic through
one LB. Another mistake: omitting `ingressClassName` — without it,
the cluster's default Ingress controller processes the rule, which
may not be what you intended.

**How this changes in production:** Add annotations for: connection
timeouts, body size limits, CORS headers, and canary routing. For
high-traffic services, consider dedicated Ingress controllers per
team (isolation). Migrate to Gateway API for more expressive routing.

**Tech Lead check:** Verify TLS is enforced (no plaintext), rate
limits match expected traffic, cert-manager is configured for
automatic renewal, and no wildcard paths expose internal services
unintentionally.

### ConfigMap and Secret for application configuration

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: api-config
  namespace: team-alpha
data:
  LOG_LEVEL: "info"
  FEATURE_NEW_CHECKOUT: "true"
  MAX_CONNECTIONS: "25"
  config.yaml: |
    server:
      port: 3000
      gracefulShutdownTimeout: 30s
    cache:
      ttl: 300s
      maxSize: 1000
---
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
  namespace: team-alpha
type: Opaque
stringData:
  username: api_service
  password: "${GENERATED_AT_DEPLOY_TIME}"
  connection-string: "postgres://api_service:${PASSWORD}@db.internal:5432/app?sslmode=require"
```

**What this does:** The ConfigMap stores non-sensitive config as both
key-value pairs (injected as env vars) and a structured file
(mounted as a volume). The Secret stores database credentials
separately with stricter RBAC.

**Why it is useful:** Configuration changes do not require image
rebuilds. The same image runs in dev, staging, and production with
different ConfigMaps. Secrets are access-controlled separately from
general config.

**Common mistake:** Putting passwords in ConfigMaps (no access
control difference from general config). Committing Secret YAML to
Git (base64 is encoding, not encryption). Using one giant ConfigMap
for all services in a namespace (no ownership, unclear what changed).

**How this changes in production:** Replace plain Secret YAML with
ExternalSecret (syncs from Vault/AWS Secrets Manager). Add
`config.yaml` hash annotation to the Deployment (triggers pod
restart on config change). Use Kustomize `configMapGenerator` for
automatic hash suffixes.

**Tech Lead check:** Verify: secrets are not committed to Git,
ConfigMap keys use consistent naming across services, sensitive
values use Secret (not ConfigMap), and a config reload mechanism
exists (Reloader, hash annotation, or application-level file watch).

### Helm values for environment-specific configuration

```yaml
# values-base.yaml (shared defaults)
replicaCount: 2
image:
  repository: registry.example.com/api
  tag: ""  # set by CI
  pullPolicy: IfNotPresent

resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    memory: 512Mi

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilization: 70

ingress:
  enabled: true
  host: ""  # set per environment
  tls: true
```

```yaml
# values-production.yaml (production overrides)
replicaCount: 3

resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    memory: 1Gi

autoscaling:
  minReplicas: 3
  maxReplicas: 20

ingress:
  host: api.example.com
  annotations:
    nginx.ingress.kubernetes.io/rate-limit: "500"

podDisruptionBudget:
  enabled: true
  minAvailable: 2

topologySpreadConstraints:
  enabled: true
```

**What this does:** A base values file defines sane defaults for all
environments. The production override increases resources, scaling
limits, and adds PDB and topology spread. CI deploys with:
`helm upgrade api ./chart -f values-base.yaml -f values-production.yaml --set image.tag=$GIT_SHA`.

**Why it is useful:** Shared base prevents drift between
environments. Production-specific values are explicit and
reviewable. New environments (staging, canary) only need a small
override file — not a full copy.

**Common mistake:** Duplicating the entire values file per
environment (100+ lines with 5 differences). When the base changes,
each copy must be updated — drift is inevitable. Another mistake:
setting `image.tag` in the values file instead of at deploy time
(forces a commit for every deploy).

**How this changes in production:** Add secret references via
`--set-string` from CI secrets (not in values files). Add
environment-specific annotations (monitoring, cost attribution).
Gate production deploys on successful staging deploy + test suite.

**Tech Lead check:** Verify: no secrets in values files, image tag
set dynamically by CI, production has PDB and topology spread, base
values match observed resource usage, and values changes go through
PR review (not manual `helm upgrade`).

### NetworkPolicy restricting egress

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-egress
  namespace: team-alpha
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes: [Egress]
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: postgres
      ports:
        - port: 5432
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - port: 53
          protocol: UDP
        - port: 53
          protocol: TCP
```

**What this does:** Restricts the API pod to only communicate with
PostgreSQL (port 5432) and DNS (required for service discovery).
All other egress is denied.

**Why it is useful:** Limits blast radius if the pod is compromised.
An attacker cannot make arbitrary outbound requests (prevents SSRF
and data exfiltration). See
[Security](./15-security.md) for defense-in-depth patterns.

## Common Mistakes

1. **Running containers as root**
   - Looks like: No `USER` instruction in Dockerfile, no
     `runAsNonRoot: true` in pod security context.
   - Why it is dangerous: Container escape exploits often require root.
     Root in the container can write to mounted volumes and
     potentially access host resources.
   - Correct approach: `USER nonroot` in Dockerfile +
     `runAsNonRoot: true` in pod spec + drop all capabilities.

2. **No resource requests or limits**
   - Looks like: Pods have BestEffort QoS class. No `resources`
     section in the container spec.
   - Why it is dangerous: One pod can consume all node memory,
     causing eviction of other pods (noisy neighbor). Scheduler
     cannot make informed decisions.
   - Correct approach: Set requests based on observed P95 usage.
     Set memory limits at 1.5-2× request. Never deploy without
     resources in production.

3. **Liveness probe checks external dependencies**
   - Looks like: Liveness endpoint calls the database or Redis.
   - Why it is dangerous: External service goes down → liveness
     fails → pod restarts → reconnects to still-down service →
     fails again → restart loop. Cascading failure.
   - Correct approach: Liveness checks internal health only (is
     the process alive?). Readiness checks if the pod can serve
     traffic (including dependency availability).

4. **Using `latest` tag in production**
   - Looks like: `image: myapp:latest` in Deployment manifests.
   - Why it is dangerous: `:latest` is mutable — it can point to
     different images. Rollbacks are impossible (which version was
     "latest" yesterday?). Different nodes may pull different
     versions.
   - Correct approach: Immutable tags (semver or git SHA). Set
     `imagePullPolicy: IfNotPresent` for immutable tags.

5. **Storing secrets in ConfigMaps**
   - Looks like: Database passwords in ConfigMap, not Secret.
   - Why it is dangerous: ConfigMaps have no special access
     restrictions. They appear in `kubectl get configmap -o yaml`
     for anyone with basic RBAC access.
   - Correct approach: Use Secrets with encryption at rest. Better:
     use External Secrets Operator with a secrets manager (Vault,
     AWS Secrets Manager).

6. **No PodDisruptionBudget**
   - Looks like: Cluster upgrade drains a node and takes down all
     replicas of a service simultaneously.
   - Why it is dangerous: Voluntary disruptions (upgrades, node
     scaling) can cause downtime if all pods are on one node.
   - Correct approach: `PodDisruptionBudget` with
     `minAvailable: 2` or `maxUnavailable: 1`.

7. **Treating kubectl apply as the source of truth**
   - Looks like: Engineers manually run `kubectl apply` from their
     laptops. No GitOps, no CI/CD.
   - Why it is dangerous: No audit trail, no review process, no
     rollback mechanism. "Who changed production at 2am?" has no
     answer.
   - Correct approach: GitOps (Argo CD, Flux). All changes go
     through Git PRs. Direct cluster modification triggers drift
     alerts.

8. **Over-provisioning for "safety"**
   - Looks like: Every pod requests 4 CPU and 8Gi memory "just in
     case." Cluster has 20 nodes but uses 10% of capacity.
   - Why it is dangerous: Wasted cloud spend (40-60% over-provision
     is common). Resources reserved but unused prevent other pods
     from scheduling.
   - Correct approach: Monitor actual usage (Prometheus, kubectl top,
     Goldilocks). Right-size based on P95 actual consumption. Use
     VPA recommendations as input.

## Trade-offs

| Decision | Optimizes for | Sacrifices | Flips when |
| --- | --- | --- | --- |
| **Managed K8s (EKS/GKE/AKS)** | Ops simplicity, control plane reliability | Flexibility, cost (managed fee) | Team has deep K8s expertise and needs control |
| **Self-managed K8s** | Full control, no vendor lock-in | Ops burden (upgrades, etcd, HA) | Team is too small to maintain it |
| **ECS/Fargate** | Simplicity, AWS integration | Portability, community ecosystem | Service count grows beyond 15, need multi-cloud |
| **Serverless (Lambda)** | Zero ops, pay-per-invocation | Cold starts, vendor lock-in, duration limits | Workload is long-running or latency-sensitive |
| **Helm** | Reusable packages, community charts | Templating complexity, debugging difficulty | Team owns all manifests and does not distribute charts |
| **Kustomize** | Simplicity, no templating language | No parameterization for external users | Charts must be shared with other teams or open-source |
| **StatefulSet** | Stable identity, ordered operations | Operational complexity, scaling friction | Workload is truly stateless |
| **DaemonSet** | One-per-node guarantee | No horizontal scaling (tied to node count) | Only a subset of nodes need the agent |

## Production Considerations

- **Security.** Images scanned in CI (Trivy, Grype). Non-root pods.
  RBAC with least privilege. Network policies deny by default.
  Secrets encrypted at rest. Pod Security Standards enforced
  (restricted profile). Service mesh for mTLS between services. See
  [Security](./15-security.md) for container and cloud security
  patterns.
- **Performance and scalability.** HPA configured for all
  user-facing services. Node autoscaler (Cluster Autoscaler,
  Karpenter) sized for burst capacity. Resource requests based on
  actual P95 usage, not guesses. CPU limits set with care (excessive
  throttling degrades latency).
- **Reliability and on-call.** PodDisruptionBudgets prevent
  voluntary disruptions from causing outages. Topology spread
  constraints distribute pods across zones. etcd backups run hourly.
  Runbooks exist for common pod states (CrashLoopBackOff,
  OOMKilled, Pending). Cluster upgrades follow the version skew
  policy (kubelet within 2 minor versions of API server).
- **Maintainability.** GitOps (Argo CD or Flux) for all manifest
  changes. Helm or Kustomize (not both) for templating.
  Standardized labels (app, version, team, tier) on all resources.
  Namespace-per-team structure documented and enforced.
- **Cost.** Cost visibility by namespace (Kubecost, OpenCost). Spot
  instances for stateless workloads (with proper PDBs and topology
  spread). Right-sizing reviews quarterly. Idle resource alerting.
  Node consolidation (Karpenter) reduces under-utilized nodes.
- **Team and hiring.** Kubernetes literacy varies widely. Provide
  an internal platform abstraction (templates, CI pipelines, golden
  paths) so application developers need minimal Kubernetes
  knowledge. Hire at least one platform engineer with deep K8s
  expertise per 30-50 application developers.
- **Vendor and version lock-in.** EKS, GKE, AKS have divergent
  networking (VPC CNI vs Calico vs Cilium), IAM integration (IRSA
  vs Workload Identity), and add-on lifecycle. Minimize
  cloud-specific annotations. Test portability if multi-cloud is a
  stated goal.
- **Migration and rollback.** Cluster upgrades are one-way (no
  downgrade). Test upgrades in a staging cluster first. Blue/green
  cluster migration (spin up new version, migrate workloads, tear
  down old) is safest for major versions. See
  [AWS](./04-aws.md) for EKS-specific upgrade patterns.

## How to Explain This in an Interview

Three openings:

1. *"Kubernetes is a declarative reconciliation system. You describe
   desired state in YAML — 'I want 3 replicas of this container with
   these resources' — and controllers continuously push the cluster
   toward that state. If a pod dies, the ReplicaSet controller notices
   the deviation and creates a replacement. If a node fails, the
   scheduler places orphaned pods on healthy nodes. The key insight is
   that it is never 'done' — it is always reconciling."* — for
   general "explain Kubernetes" questions.

2. *"I think about Kubernetes decisions in three layers. First: should
   we use it at all? (service count, team size, ops maturity). Second:
   how do we operate it safely? (resource management, probes, RBAC,
   upgrade cadence). Third: how do we make it invisible to app
   developers? (platform abstractions, golden paths, CI templates)."*
   — for Tech Lead decision questions.

3. *"For Docker, the key production concern is image hygiene: minimal
   base images (distroless or Alpine), multi-stage builds to separate
   build tools from production, non-root execution, and immutable
   tags. A well-built image has fewer CVEs, starts faster, and is
   easier to debug because it contains only what it needs."* — for
   container-specific questions.

## Tech Lead Decision-Making

### Kubernetes adoption strategy

**What a Senior Engineer usually knows:** Kubernetes architecture,
writing Deployments, using kubectl, understanding probes and
resources.

**What a Tech Lead is expected to decide:** Whether to adopt
Kubernetes at all, when to migrate, how to sequence the migration,
and how to manage organizational risk during the transition.

**Adoption decision framework:**

| Factor | Adopt Kubernetes | Stay on simpler platform |
| --- | --- | --- |
| Services | 10+ services, growing | <5 services, stable |
| Teams | 3+ teams deploying independently | 1 team, shared release cycle |
| Ops skill | Platform engineer on team or planned | No dedicated ops, no hiring plan |
| Scaling needs | Auto-scaling, multi-region, self-healing | Fixed traffic, single region |
| Compliance | Multi-tenancy isolation, audit trails needed | Single-tenant, minimal compliance |
| Budget | Can justify 1-2 FTE for platform | Cannot absorb platform overhead |

**Migration sequence (not big-bang):**
1. **Prove value:** Migrate one stateless service. Learn
   operationally without risking the business.
2. **Build golden path:** After the first service, create templates
   (Helm chart or Kustomize base) that encode all production
   standards.
3. **Batch migrate stateless services:** Move remaining stateless
   services in batches of 2-3. Each batch validates the golden path.
4. **Evaluate stateful services last:** Databases and message brokers
   are the hardest to migrate. Default to managed services (RDS) unless
   portability is a hard constraint.
5. **Parallel run:** Keep old infrastructure running until the
   Kubernetes version handles production traffic for 2+ weeks without
   incident.
6. **Decommission:** Tear down old infrastructure only after rollback
   is no longer needed.

**Rollback plan:** Kubernetes migrations must be reversible. Keep DNS
pointing to old infrastructure during parallel-run. If Kubernetes
version fails, switch traffic back via DNS or load balancer. Never
decommission old infra until the new platform is proven.

**Interview framing:** "I approach Kubernetes adoption as a
multi-sprint investment, not a weekend migration. I start with one
service to learn operationally, build templates from that experience,
then batch-migrate stateless services. Stateful services come last —
or stay on managed services. The critical rule: parallel-run with
rollback capability at every stage."

### Operational ownership model

**The ownership question every Tech Lead must answer:** Who is
responsible for what in a Kubernetes environment?

| Responsibility | Platform team | Application team | Tech Lead |
| --- | --- | --- | --- |
| Cluster lifecycle (upgrades, nodes) | Owns | — | Approves schedule |
| Security baseline (admission, scanning) | Owns | — | Defines requirements |
| Namespace provisioning | Owns | Requests | Reviews quotas |
| Deployment manifests | Provides templates | Customizes within guardrails | Reviews standards |
| Resource requests/limits | Sets defaults | Adjusts per service | Reviews quarterly |
| Probes | Provides examples | Implements per service | Audits correctness |
| On-call for pod failures | Escalation for cluster issues | First responder for their services | Sets escalation policy |
| Cost | Provides tooling | Accountable for their namespace spend | Sets budgets, reviews trend |
| CI/CD pipeline | Provides template | Extends for their needs | Approves architectural changes |

**Common failure:** No clear ownership model. Application teams say
"that's a platform problem." Platform team says "that's application
config." Pods crash on Friday night with no clear responder. The Tech
Lead prevents this by publishing a written RACI and including it in
on-call rotation documentation.

**What a Senior Engineer usually knows:** How to deploy their service,
how to read pod logs, how to set resources.

**What a Tech Lead is expected to decide:** Who owns which failure
mode, how on-call rotations work across platform and application
teams, and how to escalate without blame.

**Interview framing:** "I define a clear contract between platform
and application teams. The platform provides: a working cluster,
secure defaults, and golden path templates. Application teams
provide: correct probes, appropriate resource requests, and on-call
for their services. The Tech Lead bridges the gap: reviewing
quarterly whether the platform serves the teams and whether teams
follow platform standards."

### Cost governance

**Why this is a Tech Lead responsibility:** Engineers optimize for
reliability and correctness. Nobody naturally optimizes for cost.
Without governance, Kubernetes clusters accumulate waste: over-
provisioned services, zombie namespaces, and idle capacity.

**Cost governance framework:**

1. **Visibility:** Deploy Kubecost/OpenCost. Attribute spend to
   teams via namespace labels. Publish a weekly cost report to
   engineering leadership. If nobody sees the cost, nobody owns it.
2. **Budgets:** Each team gets a resource budget (CPU/memory quota
   per namespace). Alerts fire at 80% of budget. Exceeding budget
   requires a conversation (not automatic blocking — that causes
   outages).
3. **Right-sizing cadence:** Quarterly review comparing resource
   requests to actual P95 usage. Top-5 over-provisioned services
   get right-sizing tickets. Use VPA in recommendation mode to
   generate suggestions automatically.
4. **Spot/preemptible strategy:** Stateless services on spot
   instances (50-70% savings). Stateful services on on-demand.
   PDBs and topology spread ensure spot termination does not cause
   outages.
5. **Idle detection:** Alert on namespaces with <10% utilization
   for 7+ days. Alert on Deployments with zero traffic but non-zero
   replicas.

**Stakeholder explanation:** "Our Kubernetes cluster costs
$X/month. 60% is compute, 25% is data transfer, 15% is storage. The
primary savings lever is right-sizing — our services currently
request 3× what they actually use. I am implementing quarterly
reviews and automated recommendations. Target: 30% cost reduction
without reliability impact within 6 months."

**Common overengineering trap:** Building a custom cost optimization
tool instead of deploying Kubecost. Writing Prometheus queries to
calculate cost instead of using OpenCost. The Tech Lead's job is
adopting existing tools, not building bespoke solutions for solved
problems.

### Communicating container decisions to non-technical stakeholders

**Situation:** Product leadership asks why you need a "Kubernetes
platform" that requires 2 engineers to maintain.

**Framework for explanation:**

1. **Start with the problem, not the technology:** "We deploy 20
   services. Each deployment used to require manual coordination,
   took 45 minutes, and failed 1 in 5 times. Kubernetes automates
   this: deploys happen in 3 minutes with automatic rollback."
2. **Quantify the value:** "Before Kubernetes: 4 hours of engineer
   time per deploy × 50 deploys/week = 200 hours/week. After: 15
   minutes per deploy × 50 = 12.5 hours/week. Net savings: 187
   hours/week of engineer time."
3. **Name the alternative:** "Without the platform, each team builds
   their own deployment system. That is 5 teams × 2 weeks of setup
   = 10 engineer-weeks duplicated. The platform centralizes this
   investment."
4. **Acknowledge the cost honestly:** "The platform requires 2
   engineers to maintain. It saves 8+ engineers' time weekly. The
   return is clear at our scale."

**Interview framing:** "I frame platform investments in terms of
developer-hours saved, deploy frequency enabled, and incident
reduction — not in terms of technology. Non-technical stakeholders
care about velocity and risk, not about Kubernetes itself."

### Common overengineering traps

| Trap | Symptom | Right-sized alternative |
| --- | --- | --- |
| Kubernetes for 3 services | 2 engineers maintaining the cluster, 3 services running on it | ECS/Fargate or Cloud Run |
| Service mesh for 5 services | Istio sidecars consume more resources than the services themselves | Direct service-to-service calls with retry libraries |
| Custom operator for simple config | 3 months building an operator for something Kustomize could do | ConfigMap + Reloader |
| Multi-cluster for isolation | 3 clusters, 1 platform engineer (overloaded) | Namespaces + RBAC + NetworkPolicies |
| Canary for every service | Argo Rollouts for internal tools with 10 users | Rolling updates with readiness probes |
| Helm chart library for 3 services | Shared chart with 500 lines of Go templates for 3 consumers | Simple Kustomize base |

**Decision heuristic:** If the solution requires more infrastructure
than the problem it solves, it is overengineered. The Tech Lead's
job is recognizing this before the investment is made — not after 3
months of development.

**Interview framing:** "I evaluate platform investments by asking:
how many consumers justify this? A Helm chart library is worth it at
15+ services. A service mesh is worth it at 20+ services with
cross-service security requirements. Below those thresholds, simpler
alternatives provide 90% of the value at 10% of the cost."

### Local development vs production divergence

**The problem:** Docker Compose runs the development stack. Kubernetes
runs production. The gap between them causes "works locally, fails in
production" bugs.

**Sources of divergence:**

| Layer | Local (Compose) | Production (K8s) | Failure mode |
| --- | --- | --- | --- |
| Networking | Service names resolve via Compose DNS | Service names resolve via K8s DNS + NetworkPolicies | Works locally, blocked by NetworkPolicy in prod |
| Config | `.env` file with all vars | ConfigMaps + Secrets | Missing env var in prod (not in ConfigMap) |
| Storage | Bind mounts | PVCs (EBS, EFS) | Permissions, path differences |
| Resources | No limits | Requests + limits | OOMKilled in prod (works locally with 16GB RAM) |
| Probes | Docker HEALTHCHECK | K8s liveness/readiness | App starts in dev but fails readiness in prod |
| Dependencies | Embedded (Redis, PostgreSQL in Compose) | Managed services (ElastiCache, RDS) | Connection strings, SSL requirements differ |

**Mitigation strategy:**
1. **Parity in structure:** Compose services mirror Kubernetes
   services. Same env var names, same port numbers, same healthcheck
   endpoints.
2. **Test in a K8s-like environment:** Use Tilt, Skaffold, or
   DevSpace for inner-loop development that deploys to a local Kind
   cluster (not just Compose). This catches NetworkPolicy and probe
   issues before production.
3. **Shared config schema:** Validate env vars at startup. If a
   required var is missing, fail fast with a clear error (not a
   cryptic null pointer 5 minutes after boot).
4. **Resource limits in dev:** Optional but valuable: set Docker
   Compose resource limits to match production. Catches memory leaks
   and unbounded allocations early.

**Tech Lead decision:** The tradeoff is developer experience vs
production fidelity. Compose is simpler (fast startup, easy
debugging). Kind/Tilt is more accurate (catches more prod issues).
Default to Compose for most developers, provide Kind-based workflow
for testing production-specific behaviors (probes, resources,
NetworkPolicies) before merge.

### Incident response for container and cluster failures

**What a Senior Engineer does during an incident:** Checks pod logs,
restarts failing pods, increases resources if OOMKilled.

**What a Tech Lead does during and after an incident:**
1. **During:** Establishes incident commander, ensures communication
   (status page, Slack channel), prevents multiple engineers from
   making conflicting changes.
2. **Root cause classification:** Was this a platform failure (node
   crash, etcd issue, networking) or an application failure (bad
   deploy, memory leak, misconfigured probe)? This determines who
   leads the resolution.
3. **Post-incident:** Facilitates blameless retrospective. Identifies
   whether the failure was preventable by: better probes, tighter
   resource limits, admission policies, or improved golden path.
4. **Systemic fix:** Converts incident learnings into platform
   improvements. If a bad probe caused cascading restarts, update
   the golden path to enforce liveness ≠ readiness by default.

**Interview framing:** "During container incidents, the Tech Lead's
job is coordination, not debugging. I establish a commander, separate
platform vs application responsibility, and ensure post-incident
fixes are systemic (policy changes, template updates) rather than
one-off patches to a single service."

## Good Answer vs Weak Answer

**Question**: *When would you choose Kubernetes over a simpler
container platform like ECS/Fargate for a growing startup?*

**Strong Answer**

I evaluate three factors. First, service count and team count: if we
have fewer than 5 services and one team, ECS/Fargate is simpler —
less YAML, no cluster management, and AWS handles scheduling.
Kubernetes overhead is not justified. Second, if we have 10+ services
across 3+ teams, Kubernetes provides a shared platform: namespaces
for isolation, RBAC for access control, and HPA for scaling — all
consistent regardless of which team deploys. Third, operational
readiness: Kubernetes requires at least one engineer who understands
networking, RBAC, upgrades, and debugging. If the team does not have
this skill and is not hiring for it, ECS is the safer choice. My
rule: the complexity tax of Kubernetes is only worth paying when the
complexity of managing individual services exceeds it.

**Weak Answer**

Kubernetes is the industry standard, so we should use it. It handles
everything automatically — scaling, deployments, networking. ECS is
vendor-locked to AWS, so Kubernetes is better for portability.

**Why the Strong Answer Wins**

- Names specific conditions (service count, team count, skill).
- Acknowledges Kubernetes has a cost (complexity tax).
- Provides a decision framework, not a blanket recommendation.
- Shows awareness of team capabilities and operational readiness.
- Avoids the portability fallacy (most teams never actually
  multi-cloud).

## Tech Lead Checklist

### Resource management

- [ ] Every production pod has CPU and memory requests. Owner:
      application team (reviewed by platform team).
- [ ] Memory limits set at 1.5-2× request. Owner: application team.
- [ ] HPA configured for all user-facing services with appropriate
      metrics. Owner: application team + platform team.
- [ ] Cluster Autoscaler or Karpenter configured and tested. Owner:
      platform team.
- [ ] Resource usage reviewed quarterly against actual consumption.
      Owner: Tech Lead.

### Reliability

- [ ] All pods have liveness, readiness, and startup probes. Liveness
      does NOT check external dependencies. Owner: application team.
- [ ] PodDisruptionBudgets exist for all services with >1 replica.
      Owner: application team.
- [ ] TopologySpreadConstraints distribute pods across zones. Owner:
      application team.
- [ ] etcd backup runs hourly, tested monthly. Owner: platform team.
- [ ] Cluster upgrade plan exists, follows version skew policy,
      tested in staging first. Owner: platform team + Tech Lead.

### Security

- [ ] All pods run as non-root (`runAsNonRoot: true`). Owner:
      platform team (admission controller enforces).
- [ ] Images scanned in CI. Critical CVEs block deployment. Owner:
      pipeline.
- [ ] RBAC follows least privilege. No `cluster-admin` for
      application teams. Owner: platform team.
- [ ] NetworkPolicies restrict egress by default. Owner: platform
      team.
- [ ] Secrets managed via External Secrets Operator or sealed
      secrets (not plain Secrets in Git). Owner: platform team.

### Operations

- [ ] GitOps controller (Argo CD or Flux) is the single path to
      production. No manual `kubectl apply`. Owner: platform team.
- [ ] Cost dashboard (Kubecost/OpenCost) shows spend per namespace
      and team. Owner: platform team + Tech Lead.
- [ ] On-call runbook covers CrashLoopBackOff, OOMKilled, Pending,
      ImagePullBackOff, and node NotReady. Owner: SRE/on-call team.
- [ ] Namespace-per-team with ResourceQuotas preventing one team
      from starving others. Owner: platform team.

## Interview Questions and Answers

### Basic

**Question:** What is the difference between a container and a virtual machine?

**Answer:** A VM virtualizes hardware — each VM runs a full OS kernel
on a hypervisor. A container virtualizes the OS — it shares the host
kernel but uses Linux namespaces (PID, network, mount) and cgroups
(CPU, memory limits) for isolation. Containers start in milliseconds
(just a process), VMs in seconds-to-minutes (booting an OS). The
security boundary differs: a kernel exploit can escape a container
but not a VM.

---

**Question:** What is a Docker image layer?

**Answer:** Each Dockerfile instruction (RUN, COPY, ADD) creates a
filesystem diff stored as a layer. Layers are content-addressed
(SHA256), immutable, and shared between images. If two images use the
same base layer, it is stored and pulled once. Layer ordering matters
for build cache — put frequently changing instructions at the bottom.

---

**Question:** What is a Pod in Kubernetes?

**Answer:** The smallest deployable unit — one or more containers
sharing a network namespace (same IP, communicate via localhost) and
storage volumes. Most pods have one container. Multi-container pods
use the sidecar pattern (log forwarder, envoy proxy, config
reloader). Pods are ephemeral — they are never rescheduled; controllers
create replacements.

---

**Question:** What is the difference between a Deployment and a StatefulSet?

**Answer:** A Deployment manages stateless pods — they are
interchangeable, have random names (pod-xyz-abc), and share no
persistent identity. A StatefulSet gives each pod a stable hostname
(pod-0, pod-1), ordered creation/deletion, and stable persistent
storage (each pod keeps its PVC across restarts). Use StatefulSets
for databases, Kafka, Elasticsearch — workloads where identity and
storage persistence matter.

---

**Question:** What is a Kubernetes Service?

**Answer:** A stable network abstraction over ephemeral pods. Pods
die and get new IPs. A Service provides a fixed ClusterIP and DNS
name, and load-balances traffic to pods matching its label selector.
Types: ClusterIP (internal), NodePort (external via node port),
LoadBalancer (cloud LB), ExternalName (DNS alias).

---

**Question:** What does `kubectl describe pod` show that `kubectl get pod` does not?

**Answer:** `describe` shows events (scheduling decisions, image
pulls, probe failures, OOM kills), conditions (Ready, Initialized,
PodScheduled), container states with exit codes, resource
requests/limits, mounted volumes, and node assignment. It is the
first debugging command for any pod issue.

---

**Question:** What is the difference between a ConfigMap and a Secret?

**Answer:** Both are key-value stores injected into pods. ConfigMaps
hold non-sensitive configuration. Secrets hold sensitive data
(passwords, tokens, certificates). Secrets are base64-encoded (not
encrypted by default), have stricter RBAC defaults, and can be
encrypted at rest with EncryptionConfiguration. Neither should be
committed to Git in plain text.

---

**Question:** What is an Ingress?

**Answer:** A layer-7 (HTTP) routing rule that maps external
hostnames and URL paths to internal Services. It requires an Ingress
controller (nginx-ingress, Traefik, AWS ALB) to implement the
routing. Without a controller, Ingress resources are inert.
Ingress handles TLS termination, virtual hosting, and path-based
routing.

---

**Question:** What is a Namespace?

**Answer:** A virtual cluster within a physical cluster. Namespaces
provide: RBAC boundary (Roles are namespace-scoped), resource quotas
(limit CPU/memory per namespace), network policy boundaries, and
logical separation between teams or environments. Production
workloads should not run in the `default` namespace.

---

**Question:** What is a multi-stage Docker build?

**Answer:** A Dockerfile with multiple `FROM` instructions. Each
stage is a separate build environment. The final stage copies only
production artifacts from previous stages. Benefit: the production
image contains no build tools, no dev dependencies, no source code —
smaller size, fewer CVEs, and faster startup.

---

**Question:** What are resource requests and limits in Kubernetes?

**Answer:** Requests are the guaranteed minimum — the scheduler uses
them to find a node with capacity. Limits are the enforced maximum —
exceeding memory limits causes OOM-kill; exceeding CPU limits causes
throttling. Requests determine scheduling; limits determine enforcement.
The ratio between them determines the QoS class (Guaranteed,
Burstable, BestEffort).

---

**Question:** What is the purpose of `.dockerignore`?

**Answer:** It excludes files from the Docker build context. Without
it, `docker build` sends everything (node_modules, .git, test
fixtures, .env files) to the daemon — slowing builds and risking
secret leakage into image layers. It is analogous to `.gitignore`
for Docker builds.

---

**Question:** What is a DaemonSet?

**Answer:** A DaemonSet ensures exactly one pod runs on every node
(or a subset selected by nodeSelector/affinity). Use cases: log
collectors (Fluent Bit), monitoring agents (Prometheus node-exporter),
CNI plugins, storage drivers. When a new node joins, the DaemonSet
automatically schedules a pod on it.

---

**Question:** What is Helm?

**Answer:** A package manager for Kubernetes. Helm charts are
parameterized YAML templates (Go templating). They allow versioning,
dependency management, and reuse of Kubernetes manifests. Community
charts exist for PostgreSQL, Redis, Prometheus, Grafana. Trade-off:
Go templating adds complexity and makes debugging harder (`helm
template` renders locally for review).

---

**Question:** What is the difference between liveness, readiness, and startup probes?

**Answer:** Startup probe: runs during initialization — delays
liveness/readiness until the app is ready (for slow-starting apps).
Liveness probe: detects deadlocks — failure restarts the container.
Readiness probe: detects inability to serve — failure removes the
pod from Service endpoints (no traffic routed). Critical rule: never
check external dependencies in liveness probes.

---

**Question:** What is a Docker volume, and how does it differ from a bind mount?

**Answer:** A Docker volume is a Docker-managed filesystem stored
outside the container's writable layer (typically under
`/var/lib/docker/volumes/`). A bind mount maps a specific host path
into the container. Volumes are portable (work across hosts), support
named references, and are managed via `docker volume` commands. Bind
mounts depend on host filesystem structure — useful for development
(live code reload) but fragile in production.

---

**Question:** What is RBAC in Kubernetes?

**Answer:** Role-Based Access Control — the authorization layer that
controls who can do what to which resources. It consists of: Roles
(define permissions within a namespace), ClusterRoles (cluster-wide
permissions), RoleBindings (grant a Role to a user/group/
ServiceAccount within a namespace), and ClusterRoleBindings (grant a
ClusterRole cluster-wide). Production rule: least privilege — no
application team needs cluster-admin.

---

**Question:** What is a PersistentVolumeClaim (PVC)?

**Answer:** A request for storage by a pod. The PVC specifies: access
mode (ReadWriteOnce, ReadOnlyMany, ReadWriteMany), storage class
(defines the provisioner — EBS, EFS, Ceph), and size. Dynamic
provisioning creates the underlying PersistentVolume automatically.
PVCs decouple storage lifecycle from pod lifecycle — data survives
pod restarts and rescheduling.

---

**Question:** What is the difference between `COPY` and `ADD` in a Dockerfile?

**Answer:** `COPY` copies files from the build context into the
image. `ADD` does the same but also supports URL fetching and
automatic tar extraction. Best practice: always use `COPY` unless
you specifically need tar extraction. `ADD` with URLs is unpredictable
(no checksum verification, no caching control). Explicit `COPY` +
`RUN curl` is more transparent and cacheable.

---

**Question:** What is a Kubernetes controller?

**Answer:** A control loop that watches the desired state (stored in
etcd) and continuously reconciles actual state toward it. Examples:
Deployment controller (ensures correct replica count), ReplicaSet
controller (creates/deletes pods), Job controller (runs to
completion), Node controller (monitors node health). The controller
pattern is Kubernetes' core design principle — declarative, eventually
consistent, self-healing.

---

**Question:** What happens when you run `docker build`?

**Answer:** (1) Docker client sends the build context (all files not
in `.dockerignore`) to the daemon. (2) The daemon processes each
Dockerfile instruction sequentially. (3) Each instruction creates a
new layer (filesystem diff). (4) For `RUN` instructions, Docker
creates a temporary container, executes the command, and commits the
result as a new layer. (5) BuildKit (default since Docker 23) adds
parallelism, better caching, and secret mounting.

---

**Question:** What is the difference between `CMD` and `ENTRYPOINT` in a Dockerfile?

**Answer:** `ENTRYPOINT` defines the executable that always runs.
`CMD` provides default arguments to `ENTRYPOINT` (or the default
command if no ENTRYPOINT is set). Together: `ENTRYPOINT ["node"]` +
`CMD ["server.js"]` runs `node server.js` by default, but `docker
run myimage worker.js` overrides only the CMD (runs `node
worker.js`). Use ENTRYPOINT for the fixed binary, CMD for
overridable arguments.

---

**Question:** What is a Kubernetes label, and how does it differ from an annotation?

**Answer:** Labels are key-value pairs used for identification and
selection — Services, Deployments, and NetworkPolicies use label
selectors to target pods. Annotations are key-value metadata not
used for selection — they store build info, monitoring config, or
Ingress controller hints. Labels are indexed (fast lookup);
annotations are not. Labels should be concise; annotations can hold
larger payloads.

---

**Question:** What is `imagePullPolicy` and when does it matter?

**Answer:** Controls when kubelet pulls the container image.
`Always`: pull on every pod start (ensures latest version, slower
start). `IfNotPresent`: use cached image if available (faster, but
stale if tag is mutable). `Never`: never pull (only use pre-loaded
images). Critical rule: `:latest` tag forces `Always` by default.
Immutable tags (semver, git SHA) with `IfNotPresent` is the
production pattern — fast starts and deterministic versions.

---

**Question:** What is a PodDisruptionBudget (PDB)?

**Answer:** A policy that limits how many pods of a Deployment can be
simultaneously unavailable during voluntary disruptions (node drains,
cluster upgrades, autoscaler scale-down). Specified as `minAvailable`
or `maxUnavailable`. Without PDB, a node drain can terminate all
replicas at once. PDB does not protect against involuntary disruptions
(node crash, OOM-kill) — only voluntary ones initiated by the cluster.

---

**Question:** What is a Docker network, and what types exist?

**Answer:** Docker networks provide isolated communication between
containers. Types: `bridge` (default — containers on same host
communicate via virtual bridge), `host` (container shares host
network stack — no isolation), `overlay` (multi-host communication
in Swarm/Docker Compose clusters), `none` (no networking — complete
isolation). Custom bridge networks enable DNS-based container
discovery by name.

---

**Question:** What is the difference between `docker stop` and `docker kill`?

**Answer:** `docker stop` sends SIGTERM (graceful shutdown signal),
waits a timeout (default 10s), then sends SIGKILL if the process has
not exited. `docker kill` sends SIGKILL immediately (no graceful
shutdown). Production containers should handle SIGTERM (drain
connections, finish work, close cleanly). `docker kill` is for hung
containers that ignore SIGTERM.

---

**Question:** What is a Kubernetes Job, and how does it differ from a Deployment?

**Answer:** A Job runs pods to completion (exit code 0) rather than
keeping them running indefinitely. Use cases: database migrations,
batch processing, one-time scripts. CronJobs schedule Jobs
periodically. Deployments keep pods running forever (restart on
failure); Jobs track completion (restart only on failure until
success count is met). Jobs have `backoffLimit` (max retries) and
`activeDeadlineSeconds` (timeout).

---

**Question:** What is container image tagging best practice for production?

**Answer:** Use immutable, descriptive tags: git SHA
(`myapp:abc123f`), semver (`myapp:1.4.2`), or build ID
(`myapp:build-4521`). Never use `:latest` in production — it is
mutable and provides no rollback target. Pin base images by digest
(`node:20-alpine@sha256:...`) for reproducibility. Set
`imagePullPolicy: IfNotPresent` with immutable tags for fast pod
startup.

---

**Question:** What is the Horizontal Pod Autoscaler (HPA)?

**Answer:** A controller that adjusts Deployment replica count based
on observed metrics. Default metric: CPU utilization (requires
metrics-server). Custom metrics (request rate, queue depth, latency)
require Prometheus Adapter. Key parameters: `minReplicas` (floor),
`maxReplicas` (ceiling), target utilization (70% typical).
Scale-down includes a stabilization window (default 5 minutes) to
prevent flapping.

---

### Senior

**Question:** How do you configure resource requests and limits to balance cost and reliability?

**Answer:** Start by observing actual usage (Prometheus metrics, `kubectl top`, VPA recommendations). Set CPU request to P50 usage and memory request to P95 usage (memory is not compressible — OOM is worse than CPU throttling). Set memory limit at 1.5-2× request for spike headroom. CPU limits are controversial — some teams omit them to avoid throttling (Burstable QoS). Review quarterly: over-requesting wastes money (idle reserved resources); under-requesting causes evictions and scheduling failures.

---

**Question:** How do you design a zero-downtime deployment strategy?

**Answer:** Use RollingUpdate with `maxUnavailable: 0` (no pod removed until new one is ready). Ensure readiness probes pass only after the app is fully initialized and can serve traffic. Add `preStop` lifecycle hook with a sleep (5-10 seconds) to allow load balancers to deregister the pod before it terminates. Set `terminationGracePeriodSeconds` long enough for in-flight requests to complete. Add PodDisruptionBudget (`minAvailable: N-1`) for voluntary disruptions like node drains.

---

**Question:** When would you choose a StatefulSet over a Deployment?

**Answer:** When the workload requires: (1) stable network identity — each pod needs a predictable hostname (pod-0, pod-1) for cluster formation (Kafka brokers, Elasticsearch nodes). (2) Ordered startup/shutdown — database replicas must start primary first, then secondaries. (3) Stable persistent storage — each pod has its own PVC that survives pod rescheduling. Trade-off: StatefulSets are harder to scale (ordered operations are slow), harder to update (rolling update goes one-by-one), and cannot easily rebalance across nodes.

---

**Question:** How do you handle secrets in Kubernetes without committing them to Git?

**Answer:** Layer 1: External Secrets Operator syncs secrets from AWS Secrets Manager, Vault, or GCP Secret Manager into Kubernetes Secret objects. The Git repo contains ExternalSecret resources (metadata only, not values). Layer 2: Enable encryption at rest for etcd (EncryptionConfiguration with KMS provider). Layer 3: RBAC restricts Secret read access per namespace. Layer 4: Audit logging tracks who accessed which secrets. Never base64-encode secrets in Git — anyone can decode them.

---

**Question:** How do you troubleshoot a pod stuck in `Pending` state?

**Answer:** (1) `kubectl describe pod` — check Events section for scheduling failures. (2) Common causes: insufficient resources (no node can fit the request), unbound PVC (StorageClass misconfigured), unsatisfied affinity/anti-affinity, taint without toleration, or exceeded ResourceQuota. (3) Check node capacity: `kubectl describe nodes | grep -A5 Allocated`. (4) If resource-bound: reduce requests, add nodes, or enable cluster autoscaler. (5) If taint-bound: add toleration or remove taint.

---

**Question:** How does the Kubernetes scheduler decide where to place a pod?

**Answer:** Two phases: (1) Filtering — eliminates nodes that cannot run the pod (insufficient resources, incompatible taints, failed affinity rules, unmet topology constraints). (2) Scoring — ranks remaining nodes by factors: resource balance (spread load), affinity preferences, topology spread, pod priority. The highest-scoring node wins. Key insight: the scheduler uses *requests* (not limits) for capacity calculation — under-requesting causes over-packing.

---

**Question:** How do you implement canary deployments in Kubernetes?

**Answer:** Native Deployments do not support canary (they replace all pods). Options: (1) Manual: deploy canary as a separate Deployment (1 replica) behind the same Service selector. Observe metrics. If healthy, update the main Deployment. (2) Argo Rollouts: native canary support with traffic splitting, analysis (Prometheus queries), and automatic promotion/rollback. (3) Service mesh (Istio): VirtualService weight-based routing (send 5% to canary). The choice depends on existing tooling — Argo Rollouts is the most common for teams without a service mesh.

---

**Question:** How do you manage cluster upgrades safely?

**Answer:** (1) Follow version skew policy (kubelet within 2 minor versions of API server). (2) Upgrade staging cluster first, run integration tests. (3) Upgrade control plane (managed services handle this). (4) Upgrade node groups one at a time: cordon → drain → upgrade → uncordon. (5) PodDisruptionBudgets prevent draining too many pods at once. (6) For major version jumps: blue/green cluster strategy — spin up new cluster, migrate workloads, tear down old. (7) Deprecation warnings: check `kubectl deprecations` before upgrading.

---

**Question:** What is the difference between Horizontal Pod Autoscaler and Vertical Pod Autoscaler?

**Answer:** HPA adjusts replica count (more pods). VPA adjusts resource requests/limits per pod (bigger pods). HPA works for stateless services (scale out). VPA works for workloads where adding replicas does not help (single-threaded, memory-bound). Trade-off: HPA is production-ready and widely used. VPA in "Auto" mode can restart pods (disruptive) — most teams use VPA in "Off" mode (recommendations only) and apply manually. Do not use HPA and VPA on the same metric (they conflict).

---

**Question:** How do you implement NetworkPolicies effectively?

**Answer:** Start with a default-deny policy per namespace (deny all ingress and egress). Then add explicit allow rules for known communication paths. Require DNS egress (port 53 to kube-dns) for service discovery. Key constraint: NetworkPolicies require a CNI that supports them (Calico, Cilium — not all CNIs enforce them). Validate policies actually block traffic (test in staging with `kubectl exec` curl attempts). Policy-as-code: store policies in Git, review with PRs.

---

**Question:** How do you choose between Helm and Kustomize?

**Answer:** Helm when: (1) distributing charts to external users (parameterization is essential), (2) using community charts (PostgreSQL, Prometheus), (3) managing complex dependency trees. Kustomize when: (1) the team owns all manifests (no need for parameterization), (2) the team prefers plain YAML without templating, (3) environment differences are small (patch files are sufficient). Some teams use both: Helm for third-party software, Kustomize for internal services. Never mix both for the same service — it creates confusion.

---

**Question:** How do you handle persistent storage for databases in Kubernetes?

**Answer:** (1) Use StatefulSet with volumeClaimTemplates (each pod gets its own PVC). (2) Choose appropriate StorageClass (gp3 for general, io2 for high-IOPS databases). (3) Enable volume snapshots for backup (CSI VolumeSnapshot). (4) Set appropriate `reclaimPolicy` (Retain for databases — never Delete). (5) Test pod rescheduling: when a pod moves to a new node, the PVC must reattach (only works within same AZ for EBS). (6) Consider whether running databases in Kubernetes is worth the complexity — managed databases (RDS, Cloud SQL) eliminate this entire problem.

---

**Question:** When should you run databases in Kubernetes vs managed services?

**Answer:** Managed services (RDS, Cloud SQL) when: the team lacks deep database ops experience, HA/backup/patching must be someone else's problem, or the database is critical infrastructure. Kubernetes when: multi-cloud portability is a hard requirement, the team has Kubernetes operator expertise, or cost savings at scale justify the ops investment. Most teams should default to managed. Running PostgreSQL on Kubernetes is possible (with operators like CloudNativePG) but adds complexity that managed services eliminate. Trade-off: managed services cost more per-unit but less in total when including engineer time.

---

**Question:** How do you debug a container that crashes immediately on startup?

**Answer:** (1) `kubectl logs pod-name --previous` — shows logs from the crashed container. (2) If no logs: the crash is before logging starts — check the entrypoint/CMD. (3) Override the entrypoint: `kubectl run debug --image=same-image --command -- sleep infinity`, then exec in and run the command manually. (4) Check events: `kubectl describe pod` for OOMKilled (memory too low), exit code 137 (SIGKILL/OOM), exit code 1 (application error). (5) Ephemeral debug containers: `kubectl debug pod-name --image=busybox --target=container-name`.

---

**Question:** How do you implement multi-tenancy in a Kubernetes cluster?

**Answer:** (1) Namespace-per-tenant with RBAC restricting each team to their namespace. (2) ResourceQuotas per namespace (prevent one tenant from starving others). (3) LimitRanges set default requests/limits (prevent BestEffort pods). (4) NetworkPolicies isolate inter-namespace traffic. (5) Pod Security Standards (restricted profile) enforced via admission controller. (6) Separate node pools for hard isolation (noisy neighbors, compliance). Trade-off: soft multi-tenancy (namespaces) vs hard multi-tenancy (separate clusters) depends on trust level between tenants.

---

### Tech Lead

### Question

Your team is evaluating whether to adopt Kubernetes for a platform with 8 services and 12 engineers. How do you make this decision?

### Strong Answer

I evaluate three dimensions. First, operational readiness: do we have at least one engineer with Kubernetes expertise, or are we prepared to hire? Without this, we will spend months learning through production incidents. Second, current pain: are we struggling with deployment consistency, scaling, or isolation between services? If ECS or Cloud Run handles our current needs without friction, Kubernetes adds complexity without immediate benefit. Third, growth trajectory: if we expect 20+ services and 3+ teams within a year, investing in Kubernetes now avoids a migration later. My recommendation: at 8 services and 12 engineers, we are at the threshold. If we have ops experience and expect growth, start with managed Kubernetes (EKS/GKE) with a thin platform layer. If the team is purely application-focused, ECS/Fargate is safer today — migrate when complexity demands it.

### Explanation

The decision is not technical (Kubernetes can run anything). It is organizational: does the team's skill, growth rate, and operational maturity justify the investment? Premature Kubernetes adoption is a common failure mode in startups — spending months building platform infrastructure before validating the product.

### What the Interviewer Is Testing

- Decision framework (not just "Kubernetes is better").
- Awareness of operational cost and team skill requirements.
- Growth thinking (invest vs wait).
- Ability to recommend *against* a technology when conditions do not warrant it.

### Weak Answer

Kubernetes is the industry standard, so we should adopt it. It gives us auto-scaling, self-healing, and portability. Every company uses it eventually.

### Red Flags

- No mention of team readiness or skill requirements.
- "Industry standard" as a justification (appeal to popularity).
- Portability cited without evidence of multi-cloud requirement.
- No awareness of the complexity cost.

---

### Question

How do you manage Kubernetes costs for a platform running 50+ services across multiple teams?

### Strong Answer

I implement cost visibility, governance, and optimization in layers. First, visibility: deploy Kubecost or OpenCost to attribute spend per namespace/team/service. Without attribution, nobody owns their cost. Second, governance: ResourceQuotas per namespace prevent any team from over-provisioning. LimitRanges set default requests so no pod runs without resources. Third, optimization: quarterly right-sizing reviews comparing actual usage (Prometheus) to requests — most teams over-provision by 40-60%. Fourth, compute strategy: spot/preemptible instances for stateless workloads (with PDBs and topology spread for resilience), reserved instances for stable baseline, on-demand for peaks. Fifth, idle resource detection: alert on namespaces with <10% utilization, deployments with replicas=1 but zero traffic. My target: cluster utilization of 60-70% (balanced between cost and headroom).

### Explanation

Cost management is a Tech Lead responsibility because engineering teams optimize for reliability (over-provision to avoid incidents). The Tech Lead balances reliability with cost by providing visibility (teams see their spend) and guardrails (quotas prevent waste without blocking work).

### What the Interviewer Is Testing

- Understanding that cost is a first-class architectural concern.
- Multi-layered approach (visibility, governance, optimization).
- Specific tools and metrics (not generic "reduce waste").
- Awareness of the reliability-cost tension.

### Weak Answer

We just set resource limits and use the cluster autoscaler. Kubernetes handles scaling automatically, so costs should be fine.

### Red Flags

- No cost attribution per team/service.
- Reliance on autoscaler without right-sizing.
- No mention of governance or quotas.
- No awareness that over-provisioning is the primary cost driver.

---

### Question

A critical production service is experiencing intermittent 503 errors after a Kubernetes cluster upgrade. How do you investigate?

### Strong Answer

Systematic approach: (1) Scope: which services are affected? Check Service endpoints (`kubectl get endpoints`) — are pods being removed from the endpoint list during the upgrade? (2) Probes: are readiness probes failing transiently during the upgrade? Check `kubectl describe pod` events for readiness failures. (3) PDB: is the PodDisruptionBudget being respected? During node drains, if PDB allows too many unavailable pods, traffic has nowhere to go. (4) Grace period: is `terminationGracePeriodSeconds` long enough for in-flight requests? If pods are killed before connections drain, clients see 503. (5) Ingress/LB: check if the load balancer health checks are slower to deregister pods than Kubernetes is to terminate them — add a `preStop` hook with sleep(10) to allow deregistration. (6) API changes: did the cluster upgrade deprecate an API version used by our manifests? Check `kubectl get events --field-selector reason=FailedCreate`.

### Explanation

503 errors during cluster upgrades are almost always caused by traffic routing to pods that are shutting down (insufficient graceful shutdown) or away from pods that are healthy but not yet registered (slow readiness). The fix is always in the graceful shutdown path: preStop hooks, terminationGracePeriod, and PDB configuration.

### What the Interviewer Is Testing

- Systematic debugging approach (not guessing).
- Understanding of the pod termination lifecycle.
- Knowledge of PDB interaction with node drains.
- Awareness of the load balancer deregistration race condition.

### Weak Answer

I would roll back the cluster upgrade and investigate later. Upgrades always cause issues.

### Red Flags

- "Roll back" as first action (cluster downgrades are not supported).
- No investigation methodology.
- "Upgrades always cause issues" (fatalistic, not analytical).
- No understanding of the pod lifecycle during termination.

---

### Question

How do you design the platform team's responsibilities versus application teams' responsibilities in a Kubernetes environment?

### Strong Answer

I draw a clear contract. The platform team owns: cluster lifecycle (upgrades, node management, autoscaling), security baseline (admission controllers, network policies, image scanning), observability stack (Prometheus, Grafana, alert routing), cost tooling (Kubecost, quotas), and golden paths (Helm charts, CI templates, namespace provisioning). Application teams own: their Deployment manifests (within platform guardrails), resource requests/limits (guided by VPA recommendations), probes, application-level metrics, and on-call for their services. The contract: platform provides a "paved road" that handles 90% of cases. When an application team needs something off the road, they submit a request (not modify the platform directly). Success metric: how fast can a new team deploy their first service? Target: under 1 day.

### Explanation

The tension is between platform standardization (consistency, security) and application team autonomy (velocity, experimentation). The Tech Lead bridges this by ensuring guardrails are not blockers — they enable safe self-service rather than gatekeeping.

### What the Interviewer Is Testing

- Clear ownership model (not "everyone does everything").
- Understanding of platform team value proposition.
- Balance between governance and developer experience.
- Measurable success criteria (time-to-first-deploy).

### Weak Answer

The platform team sets up the cluster and the application teams deploy whatever they want.

### Red Flags

- No governance model.
- No mention of guardrails or security baseline.
- No concept of "golden paths" or developer experience.
- Platform team only does initial setup (no ongoing ownership).

---

### Question

How do you decide between running a database in Kubernetes versus using a managed database service?

### Strong Answer

Default to managed (RDS, Cloud SQL, Atlas) unless a specific constraint forces Kubernetes. Managed databases provide: automated backups, point-in-time recovery, HA failover, OS patching, and monitoring — all without operational investment. Running databases in Kubernetes is viable with operators (CloudNativePG, Percona Operator) but adds: PVC management, backup coordination, upgrade orchestration, and failure domain complexity (pod rescheduling loses node-local storage). I choose Kubernetes for databases when: (1) multi-cloud portability is a hard business requirement, (2) cost savings at large scale justify dedicated ops investment, or (3) a cloud-native database (CockroachDB, TiDB) is designed for Kubernetes. For most teams: use managed services for databases and Kubernetes for stateless workloads.

### Explanation

This tests whether the candidate defaults to complexity ("run everything in K8s") or makes pragmatic infrastructure decisions. The best answer acknowledges that Kubernetes' strength is stateless workload orchestration — adding state makes everything harder.

### What the Interviewer Is Testing

- Pragmatic trade-off thinking (not dogmatic "K8s for everything").
- Understanding of operational burden for stateful workloads.
- Knowledge of Kubernetes operators for databases.
- Cost and team skill awareness.

### Weak Answer

We should run databases in Kubernetes because it gives us portability and we can manage everything in one place.

### Red Flags

- "Everything in one place" as primary argument (ignoring complexity).
- No mention of backup, recovery, or failover challenges.
- No awareness of managed service trade-offs.
- Portability cited without evidence of multi-cloud need.

---

### Question

Your cluster's compute costs have increased 3× in 6 months despite stable traffic. How do you investigate and fix this?

### Strong Answer

(1) Attribution: Use Kubecost to identify which namespaces/services account for the increase. Often one team deployed without resource awareness. (2) Request vs usage: Compare resource requests to actual usage (Prometheus `container_memory_working_set_bytes` vs requests). Over-provisioning by 3× means we are paying for capacity we never use. (3) Scaling behavior: Check if HPA min replicas were raised without being lowered (ratchet effect after incidents). (4) Node pool: Are nodes being added but never consolidated? (Cluster autoscaler may under-consolidate.) Switch to Karpenter for better bin-packing. (5) Spot mix: Are all workloads on on-demand instances? Stateless services should run on spot (50-70% savings). (6) Action plan: right-size top-5 over-provisioned services (quick win), implement namespace quotas (prevent recurrence), set up weekly cost alerts per team, and run a monthly cost review with Tech Leads.

### Explanation

Cost control requires both investigation (find the cause) and governance (prevent recurrence). The answer combines immediate fixes (right-sizing) with structural improvements (quotas, visibility, reviews).

### What the Interviewer Is Testing

- Analytical approach (not guessing).
- Knowledge of cost attribution tools.
- Understanding that over-provisioning is the primary driver.
- Governance and prevention (not just one-time fix).

### Weak Answer

We need to upgrade to bigger node types so we use fewer nodes. Also, we should negotiate better pricing with the cloud provider.

### Red Flags

- Bigger nodes does not reduce cost (may increase it).
- No investigation of actual cause.
- "Negotiate pricing" instead of addressing waste.
- No concept of resource requests or right-sizing.

---

### Question

How do you establish a security baseline for a shared Kubernetes cluster?

### Strong Answer

I implement defense in depth across four layers. (1) Admission control: Pod Security Standards in "restricted" mode (enforced by built-in admission or OPA Gatekeeper). No privileged pods, no root, no host networking. (2) Image security: only images from trusted registries are allowed (admission webhook validates image source). All images scanned for CVEs in CI — critical CVEs block deployment. (3) Network: default-deny NetworkPolicies per namespace. Explicit allow rules for known communication paths. Service mesh (Istio/Linkerd) for mTLS between services. (4) RBAC: namespace-scoped Roles only (no cluster-admin for app teams). ServiceAccounts per workload with no auto-mounted tokens. Audit logging for all API server access. (5) Secrets: encryption at rest for etcd. External Secrets Operator for secrets from Vault/AWS Secrets Manager.

### Explanation

A security baseline is not one control — it is layers that work together. The Tech Lead ensures these are enforced automatically (admission controllers, not documentation) so teams cannot accidentally deploy insecure workloads.

### What the Interviewer Is Testing

- Defense in depth (multiple layers).
- Automation over documentation (admission controllers enforce).
- Specific technologies (Pod Security Standards, NetworkPolicies, RBAC).
- Understanding that security must not block developer velocity.

### Weak Answer

We use RBAC to control access and scan images for vulnerabilities.

### Red Flags

- Only two controls mentioned (no layered defense).
- No mention of NetworkPolicies or admission control.
- No runtime protection (just pre-deploy scanning).
- RBAC alone is not a complete security strategy.

---

### Question

A team wants to deploy a new microservice. What is your "golden path" — the standard way to get from code to production on your Kubernetes platform?

### Strong Answer

The golden path minimizes decisions for application teams: (1) Repository template with Dockerfile, Helm chart (or Kustomize overlay), CI pipeline, and default resource values. `make new-service` scaffolds everything. (2) CI pipeline: build image → scan → push to registry → update manifests. Runs automatically on merge to main. (3) Deployment: Argo CD detects manifest change → applies to staging → runs integration tests → promotes to production (progressive rollout). (4) Observability: standard labels (app, version, team) enable auto-dashboards. Prometheus ServiceMonitor auto-discovers the service. (5) Networking: Service and Ingress generated by the chart with team-specific domain. NetworkPolicy generated from a template. (6) Guardrails: admission controller validates resource requests, security context, and image source. Non-compliant manifests are rejected with clear error messages. Target metric: new service goes from `git init` to production traffic in under 4 hours.

### Explanation

The golden path is the platform team's product — designed for the application team as user. It should be easier to follow the path than to deviate. The Tech Lead's role is ensuring the path exists, is well-documented, and evolves based on team feedback.

### What the Interviewer Is Testing

- Concept of "platform as product" with developer experience.
- End-to-end thinking (not just one step).
- Specific tools and patterns (not generic "best practices").
- Measurable success (time-to-production).

### Weak Answer

Teams write their own Dockerfiles and YAML and submit them for review. The platform team applies them manually.

### Red Flags

- Manual application by platform team (bottleneck).
- No standardization or templates.
- No CI/CD automation.
- No mention of developer experience or speed.

---

### Question

How do you plan and execute a Kubernetes cluster migration from version 1.26 to 1.30?

### Strong Answer

I treat this as a multi-sprint project: (1) Preparation: run `kubectl deprecations` to identify deprecated API versions in our manifests. Update manifests before the upgrade (e.g., `networking.k8s.io/v1beta1` → `networking.k8s.io/v1`). (2) Release notes review: check each minor version's changelog for breaking changes, removed features, and new defaults. (3) Staging first: upgrade staging cluster through each minor version (1.26→1.27→1.28→1.29→1.30). Skip versions is not supported. Run full integration test suite at each step. (4) Production strategy: blue/green cluster migration — provision new 1.30 cluster, migrate workloads namespace-by-namespace, validate each batch, then decommission old cluster. Alternative for smaller risk tolerance: in-place rolling upgrade with node group rotation. (5) Rollback plan: there is no cluster downgrade. If 1.30 has critical issues, the rollback is "fail forward" — fix in the new version or keep the old cluster running longer. (6) Communication: announce maintenance windows, document known behavior changes, and have on-call present during migration.

### Explanation

Cluster upgrades are high-risk, one-way operations. The interview tests whether the candidate plans systematically (deprecation checks, sequential minor versions, staging-first) or treats it as a one-click operation.

### What the Interviewer Is Testing

- Knowledge of upgrade constraints (no skipping versions, no downgrade).
- Systematic approach (deprecation → staging → production).
- Blue/green cluster strategy for safety.
- Communication and rollback planning.

### Weak Answer

I would upgrade directly from 1.26 to 1.30 on a weekend. Kubernetes is backwards compatible so it should be fine.

### Red Flags

- Skipping minor versions (violates version skew policy).
- "Backwards compatible" assumption without verification.
- No staging test.
- Weekend upgrade implies no preparation or testing.

---

### Question

How do you handle a situation where Kubernetes cluster costs are growing but engineering leadership resists reducing service resources because of reliability concerns?

### Strong Answer

I bridge the gap with data, not opinions. (1) Show the numbers: "Service X requests 4Gi memory but P99 usage is 800Mi. We are paying for 5× what we use." Visualization in Grafana dashboards makes this concrete. (2) Reduce risk of right-sizing: start with CPU (throttling is recoverable, unlike OOM-kill). Use VPA in "Off" mode to generate recommendations without auto-applying. Right-size in staging first, load-test to validate. (3) Gradual rollout: reduce requests by 20% at a time, monitor for a week, then reduce further. Never jump to P50 usage immediately. (4) Provide guardrails: configure HPA so if right-sized pods hit high utilization, they scale out automatically. The safety net makes leadership comfortable. (5) Frame as reliability improvement: over-provisioning wastes budget that could fund better observability, more replicas, or multi-region deployment — all of which improve reliability more than idle CPU.

### Explanation

This tests the candidate's ability to influence without authority. The answer shows technical depth (VPA, gradual rollout, HPA safety net) combined with stakeholder management (data-driven framing, risk reduction, alignment with leadership's actual concern).

### What the Interviewer Is Testing

- Data-driven persuasion (not just "we should save money").
- Risk mitigation strategy (gradual, reversible changes).
- Understanding of leadership concerns (reliability > cost).
- Creative framing (re-invest savings into reliability).

### Weak Answer

I would override the team's resource requests to save money. If things break, we can always scale back up.

### Red Flags

- Unilateral override without consensus.
- "If things break" is not a plan.
- No data, no gradual approach.
- Ignores team autonomy and trust.

---

### Question

Your team manages 30 services across 4 namespaces. Some services have been in CrashLoopBackOff for weeks without anyone noticing. How do you prevent this?

### Strong Answer

This is an observability and ownership gap. (1) Alerting: configure alerts for any pod in CrashLoopBackOff for more than 5 minutes (Prometheus `kube_pod_container_status_waiting_reason{reason="CrashLoopBackOff"}`). Route to the owning team based on namespace labels. (2) Ownership metadata: require labels (team, slack-channel, oncall-rotation) on every Deployment via admission webhook. Alerts without a routing label go to the platform team escalation channel. (3) Health dashboard: per-namespace health scorecard visible to all (pod restart count, CrashLoopBackOff count, OOMKill count over 24h). Make it the team standup default screen. (4) Stale pod cleanup: policy that CrashLoopBackOff pods without an active investigation ticket are scaled to 0 after 48 hours (prevents consuming node resources indefinitely). (5) Root cause: often CrashLoopBackOff is caused by misconfigured ConfigMaps, expired credentials, or missing secrets after rotation — invest in config validation and secret health checks.

### Explanation

CrashLoopBackOff going unnoticed reveals a systemic problem: no ownership, no alerting, and no cost of failure for the responsible team. The fix is structural (alerts, ownership labels) not technical (fixing one pod).

### What the Interviewer Is Testing

- Systems thinking (not just "fix the pod").
- Understanding of ownership and accountability.
- Alerting and observability design.
- Governance patterns for multi-team platforms.

### Weak Answer

I would check the logs and fix the issue. We should also add monitoring.

### Red Flags

- Addresses one instance, not the systemic problem.
- "Add monitoring" without specifics.
- No ownership model or alerting strategy.
- No prevention of recurrence.

---

### Question

You are introducing Helm charts as the standard packaging format for your platform. Several teams resist it, saying "plain YAML is simpler." How do you handle this?

### Strong Answer

I listen to the resistance because it is often legitimate. (1) Acknowledge the valid concern: Helm's Go templating is genuinely harder to debug than plain YAML. Teams that own few services and do not distribute charts may not benefit. (2) Identify the real problem we are solving: if the pain is YAML duplication across 30 services (same probes, security context, labels structure), a shared Helm chart eliminates that repetition while enforcing standards. If duplication is not the problem, Helm may not be the answer. (3) Offer alternatives: Kustomize for teams that prefer plain YAML (template-free overlays). A shared library chart that generates base manifests, allowing teams to consume without writing templates themselves. (4) Pilot: let one willing team adopt the shared chart, measure their experience (deploy time, incident rate, onboarding speed). Use data to convince others — not mandates. (5) Support: if we mandate Helm, we must provide documentation, IDE snippets for values files, a `helm template` CI check that shows rendered YAML, and office hours for questions. Forcing a tool without support creates frustration.

### Explanation

Technology adoption is a change management challenge. The Tech Lead's role is aligning the tool with the actual problem (duplication, inconsistency), providing evidence it works, and supporting the transition — not mandating tools from authority.

### What the Interviewer Is Testing

- Ability to handle team resistance constructively.
- Understanding that tooling decisions require buy-in.
- Pragmatism (Helm is not always the answer).
- Support and enablement mindset.

### Weak Answer

Helm is the industry standard. I would mandate it and set a deadline for all teams to migrate.

### Red Flags

- Mandate without buy-in or support.
- "Industry standard" as sole justification.
- No acknowledgment of valid concerns.
- No pilot, no data, no gradual adoption.

---

### Question

Your organization runs a single large Kubernetes cluster. Two teams are proposing to split into separate clusters for isolation. How do you evaluate this?

### Strong Answer

I assess the need against the cost. (1) What problem are we solving? If it is security isolation (untrusted workloads, compliance boundaries like PCI), separate clusters are justified — namespace isolation is soft, not hard. If it is "we want independence," that can usually be solved with stronger RBAC, quotas, and NetworkPolicies on the shared cluster. (2) Cost of multi-cluster: each cluster needs its own control plane ($70-150/month for managed), monitoring stack, Ingress controller, and platform team attention. Multiply operational burden by cluster count. (3) Cross-cluster communication: services calling across clusters need service mesh federation or external DNS — significant complexity. (4) My recommendation framework: shared cluster for teams with similar trust levels and compliance requirements. Separate clusters for: production vs non-production (different SLAs), regulated workloads (PCI scope minimization), or genuinely untrusted tenants. (5) Middle ground: node pools with taints for workload isolation (shared control plane, dedicated compute).

### Explanation

The multi-cluster debate tests whether the candidate can separate legitimate isolation needs from organizational politics. Most "we need our own cluster" requests are really "we want fewer noisy neighbors" — solvable with quotas and priority classes.

### What the Interviewer Is Testing

- Ability to challenge a proposal with data and alternatives.
- Understanding of isolation models (namespace vs node pool vs cluster).
- Cost awareness (clusters are expensive to operate).
- Pragmatic compromise (node pools as middle ground).

### Weak Answer

Separate clusters give each team full autonomy. We should give each team their own cluster for maximum isolation.

### Red Flags

- "Maximum isolation" without considering cost.
- No consideration of cross-cluster communication complexity.
- No middle-ground options explored.
- Autonomy as a goal (rather than a means to solve a specific problem).

---

### Question

Your Docker images average 1.2 GB and container startup takes 45 seconds, causing slow deployments and failed readiness probes. How do you fix this?

### Strong Answer

I attack this at three layers. (1) Image size: switch from full OS images (node:20) to Alpine or distroless. Multi-stage builds — only copy production artifacts (compiled code, production dependencies). Remove unnecessary files (docs, tests, caches) in the final stage. Target: under 200MB. (2) Build performance: order Dockerfile instructions by change frequency (dependencies first, code last) for layer caching. Use BuildKit with `--mount=type=cache` for package manager caches. Use remote cache (`--cache-from` registry). (3) Startup time: if 45 seconds is application startup (not pull time), investigate: lazy dependency initialization, connection pool warmup, or large config loading. Use startup probes with generous thresholds during startup, then switch to liveness. (4) Pull optimization: pre-pull images to nodes (DaemonSet that pulls but does not run). Use `imagePullPolicy: IfNotPresent` with immutable tags. For large clusters: mirror registry closer to nodes (ECR in same region, or in-cluster registry). Expected result: 1.2GB → 150-200MB, 45s startup → 5-10s.

### Explanation

Image size and startup time are connected but have different root causes. Large images slow both build and pull. Slow startup is usually application-level (not image-level). Diagnosing which layer contributes what is the first step.

### What the Interviewer Is Testing

- Layered diagnosis (image vs pull vs application startup).
- Practical Docker optimization techniques (multi-stage, layer caching).
- Understanding of production impact (readiness probe interaction).
- Measurable targets (1.2GB → 200MB).

### Weak Answer

We should use a bigger node type so images pull faster. Or we could increase the readiness probe timeout.

### Red Flags

- Treating symptoms (increase timeout) not cause (large image).
- Hardware scaling for a software problem.
- No mention of multi-stage builds or distroless.
- No understanding of layer caching.

---

### Question

You are designing a CI/CD pipeline for 15 microservices deployed to Kubernetes. Some services deploy 10 times per day, others once per week. How do you architect the pipeline?

### Strong Answer

I standardize the pipeline but parameterize per-service behavior. (1) Shared pipeline template: all services use the same stages (build → test → scan → push → deploy) but each stage is optional/configurable per service. Monorepo: detect which services changed (path filtering). Polyrepo: each repo triggers its own pipeline. (2) Build: multi-stage Docker build with remote cache. Parallel builds for independent services. Shared base images built weekly and cached. (3) Security gate: Trivy image scan (fail on CRITICAL). SBOM generation. Vulnerability in base image does not block deployment if service team accepts risk (documented exception). (4) Deploy strategy: GitOps via Argo CD. CI pushes new image tag to manifest repo. Argo CD detects and deploys. High-frequency services (10/day): canary with automatic analysis (5% → 25% → 100%). Low-frequency services: rolling update with manual promotion from staging. (5) Rollback: Argo CD can revert to any previous Git commit. No need to rebuild — previous image still in registry. (6) Observability: deployment events sent to Grafana annotations. Automated post-deploy health check (error rate comparison before/after for 5 minutes).

### Explanation

The challenge is balancing standardization (maintainable) with flexibility (different services have different risk profiles and deployment cadences). The pipeline should be a product maintained by the platform team with service teams as consumers.

### What the Interviewer Is Testing

- End-to-end pipeline design (not just one stage).
- GitOps understanding (separation of build and deploy).
- Risk-proportionate deployment strategies.
- Security integration without blocking velocity.

### Weak Answer

Each team builds their own pipeline. We use Jenkins with a shared library.

### Red Flags

- No standardization (each team reinvents).
- Jenkins without explaining why (often legacy inertia).
- No security scanning in the pipeline.
- No mention of rollback or deployment strategy.

---

### Question

A team wants to run their service with `privileged: true` in their security context because their container "needs access to the host network for monitoring." How do you respond?

### Strong Answer

I push back firmly — `privileged: true` gives the container full access to all host devices, all capabilities, and effectively root access to the node. This is a cluster-wide security risk, not a single-service decision. (1) Understand the actual need: "host network for monitoring" usually means they need `hostNetwork: true` (share the node's network namespace) or specific capabilities (NET_ADMIN, NET_RAW). These are significantly less dangerous than full privileged mode. (2) Propose alternatives: if they need to scrape node metrics, use a DaemonSet with only the specific capabilities required. If they need host networking, enable `hostNetwork: true` without privileged mode. If they need access to a host path, use a hostPath volume (scoped to one directory, not entire filesystem). (3) Governance: our admission controller (OPA/Kyverno) blocks `privileged: true` in all namespaces except the platform namespace. Any exception requires a written security review documenting the risk, mitigation, and blast radius. (4) Architecture: if the monitoring tool genuinely requires privileged access, it belongs in the platform team's namespace with their security review, not deployed by application teams.

### Explanation

This tests whether the candidate defaults to "no" for security-critical requests while still solving the underlying problem. The right answer is not "absolutely never" — it is "not without understanding what you actually need and scoping down to the minimum."

### What the Interviewer Is Testing

- Security posture (default deny, least privilege).
- Ability to say no constructively (propose alternatives).
- Understanding of Linux capabilities vs full privilege.
- Governance process (admission control, exception management).

### Weak Answer

If they need it for monitoring, we should allow it. We trust our teams.

### Red Flags

- Trust as a security control (it is not).
- No understanding of what privileged mode actually grants.
- No alternative solutions proposed.
- No governance process for security exceptions.

---

### Question

Your Kubernetes platform has been running for 2 years. Technical debt has accumulated: outdated Helm charts, inconsistent resource configurations, teams bypassing the platform with manual kubectl apply. How do you address this?

### Strong Answer

I treat platform debt like application debt — prioritize by risk, fix incrementally. (1) Audit: inventory current state. Which teams bypass GitOps? Which Helm charts are outdated? Which services lack probes, resources, or security context? Automated policy reports (Kyverno audit mode) generate the gap list without blocking anything. (2) Prioritize by risk: (a) Security gaps first — services without security context or NetworkPolicies are the highest risk. (b) Reliability gaps next — services without probes or PDB cause incidents. (c) Cost inefficiency last — important but not urgent. (3) Incremental enforcement: announce new policies with a 30-day grace period. First week: warn mode (violations logged, not blocked). Day 30: enforce mode (new deployments must comply). Existing violations get a tracked backlog. (4) Make compliance easy: update the shared Helm chart/Kustomize base to include new defaults. If compliance requires zero effort from teams, adoption is fast. If it requires migration work, provide office hours and documentation. (5) Close the bypass: restrict RBAC so direct kubectl apply is no longer possible in production namespaces. All changes go through GitOps. Existing manual changes are detected by Argo CD drift detection.

### Explanation

Platform debt is a governance and incentive problem, not a technical one. If the platform is hard to use correctly, teams will bypass it. The fix is making the right thing easy (golden paths) and the wrong thing impossible (admission control, RBAC).

### What the Interviewer Is Testing

- Strategic thinking about technical debt (prioritization, not "fix everything").
- Incremental enforcement (not big-bang migration).
- Understanding that compliance must be easy.
- Closing bypass paths (governance + tooling).

### Weak Answer

We need to rewrite the platform from scratch with proper standards. I would propose a 6-month platform modernization project.

### Red Flags

- Rewrite instead of incremental improvement.
- 6-month project with no incremental value.
- No prioritization by risk.
- No mention of making compliance easy for teams.

---

### Scenario-based

**Question:** Design a multi-tenant Kubernetes platform for 5 product teams that need isolation but share cluster infrastructure. What would you implement?

**Answer:** (1) Namespace-per-team with RBAC (each team has admin within their namespace, no access to others). (2) ResourceQuotas per namespace — CPU: 20 cores, Memory: 40Gi per team (prevents any team from starving others). (3) LimitRanges with defaults (every pod gets at least requests if the developer forgets). (4) NetworkPolicies: default-deny between namespaces. Explicit allow for shared services (monitoring, logging). (5) Pod Security Standards: restricted profile enforced via admission controller (no privileged, no root, no host networking). (6) Separate node pools for teams with strict isolation requirements (compliance, GPU). (7) Cost attribution: Kubecost labels by namespace. Monthly report to each team lead. (8) Shared services in a platform namespace: Ingress controller, cert-manager, external-secrets-operator, monitoring stack.

---

**Question:** Your CI pipeline takes 15 minutes because Docker builds are slow. How do you optimize?

**Answer:** (1) Layer ordering: put `COPY package*.json` and `RUN npm ci` before `COPY . .` — dependencies change less often than code. (2) BuildKit cache mounts: `--mount=type=cache,target=/root/.npm` persists npm cache across builds. (3) Multi-stage: only rebuild changed stages. (4) Remote cache: push layer cache to registry (`--cache-to` / `--cache-from`). (5) Smaller base image: Alpine over full Debian (fewer layers to pull). (6) .dockerignore: exclude node_modules, .git, test fixtures from build context. (7) Parallel builds: build independent images concurrently. Expected result: 15 min → 2-3 min with proper caching.

---

**Question:** A pod is consuming 4× more memory than expected and getting OOM-killed. How do you investigate?

**Answer:** (1) Confirm OOM: `kubectl describe pod` shows `OOMKilled` reason, last state exit code 137. (2) Check memory usage over time: Prometheus `container_memory_working_set_bytes`. Is it a gradual leak or a sudden spike? (3) If gradual leak: the application has a memory leak. Profile with `--inspect` (Node.js), heap dump, or language-specific tools. Common causes: unbounded caches, event listener accumulation, unresolved promises. (4) If sudden spike: a specific request triggers high allocation. Check request patterns correlating with OOM timestamps. (5) Short-term fix: increase memory limit to prevent restarts while investigating. (6) Long-term: fix the leak, add memory metrics alerting at 70% of limit, consider setting `maxOldSpaceSize` for Node.js.

---

**Question:** You need to migrate 20 services from Docker Compose (development) to Kubernetes (production). What is your plan?

**Answer:** (1) Do not migrate all at once. Start with 2-3 stateless services to establish patterns. (2) Create base Helm chart or Kustomize base that encodes team standards (probes, resources, security context, labels). (3) For each service: convert Compose volumes/ports/env to Kubernetes equivalents. Compose `depends_on` becomes readiness probes and init containers. Compose networks become Services and NetworkPolicies. (4) Stateful services (databases) last — evaluate managed alternatives first (RDS over PostgreSQL on K8s). (5) CI pipeline: add image build + push, manifest generation, and ArgoCD sync. (6) Parallel operation: run old and new simultaneously, shift traffic gradually. (7) Timeline: expect 2-3 months for 20 services (1 sprint for patterns, then batch migration).

---

**Question:** Design an HPA strategy for an API that is I/O-bound (database calls), not CPU-bound. Standard CPU-based HPA does not scale correctly.

**Answer:** (1) CPU-based HPA fails because the pods are waiting on I/O (low CPU despite high latency). (2) Use custom metrics: expose request queue depth or P95 latency as a Prometheus metric. HPA scales on this metric. (3) Setup: deploy Prometheus Adapter to expose custom metrics to the Kubernetes metrics API. Configure HPA with `type: Pods` and `metric.name: http_request_duration_p95`. (4) Target value: scale when P95 exceeds your SLO threshold (e.g., 200ms). (5) Alternative: scale on requests-per-second if it correlates better with latency. (6) Combine with connection pool size limits — adding replicas without adding database connections does not help. (7) Scale-down stabilization: 5 minutes minimum to prevent flapping.

---

**Question:** Your service receives traffic from 3 teams via internal APIs. One team's traffic spikes are causing degradation for the other two. How do you solve this in Kubernetes?

**Answer:** (1) Immediate: rate limiting at the Ingress controller level per-client (identify by header or source namespace). (2) Structural: configure resource requests and HPA to handle the expected combined load. If one team's traffic is unbounded, the service cannot absorb it. (3) Priority-based: if one team's traffic is lower priority, implement pod priority classes and preemption, or use a service mesh with traffic prioritization. (4) Architectural: separate the service into per-team deployments behind the same API (traffic shaping at the load balancer). More expensive but complete isolation. (5) Governance: define SLOs per consumer and alert when one team exceeds their allocation. Conversations about capacity become data-driven.

---

**Question:** You are tasked with implementing a disaster recovery strategy for a Kubernetes platform running in a single region. What do you design?

**Answer:** (1) Cluster state: etcd backups every hour to a different region (S3 cross-region replication). Velero for full cluster backup (resources + PVs). (2) Application data: database replication to standby region (RDS read replica or managed cross-region replication). Object storage already multi-region (S3). (3) Recovery procedure: documented, tested quarterly. Target: RTO 1 hour, RPO 1 hour for stateless services; RTO 4 hours, RPO 15 minutes for databases. (4) Infrastructure-as-Code: entire cluster can be recreated from Terraform/Pulumi. Manifests in Git (Argo CD resyncs to new cluster). (5) DNS failover: Route53 health checks with automatic failover to DR region. (6) Testing: annual DR drill — actually fail over, serve production traffic from DR, measure actual recovery time.

---

**Question:** Design a strategy for handling configuration changes (feature flags, connection strings) across 30 services without redeploying.

**Answer:** (1) ConfigMaps with volume mounts: application watches the mounted file for changes. ConfigMap updates propagate to pods within the kubelet sync period (~60s). No restart needed if the app reloads config on file change. (2) External configuration service: LaunchDarkly for feature flags (SDK polls, no redeploy). Vault for secrets with dynamic refresh. (3) For connection strings: use Kubernetes-native config reloader (stakater/Reloader) that triggers rolling restart when ConfigMap hash changes. Controlled restart is better than live-reloading database connections. (4) Graduated rollout: change config in one namespace first, observe, then propagate. Never change all 30 simultaneously. (5) Audit trail: all config changes go through Git PR (GitOps). ConfigMap history visible in Git log.

---

**Question:** Your team deploys 50 times per day across 15 services. Occasionally a bad deploy causes a production incident. How do you reduce blast radius?

**Answer:** (1) Canary deployments: every deploy goes to 1 replica first. Automatic rollback if error rate exceeds threshold (Argo Rollouts analysis). (2) Progressive delivery: 5% → 25% → 100% traffic over 15 minutes with automated metric checks between steps. (3) Feature flags: decouple deploy from release. New code deploys dark, enabled gradually via flag. (4) Blast radius reduction: PodDisruptionBudgets ensure at least N-1 pods are always healthy. Readiness probes remove bad pods from traffic before users notice. (5) Fast rollback: Argo CD can revert to previous Git commit in <1 minute (faster than building a hotfix). (6) Deployment windows: avoid deploying all 15 services simultaneously. Stagger deployments and observe between batches.

---

**Question:** How do you set up observability for a Kubernetes cluster so the on-call engineer can quickly diagnose issues at 3 AM?

**Answer:** (1) Metrics: Prometheus scrapes all pods (standard labels: app, namespace, pod). Pre-built Grafana dashboards: cluster overview, per-namespace, per-service. Key metrics: request rate, error rate, latency (RED), and resource saturation. (2) Logs: Fluent Bit DaemonSet collects container stdout/stderr. Ship to centralized logging (Elasticsearch, Loki). Structured JSON logs with request ID for correlation. (3) Traces: OpenTelemetry collector as DaemonSet. Auto-instrumentation injects tracing into HTTP calls. Jaeger or Tempo for trace visualization. (4) Alerts: symptom-based (high error rate, high latency) not cause-based (high CPU). Alert text includes: what is happening, likely causes, and link to runbook. (5) Runbooks: one per alert, linked in the alert annotation. Steps are mechanical, not requiring deep system knowledge. See [Observability](./18-observability.md) for the full observability strategy.

---

### Trick Questions

**Question:** Is a Pod the same as a container?

**Answer:** No. A Pod is a group of one or more containers that share a network namespace and storage volumes. Most pods contain one container, making them appear equivalent, but the distinction matters: multi-container pods (sidecars, init containers) are common patterns. The Pod is the scheduling unit — containers within a pod are always co-located on the same node.

---

**Question:** Does Kubernetes guarantee that a Deployment always has exactly N replicas running?

**Answer:** No. During rolling updates, node failures, or resource pressure, the actual replica count may temporarily differ from desired. `maxSurge` and `maxUnavailable` control how far from desired during updates. Eviction under resource pressure can reduce count. PodDisruptionBudgets limit voluntary disruptions but cannot prevent involuntary ones (node crash). Kubernetes guarantees *eventual convergence* to desired state, not instantaneous enforcement.

---

**Question:** If you set a CPU limit of 1000m, does the container always get 1 full CPU core?

**Answer:** No. CPU limits are enforced via CFS (Completely Fair Scheduler) throttling. The container cannot *exceed* 1000m over any 100ms period, but it is not *guaranteed* 1000m — that is what requests are for. With only a limit and no request, the scheduler does not reserve capacity. Under contention, the container may be throttled below its limit. Also: CPU throttling can cause latency spikes even when average utilization looks low (CFS quota enforcement at 100ms boundaries).

---

**Question:** Are Kubernetes Secrets encrypted?

**Answer:** By default, no. Kubernetes Secrets are base64-encoded (trivially decodable), stored in etcd in plaintext. Encryption at rest requires explicit EncryptionConfiguration with a KMS provider. Even then, anyone with RBAC permission to read Secrets in a namespace can access them. For true security: use external secret managers (Vault, AWS Secrets Manager) with operators that inject secrets at runtime.

---

**Question:** Does a Kubernetes Service do load balancing?

**Answer:** It does round-robin distribution across endpoints, but calling it "load balancing" is misleading. There is no health-weighted routing, no connection draining, no session affinity (unless explicitly configured), and no intelligent traffic shaping. kube-proxy uses iptables or IPVS rules — it is layer-4, not layer-7. For true load balancing (health-aware, weighted, circuit-breaking), use a service mesh (Istio, Linkerd) or Ingress controller with advanced features.

---

### Red Flags

1. **"We use latest tag because it is simpler"** — Shows no understanding
   of immutable deployments, rollback capability, or reproducibility.
   In production, `:latest` means nobody knows what is running.

2. **"Kubernetes handles everything automatically — scaling, healing,
   networking"** — Dangerously simplistic. Kubernetes automates
   *reconciliation* of desired state, but someone must define the
   desired state correctly (probes, resources, PDBs, topology). Without
   proper configuration, Kubernetes automates *failure* just as readily.

3. **"We run everything in the default namespace"** — Indicates no
   understanding of isolation, RBAC boundaries, or multi-team
   operations. Production workloads in `default` is a governance
   failure.

4. **"Our pods do not need resource requests — we have plenty of
   capacity"** — Without requests, the scheduler cannot make informed
   decisions, pods get BestEffort QoS (first evicted), and one
   workload can starve all others. "Plenty of capacity" is a symptom
   of over-spending.

5. **"We kubectl apply from laptops when we need to deploy"** — No
   audit trail, no review process, no rollback mechanism, no
   environment consistency. This is acceptable for learning but a red
   flag for production operations. GitOps solves this completely.

## Summary

- Containers are process-level isolation (namespaces + cgroups), not
  lightweight VMs. They share the host kernel — the security
  implications are real.
- Docker images are layered filesystems. Multi-stage builds, minimal
  base images (distroless), non-root execution, and proper
  `.dockerignore` are non-negotiable for production.
- Kubernetes is a declarative reconciliation system. Desired state is
  stored in etcd; controllers continuously push actual state toward it.
  The cluster is never "done" — it is always reconciling.
- Resource requests determine scheduling; limits determine enforcement.
  Right-sizing (based on observed usage, not guesses) is the primary
  lever for both reliability and cost.
- Probes must be designed carefully: liveness checks internal health
  only (never external dependencies); readiness checks ability to
  serve traffic. Conflating them causes cascading restart loops.
- Kubernetes earns its cost when service count exceeds 10-15, multiple
  teams need self-service, and the organization can staff platform
  expertise. Below that threshold, simpler platforms (ECS, Cloud Run)
  provide 80% of the value at 20% of the complexity.
- The Tech Lead owns the platform decision (adopt/not), resource
  governance (quotas, right-sizing reviews), security baseline
  (admission controllers, NetworkPolicies), and cost visibility
  (attribution by team).

## Further Study

- Kubernetes official documentation (kubernetes.io) — the authoritative
  reference for API objects, scheduling, and networking.
- *Kubernetes Up & Running* (Hightower, Burns, Beda) — the standard
  practitioner's guide.
- *Production Kubernetes* (Hausenblad, Skrzypek) — operational
  patterns for large-scale clusters.
- CNCF Landscape (landscape.cncf.io) — context for the ecosystem
  (service meshes, observability, security tools).
- [AWS](./04-aws.md) — EKS-specific patterns, IRSA, VPC CNI, and
  managed node groups.
- [CI/CD and DevOps](./17-ci-cd-and-devops.md) — GitOps with Argo
  CD/Flux, pipeline integration, artifact management.
- [Security](./15-security.md) — container security, image scanning,
  supply chain security, secrets management.
- [Observability](./18-observability.md) — Prometheus, OpenTelemetry,
  alerting, and SLOs for Kubernetes workloads.
- [System Design](./13-system-design.md) — scaling patterns,
  reliability mechanisms, and multi-region architectures.

> Verify against official documentation. Kubernetes APIs, default
> behaviors, and recommended practices change across minor versions.
