# MetaKube Live Stream

Live Stream is the real-time evidence feed of MetaKube.

History is what happened. Movie is the replayable narrative. Live Stream is what is happening now.

```text
History     = ordered past
Movie       = replayable evidence narrative
Live Stream = real-time evidence flow
```

## Definition

Live Stream is the continuous flow of Kubernetes events, operator status changes, Prometheus signals, alerts, runbook steps, repair actions, trust updates, and verdict changes while a KubeContainer promise is being kept or broken.

```text
Declaration -> Event -> Reconcile -> Metric -> Alert -> Verdict -> Repair -> Evidence
```

## Doctrine

```text
Core reconciles.
Store remembers.
Operations heals.
Governance decides.
Trust scores.
Identity names.
Agent acts.
Relation connects.
Mathematics models.
Data flows.
Simulation forecasts.
Statistics measures.
Provenance proves.
History orders.
Movie explains.
Live Stream shows now.
```

## Offices

| Primitive | Office |
|---|---|
| Event | state transition |
| Metric sample | measured signal |
| Alert | testimony |
| Log line | supporting record |
| Status condition | promise surface |
| Runbook step | procedure state |
| Repair action | reconciliation act |
| Trust update | standing change |
| Verdict update | judgment change |

## Stream model

Every stream item should be reducible to a relation:

```text
(subject, predicate, object, evidence, time)
```

Examples:

```text
(kubecontainer/hello-metakube, became, Ready, status.condition/Ready, 2026-06-14T00:00:00Z)
(prometheus, witnessed, KubeContainerWaiting, alert/KubeContainerWaiting, 2026-06-14T00:00:30Z)
(repair-agent, executed, describe-pod, runbook/KubeContainerWaiting#step1, 2026-06-14T00:01:00Z)
(metakube, judged, PROMISE_KEPT, evidence/report, 2026-06-14T00:02:00Z)
```

## Live stream layers

### Kubernetes stream

```bash
kubectl get events --all-namespaces --watch
kubectl get kubecontainers --all-namespaces --watch
kubectl get pods --all-namespaces --watch
```

### Operator stream

```bash
kubectl -n kubecontainer-system logs deploy/kubecontainer-controller-manager -f
```

### Prometheus stream

Prometheus itself is pull-based, but MetaKube treats recent samples, target health, and firing alerts as stream material.

```text
/metrics -> Prometheus scrape -> alert evaluation -> live testimony
```

### Observance stream

The Observance stream binds low-level signals back to promise objects:

```text
Kubernetes event -> owning Pod -> owning Deployment -> owning KubeContainer -> verdict
```

## Why Live Stream matters

Without Live Stream, MetaKube can only explain after the fact.

With Live Stream, MetaKube can show the promise being kept in real time.

```text
Logs are fragments.
Metrics are samples.
Events are transitions.
History is memory.
Movie is replay.
Live Stream is presence.
```

## Canonical line

Live Stream is the present-tense movie of a KubeContainer promise: the real-time flow of evidence from declaration to verdict.
