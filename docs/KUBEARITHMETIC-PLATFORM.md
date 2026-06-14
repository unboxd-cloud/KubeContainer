# KubeArithmetic Platform

KubeArithmetic is the calculation and measurement kube for FabriKube.

```text
KubeArithmetic = declared formula + calculation loop + number face + measurement record + arithmetic contract
```

The platform needs arithmetic because every serious claim eventually becomes a number: cost, price, usage, score, rank, quota, budget, latency, reputation, learning progress, entitlement, revenue, unit economics, and optimization.

## Placement

| Layer | Arithmetic role |
|---|---|
| KubeApp lifecycle | release risk, rollback thresholds, SLO math, health scoring |
| Cost optimization | budgets, unit cost, right-sizing, idle waste, savings estimates |
| KubeMarket | pricing, metering, revenue share, entitlements, invoices |
| Skill Cloud | progress scores, proof scores, reputation, learning path fit |
| KubeAnswer | votes, accepted-answer trust, reputation, repeated-question reduction |
| KubeAnalytics | formulas, aggregations, confidence, query cost estimates |
| KubeNode | capacity, utilization, placement cost, quota, saturation |
| KubeSearch | ranking, relevance, index freshness, query cost |
| Data Fabric | retention age, sync size, data movement cost, lineage completeness |
| Safety | thresholds, risk scores, policy limits, allowed spend |

## Rule of numbers

No number may stand alone.

Every number must carry:

- source;
- unit;
- formula;
- inputs;
- time window;
- owner;
- purpose;
- precision or confidence;
- verdict.

```text
number = value + unit + source + formula + time + owner + purpose + verdict
```

## KubeArithmetic contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeArithmetic
metadata:
  name: fabric-arithmetic
spec:
  formulas:
    - name: workload-unit-cost
      purpose: cost-optimization
      expression: cloud_cost / successful_requests
      unit: currency_per_request
      inputs:
        - cloud_cost
        - successful_requests
      verdict: UNIT_COST_CALCULATED
    - name: learning-progress-score
      purpose: personalized-learning
      expression: completed_outcomes / declared_outcomes
      unit: ratio
      inputs:
        - completed_outcomes
        - declared_outcomes
      verdict: PROGRESS_CALCULATED
    - name: answer-trust-score
      purpose: knowledge-quality
      expression: accepted_answer_weight + vote_weight + owner_review_weight
      unit: score
      inputs:
        - accepted_answer_weight
        - vote_weight
        - owner_review_weight
      verdict: TRUST_CALCULATED
  governance:
    identityFabric: required
    purposeRequired: true
    sourceRequired: true
    unitRequired: true
    formulaVersionRequired: true
  evidence:
    requiredVerdicts:
      - FORMULA_DECLARED
      - INPUTS_BOUND
      - CALCULATION_RECORDED
      - NUMBER_EXPLAINED
```

## KubeMeasure record

A measurement is a number with provenance.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeMeasure
metadata:
  name: commerce-web-unit-cost-2026-06-14
spec:
  formula: workload-unit-cost
  subject:
    kind: KubeApp
    name: commerce-demo
    component: web
  value: holder-defined
  unit: currency_per_request
  window: 24h
  inputs:
    - name: cloud_cost
      source: billing-record
    - name: successful_requests
      source: prometheus-witness
  owner: team-commerce
  purpose: cost-optimization
  verdict: UNIT_COST_CALCULATED
```

## Marketplace arithmetic

KubeMarket depends on KubeArithmetic for metering and monetization.

```text
usage * price + entitlement - credits = billable amount
```

The formula is not hidden inside a billing system. It is declared, versioned, and attached to the offer.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubePriceFormula
metadata:
  name: skill-cloud-pro-monthly
spec:
  offer: skill-cloud-pro
  formula: base_subscription + metered_usage - credits
  currency: holder-defined
  evidence:
    requiredVerdicts:
      - PRICE_FORMULA_DECLARED
      - USAGE_METERED
      - ENTITLEMENT_BOUND
```

## Optimization arithmetic

KubeArithmetic is the math behind optimization.

```text
current cost - recommended cost = estimated savings
risk score <= allowed risk threshold -> optimization may be recommended
```

Optimization may recommend; governance decides whether it may act.

## Learning arithmetic

Personalized learning uses arithmetic, but it must not reduce the learner to a hidden score.

```text
progress score + evidence + explanation -> learning recommendation
```

Every recommendation must explain which numbers mattered and why.

## Safety arithmetic

Safety uses thresholds and scores only when they are declared.

```text
No hidden score may block a person.
No hidden score may charge a person.
No hidden score may authorize an agent.
```

## Rule

No formula, no number. No unit, no comparison. No source, no trust. No verdict, no claim.