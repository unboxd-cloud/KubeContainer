#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${METAKUBE_CLUSTER:-metakube}"
SAMPLE="${METAKUBE_SAMPLE:-examples/metakube/hello-kubecontainer.yaml}"

command -v kubectl >/dev/null 2>&1 || {
  echo "missing required command: kubectl" >&2
  exit 1
}

kubectl config use-context "$CLUSTER_NAME"

echo "Applying sample KubeContainer: $SAMPLE"
kubectl apply -f "$SAMPLE"

echo "Waiting for generated workload"
kubectl wait --for=condition=Ready kubecontainer/hello-metakube --timeout=180s || true
kubectl get kubecontainer hello-metakube -o wide || true
kubectl get pods,svc -l app.kubernetes.io/name=hello-metakube || true
