# Git and Engineering Workflow

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can explain Git internals at the level
expected of a Tech Lead, choose a branching strategy with reasons, and
set commit, code review, and release norms that scale.

## Why This Matters for a Tech Lead

Engineering workflow is the daily friction (or flow) of the team.
Branching strategy, PR size, review depth, and merge policy compound
into delivery throughput.

## Mental Model

> TODO: Git as "a content-addressable filesystem with a porcelain on
> top". Most "Git problems" are misunderstandings of the object model.
> Add a Mermaid diagram of objects (blob, tree, commit, ref).

## Core Terminology

> TODO: Blob, tree, commit, ref, branch, tag, HEAD, fast-forward,
> rebase, merge, squash, three-way merge, conflict, fetch vs pull,
> upstream, origin, monorepo, polyrepo, CODEOWNERS.

## Theoretical Foundation

> TODO: Cover:
>
> - Git object model: blobs, trees, commits, refs.
> - Branches as movable refs.
> - Merge vs rebase vs squash; when each is appropriate.
> - Branching strategies: trunk-based, GitHub Flow, GitFlow,
>   release branches.
> - Commit hygiene: atomic commits, conventional commits, signed
>   commits.
> - Pull request culture: size, scope, review depth, review SLA.
> - Code ownership: CODEOWNERS, review routing.
> - Release branches and hotfix flow.
> - Monorepo vs polyrepo trade-offs (and tooling).
> - Recovering from mistakes: `reflog`, `reset` modes, `cherry-pick`,
>   `bisect`.

## Practical Usage

> TODO:
>
> - Trunk-based development with feature flags.
> - PR review SLAs and review backlog dashboards.
> - Hotfix flow that doesn't break trunk.

## Examples

> TODO:
>
> - A clean rebase preserving authorship.
> - A CODEOWNERS file with team boundaries.
> - A conventional commit message with body and footer.
> - A `git bisect` walkthrough.

## Common Mistakes

> TODO:
>
> 1. Long-lived feature branches with massive merges.
> 2. Force-pushing to shared branches.
> 3. PRs that mix refactors with features.
> 4. CODEOWNERS that forces every PR through one team.
> 5. Treating Git as a black box (and being unable to recover from
>    a bad merge).

## Trade-offs

> TODO: Trunk-based vs GitFlow; merge vs squash vs rebase; monorepo
> vs polyrepo.

## Production Considerations

> TODO:
>
> - PR size and review SLA as a delivery metric.
> - Build cache and CI cost in monorepos.
> - Repository size and shallow clones.
> - Backup and recovery for the source of truth (Git host).

## How to Explain This in an Interview

> TODO: 60-second explanation of "what is a commit, really?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Trunk-based vs GitFlow".

## Tech Lead Checklist

- [ ] Branching strategy is documented and consistent.
- [ ] PR size guideline is enforced (e.g., review-friendly diffs).
- [ ] Review SLA and backlog metrics are visible.
- [ ] CODEOWNERS routes reviews efficiently.
- [ ] The team can recover from common Git mistakes.

## Interview Questions and Answers

### Basic

> TODO: "What is the difference between merge and rebase?"

### Senior

> TODO: "How do you keep PRs reviewable in a 200-engineer org?"

### Tech Lead

> TODO: "How do you decide between monorepo and polyrepo?"

### Scenario-based

> TODO: "Your team's CI is at 45 minutes. How do you cut that?"

### Trick Questions

> TODO: "Does Git store snapshots or diffs?"

### Red Flags

> TODO: Candidates who treat Git as terrifying or who avoid rebase.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: Pro Git (Chacon & Straub); "Trunk Based Development"; the
> Git documentation.

---

### Generation Notes

- Cross-link to chapter 17 (CI/CD) and chapter 23 (Tech Lead Skills).
