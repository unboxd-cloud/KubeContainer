# Meta Platform Release

## Release name

```text
Meta Platform v0.1.0
MACH Fabric Proof Edition
```

## Definition

Meta Platform is the accountable cloud-native platform layer built from KubeContainer and MetaKube.

It is not only an operator release. It is a platform release that packages the first complete proof loop:

```text
Declare -> Build -> Reconcile -> Witness -> Store -> Judge -> Repair -> Publish
```

## Platform equation

```text
Meta Platform = KubeContainer + MetaKube + MACH Fabric + Prometheus Witness + Cortex Store + Observance + Release Gate
```

## What is released

| Layer | Release content |
|---|---|
| Core | KubeContainer CRD, operator, sample workload |
| MetaKube | Minikube local proving fabric and scripts |
| MACH Fabric | Microservices, API-first, cloud-native, headless architecture mapped to Fabric accountability |
| Witness | Prometheus telemetry model and scrape config |
| Store | Cortex as long-term evidence-store model |
| Operations | runbook-oriented repair path and Observance verdict script |
| Governance | release gate, doctrine, publish rule |
| Evidence | `dist/metakube-report.txt` artifact path |

## Release artifacts

```text
README.md
docs/MACH-FABRIC.md
docs/METAKUBE-STACK.md
docs/PROMETHEUS-AS-WITNESS.md
docs/METAKUBE-TELEMETRY.md
docs/METAKUBE-LIVE-STREAM.md
docs/RELEASE-GATE.md
docs/META-PLATFORM-RELEASE.md
hack/metakube/*.sh
hack/metakube/prometheus.yml
examples/metakube/hello-kubecontainer.yaml
.github/workflows/metakube.yml
```

## Release gate

The platform release is green only when:

```bash
make metakube-verify
```

produces:

```text
Verdict: PROMISE_KEPT
```

## Release promise

Meta Platform proves that a cloud-native unit of work can be declared, reconciled, witnessed, evidenced, and governed before it is published.

## Doctrine

```text
MACH composes.
KubeContainer packages.
MetaKube proves.
Prometheus witnesses.
Cortex preserves.
Fabric governs.
Repair reconciles.
Market exchanges.
```

## Public positioning

Meta Platform is MACH with accountability: every microservice becomes a promise object, every runtime signal becomes evidence, and every release passes through a proof gate.

## Tagging plan

Use a platform tag distinct from the operator tag:

```text
meta-platform-v0.1.0
```

The operator itself may later use:

```text
v0.2.0
```

This separation keeps product layers clean:

```text
KubeContainer v0.2.0 = operator/product unit
Meta Platform v0.1.0 = platform/proof stack
```

## Canonical line

A Meta Platform release is not a bundle of files. It is the first published proof that the Fabric can keep, witness, and judge a promise.
