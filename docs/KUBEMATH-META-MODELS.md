# KubeMath Meta Models

KubeMath is the mathematical meta-model layer for FabriKube.

```text
KubeMath = meta model + formulas + constraints + units + optimization goals + proofs
```

KubeArithmetic calculates numbers. KubeMath defines the models those numbers belong to.

## Why meta models

A platform that manages apps, skills, data, identity, cost, search, analytics, AI, and marketplaces needs more than raw formulas. It needs mathematical models for each domain, and meta models that explain which models are valid, comparable, optimizable, and safe to act on.

```text
formula = one calculation
model = a set of formulas, variables, constraints, and goals
meta model = the rules for creating, comparing, governing, and proving models
```

## Placement

| Layer | KubeMath role |
|---|---|
| KubeArithmetic | defines valid formulas, units, dimensions, and formula versions |
| KubeAnalytics | defines query models, aggregation models, confidence, and insight rules |
| Cost optimization | defines cost models, savings models, budget constraints, and risk bounds |
| KubeMarket | defines pricing models, metering models, revenue share, and entitlement math |
| Skill Cloud | defines learning progress, proof, ranking, reputation, and fit models |
| Safety | defines thresholds, risk models, guardrails, and action constraints |
| KubeNode | defines capacity, placement, saturation, and quota models |
| Data Fabric | defines lineage completeness, data movement, retention, and governance models |
| AI Cloud | defines eval, drift, confidence, token, compute, and purpose-fit models |

## KubeMathModel contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeMathModel
metadata:
  name: workload-cost-model
spec:
  domain: cost-optimization
  variables:
    - name: cloud_cost
      unit: currency
      source: billing-record
    - name: successful_requests
      unit: count
      source: prometheus-witness
    - name: error_rate
      unit: ratio
      source: prometheus-witness
  formulas:
    - name: unit_cost
      expression: cloud_cost / successful_requests
      unit: currency_per_request
    - name: safe_savings
      expression: current_cost - recommended_cost
      unit: currency
  constraints:
    - name: max_error_rate
      expression: error_rate <= allowed_error_rate
    - name: budget_bound
      expression: recommended_cost <= budget
  goals:
    - minimize: unit_cost
    - preserve: availability_slo
  evidence:
    requiredVerdicts:
      - MODEL_DECLARED
      - UNITS_VALIDATED
      - CONSTRAINTS_CHECKED
      - MODEL_PROVEN
```

## Meta-model contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeMetaModel
metadata:
  name: fabric-math-meta-model
spec:
  appliesTo:
    - KubeArithmetic
    - KubeAnalytics
    - KubeMarket
    - KubeLearning
    - KubeNode
    - KubeAICloud
  requirements:
    sourceRequired: true
    unitRequired: true
    formulaVersionRequired: true
    dimensionCheckRequired: true
    constraintsRequiredBeforeAction: true
    explanationRequired: true
  actions:
    recommend:
      requires: [MODEL_PROVEN, CONSTRAINTS_CHECKED]
    automate:
      requires: [MODEL_PROVEN, SAFETY_BOUND, ACCESS_DECIDED]
    charge:
      requires: [PRICE_FORMULA_DECLARED, USAGE_METERED, ENTITLEMENT_BOUND]
  verdicts:
    required:
      - META_MODEL_DECLARED
      - MODEL_GOVERNED
      - ACTION_CONSTRAINED
```

## Avatica query face

KubeMath and KubeAnalytics need a standard query face so tools can ask for governed calculations without coupling to one database.

Apache Calcite Avatica is the reference pattern: a framework for database drivers with an HTTP server, JDBC client, and JSON or Protobuf wire API.

```text
KubeQueryFace = Avatica-style query API + identity + policy + model registry + evidence
```

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeQueryFace
metadata:
  name: fabric-query-face
spec:
  protocol: avatica-style
  transports:
    - http
  clients:
    - jdbc
    - language-client
  encoding:
    - json
    - protobuf
  governance:
    identityFabric: required
    modelRegistry: required
    purposeRequired: true
    queryRecordRequired: true
  evidence:
    requiredVerdicts:
      - QUERY_FACE_READY
      - MODEL_BOUND
      - ACCESS_DECIDED
      - QUERY_RECORDED
```

## Safety rule

A mathematical model may recommend action, but it may not silently perform action.

```text
model proposes
policy gates
governance records
automation acts only when allowed
```

## Rule

No hidden model. No untyped number. No unitless comparison. No unconstrained optimization. No automated action from an unproven model.