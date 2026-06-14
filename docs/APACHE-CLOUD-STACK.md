# Apache Cloud Stack Blueprint

Apache Cloud is the open-source substrate for Unboxd Code First Cloud.

This blueprint maps Apache projects into the Unboxd cloud stack features.

## Product line

```text
Unboxd — Code First Cloud Where Anyone Can Build
```

## Stack map

```text
Cloud Store      -> Apache Cassandra / Apache Hudi / Apache Iceberg / SurrealDB for Fabric graph
Cloud Stack      -> Apache CloudStack + Kubernetes
Cloud Panel      -> Unboxd Cloud Panel
Cloud Chat       -> Fabric chat records + agent routing
Cloud Search     -> Apache Lucene / Solr / OpenSearch-compatible future path
Cloud Analytics  -> Apache Superset + Apache Arrow
Cloud Campaign   -> Fabric campaign records + workflow
Cloud Publish    -> Apache Airflow / Camel / NiFi style publish flows
Billing          -> Fabric billing records + usage metering
Event Bus        -> Apache Kafka / Pulsar
Data Movement    -> Apache SeaTunnel / NiFi
API Gateway      -> Apache APISIX
Workflow         -> Apache Airflow
Policy/Evidence  -> Fabric Observance + SLA score
```

## Apache-first operating model

| Layer | Apache anchor | Role |
|---|---|---|
| Infrastructure | Apache CloudStack | IaaS / cloud control plane |
| API gateway | Apache APISIX | route APIs and services |
| Event streaming | Apache Kafka / Pulsar | cloud events and agent events |
| Data movement | Apache SeaTunnel / NiFi | flow data across systems |
| Workflow | Apache Airflow | scheduled and governed workflows |
| Analytics | Apache Superset | dashboards and metrics |
| Table/data lake | Apache Iceberg / Hudi | analytical storage path |
| Compute/query | Apache Arrow / Calcite | efficient data/query layer |
| Search | Apache Lucene / Solr | search primitive |

## Unboxd feature mapping

### 1. Cloud Store

Stores tenant, workspace, agent, chat, campaign, publish, billing, usage, and evidence records.

```text
Fabric Store = SurrealDB today
Apache analytical store = Iceberg/Hudi/Cassandra later
```

### 2. Cloud Stack

Runs infrastructure and workload control.

```text
Apache CloudStack = IaaS base
Kubernetes/k3s = workload base
Fabric = governed promise graph
```

### 3. Cloud Panel

Human-facing control surface.

```text
Panel = onboarding + stack health + agents + chat + proof + billing
```

### 4. Cloud Chat

Command interface for cloud agents.

```text
Human command -> agent route -> action/evidence -> Fabric record
```

### 5. Cloud Search

Searches Fabric records and future indexed content.

```text
agents
workspaces
messages
campaigns
publish jobs
billing records
evidence
```

### 6. Cloud Analytics

Measures the stack.

```text
usage
agent activity
chat volume
campaign activity
publish jobs
billing events
proof/verdicts
```

### 7. Cloud Campaign

Plans product, community, marketplace, and customer campaigns.

```text
campaign -> content -> channel -> publish job -> evidence
```

### 8. Cloud Publish

Publishes outputs with proof.

```text
website
GitHub release
blog
marketplace listing
social drafts
customer evidence bundle
```

### 9. Billing / Multi-Tenant

Commercial memory for each tenant.

```text
tenant -> subscription -> usage -> invoice -> credit ledger
```

## Minimal Apache path

Do not install every Apache project first. Start with the smallest useful path:

```text
Phase 1: k3s + SurrealDB + Unboxd panels
Phase 2: Apache APISIX gateway
Phase 3: Apache Kafka or Pulsar event bus
Phase 4: Apache SeaTunnel/NiFi data movement
Phase 5: Apache Superset analytics
Phase 6: Apache CloudStack IaaS integration
```

## Canonical line

Apache Cloud gives Unboxd the open cloud backbone; Fabric gives it identity, evidence, scoring, repair, and commercial memory.
