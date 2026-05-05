# AWS

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can navigate AWS at the level required
for a Tech Lead: choose between compute options, design VPCs and IAM
boundaries, evaluate storage and database services, and reason about
multi-account organization and cost.

## Why This Matters for a Tech Lead

AWS choices set cost and reliability for years. A Tech Lead must
defend service selection, IAM design, and account topology under
audit, growth, and migration pressure.

## Mental Model

> TODO: AWS as "primitives + identity". Almost everything is a
> primitive (compute, storage, network, queue, KMS) and IAM ties them
> together. A Mermaid diagram showing services grouped by primitive.

## Core Terminology

> TODO: Region, AZ, edge location, VPC, subnet (public/private),
> security group, NACL, IAM principal/role/policy, STS, KMS, S3 bucket,
> EBS volume, EFS, RDS/Aurora, DynamoDB, ElastiCache, SQS/SNS/EventBridge,
> Kinesis, Lambda, ECS, EKS, Fargate, CloudFront, Route 53, CloudWatch,
> X-Ray, CloudTrail.

## Theoretical Foundation

> TODO: Cover:
>
> - Global structure: regions, AZs, edge.
> - Compute: EC2, ECS, EKS, Lambda, Fargate, Batch; when to use each.
> - Storage: S3 (durability/consistency model), EBS, EFS, FSx.
> - Databases: RDS, Aurora, DynamoDB, ElastiCache, Redshift,
>   OpenSearch.
> - Networking: VPC layout, public vs private subnets, security
>   groups, NACLs, NAT gateway, VPC endpoints, Transit Gateway,
>   PrivateLink, Route 53 routing policies.
> - Identity: IAM users, roles, policies (identity-based vs
>   resource-based), permission boundaries, STS, SCPs, ABAC.
> - Messaging: SQS (standard vs FIFO), SNS, EventBridge, Kinesis, MSK.
> - Edge and CDN: CloudFront, Global Accelerator.
> - Observability: CloudWatch metrics/logs, X-Ray, CloudTrail.
> - Cost levers: pricing models (on-demand, spot, savings plans),
>   egress, idle resources, S3 storage classes.
> - Multi-account: AWS Organizations, SCPs, landing zones, account
>   per environment vs per team.

## Practical Usage

> TODO:
>
> - Standard 3-tier web app on AWS.
> - Serverless event-driven pipeline (S3 -> Lambda -> DynamoDB).
> - Multi-account org with shared services account.

## Examples

> TODO:
>
> - An IAM trust policy with `sts:AssumeRoleWithWebIdentity`.
> - An S3 lifecycle rule moving cold data to Glacier.
> - A VPC layout with public/private subnets and NAT.
> - A serverless event flow with SQS and a DLQ.

## Common Mistakes

> TODO:
>
> 1. Wildcard IAM permissions (`*` on `*`) "for now".
> 2. Mixing prod and non-prod in the same account.
> 3. Public S3 buckets through misconfiguration.
> 4. Cross-region traffic that no one notices on the bill.
> 5. Treating Lambda as "free scaling" without limits and concurrency
>    quotas in mind.

## Trade-offs

> TODO: Compare EC2 vs ECS vs EKS vs Lambda by cost shape, ops cost,
> latency profile, and team skill. Compare RDS vs DynamoDB by access
> pattern.

## Production Considerations

> TODO:
>
> - IAM least privilege and rotation.
> - KMS key management and CMK ownership.
> - Cost guardrails: budgets, anomaly detection, tagging policy.
> - Backup and restore drills.
> - Vendor lock-in and exit strategy.

## How to Explain This in an Interview

> TODO: A 60-second answer to "How would you set up AWS for a new
> startup?".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "Where would you put secrets?".

## Tech Lead Checklist

- [ ] Multi-account organization with SCPs.
- [ ] No long-lived access keys for human users.
- [ ] Tagging policy enforced and used in cost reports.
- [ ] Backup and restore tested for each stateful service.
- [ ] Disaster recovery plan documented per service.

## Interview Questions and Answers

### Basic

> TODO: "What is an AZ vs a Region?"

### Senior

> TODO: "How does S3 strong read-after-write consistency change your
> design?"

### Tech Lead

> TODO: "How do you organize AWS accounts for a 200-engineer org?"

### Scenario-based

> TODO: "Design a multi-region failover for a regulated SaaS."

### Trick Questions

> TODO: "Is Lambda always cheaper than EC2?"

### Red Flags

> TODO: Candidates who design with `*` IAM permissions or single-AZ
> production databases.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: AWS Well-Architected Framework; AWS service docs; reInvent
> talks for specific services.

---

### Generation Notes

- AWS is **highly version-sensitive**. Mark every specific limit,
  pricing detail, and feature claim as "verify against official
  documentation" and add to `notes/verification-needed.md`.
- Avoid recommending specific instance types or service tiers; focus
  on the service families and trade-offs.
