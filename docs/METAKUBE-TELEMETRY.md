# MetaKube Telemetry

MetaKube telemetry is the measurable surface of Observance.

Observability answers what happened. Observance answers whether the declared promise was kept. Telemetry is the instrumented signal stream that makes that answer repeatable.

```text
Telemetry = Metrics + Events + Logs + Status + Evidence
Observance = Telemetry + Policy + Verdict
```

## Prometheus is back

Prometheus is the default MetaKube telemetry backbone.

MetaKube does not invent a monitoring protocol. The KubeContainer operator already exposes controller-runtime metrics through its manager process. Prometheus scrapes that endpoint and becomes the local evidence collector for reconcile behavior, health, failures, latency, and workload promise drift.

```text
KubeContainer operator
   ↓ /metrics
Prometheus
   ↓ queries + alerts
MetaKube Observance Report
   ↓
PROMISE_KEPT / PROMISE_BROKEN
```

## Purpose

MetaKube uses Minikube as the local Kubernetes substrate and KubeContainer as the declared workload box. Telemetry proves the loop is alive:

1. The cluster exists.
2. The CRD is installed.
3. The operator is running.
4. Prometheus is scraping.
5. The controller is reconciling.
6. The workload converges.
7. The service responds.
8. The final verdict is recorded.

## Signals

| Signal | Source | Meaning |
|---|---|---|
| Health | `/healthz` | manager process is alive |
| Readiness | `/readyz` | manager is ready to reconcile |
| Metrics | `/metrics` | reconcile behavior, workqueue state, Go runtime, controller-runtime metrics |
| Prometheus target health | Prometheus | metrics endpoint is continuously scrapeable |
| Kubernetes Events | API server | child resources created, updated, degraded, recovered |
| Status Conditions | `KubeContainer.status.conditions` | Ready, Progressing, Degraded |
| Evidence Report | `dist/metakube-report.txt` or JSON later | human-readable release-gate proof |

## Metric families

The operator is built with controller-runtime, so the manager exposes standard Prometheus metrics when the metrics endpoint is enabled:

- controller reconcile totals
- controller reconcile errors
- reconcile duration histograms
- workqueue depth
- workqueue retries
- process and Go runtime metrics
- REST client request metrics

MetaKube treats those as the first telemetry contract. Custom promise metrics can be added after the base loop is stable.

## Local scrape model

In local MetaKube mode, metrics should be easy to inspect. The preferred developer mode is insecure HTTP inside a local-only Minikube environment:

```bash
--metrics-bind-address=:8080 --metrics-secure=false
```

Production clusters should use the secure controller-runtime metrics path with Kubernetes authn/authz and cert-manager-managed TLS.

## Prometheus scrape config

See `hack/metakube/prometheus.yml` for a local scrape profile.

The simplest local path is port-forwarding the manager metrics service and then running Prometheus against it:

```bash
kubectl -n kubecontainer-system port-forward svc/kubecontainer-controller-manager-metrics-service 8080:8443
prometheus --config.file=hack/metakube/prometheus.yml
```

For insecure local development builds using `--metrics-secure=false`, scrape `localhost:8080` directly.

## MetaKube telemetry gate

A release gate should fail when any of these are false:

```text
cluster_ready=true
crd_installed=true
operator_ready=true
prometheus_ready=true
metrics_reachable=true
sample_kubecontainer_ready=true
sample_workload_http_200=true
verdict=PROMISE_KEPT
```

## Target report

```text
MetaKube Telemetry Report
-------------------------
Cluster: Ready
CRD: Installed
Operator: Ready
Prometheus: Ready
Healthz: OK
Readyz: OK
Metrics: Reachable
KubeContainer: Ready
Workload: HTTP 200
Verdict: PROMISE_KEPT
```

## Roadmap

- Add custom `kubecontainer_promise_verdict_total` metrics.
- Add `kubecontainer_ready` gauge by namespace/name.
- Add `kubecontainer_reconcile_to_ready_seconds` histogram.
- Add Prometheus alert rules for degraded kubes.
- Add Grafana dashboard JSON for local MetaKube demos.
- Emit a signed telemetry evidence bundle during release gates.
