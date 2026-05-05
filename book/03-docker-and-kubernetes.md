# Docker and Kubernetes

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can write a clean container image,
explain the Kubernetes object model on a whiteboard, reason about
scheduling and rollout strategies, and decide when Kubernetes is the
right answer (and when it is not).

## Why This Matters for a Tech Lead

Kubernetes is a force multiplier and a force of complexity. A Tech
Lead must own the decision to adopt it, the cost of operating it, and
the upgrade strategy that keeps the cluster from becoming a museum.

## Mental Model

> TODO: Containers as "shipping containers for processes"; Kubernetes
> as "a control loop that pushes the cluster toward a declared
> desired state". Add a Mermaid diagram of the control loop.

## Core Terminology

> TODO: Container, image, layer, OCI, namespace, cgroup, Pod,
> ReplicaSet, Deployment, Service, Ingress, ConfigMap, Secret, Job,
> CronJob, StatefulSet, DaemonSet, PV/PVC, StorageClass, taint,
> toleration, affinity, PDB, HPA, VPA.

## Theoretical Foundation

> TODO: Cover:
>
> - Containers vs VMs; Linux namespaces and cgroups.
> - OCI images, layers, registries.
> - Dockerfile patterns: multi-stage, layer caching, distroless,
>   non-root, minimal base, build-time secrets.
> - Kubernetes architecture: control plane (API server, etcd,
>   scheduler, controller manager), kubelet, kube-proxy, CNI, CSI.
> - Workload objects: Deployment, StatefulSet, DaemonSet, Job, CronJob.
> - Networking: ClusterIP, NodePort, LoadBalancer, Ingress,
>   NetworkPolicy.
> - Storage: ephemeral vs persistent, PV/PVC, StorageClass.
> - Scheduling: requests/limits, node selectors, taints/tolerations,
>   affinity, PDB.
> - Health checks: liveness, readiness, startup probes.
> - Rollouts: rolling, recreate, blue/green, canary (often via service
>   mesh or Argo Rollouts).
> - Secrets management options.

## Practical Usage

> TODO:
>
> - When Kubernetes is overkill (small teams, low scale).
> - When it earns its keep (multi-team platforms, many services,
>   strong cost discipline).
> - GitOps with Argo CD or Flux at concept level.

## Examples

> TODO:
>
> - A clean multi-stage Dockerfile for a Node.js service.
> - A Kubernetes Deployment with proper probes, resource requests,
>   and limits.
> - An HPA based on CPU and a custom metric.
> - A NetworkPolicy denying egress by default.

## Common Mistakes

> TODO:
>
> 1. Running as root inside the container.
> 2. No resource requests/limits, leading to noisy neighbors.
> 3. Liveness probe that restarts a healthy app under temporary load.
> 4. Storing secrets as ConfigMaps.
> 5. Treating Kubernetes manifests as application code instead of
>    infrastructure code.

## Trade-offs

> TODO: Table comparing managed Kubernetes, self-managed Kubernetes,
> ECS/Fargate, and serverless functions, by ops cost, flexibility,
> vendor lock-in, and team skill required.

## Production Considerations

> TODO:
>
> - Cluster upgrades and version skew policy.
> - Multi-tenancy: namespaces, RBAC, network policies, resource quotas.
> - Cost: idle nodes, oversized requests.
> - Security: image scanning, signed images, admission controllers.
> - Disaster recovery: cluster-level backup and restore.

## How to Explain This in an Interview

> TODO: A 60-second whiteboard explanation of the Kubernetes control
> loop.

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Why use Kubernetes for a 5-service
> startup?".

## Tech Lead Checklist

- [ ] Every workload has resource requests, limits, and probes.
- [ ] Images are scanned and run as non-root.
- [ ] Cluster upgrade plan exists and is followed.
- [ ] RBAC and namespaces enforce team boundaries.
- [ ] Cost dashboard breaks down by namespace.

## Interview Questions and Answers

### Basic

> TODO: "What is a Pod?"

### Senior

> TODO: "Liveness vs readiness vs startup probe — when does each fire,
> and what is the failure mode of confusing them?"

### Tech Lead

> TODO: "When would you choose ECS over EKS?"

### Scenario-based

> TODO: "Design a multi-tenant cluster for 30 teams."

### Trick Questions

> TODO: "Is a Pod a container?"

### Red Flags

> TODO: Candidates who treat `kubectl apply` as the source of truth.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: Kubernetes documentation; "Kubernetes Up & Running"; the CNCF
> landscape for context.

---

### Generation Notes

- Mark version-sensitive items (e.g. specific API versions, deprecated
  resources) and add to `notes/verification-needed.md`.
- Cross-link to chapter 17 (CI/CD) for GitOps and chapter 04 (AWS)
  for managed Kubernetes (EKS).
