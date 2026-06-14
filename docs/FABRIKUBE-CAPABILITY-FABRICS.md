# FabriKube Capability Fabrics

FabriKube is application lifecycle management surrounded by four capability fabrics.

```text
FabriKube = KubeApp lifecycle + Identity Fabric + Data Fabric + Experience Management + Personalized Learning
```

Each fabric is a set of kubes with declarations, loops, faces, records, contracts, and verdicts.

## Capability map

| Fabric | Purpose | Primary kube | First verdict |
|---|---|---|---|
| Identity Fabric | Know who acts, who owns, and who may do what | KubeIdentity | IDENTITY_BOUND |
| Data Fabric | Know where data lives, moves, is protected, and is proven | KubeStore | DATA_ACCOUNTED |
| Experience Management | Know what each user or party experiences across surfaces | KubeExperience | EXPERIENCE_DELIVERED |
| Personalized Learning | Adapt guidance, automation, and journeys to the person or agent | KubeLearning | LEARNING_APPLIED |

## Identity Fabric

Identity Fabric binds principals, agents, services, owners, teams, devices, and contracts into one accountable graph.

Baseline:

- Kubernetes RBAC remains the required control plane baseline.
- ServiceAccounts identify in-cluster automation.
- OpenFGA is the optional relationship authorization engine.
- DID/web is the optional portable identifier layer.
- Every lifecycle action records principal, relation, action, reason, and verdict.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeIdentity
metadata:
  name: commerce-identity
spec:
  baseline: kubernetes-rbac
  optionalProviders:
    - openfga
    - did-web
  relations:
    - principal: team-commerce
      relation: owner
      object: kubeapp/commerce-demo
    - principal: agent-release
      relation: editor
      object: kubepipeline/commerce-release
  verdicts:
    required:
      - IDENTITY_BOUND
      - ACCESS_DECIDED
```

## Data Fabric

Data Fabric binds stores, streams, records, backups, retention, lineage, and evidence.

Baseline:

- `KubeStore` owns data lifecycle: provision, protect, backup, restore, retain, retire.
- provenance records where data came from and where it moved;
- policy decides whether data may move;
- evidence proves backup, restore, retention, and access promises.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeDataFabric
metadata:
  name: commerce-data
spec:
  stores:
    - name: orders
      kind: KubeStore
      engine: postgres
      retention: 90d
    - name: events
      kind: KubeStore
      engine: object
      retention: 365d
  lineage:
    required: true
  backup:
    required: true
  restore:
    testCadence: weekly
  verdicts:
    required:
      - DATA_ACCOUNTED
      - BACKUP_VERIFIED
      - RESTORE_TESTED
```

## Experience Management

Experience Management binds the app's faces to the user journey. It does not replace the app; it measures and manages the lived surface of the app.

Baseline:

- every face has an owner;
- every journey names its intended outcome;
- every experience has health, latency, accessibility, and satisfaction evidence where applicable;
- `KubeBrowser` is the first surface kube for browsing apps, records, and verdicts.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeExperience
metadata:
  name: commerce-experience
spec:
  faces:
    - name: web
      owner: team-commerce
      app: commerce-demo
    - name: admin
      owner: team-ops
      app: commerce-demo
  journeys:
    - name: browse-to-order
      outcome: order-created
      evidence:
        latencyP95: required
        availability: required
        accessibility: required
  verdicts:
    required:
      - EXPERIENCE_DELIVERED
```

## Personalized Learning

Personalized Learning adapts instruction, workflow guidance, automation, and recommendations to the learner or operator while keeping the record honest.

Baseline:

- the learner profile is declared, consented, and bounded;
- recommendations carry reason and evidence;
- no learning action silently changes authorization;
- learning improves the path without hiding the contract.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeLearning
metadata:
  name: commerce-learning
spec:
  learners:
    - kind: human
      scope: operator-training
    - kind: agent
      scope: repair-recommendations
  personalization:
    consentRequired: true
    explainRecommendations: true
    preserveAuditRecord: true
  outcomes:
    - name: faster-repair
      measure: time-to-recovery
    - name: safer-release
      measure: failed-rollout-rate
  verdicts:
    required:
      - LEARNING_APPLIED
      - REASON_RECORDED
```

## KubeApp integration

A KubeApp can bind all fabrics in one lifecycle declaration:

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeApp
metadata:
  name: commerce-demo
spec:
  lifecycle:
    goal: application-lifecycle-management
  fabrics:
    identity: commerce-identity
    data: commerce-data
    experience: commerce-experience
    learning: commerce-learning
  automation:
    mode: autonomous
  costOptimization:
    required: true
  evidence:
    witness: prometheus
    requiredVerdict: PROMISE_KEPT
```

## Rule

No fabric may bypass the kube rule. Each capability must declare what it does, keep it with a loop, expose one face, preserve a record, and name the verdict that proves the contract held.