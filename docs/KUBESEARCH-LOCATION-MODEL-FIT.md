# KubeSearch Location and Model Fit

KubeSearch Location and Model Fit extends search beyond text: where something belongs, which model should handle it, and how well a result fits the user's intent.

```text
Location search = query + place + scope + policy + distance + entitlement
Model fit = task + capability + cost + latency + quality + safety + context
```

## Placement

| Layer | Role |
|---|---|
| KubeSearch | indexes and retrieves location-aware, vector, text, and metadata records |
| KubeAnalytics | scores fit, ranks results, and explains recommendations |
| KubeArithmetic | calculates distance, score, cost, confidence, and thresholds |
| KubeMath | defines fit models, constraints, and optimization goals |
| KubeAgentRuntime | picks tools, models, and data sources based on fit |
| KubeImage | searches images by tags, embeddings, provenance, rights, and location |
| KubeExperience | personalizes results by user journey and surface context |
| Identity Fabric | filters by access, entitlement, region, and relationship |

## Location search contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeLocationSearch
metadata:
  name: fabric-location-search
spec:
  indexes:
    - name: apps-by-region
      subjects: [KubeApp, KubeNode, KubeExperience]
    - name: data-by-location
      subjects: [KubeStore, KubeObjectStore, KubeDeskData]
    - name: images-by-place
      subjects: [KubeImage, KubeObjectRecord]
  location:
    coordinateSystem: wgs84
    hierarchy:
      - desk
      - room
      - site
      - city
      - region
      - country
      - cloud-region
  governance:
    identityFabric: required
    regionPolicyRequired: true
    dataResidencyRequired: true
    purposeRequired: true
  evidence:
    requiredVerdicts:
      - LOCATION_INDEXED
      - REGION_POLICY_CHECKED
      - LOCATION_RESULTS_FILTERED
```

## Model fit contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeModelFit
metadata:
  name: fabric-model-fit
spec:
  dimensions:
    - capability
    - cost
    - latency
    - contextWindow
    - quality
    - safety
    - dataPolicy
    - toolAccess
    - region
  scoring:
    formula: weighted-fit-score
    explain: required
    threshold: holder-defined
  appliesTo:
    - model-routing
    - search-ranking
    - image-processing
    - agent-tool-selection
    - learning-recommendations
    - node-placement
  governance:
    noHiddenScores: true
    identityFabric: required
    purposeRequired: true
    arithmeticRecordRequired: true
  evidence:
    requiredVerdicts:
      - MODEL_FIT_CALCULATED
      - FIT_EXPLAINED
      - FIT_POLICY_PASSED
```

## Model fit record

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeFitDecision
metadata:
  name: image-edit-model-fit-2026-06-14
spec:
  task: image-background-removal
  candidateModels:
    - vision-fast
    - vision-quality
    - local-desk-model
  selected: vision-quality
  reason:
    capability: best-for-edit-quality
    cost: within-budget
    latency: acceptable
    dataPolicy: source-image-cloud-allowed
  score: holder-defined
  formula: weighted-fit-score
  verdict: MODEL_FIT_CALCULATED
```

## Search map

```text
user intent
  -> identity and entitlement
  -> location scope
  -> text/vector/metadata query
  -> model fit scoring
  -> policy filtering
  -> ranked result set
  -> explanation and ledger record
```

## Local proof

Search is optional in the first MetaKube proof. The target is discoverable so the path is visible:

```sh
make metakube-search
```

The first implementation may print the contract location until a real Solr/OpenSearch/Pinot-backed search stack is added.

## Rule

No location result without region policy. No model choice without fit reason. No score without formula. No personalized result without identity and purpose.