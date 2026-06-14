# Data Sync, Governance, and Seat Tunnel

This layer keeps the `everything in cloud, data on desk` rule workable.

```text
Data Sync = move only what policy allows.
Governance = decide, record, and prove every allowed movement.
Seat Tunnel = give each user or agent a scoped path to the app without exposing everything.
Calico-style policy = keep network access explicit and default-denied.
```

## Data Sync

`KubeDataSync` synchronizes owner-bound data between desk, cloud, app, search, AI, and archive according to declared policy.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeDataSync
metadata:
  name: commerce-data-sync
spec:
  source:
    location: owner-desk
    classification: private
  targets:
    - name: app-cloud-cache
      purpose: runtime-cache
      retention: 24h
    - name: search-index
      purpose: query
      retention: 30d
  movement:
    requireConsent: true
    requirePurpose: true
    requireLineage: true
    requireDeleteAfterRetention: true
  verdicts:
    required:
      - DATA_SYNC_ALLOWED
      - LINEAGE_RECORDED
      - RETENTION_ENFORCED
```

## Governance

`KubeGovernance` is the policy and evidence office for lifecycle, identity, data, cost, automation, AI, image, skill, and experience controls.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeGovernance
metadata:
  name: fabric-governance
spec:
  policies:
    - identity-required
    - access-required
    - data-classification-required
    - cost-budget-required
    - ai-eval-required
    - provenance-required
    - evidence-required
  decisions:
    recordPrincipal: true
    recordReason: true
    recordVerdict: true
  verdicts:
    required:
      - POLICY_PASSED
      - DECISION_RECORDED
      - GOVERNANCE_APPLIED
```

## Seat Tunnel

`KubeSeatTunnel` gives each user, team, agent, or customer seat a scoped tunnel into the app or fabric. A seat tunnel is not broad network access; it is a governed path for one seat, one purpose, one scope.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeSeatTunnel
metadata:
  name: analyst-seat-tunnel
spec:
  seat:
    principal: user:analyst@example.com
    relation: viewer
  target:
    app: commerce-demo
    face: kube-browser
  scope:
    namespaces: [commerce]
    actions: [observe, search, export-approved]
  controls:
    identityFabric: required
    accessDecision: required
    sessionRecord: required
    expiry: 8h
  verdicts:
    required:
      - SEAT_TUNNEL_BOUND
      - ACCESS_DECIDED
      - SESSION_RECORDED
```

## Calico-style network policy

The network posture is default-deny with explicit application, data, and tunnel paths. Calico can implement this, but the contract is policy-first so other Kubernetes NetworkPolicy-compatible implementations may also satisfy it.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: commerce-default-deny
  namespace: commerce
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-seat-tunnel-to-browser
  namespace: commerce
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: kube-browser
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              fabric.unboxd.cloud/office: seat-tunnel
```

## Rule

Data may sync only through governance. Seats may tunnel only through identity and access management. Network paths are closed until declared open.