# CNCF Landscape Alignment

The CNCF Landscape is the reference map for cloud-native project placement in FabriKube.

The landscape is intended as a map through cloud-native technologies and categorizes projects and product offerings across the cloud-native ecosystem.

```text
CNCF Landscape = discovery map
FabriKube = accountable product fabric
Kube contract = declaration + loop + face + record + verdict
```

## Placement rule

FabriKube should prefer established cloud-native categories and projects where they fit, then bind them to kube contracts.

```text
known project -> declared role -> lifecycle loop -> evidence -> verdict
```

## Landscape mapping

| FabriKube office | Landscape-style category | Examples already placed |
|---|---|---|
| Runtime | container/runtime/orchestration | Kubernetes, KubeContainer, KubeNode |
| Observability | metrics/logs/traces/sessions | Prometheus, ClickStack, OpenTelemetry-style signals |
| Data and analytics | database/streaming/analytics | Spark, Pinot, Solr, OpenSearch, Calcite, SeaTunnel |
| Workflow | orchestration/scheduling | Airflow, KubePipeline, KubeOrchestrator |
| Security and compliance | identity/policy/secrets/governance | Identity Fabric, KubeAtlas, KubeGovernance, KubeSeatTunnel |
| Application definition | app specs/operators/controllers | KubeApp, KubeStack, KubeStore, KubeBrowser |
| AI and agents | AI engineering/runtime/evals | KubeAgentRuntime, MLflow, Langfuse, KubeAICloud |
| Edge and device | edge/device runtime | KubeDeviceOS, LineageOS-style device nodes |

## KubeLandscape contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeLandscape
metadata:
  name: fabric-cloud-native-landscape
spec:
  reference: cncf-landscape
  categories:
    - runtime
    - observability
    - data-analytics
    - workflow
    - security-compliance
    - application-definition
    - ai-agents
    - edge-device
  admission:
    preferOpenStandards: true
    preferCloudNativeProjects: true
    requireKubeContract: true
    requireEvidenceVerdict: true
  evidence:
    requiredVerdicts:
      - LANDSCAPE_MAPPED
      - CONTRACT_BOUND
      - EVIDENCE_REQUIRED
```

## Adoption rule

A project is not adopted by name alone. It must be placed.

```text
Name -> Role -> Boundary -> Data handled -> Identity needed -> Cost model -> Evidence -> Verdict
```

Example:

```text
Apache Spark
  -> KubeCompute
  -> distributed jobs
  -> governed datasets
  -> service account plus owner
  -> compute budget
  -> job record and lineage
  -> COMPUTE_READY / JOB_RECORDED
```

## Rule

Do not invent a platform category when the cloud-native ecosystem already has one. Do not adopt a landscape project without declaring its boundary, owner, lifecycle, and verdict.