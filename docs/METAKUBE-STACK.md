# MetaKube Stack

MetaKube is the local-to-enterprise fabric for proving KubeContainers.

```text
MetaKube = Minikube + KubeContainer + Prometheus + Cortex + Observance + Governance + Evidence
```

## Offices

| Component | Office | Meaning |
|---|---|---|
| Minikube | local substrate | starts the smallest Kubernetes fabric |
| KubeContainer | promise object | declares the workload box |
| Kubernetes | runtime reality | runs the actual Pods, Services, and Ingresses |
| Prometheus | witness | scrapes runtime truth and fires testimony as alerts |
| Cortex | evidence store | preserves Prometheus witness records across time, tenants, and clusters |
| Grafana | evidence lens | visualizes witness records and verdicts |
| MetaKube Observance | court | maps signals back to promises and produces verdicts |
| Repair Agent | reconciliation arm | follows runbooks and records repair evidence |

## Local stack

For a developer machine or demo:

```text
Minikube
  + KubeContainer operator
  + sample KubeContainer
  + Prometheus
  + optional Grafana
```

Prometheus is enough locally because the witness and its short-term evidence live in one place.

## Enterprise stack

For many clusters, teams, tenants, and long-term audit:

```text
Clusters
  -> Prometheus agents / Prometheus servers
  -> remote_write
  -> Cortex
  -> Grafana / Observance API
  -> Verdict / Repair / Audit
```

Cortex exists because Prometheus alone is intentionally local-first. Cortex turns many local witnesses into a durable, horizontally scalable evidence store.

## Evidence flow

```text
KubeContainer declared
   ↓
Operator reconciles Deployment / Service / Pods
   ↓
Prometheus scrapes controller and Kubernetes metrics
   ↓
Prometheus fires alerts such as KubeContainerWaiting
   ↓
Cortex stores long-term metric evidence
   ↓
MetaKube Observance maps signal -> promise -> verdict
   ↓
Repair Agent executes runbook
   ↓
Evidence is recorded
```

## Storage doctrine

```text
Prometheus witnesses the promise.
Cortex preserves the witness record.
Grafana shows the evidence.
MetaKube judges the verdict.
Repair reconciles the broken promise.
```

## Stack levels

### Level 0 — Build

```text
make metakube-up
make metakube-sample
```

### Level 1 — Witness

```text
make metakube-prometheus
make metakube-observe
```

### Level 2 — Evidence store

```text
make metakube-cortex
```

### Level 3 — Verdict

```text
make metakube-verify
```

## First verdict gates

A MetaKube run is green only when:

```text
cluster_ready=true
operator_ready=true
sample_kubecontainer_ready=true
prometheus_scraping=true
cortex_ready=true when storage stack is enabled
verdict=PROMISE_KEPT
```

## Non-goals

- Cortex does not replace Prometheus.
- Prometheus does not replace the operator.
- Grafana does not create evidence; it visualizes evidence.
- Observance does not invent a new monitoring protocol; it binds existing signals to promise verdicts.
