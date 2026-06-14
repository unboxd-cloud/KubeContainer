# KubeData Compute Engines

FabriKube uses Apache data and compute engines as reference patterns for orchestration, integration, compute, query planning, query access, and real-time analytics.

```text
Airflow = workflow authoring, scheduling, and monitoring
SeaTunnel = data integration and sync
Spark = distributed data engineering, data science, SQL, streaming, and ML compute
Pinot = real-time user-facing and agent-facing OLAP analytics
Calcite = SQL planning, validation, adapters, and optimization
Avatica = database-driver wire API and query access face
Scala = typed, scalable language for Spark, services, and mathematical model implementations
```

## Engine placement

| Engine | Kube role | Primary office |
|---|---|---|
| Apache Airflow | programmatically author, schedule, and monitor workflows | KubeOrchestrator |
| Apache SeaTunnel | batch, real-time, full, and incremental data integration | KubeDataSync |
| Apache Spark | large-scale data engineering, data science, streaming, SQL, and ML | KubeCompute |
| Apache Pinot | real-time OLAP analytics for users and AI agents | KubeRealtimeAnalytics |
| Apache Calcite | SQL parser, validator, relational algebra, cost optimizer, adapters | KubeAnalytics |
| Apache Calcite Avatica | HTTP/JDBC/JSON/Protobuf query-driver face | KubeQueryFace |
| Scala | expressive typed language for distributed compute and model-heavy services | KubeLanguage |

## KubeOrchestrator with Airflow

Apache Airflow is the reference pattern for workflows: programmatically author, schedule, and monitor pipelines, with extensible operators and a UI for observing workflow state.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeOrchestrator
metadata:
  name: fabric-airflow-orchestrator
spec:
  engine: airflow
  workflows:
    - data-sync
    - analytics-refresh
    - model-evaluation
    - cost-optimization
    - marketplace-settlement
    - learning-path-update
  authoring:
    language: python
    dynamicPipelines: true
  scheduling:
    required: true
  monitoring:
    required: true
  governance:
    identityFabric: required
    purposeRequired: true
    runRecordRequired: true
    retryPolicyRequired: true
  evidence:
    requiredVerdicts:
      - WORKFLOW_DECLARED
      - WORKFLOW_SCHEDULED
      - WORKFLOW_RUN_RECORDED
      - WORKFLOW_OBSERVED
```

## KubeCompute with Spark

Apache Spark is the reference pattern for distributed compute: multi-language execution for data engineering, data science, machine learning, SQL, batch, and streaming on single machines or clusters.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeCompute
metadata:
  name: fabric-spark-compute
spec:
  engine: spark
  workloads:
    - data-engineering
    - sql-analytics
    - streaming
    - machine-learning
    - feature-generation
  languages:
    - python
    - sql
    - scala
    - java
    - r
  placement:
    nodeTypes:
      - cloud
      - ai
      - gateway
  governance:
    identityFabric: required
    dataClassification: required
    budgetRequired: true
    lineageRequired: true
  evidence:
    requiredVerdicts:
      - COMPUTE_READY
      - JOB_RECORDED
      - COST_BOUNDED
      - LINEAGE_RECORDED
```

## KubeLanguage with Scala

Scala is the typed language placement for Spark-native jobs, model-heavy services, and high-confidence arithmetic or analytics implementations.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeLanguage
metadata:
  name: scala
spec:
  language: scala
  runtimes:
    - jvm
    - javascript
    - native
  useCases:
    - spark-jobs
    - typed-services
    - mathematical-meta-models
    - distributed-systems
    - data-validation
  governance:
    buildPipelineRequired: true
    testsRequired: true
    provenanceRequired: true
  evidence:
    requiredVerdicts:
      - LANGUAGE_BOUND
      - BUILD_RECORDED
      - TESTS_PASSED
```

## KubeRealtimeAnalytics with Pinot

Apache Pinot is the reference pattern for real-time OLAP: sub-second SQL analytics on fresh data for dashboards, metrics APIs, user-facing apps, and AI agents.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeRealtimeAnalytics
metadata:
  name: fabric-pinot-analytics
spec:
  engine: pinot
  useCases:
    - embedded-analytics
    - customer-dashboards
    - metrics-api
    - agent-facing-analytics
    - real-time-observability
  ingestion:
    streaming: true
    batch: true
    upserts: true
  query:
    sql: true
    latencyGoal: sub-second
  governance:
    tenantIsolation: required
    identityFabric: required
    dataClassification: required
  evidence:
    requiredVerdicts:
      - REALTIME_ANALYTICS_READY
      - FRESHNESS_BOUND
      - QUERY_LATENCY_BOUND
      - ACCESS_FILTERED
```

## KubeDataSync with SeaTunnel

Apache SeaTunnel is the reference pattern for data integration: offline sync, real-time sync, full sync, incremental sync, many connectors, job scheduling, running, and monitoring.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeDataSync
metadata:
  name: fabric-seatunnel-sync
spec:
  engine: seatunnel
  modes:
    - offline
    - realtime
    - full
    - incremental
  sources:
    - transaction-db
    - cloud-db
    - saas
    - binlog
    - owner-desk
  targets:
    - kubestore
    - kubesearch
    - kubeanalytics
    - pinot
    - owner-desk
  governance:
    atlasClassification: required
    identityFabric: required
    purposeRequired: true
    lineageRequired: true
    retentionRequired: true
  evidence:
    requiredVerdicts:
      - DATA_SYNC_ALLOWED
      - SYNC_JOB_RECORDED
      - LINEAGE_RECORDED
      - RETENTION_ENFORCED
```

## KubeQueryFace with Avatica

Apache Calcite Avatica is the reference pattern for query access: an HTTP server, JDBC client, and JSON or Protobuf wire API for database drivers and language-flexible clients.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeQueryFace
metadata:
  name: fabric-query-face
spec:
  protocol: avatica-style
  server: http
  clients:
    - jdbc
    - language-client
  encoding:
    - json
    - protobuf
  binds:
    - KubeAnalytics
    - KubeArithmetic
    - KubeRealtimeAnalytics
  governance:
    identityFabric: required
    purposeRequired: true
    queryRecordRequired: true
  evidence:
    requiredVerdicts:
      - QUERY_FACE_READY
      - ACCESS_DECIDED
      - QUERY_RECORDED
```

## Data-on-desk execution

The engine map keeps the sovereignty rule intact.

```text
Everything in cloud, data on desk.
```

- Airflow schedules and observes the governed workflows.
- SeaTunnel moves only what governance allows.
- Spark computes where policy permits.
- Pinot serves live analytics from governed ingested data.
- Calcite plans across sources before moving data.
- Avatica exposes query access with identity and records.
- Scala implements typed jobs and model-heavy services where that helps safety.

## Rule

No engine bypasses the fabric. Every workflow, job, query, sync, ingest, and result must carry identity, purpose, policy, lineage, cost, and verdict.