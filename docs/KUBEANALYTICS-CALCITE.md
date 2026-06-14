# KubeAnalytics with Apache Calcite

KubeAnalytics is the governed analytics and query kube for FabriKube.

Apache Calcite is the reference implementation pattern: standard SQL, query validation, relational algebra, cost-based optimization, and adapters that connect to many data sources while pushing computation toward the data.

```text
KubeAnalytics = declared query surface + planner loop + analytics face + query record + insight contract
```

## Placement

| Layer | Role |
|---|---|
| Data Fabric | queries KubeStore, desk data, cloud data, metadata, lineage, and evidence |
| KubeAtlas | supplies catalog, classification, ownership, and lineage metadata |
| KubeSearch | supplies indexed records, answer knowledge, app metadata, and evidence search |
| Identity Fabric | filters analytics by principal, relation, purpose, and entitlement |
| KubeApp lifecycle | analyzes releases, rollbacks, cost, incidents, usage, and outcomes |
| Experience Management | analyzes journeys, surfaces, latency, satisfaction, and support loops |
| Skill Cloud | analyzes learning progress, skill proof, tool usage, and monetization outcomes |

## Calcite fit

| Calcite capability | KubeAnalytics use |
|---|---|
| Standard SQL parser and validator | one governed query language over fabric records |
| JDBC driver | standard connection face for tools and apps |
| Relational algebra | portable planning across stores, indexes, and evidence records |
| Cost-based optimization | choose safe, efficient query plans |
| Adapters | connect KubeStore, KubeSearch, KubeAtlas, desk data, cloud data, and external gateways |
| Pushdown | move computation to data when policy allows, instead of moving data blindly |

## KubeAnalytics contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeAnalytics
metadata:
  name: fabric-analytics
spec:
  engine: calcite
  query:
    language: sql
    validate: true
    optimize: cost-based
  sources:
    - name: kubeapps
      kind: KubeStore
    - name: evidence
      kind: KubeSearch
    - name: metadata
      kind: KubeAtlas
    - name: desk-data
      kind: KubeDeskData
      movement: no-copy-by-default
    - name: answers
      kind: KubeAnswer
  governance:
    identityFabric: required
    atlasClassification: required
    purposeRequired: true
    lineageRequired: true
    policyPushdown: required
  costOptimization:
    estimateBeforeRun: true
    budgetRequired: true
    pushComputationToData: when-policy-allows
  evidence:
    requiredVerdicts:
      - QUERY_VALIDATED
      - ACCESS_DECIDED
      - QUERY_OPTIMIZED
      - INSIGHT_RECORDED
```

## Data-on-desk analytics

KubeAnalytics must respect the sovereignty rule.

```text
Everything in cloud, data on desk.
```

That means analytics can run in cloud while owner-bound data stays on desk when required. Calcite-style adapters and pushdown make this practical:

```text
query arrives in cloud
  -> identity and purpose are checked
  -> Atlas classification and lineage are checked
  -> planner decides what can run where
  -> allowed computation is pushed to desk node
  -> only permitted aggregates or results return
  -> record and verdict are attached
```

## Insight record

Every analytics result that informs a lifecycle decision must produce a record.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeInsight
metadata:
  name: rightsize-commerce-web
spec:
  source: fabric-analytics
  query: cpu-memory-usage-last-14d
  principal: user:operator@example.com
  purpose: cost-optimization
  app: commerce-demo
  result:
    recommendation: reduce-requested-memory
    confidence: holder-defined
  checks:
    - ACCESS_DECIDED
    - DATA_GUARDED
    - QUERY_OPTIMIZED
  verdict: INSIGHT_RECORDED
```

## First analytics questions

KubeAnalytics should answer these first:

- Which apps are over-provisioned?
- Which apps breach latency promises most often?
- Which skill paths lead to successful showcases?
- Which support answers reduce repeated questions?
- Which data syncs move sensitive data?
- Which releases produced rollback or repair events?
- Which node placements cost more than expected?

## Rule

No query without identity. No insight without purpose. No data movement hidden inside analytics. No decision without an insight record.