# KubeApp Application Lifecycle Management

KubeApp exists to manage the full application lifecycle, not only deployment.

```text
KubeApp = application lifecycle management for a declared stack.
```

The goal is one contract that covers the app from declaration to retirement:

```text
Declare -> Admit -> Build -> Release -> Run -> Observe -> Optimize -> Repair -> Upgrade -> Rollback -> Retire
```

## Lifecycle offices

| Office | Duty | First verdict |
|---|---|---|
| Stack | Declares workloads, stores, faces, and dependencies | STACK_DECLARED |
| Automation | Executes lifecycle steps without being re-asked | AUTOMATION_APPLIED |
| Identity | Names principals, agents, services, and owners | IDENTITY_BOUND |
| Access management | Decides who or what may act on each lifecycle step | ACCESS_ALLOWED or ACCESS_DENIED |
| Cost optimization | Measures requests, limits, replicas, waste, and recommendations | COST_BOUNDED |
| Observance | Maps runtime signals back to the application promise | PROMISE_KEPT or BREACH_RECORDED |
| Repair | Follows runbooks when a promise breaks | REPAIR_COMPLETE |
| Release | Rolls forward only after gates pass | ROLLOUT_COMPLETE |
| Rollback | Returns to last known kept promise on breach | ROLLBACK_COMPLETE |
| Retirement | Removes runtime while preserving record and evidence | RETIRED_WITH_RECORD |

## KubeApp lifecycle contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeApp
metadata:
  name: commerce-demo
spec:
  lifecycle:
    goal: application-lifecycle-management
    phases:
      - declare
      - admit
      - build
      - release
      - run
      - observe
      - optimize
      - repair
      - upgrade
      - rollback
      - retire

  automation:
    mode: autonomous
    sync: continuous
    repair: runbook
    rollback: automatic-on-breach

  identity:
    provider: kubernetes-rbac
    optionalProviders:
      - openfga
      - did-web
    principals:
      - name: owner
        relation: owner
      - name: operator
        relation: editor
      - name: viewer
        relation: viewer

  accessManagement:
    admission:
      requireOwner: true
      requirePolicyVerdict: true
    relations:
      owner:
        can: [declare, release, retire]
      editor:
        can: [declare, sync, repair]
      viewer:
        can: [observe]

  costOptimization:
    budget:
      monthly: holder-defined
      currency: holder-defined
    policy:
      requireResourceRequests: true
      requireAutoscalingReview: true
      idleWorkloadAction: recommend-scale-down
      overProvisionedAction: recommend-right-size
    evidence:
      requiredVerdict: COST_BOUNDED

  stack:
    components:
      - name: web
        kind: KubeContainer
        image: nginx:1.27
        port: 80
      - name: store
        kind: KubeStore
        engine: postgres

  evidence:
    witness: prometheus
    requiredVerdict: PROMISE_KEPT
```

## Automation

Automation is a lifecycle loop, not a script pile. It observes the declared app, compares the world to the declaration, acts through allowed steps, and records the result.

First automation promises:

- keep declared components present;
- keep dependency order respected;
- keep release gates enforced;
- keep repair paths explicit;
- keep rollback available when a breach is detected.

## Cost optimization

Cost optimization is a contract office. It does not merely report spend after the fact; it constrains lifecycle choices before and during runtime.

First cost promises:

- every scalable workload declares resource requests;
- autoscaling is preferred over fixed over-provisioning where safe;
- idle workloads are named;
- over-provisioned workloads receive right-size recommendations;
- every recommendation carries evidence and a reason.

## Identity and access management

Identity and access management decide who may ask for lifecycle change and which agent may perform it.

Baseline identity is Kubernetes-native:

- Kubernetes RBAC is the required baseline;
- ServiceAccounts identify in-cluster automation;
- optional OpenFGA adds relationship authorization;
- optional DID/web identity adds portable principal identity;
- admission records the principal, action, reason, and verdict.

## Juju-type operator model

The operating style is Juju-like: each application has lifecycle hooks, relations, config changes, upgrades, and removal behavior. The implementation remains Kubernetes-native: hooks become controller actions, relations become declared dependencies, and all changes pass through CRDs, policy, status, events, and evidence.

```text
Juju charm idea -> Kubernetes operator implementation
install hook -> create declared children
config-changed hook -> reconcile spec updates
relation-changed hook -> reconcile dependencies and bindings
upgrade hook -> rollout with gates
remove hook -> retire runtime and preserve record
```

## MetaKube proof

The first proof is intentionally local and small:

```sh
make metakube-verify
```

The proof is green only when the Minikube cluster is ready, the operator is ready, the sample KubeContainer is ready, Prometheus is scraping, and the verdict is `PROMISE_KEPT`.