# Prometheus as Witness

Prometheus is not only monitoring in MetaKube. Prometheus is the witness.

KubeContainer declares the promise. Kubernetes holds the runtime reality. Prometheus observes the runtime truth. MetaKube turns that observation into an evidentiary verdict. The Repair Agent acts on the verdict through runbooks.

```text
Declaration -> KubeContainer
Reality     -> Kubernetes Pod / Container state
Witness     -> Prometheus
Testimony   -> Alert
Evidence    -> Metric
Procedure   -> Runbook
Judgment    -> MetaKube Observance
Action      -> Repair Agent
```

## The doctrine

```text
Prometheus as Witness
Alert as Testimony
Metric as Evidence
Runbook as Procedure
Verdict as Governance
Repair as Reconciliation
```

This gives Prometheus the right office. It is not the operator, not the judge, and not the repair loop. It watches, records, and testifies.

## Why this matters

The Prometheus Kubernetes runbook `KubeContainerWaiting` already uses the phrase that matters: a Kubernetes container is waiting too long. That is not the same as the unboxd.cloud `KubeContainer` custom resource, but the overlap is valuable.

```text
KubeContainer
= our declared workload promise object

KubeContainerWaiting
= Prometheus testimony that the underlying Kubernetes container may be stuck
```

The product connection is:

```text
KubeContainer is the promise.
KubeContainerWaiting is witness testimony that the promise may be broken.
MetaKube Observance converts that testimony into a verdict.
```

## Observance mapping

| Cloud-native signal | MetaKube meaning |
|---|---|
| metric | evidence |
| alert | testimony |
| runbook | procedure |
| status condition | declared-state verdict surface |
| Kubernetes event | state-transition witness |
| log line | supporting record |
| Prometheus target health | witness availability |
| repair action | reconciliation response |

## KubeContainerWaiting path

```text
User declares KubeContainer
   ↓
Operator creates Deployment, Service, and Pods
   ↓
A Pod container enters Waiting
   ↓
Prometheus fires KubeContainerWaiting
   ↓
MetaKube maps the alert back to the owning KubeContainer
   ↓
Verdict becomes PROMISE_BROKEN
   ↓
Repair Agent follows the runbook
   ↓
Outcome is recorded as evidence
```

## First-class product statement

MetaKube is a local Kubernetes fabric powered by Minikube, governed by KubeContainer, witnessed by Prometheus, and judged through Observance.

```text
MetaKube = Minikube + KubeContainer + Prometheus + Observance + Governance + Evidence
```

## Rules

1. Prometheus must be named in public architecture, not hidden as implementation detail.
2. Every alert must map to a promise object, a verdict, and a repair procedure.
3. Every repair procedure must leave evidence.
4. A metric is not complete until it can answer: which promise did this affect?
5. A verdict is not complete until it can answer: which signal proved it?

## Canonical line

Prometheus is the witness that turns runtime behavior into evidence. MetaKube turns that evidence into a verdict. KubeContainer is the promise being judged.
