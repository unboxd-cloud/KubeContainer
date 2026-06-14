# Apache Airavata and FabriKube Alignment

Apache Airavata is a useful reference point for FabriKube's workflow and gateway ambitions.

Airavata describes itself as a software framework for composing, managing, executing, and monitoring large-scale applications and workflows across distributed resources: local clusters, supercomputers, computational grids, and computing clouds.

FabriKube uses that direction for the Kubernetes-native product layer:

```text
Airavata-style distributed workflow and gateway management
+ Kubernetes-native kube contracts
+ application lifecycle management
+ identity fabric
+ data fabric
+ experience management
+ cost optimization
+ safety guarantee
= FabriKube App Cloud
```

## Fit

| Airavata idea | FabriKube placement |
|---|---|
| Compose workflows | KubePipeline and KubeApp lifecycle |
| Manage applications | KubeApp application lifecycle management |
| Execute on distributed resources | KubeStack across Kubernetes clusters and external compute gateways |
| Monitor workflows | Observance, Prometheus witness, KubeSearch evidence indexes |
| Desktop and web interfaces | KubeBrowser, KubeExperience, seat tunnels |
| Generated data management | KubeStore, Data Fabric, KubeDataSync, data-on-desk rule |
| User analytics | Experience Management and KubeSearch |

## Boundary

Airavata is not copied into FabriKube. It is the pattern for distributed workflow and science-gateway-style orchestration. FabriKube keeps its own product law:

```text
Declaration + Loop + Face + Record + Contract + Verdict
```

## KubeGateway contract

`KubeGateway` is the bridge between a KubeApp and external compute, workflow, or science-gateway systems such as Airavata-style environments.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeGateway
metadata:
  name: airavata-style-gateway
spec:
  targets:
    - name: local-cluster
      type: kubernetes
    - name: hpc-gateway
      type: external-compute
    - name: cloud-runner
      type: cloud-compute
  workflows:
    compose: true
    execute: true
    monitor: true
    retrieveData: true
  identity:
    fabric: required
  data:
    sync: governed
    defaultLocation: owner-desk
  evidence:
    requiredVerdicts:
      - GATEWAY_BOUND
      - WORKFLOW_EXECUTED
      - DATA_RETRIEVED
      - PROMISE_KEPT
```

## Rule

A gateway may run work elsewhere, but the app contract remains answerable in FabriKube: identity, data movement, cost, automation, evidence, and lifecycle verdicts stay attached.