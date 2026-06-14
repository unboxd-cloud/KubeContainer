#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${METAKUBE_CLUSTER:-metakube}"
NAME="${METAKUBE_KUBECONTAINER:-hello-metakube}"
NAMESPACE="${METAKUBE_NAMESPACE:-default}"
REPORT="${METAKUBE_REPORT:-dist/metakube-report.txt}"

command -v kubectl >/dev/null 2>&1 || {
  echo "missing required command: kubectl" >&2
  exit 1
}

mkdir -p "$(dirname "$REPORT")"
kubectl config use-context "$CLUSTER_NAME" >/dev/null

cluster="Ready"
operator="Unknown"
kubecontainer="Unknown"
pods="Unknown"
metrics="Unknown"
verdict="PROMISE_UNKNOWN"

if kubectl get nodes >/dev/null 2>&1; then cluster="Ready"; fi
if kubectl -n kubecontainer-system get deploy/kubecontainer-controller-manager >/dev/null 2>&1; then
  available="$(kubectl -n kubecontainer-system get deploy/kubecontainer-controller-manager -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)"
  if [ "${available:-0}" != "" ] && [ "${available:-0}" -gt 0 ]; then operator="Ready"; else operator="NotReady"; fi
fi
if kubectl -n "$NAMESPACE" get kubecontainer "$NAME" >/dev/null 2>&1; then
  kubecontainer="$(kubectl -n "$NAMESPACE" get kubecontainer "$NAME" -o jsonpath='{range .status.conditions[?(@.type=="Ready")]}{.status}{end}' 2>/dev/null || true)"
  [ -n "$kubecontainer" ] || kubecontainer="Present"
fi
if kubectl -n "$NAMESPACE" get pods -l app.kubernetes.io/name="$NAME" >/dev/null 2>&1; then
  pods="$(kubectl -n "$NAMESPACE" get pods -l app.kubernetes.io/name="$NAME" --no-headers 2>/dev/null | awk '{print $3}' | sort -u | paste -sd, - || true)"
  [ -n "$pods" ] || pods="None"
fi

if kubectl -n kubecontainer-system get svc kubecontainer-controller-manager-metrics-service >/dev/null 2>&1; then
  metrics="ServicePresent"
fi

if [ "$cluster" = "Ready" ] && [ "$operator" = "Ready" ] && { [ "$kubecontainer" = "True" ] || [ "$kubecontainer" = "Present" ]; }; then
  verdict="PROMISE_KEPT"
fi

cat > "$REPORT" <<EOF
MetaKube Observance Report
--------------------------
Cluster: $cluster
Operator: $operator
KubeContainer: $kubecontainer
Pods: $pods
Metrics: $metrics
Verdict: $verdict
EOF

cat "$REPORT"

test "$verdict" = "PROMISE_KEPT"
