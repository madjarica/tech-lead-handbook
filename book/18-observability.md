# Observability

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can design logs, metrics, and traces
that actually answer production questions, define SLOs and error
budgets, and avoid alert fatigue.

## Why This Matters for a Tech Lead

Observability is what separates "we know" from "we guess" during
incidents. A Tech Lead must own the observability budget and make
sure the team can debug what they ship.

## Mental Model

> TODO: Observability as "the ability to ask new questions about
> your system without shipping new code". Add a Mermaid diagram of
> the three pillars (logs, metrics, traces) plus events and profiles.

## Core Terminology

> TODO: Log, metric, trace, span, exemplar, cardinality, SLI, SLO,
> SLA, error budget, percentile, MTBF, MTTR, alert fatigue, runbook.

## Theoretical Foundation

> TODO: Cover:
>
> - Three pillars: logs, metrics, traces. Plus events and profiles.
> - Structured logs and log levels; correlation IDs.
> - Metric types: counter, gauge, histogram, summary; quantiles vs
>   averages; cardinality and label discipline.
> - Distributed tracing: spans, context propagation, sampling
>   strategies, OpenTelemetry.
> - SLIs and SLOs: turning customer experience into measurable
>   signals.
> - Error budgets: how to use them as a contract between dev and ops.
> - Alerting on **symptoms** (user-visible), not causes.
> - Dashboards as products: a few that matter, not many that don't.
> - Logs vs metrics vs traces: when to reach for which.

## Practical Usage

> TODO:
>
> - Standard service observability stack: structured logs +
>   Prometheus-style metrics + OpenTelemetry traces.
> - SLO-based alerting with multiple burn-rate alerts.
> - Tracing across asynchronous boundaries (queues).

## Examples

> TODO:
>
> - A structured log line in JSON.
> - A Prometheus query for a 99th-percentile latency SLO burn rate.
> - An OpenTelemetry span hierarchy for a request that fans out.
> - A runbook entry for a paged alert.

## Common Mistakes

> TODO:
>
> 1. Free-text logs without structure.
> 2. Histograms with unbounded label cardinality.
> 3. Alerts on causes (CPU > 80%) instead of symptoms (latency SLO
>    burn).
> 4. Tracing turned on for 0.1% of traffic when debugging a 1% issue.
> 5. Dashboards no one looks at, paged alerts no one acts on.

## Trade-offs

> TODO: Self-hosted (Prometheus, Loki, Tempo) vs vendor (Datadog,
> Honeycomb, New Relic) by cost, control, ecosystem, on-call burden.

## Production Considerations

> TODO:
>
> - Cost: log volume, metric cardinality, trace ingest.
> - Retention vs compliance.
> - On-call rotations and runbooks.
> - Vendor lock-in (proprietary query languages).

## How to Explain This in an Interview

> TODO: 60-second answer to "What is the difference between monitoring
> and observability?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "How do you set up alerts for a
> new service?".

## Tech Lead Checklist

- [ ] Every service emits structured logs, metrics, and traces.
- [ ] SLOs are defined and reviewed.
- [ ] Alerts page on symptoms, not causes.
- [ ] Each paged alert has a runbook.
- [ ] Observability cost is reviewed monthly.

## Interview Questions and Answers

### Basic

> TODO: "What are the three pillars of observability?"

### Senior

> TODO: "Why is alerting on CPU usage usually wrong?"

### Tech Lead

> TODO: "How do you keep observability cost from running away?"

### Scenario-based

> TODO: "Production has elevated 5xxs but everything 'looks fine'.
> Walk me through your investigation."

### Trick Questions

> TODO: "Is 100% trace sampling required for accuracy?"

### Red Flags

> TODO: Candidates who say "we'll add logs later".

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: "Site Reliability Engineering" (Google); "Implementing Service
> Level Objectives"; OpenTelemetry documentation.

---

### Generation Notes

- Cross-link to chapter 13 (System Design), chapter 17 (CI/CD),
  chapter 19 (Performance).
- Vendor-neutral whenever possible.
