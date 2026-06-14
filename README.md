# The Fabric

**Kube — the soul of Any'Thing'.**

An intelligent operating system of work: declared outcomes, kept by autonomous loops, woven from contracts, with provenance attached to everything it delivers. The fabric is built from kubes — whole, indivisible units of kept promises — and this repository contains its first one, plus the constitution the whole weave answers to.

**KubeContainer** is that first kube: a Kubernetes operator where twelve lines of YAML become a running, scaled, exposed, self-healing workload — the reference implementation of the [Kube product specification](docs/KUBE-SPEC.md), governed by the [founding principles](docs/FOUNDING-PRINCIPLES.md). You declare what you want; the kube makes it true, keeps it true, proves it was true, and answers for it.

## MACH Fabric

MACH makes software composable. Fabric makes composable software accountable.

```text
MACH = Microservices + API-first + Cloud-native + Headless
Fabric = Identity + Relation + Governance + Trust + Evidence + Provenance + Repair
```

KubeContainer is the deployable MACH unit. MetaKube is the local proving fabric. Prometheus is the witness. Cortex is the long-term evidence store. Observance turns evidence into verdicts.

```text
Microservice -> KubeContainer
API contract -> declared face
Cloud-native -> Kubernetes + Prometheus + OCI + operator reconciliation
Headless -> UI independent from runtime and governance
Fabric -> trust, evidence, identity, provenance, market, repair
```

## MetaKube local build

MetaKube turns Minikube into the local fabric for building and proving KubeContainers.

```sh
make metakube-up
make metakube-sample
make metakube-observe
```

Or run the full local proof loop:

```sh
make metakube-verify
```

The expected verdict is:

```text
PROMISE_KEPT
```

## Proof, not promises

Nothing here asks to be believed; everything names its verdict:

| Claim | Check it |
|---|---|
| It ships | Release artifacts, images, install bundles, and digests |
| It works locally | `make metakube-verify` creates a Minikube fabric, deploys the operator, applies a sample KubeContainer, and emits an Observance verdict |
| It works in real clusters | The e2e gate: a declared workload must converge and serve HTTP 200 in a live cluster |
| It will not break its word | The golden compatibility corpus under `internal/controller/testdata/compat/` keeps era manifests valid |
| It carries evidence | MetaKube reports and eval reports bind outcomes to proof |
| It is governed | The charter, lexicon, protocols, and vocabulary checks keep doctrine from drifting |

## Example

```yaml
apiVersion: kubecontainer.unboxd.cloud/v1alpha1
kind: KubeContainer
metadata:
  name: my-app
spec:
  image: ghcr.io/acme/my-app:1.4.2
  port: 8080
  scaling:
    autoscale:
      minReplicas: 2
      maxReplicas: 10
  expose:
    type: Ingress
    host: my-app.example.com
  healthCheck:
    path: /healthz
```

## The document map

| Read | For |
|---|---|
| [MACH-FABRIC.md](docs/MACH-FABRIC.md) | MACH as accountable Fabric architecture |
| [METAKUBE-STACK.md](docs/METAKUBE-STACK.md) | Core, Store, Operations, Governance, evidence stack |
| [PROMETHEUS-AS-WITNESS.md](docs/PROMETHEUS-AS-WITNESS.md) | Prometheus as witness; alerts as testimony; metrics as evidence |
| [METAKUBE-TELEMETRY.md](docs/METAKUBE-TELEMETRY.md) | Telemetry and Prometheus scrape model |
| [METAKUBE-LIVE-STREAM.md](docs/METAKUBE-LIVE-STREAM.md) | Real-time evidence stream |
| [KUBE-SPEC.md](docs/KUBE-SPEC.md) | What a kube is — anatomy, guarantees, conformance |
| [DESIGN.md](docs/DESIGN.md) | The operator architecture and roadmap |
| [FOUNDING-PRINCIPLES.md](docs/FOUNDING-PRINCIPLES.md) | The constitution: principles, axiom, promise |
| [AGENT-PLATFORM.md](docs/AGENT-PLATFORM.md) | The agent ladder, lexicon, anti-drift protocols |
| [GO-TO-MARKET.md](docs/GO-TO-MARKET.md) | What is sold and to whom |
| [PRIMITIVES.md](docs/PRIMITIVES.md) | Every word, one self-explanatory statement |

## Features

- **One CRD for the common case** — Deployment + Service + optional Ingress/HPA from a dozen lines of YAML.
- **Self-healing** — drift in any managed child is reverted by the reconcile loop; deleting the CR garbage-collects everything via owner references.
- **Safe scaling semantics** — fixed `replicas` or an `autoscale` block, mutually exclusive and enforced by validation.
- **Observable and witnessed** — `Ready`/`Progressing`/`Degraded` conditions, Kubernetes events, controller-runtime metrics, and Prometheus-backed evidence.
- **Headless by default** — runtime and governance are decoupled from UI, console, site, and marketplace.

## Quickstart

Prerequisites: Kubernetes v1.30+, `kubectl`, Go, and Docker.

```sh
make docker-build docker-push IMG=<registry>/kubecontainer:v0.1.0
make deploy IMG=<registry>/kubecontainer:v0.1.0
kubectl apply -k config/samples/
kubectl get kubecontainers
```
