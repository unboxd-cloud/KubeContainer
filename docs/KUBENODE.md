# KubeNode

KubeNode is the compute placement kube for FabriKube.

```text
KubeNode = declared compute seat + placement loop + node face + node record + capacity contract
```

A node is not only a Kubernetes worker. In FabriKube, a node is any declared place where work may safely land: cloud, desk, edge, AI/GPU, gateway, or local proof.

## Node types

| Node type | Meaning | First verdict |
|---|---|---|
| Cloud node | Runs app, AI, image, skill, automation, and marketplace workloads in cloud | NODE_READY |
| Desk node | Holds owner-bound data and local sync/runtime where data stays on desk | DESK_BOUND |
| Edge node | Runs close to devices, locations, or offline environments | EDGE_READY |
| AI node | Provides GPU, accelerator, model, or inference capacity | AI_NODE_READY |
| Gateway node | Bridges external compute such as Airavata-style HPC/cloud workflows | GATEWAY_BOUND |
| MetaKube node | Proves the local fabric in Minikube | PROMISE_KEPT |

## KubeNode contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeNode
metadata:
  name: desk-node-01
spec:
  type: desk
  owner: user:owner@example.com
  placement:
    accepts:
      - data-sync
      - local-cache
      - private-index
    rejects:
      - ungoverned-cloud-copy
      - autonomous-spend
  capacity:
    cpu: holder-defined
    memory: holder-defined
    storage: holder-defined
    gpu: optional
  identity:
    fabric: required
  data:
    defaultLocation: owner-desk
    movementRequiresPolicy: true
  network:
    seatTunnel: required
    defaultDeny: true
  evidence:
    requiredVerdicts:
      - NODE_READY
      - OWNER_CONTROL_HELD
      - DATA_GUARDED
```

## Placement rule

KubeApp decides where each part lands by matching workload intent to node contract.

```text
workload intent + data policy + identity + cost + capacity + safety -> node placement verdict
```

Example:

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeApp
metadata:
  name: commerce-demo
spec:
  placement:
    web:
      nodeSelector:
        fabric.unboxd.cloud/node-type: cloud
    private-data-cache:
      nodeSelector:
        fabric.unboxd.cloud/node-type: desk
    inference:
      nodeSelector:
        fabric.unboxd.cloud/node-type: ai
  evidence:
    requiredVerdicts:
      - PLACEMENT_DECIDED
      - COST_BOUNDED
      - DATA_GUARDED
```

## Everything in cloud, data on desk

KubeNode is how the sovereignty line becomes operational.

```text
Cloud node runs the application loop.
Desk node keeps owner-bound data.
Seat tunnel connects a principal to a scoped face.
Data sync moves only what governance allows.
```

## Node safety

No workload lands on a node until these questions are answered:

- who owns this node;
- what work it accepts;
- what data may land here;
- what network paths are open;
- what cost or capacity bound applies;
- what evidence proves the node kept its contract.

## Rule

No node, no placement. No placement verdict, no run.