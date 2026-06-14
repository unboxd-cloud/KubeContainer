# Fabric as Kube of Kubes

Fabric is the kube-of-kubes.

A kube is one kept promise. Fabric is the graph that holds many kubes, their relations, their evidence, their trust, and their history.

```text
Kube = one promise kept
Fabric = many kubes related, governed, observed, and scored
```

## Definition

Fabric is not only a platform around KubeContainer. Fabric is the higher-order kube that contains other kubes.

```text
FabricKube = Kube(Kube1, Kube2, Kube3, ..., KubeN)
```

Each inner kube has:

```text
identity
relation
declaration
runtime
evidence
verdict
trust
history
```

The FabricKube has the same shape, but at a higher level:

```text
FabricKube = identity + relations + declarations + runtime + evidence + verdicts + trust + history
```

## Kube hierarchy

```text
Fabric
└── Meta Platform
    └── MetaKube
        └── KubeContainer
            └── Kubernetes workload
```

Or as promise units:

```text
FabricKube
  contains MetaPlatformKube
    contains MetaKube
      contains KubeContainer
        contains Pod/Service/Ingress
```

## Decimal scoring model

Every kube receives a decimal score from `0.0` to `1.0`.

```text
0.0 = no proof
0.5 = partial proof
1.0 = promise kept with evidence
```

Fabric score is the weighted aggregate of its child kube scores.

```text
FabricScore = weighted_average(KubeScores)
```

For v0.1.0:

```text
FabricScore =
  0.40 * KubeContainerScore
+ 0.30 * MetaKubeScore
+ 0.20 * MetaPlatformScore
+ 0.10 * GovernanceScore
```

## KubeContainer score

```text
KubeContainerScore = average(CRD, Operator, Workload, Health, Evidence)
```

| Check | Score |
|---|---:|
| CRD installed | 1.0 else 0.0 |
| operator ready | 1.0 else 0.0 |
| workload created | 1.0 else 0.0 |
| health check passes | 1.0 else 0.0 |
| status/evidence emitted | 1.0 else 0.0 |

## MetaKube score

```text
MetaKubeScore = average(Cluster, Build, Deploy, Witness, Verdict)
```

| Check | Score |
|---|---:|
| Minikube cluster ready | 1.0 else 0.0 |
| operator image built | 1.0 else 0.0 |
| operator deployed | 1.0 else 0.0 |
| Prometheus witness present | 1.0 else 0.0 |
| Observance verdict emitted | 1.0 else 0.0 |

## Meta Platform score

```text
MetaPlatformScore = average(Core, Store, Operations, Governance, Trust, ReleaseReadiness)
```

| Dimension | Meaning |
|---|---|
| Core | promises can be built and reconciled |
| Store | evidence can be preserved |
| Operations | broken promises can be repaired |
| Governance | publish rules exist and are enforced |
| Trust | identity, relation, and evidence produce standing |
| ReleaseReadiness | gate is green and artifact exists |

## Governance score

```text
GovernanceScore = average(Identity, Relation, Policy, EvidenceCompleteness, ReleaseGate)
```

| Check | Score |
|---|---:|
| identity resolved | 1.0 else 0.0 |
| relations resolved | 1.0 else 0.0 |
| policy documented | 0.7 |
| policy enforced | 1.0 |
| evidence complete | 1.0 else 0.0 |
| release gate present | 1.0 else 0.0 |

## Verdict rollup

```text
if FabricScore >= 0.90 -> FABRIC_PROMISE_KEPT
if FabricScore >= 0.70 -> FABRIC_PROMISE_PARTIAL
if FabricScore <  0.70 -> FABRIC_PROMISE_BROKEN
```

## Doctrine

```text
A kube keeps one promise.
A Fabric keeps the promises between kubes.
A Meta Platform proves the Fabric can keep those promises.
```

## Canonical line

Fabric is the kube-of-kubes: the higher-order promise that many smaller promises can be related, governed, witnessed, scored, repaired, and trusted as one accountable whole.
