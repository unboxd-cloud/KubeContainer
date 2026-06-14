# MACH Fabric

MACH makes software composable. Fabric makes composable software accountable.

```text
MACH = Microservices + API-first + Cloud-native + Headless
Fabric = Identity + Relation + Governance + Trust + Evidence + Provenance + Repair
```

## Definition

MACH Fabric is the accountable implementation of MACH architecture using KubeContainer as the deployable promise unit and MetaKube as the proving fabric.

```text
Microservice -> KubeContainer
API contract -> declared face
Cloud-native -> Kubernetes + Prometheus + OCI + operator reconciliation
Headless -> UI independent from runtime and governance
Fabric -> trust, evidence, identity, provenance, market, repair
```

## Offices

| MACH term | Fabric office | KubeContainer implementation |
|---|---|---|
| Microservices | promise units | one KubeContainer per service/workload |
| API-first | declared face | ports, health checks, events, OpenAPI/AsyncAPI contracts later |
| Cloud-native | runtime substrate | Kubernetes, OCI image, operator, Prometheus telemetry |
| Headless | separated experience | backend/runtime decoupled from UI, console, site, marketplace |
| Composable | relation graph | services connected by identity, relation, policy, and evidence |
| Replaceable | governed substitution | versioned contract, compatibility corpus, provenance, rollback |

## KubeContainer as MACH unit

A KubeContainer is not only a Kubernetes object. It is the productized unit of MACH:

```text
KubeContainer = Microservice + API Face + Runtime Contract + Evidence Surface
```

It declares:

- image
- port
- scaling
- exposure
- health check
- resources later
- contract metadata later
- evidence status

## MetaKube as MACH proving fabric

MetaKube proves that a MACH unit can run before it is promoted:

```text
Declaration -> Build -> Deploy -> Observe -> Verify -> Evidence -> Promote
```

MetaKube includes:

- Minikube as local substrate
- KubeContainer operator as reconciler
- Prometheus as witness
- Cortex as long-term evidence store for enterprise mode
- runbooks as procedures
- Observance as verdict layer

## Fabric extension over MACH

MACH alone does not answer:

```text
Who owns this service?
Who may deploy it?
Which policy allowed it?
What signal proved it worked?
Who repaired it?
What changed over time?
Can it be trusted?
Can it be sold or reused?
```

Fabric adds those answers.

```text
MACH service + identity = owned service
MACH service + governance = permitted service
MACH service + telemetry = witnessed service
MACH service + evidence = provable service
MACH service + trust = reusable service
MACH service + market = tradable service
```

## Reference architecture

```text
Human / Team / Agent
   ↓ declares
KubeContainer
   ↓ reconciled by
KubeContainer Operator
   ↓ materializes
Deployment / Service / Ingress / HPA
   ↓ witnessed by
Prometheus
   ↓ preserved by
Cortex
   ↓ judged by
MetaKube Observance
   ↓ repaired by
Repair Agent
   ↓ published to
Fabric Market
```

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

## Canonical line

Fabric is MACH with memory, evidence, governance, trust, and repair.
