# KubeCloud Stack

KubeCloud Stack is the complete deployable cloud stack for FabriKube.

```text
KubeCloud Stack = App Cloud + Data Fabric + Identity Fabric + AI Cloud + Skill Cloud + Observability + Ledger + Object Store + Build + Device/Edge
```

It is the stack that lets a user learn, build, showcase, monetize, run, govern, observe, and prove any app, skill, tool, model, image, or agent the Kubernetes way.

## Stack layers

| Layer | Kube office | Reference patterns |
|---|---|---|
| Cloud-native map | KubeLandscape | CNCF Landscape |
| Runtime | KubeContainer, KubeApp, KubeStack, KubeNode | Kubernetes, operators, Minikube |
| Application lifecycle | KubeApp, KubePipeline, KubeOrchestrator | Airflow-style workflows, Juju-style operator lifecycle |
| Build and release | KubeBuild, KubePipeline | BuildStream-style declarative build graphs |
| Data integration | KubeDataSync | SeaTunnel-style batch, realtime, full, incremental sync |
| Data governance | KubeAtlas, KubeGovernance | Atlas-style catalog, classification, lineage, stewardship |
| Storage | KubeStore, KubeObjectStore, KubeLedger | RustFS-style object storage, BookKeeper-style ledgers |
| Analytics | KubeAnalytics, KubeRealtimeAnalytics | Calcite, Avatica, Spark, Pinot |
| Search and knowledge | KubeSearch, KubeAnswer | Solr/OpenSearch, Apache Answer-style Q&A |
| AI and agents | KubeAICloud, KubeAgentRuntime, KubeAIObservability | MindsHub, MLflow, Langfuse |
| Experience | KubeBrowser, KubeExperience | governed app and knowledge surfaces |
| Arithmetic and models | KubeArithmetic, KubeMath | formulas, units, constraints, optimization, proofs |
| Observability | KubeObservability, Observance | Prometheus, ClickStack, OpenTelemetry-style signals |
| Security and access | Identity Fabric, KubeSeatTunnel | RBAC, OpenFGA-aligned relations, policy gates |
| Device and edge | KubeDeviceOS, KubeNode | LineageOS-style open device OS, edge nodes |
| Marketplace | KubeMarket | offers, entitlements, usage, settlement, delivery proof |

## Core promise

```text
Everything in cloud, data on desk.
```

Cloud runs lifecycle, orchestration, AI, analytics, search, marketplace, and observability. Owner-bound data may remain on desk, edge, or private nodes. Movement happens only through governed sync with identity, purpose, lineage, and verdict.

## Deployment shape

```text
KubeCloud Stack
  ├─ App Cloud
  │  ├─ KubeApp
  │  ├─ KubeStack
  │  ├─ KubePipeline
  │  └─ KubeOrchestrator
  ├─ Data Fabric
  │  ├─ KubeStore
  │  ├─ KubeObjectStore
  │  ├─ KubeLedger
  │  ├─ KubeDataSync
  │  ├─ KubeAtlas
  │  ├─ KubeAnalytics
  │  └─ KubeRealtimeAnalytics
  ├─ AI Cloud
  │  ├─ KubeAgentRuntime
  │  ├─ KubeAIObservability
  │  ├─ KubeModelRegistry
  │  └─ KubeLLMTrace
  ├─ Skill Cloud
  │  ├─ KubeSkill
  │  ├─ KubeTool
  │  ├─ KubeAnswer
  │  └─ KubeMarket
  ├─ Experience
  │  ├─ KubeBrowser
  │  └─ KubeExperience
  ├─ Governance
  │  ├─ Identity Fabric
  │  ├─ KubeGovernance
  │  ├─ KubeSeatTunnel
  │  └─ policy gates
  ├─ Math and proof
  │  ├─ KubeArithmetic
  │  ├─ KubeMath
  │  ├─ Observance
  │  └─ evidence records
  └─ Nodes
     ├─ cloud nodes
     ├─ desk nodes
     ├─ edge nodes
     ├─ AI nodes
     └─ gateway nodes
```

## First runnable stack

The first runnable stack remains deliberately small:

```sh
make metakube-verify
```

That proves:

```text
Minikube + KubeContainer operator + sample KubeContainer + Prometheus witness + verdict
```

The larger KubeCloud Stack grows from that proof by adding one kube at a time.

## Stack contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeCloudStack
metadata:
  name: fabric-cloud
spec:
  goal: application-lifecycle-management
  sovereignty:
    rule: everything-in-cloud-data-on-desk
  clouds:
    app: enabled
    data: enabled
    ai: enabled
    skill: enabled
    image: enabled
  fabrics:
    identity: required
    data: required
    experience: required
    learning: required
  foundations:
    build: required
    objectStore: required
    ledger: required
    observability: required
    arithmetic: required
    mathModels: required
  governance:
    fineGrainedControl: true
    policyRequired: true
    evidenceRequired: true
    costOptimizationRequired: true
  evidence:
    requiredVerdicts:
      - STACK_DECLARED
      - IDENTITY_BOUND
      - DATA_GUARDED
      - COST_BOUNDED
      - OBSERVABILITY_READY
      - PROMISE_KEPT
```

## Maturity path

1. Prove the workload kube: `KubeContainer`.
2. Prove local fabric: `MetaKube` on Minikube.
3. Add stack composition: `KubeApp` and `KubeStack`.
4. Add storage and record: `KubeObjectStore` and `KubeLedger`.
5. Add data movement and governance: `KubeDataSync` and `KubeAtlas`.
6. Add analytics/search/observability: `KubeAnalytics`, `KubeSearch`, `KubeObservability`.
7. Add AI/agents/skills: `KubeAgentRuntime`, `KubeAIObservability`, `KubeSkill`, `KubeTool`.
8. Add marketplace and monetization: `KubeMarket` and arithmetic pricing.
9. Add device/edge: `KubeDeviceOS` and desk/edge nodes.
10. Bind the whole stack to CNCF landscape categories and conformance verdicts.

## Rule

No cloud stack without a contract. No contract without identity, data policy, cost bounds, observability, ledger record, and verdict.