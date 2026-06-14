# KubeObservability with ClickStack Alignment

KubeObservability is the observability kube for FabriKube.

ClickStack is the reference pattern: a high-performance observability stack powered by ClickHouse that unifies logs, metrics, traces, and sessions for OpenTelemetry-scale workloads.

```text
KubeObservability = telemetry declaration + collection loop + observability face + signal record + evidence contract
```

## Placement

| Layer | Role |
|---|---|
| KubeApp lifecycle | observes releases, incidents, rollbacks, repairs, and SLOs |
| MetaKube | proves the local stack with metrics, events, and verdicts |
| KubeAgentRuntime | records agent runs, tools, model calls, artifacts, and errors |
| KubeAnalytics | queries observability data for lifecycle decisions |
| KubeArithmetic | calculates latency, error rates, costs, budgets, and risk scores |
| KubeRealtimeAnalytics | serves live user-facing and agent-facing metrics |
| KubeExperience | connects telemetry to user journeys and surface health |

## KubeObservability contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeObservability
metadata:
  name: fabric-observability
spec:
  engine: clickstack
  store: clickhouse
  standard: opentelemetry
  signals:
    - logs
    - metrics
    - traces
    - sessions
  sources:
    - kubeapps
    - kubenodes
    - kubeagents
    - kubedata-sync
    - kubepipelines
    - kubebrowser
  query:
    search: true
    dashboards: true
    alerts: true
    sessionReplay: optional
  governance:
    identityFabric: required
    tenantIsolation: required
    retentionRequired: true
    sensitiveDataScrubbing: required
  evidence:
    requiredVerdicts:
      - OBSERVABILITY_READY
      - TELEMETRY_INGESTED
      - TRACE_CORRELATED
      - SIGNALS_QUERYABLE
```

## Observability flow

```text
workload emits signal
  -> collector receives OpenTelemetry data
  -> ClickHouse stores logs, metrics, traces, sessions
  -> ClickStack exposes search, dashboards, alerts, trace correlation
  -> KubeAnalytics and KubeArithmetic produce insights and measures
  -> Observance names the verdict
```

## Relationship to Prometheus

Prometheus remains the local witness in MetaKube. ClickStack is the broader observability estate for high-volume logs, traces, metrics, sessions, and long-running operations.

```text
Prometheus = first witness
ClickStack = unified observability stack
Observance = verdict layer
```

## Rule

No silent workload. No uncorrelated trace. No metric without source. No alert without owner. No observability signal outside governance.