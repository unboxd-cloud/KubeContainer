# AWS Marketplace Release

AWS Marketplace is the commercial publishing target for Meta Platform and KubeContainer.

## Release target

```text
AWS Marketplace listing:
Meta Platform v0.1.0 — MACH Fabric Proof Edition
```

## Product package

```text
Meta Platform = KubeContainer + MetaKube + MACH Fabric + Prometheus Witness + Cortex Store + Observance + SLA Gate
```

## Marketplace shape

The first listing should be packaged as a professional cloud-native software product with a container/operator delivery path.

Recommended initial form:

```text
Container / Kubernetes product listing
```

Future form:

```text
SaaS Contract listing for managed Meta Platform
```

## Buyer promise

Meta Platform helps teams turn MACH services into accountable promise objects: declared, reconciled, witnessed, scored, repaired, and release-gated.

## Listing headline

```text
Meta Platform — MACH Fabric for Accountable Cloud-Native Workloads
```

## Short description

Meta Platform packages KubeContainer, MetaKube, Prometheus-backed observance, SLA scoring, and release gates into a proof-driven cloud-native platform for building and publishing accountable microservices.

## Fulfillment model

### v0.1.0

```text
Self-managed Kubernetes operator
```

Buyer installs KubeContainer and runs MetaKube verification in their own environment.

### v0.2+

```text
Managed SaaS control plane
```

Buyer connects clusters and receives dashboards, SLA scoring, provenance, repair workflows, and evidence exports.

## Required artifacts

| Artifact | Purpose |
|---|---|
| OCI image | operator runtime |
| install YAML / Helm chart later | Kubernetes install path |
| README | buyer overview |
| docs/META-PLATFORM-RELEASE.md | platform release definition |
| docs/RELEASE-GATE.md | publish criteria |
| docs/MACH-FABRIC.md | architecture |
| contracts/metakube-sla.json | measurable SLA contract |
| dist/metakube-report.txt | proof evidence |
| dist/metakube-score.json | SLA score evidence |

## Marketplace readiness checklist

- [ ] Public repository has clear product README.
- [ ] OCI image is published to a registry.
- [ ] Image has immutable tag and digest.
- [ ] Install path is one command or one manifest.
- [ ] License and commercial terms are clear.
- [ ] Support contact is listed.
- [ ] Security policy is present.
- [ ] Release gate passes with `PROMISE_KEPT`.
- [ ] SLA score is at least `0.90`.
- [ ] Evidence artifacts are attached to release.
- [ ] Pricing model is defined.
- [ ] Refund/support policy is defined.
- [ ] Customer onboarding guide is present.

## Pricing models

### Developer / evaluation

```text
Free open-source self-managed install
```

### Team

```text
per cluster / per month
```

### Enterprise

```text
annual contract + support + managed evidence retention
```

### Usage expansion

```text
per KubeContainer promise scored
per evidence retention window
per connected cluster
```

## Metering model

Initial self-managed version can report no usage externally.

Managed version may meter:

```text
clusters_connected
kubecontainers_scored
evidence_retention_days
sla_evaluations
repair_runs
```

## SLA publication

Marketplace claim must not say the platform is compliant or certified until evidence exists.

Allowed v0.1.0 claim:

```text
Includes an executable SLA scoring gate for local proof and release readiness.
```

Not allowed yet:

```text
SOC 2 certified
ISO certified
HIPAA compliant
production certified
```

## Launch order

1. Finish MetaKube Verify workflow.
2. Publish OCI image.
3. Attach evidence artifacts to GitHub release.
4. Create marketplace listing draft.
5. Add screenshots and architecture diagram.
6. Add support and security policy.
7. Submit for AWS Marketplace review.

## Canonical line

AWS Marketplace is where the proven promise becomes a commercial product: the Fabric does not sell claims; it sells evidenced, scored, supportable cloud-native work.
