# FabriKube Clouds and Safety Guarantee

FabriKube can surface as specialized clouds, each governed by the same kube rule and safety guarantee.

```text
App Cloud = application lifecycle management for every KubeApp.
Image Cloud = image generation, storage, provenance, search, and delivery.
AI Cloud = model, agent, inference, evaluation, and automation lifecycle.
Skill Cloud = learn, build, showcase, monetize, and personalize skills.
```

The sovereignty line:

```text
Everything in cloud, data on desk.
```

Cloud runs the lifecycle, automation, AI, image, skill, showcase, and monetization loops. Data remains owner-bound, portable, classed, and recoverable at the user's desk unless a declared policy explicitly permits movement.

## Complete safety guarantee

Safety is not a slogan. It is a control fabric across identity, policy, data, cost, automation, lifecycle, and evidence.

```text
Safety guarantee = nothing acts without identity, scope, policy, reason, and record.
```

| Safety control | Guarantee | Verdict |
|---|---|---|
| Identity | Every actor is named before action | IDENTITY_BOUND |
| Access | Every action is authorized before execution | ACCESS_DECIDED |
| Policy | Every app and cloud action passes declared policy | POLICY_PASSED |
| Data | Every data movement has classification, lineage, and permission | DATA_GUARDED |
| Cost | Every workload has budget and right-sizing controls | COST_BOUNDED |
| Automation | Every autonomous action is scoped and reversible where required | AUTOMATION_GUARDED |
| AI | Every model or agent action has provenance, evals, and allowed purpose | AI_GUARDED |
| Image | Every generated or transformed image has provenance and rights metadata | IMAGE_GUARDED |
| Skill | Every learning or monetized skill has outcome evidence | SKILL_GUARDED |
| Experience | Every surface records impact and owner | EXPERIENCE_GUARDED |
| Evidence | Every claim names the verdict that proves it | EVIDENCE_ATTACHED |

## App Cloud

App Cloud is the core offering: application lifecycle management for every KubeApp.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeAppCloud
metadata:
  name: fabric-app-cloud
spec:
  lifecycle:
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
  controls:
    identityFabric: required
    accessManagement: required
    costOptimization: required
    dataFabric: required
    experienceManagement: required
  automation:
    mode: governed-autonomous
  evidence:
    requiredVerdicts:
      - APP_LIFECYCLE_MANAGED
      - POLICY_PASSED
      - COST_BOUNDED
      - PROMISE_KEPT
```

## Data on desk

Data on desk means the user or owning organization keeps control of data location, retention, portability, and permitted movement.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeDeskData
metadata:
  name: owner-desk-data
spec:
  location:
    default: owner-desk
    allowedCloudCopies: policy-bound
  movement:
    requireConsent: true
    requirePurpose: true
    requireLineage: true
    requireReturnOrDelete: true
  access:
    identityFabric: required
    searchFiltered: true
  portability:
    exportRequired: true
    restoreRequired: true
  verdicts:
    required:
      - DATA_GUARDED
      - LINEAGE_RECORDED
      - OWNER_CONTROL_HELD
```

## Image Cloud

Image Cloud manages the lifecycle of images: create, transform, store, search, deliver, monetize, and prove provenance.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeImageCloud
metadata:
  name: creator-image-cloud
spec:
  lifecycle:
    - generate
    - transform
    - store
    - search
    - deliver
    - monetize
    - retire
  storage:
    fabric: data-fabric
  search:
    engine: opensearch
  provenance:
    required: true
    rightsMetadata: required
  safety:
    contentPolicyRequired: true
    identityRequired: true
    evidenceRequired: true
  verdicts:
    required:
      - IMAGE_GUARDED
      - PROVENANCE_ATTACHED
      - DELIVERY_PROVEN
```

## AI Cloud

AI Cloud manages models, agents, inference, tools, evaluations, automation, and cost optimization.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeAICloud
metadata:
  name: agent-ai-cloud
spec:
  capabilities:
    - models
    - agents
    - tools
    - inference
    - evaluation
    - automation
  lifecycle:
    - declare
    - evaluate
    - release
    - run
    - observe
    - optimize
    - repair
    - retire
  safety:
    allowedPurposeRequired: true
    evalRequired: true
    humanOverrideRequired: true
    identityRequired: true
    dataPolicyRequired: true
  costOptimization:
    tokenBudgetRequired: true
    computeBudgetRequired: true
    rightSizingRequired: true
  verdicts:
    required:
      - AI_GUARDED
      - EVAL_PASSED
      - COST_BOUNDED
```

## Skill Cloud

Skill Cloud manages learning, building, showcasing, monetizing, and improving any skill or tool.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeSkillCloud
metadata:
  name: creator-skill-cloud
spec:
  lifecycle:
    - learn
    - build
    - package
    - run
    - showcase
    - monetize
    - improve
    - retire
  personalization:
    required: true
    explainRecommendations: true
  marketplace:
    enabled: true
    evidenceRequired: true
  access:
    identityFabric: required
    entitlementRequired: true
  verdicts:
    required:
      - SKILL_GUARDED
      - LEARNING_APPLIED
      - OFFER_LISTED
      - DELIVERY_PROVEN
```

## Safety rule

No cloud may skip the platform's safety gate.

```text
No identity, no action.
No policy, no action.
No data classification, no data movement.
No budget, no autonomous spend.
No eval, no AI release.
No provenance, no image delivery.
No evidence, no monetized claim.
No owner control, no data movement.
```