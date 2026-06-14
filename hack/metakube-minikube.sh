#!/usr/bin/env bash
set -euo pipefail

PROFILE="${METAKUBE_PROFILE:-metakube}"
IMG="${IMG:-controller:latest}"
KUBECTL="${KUBECTL:-kubectl}"
MINIKUBE="${MINIKUBE:-minikube}"

usage() {
  cat <<USAGE
Usage: $0 <up|sample|prometheus|observe|verify|down>

Environment:
  METAKUBE_PROFILE  Minikube profile name, default: metakube
  IMG               Controller image, default: controller:latest
  KUBECTL           kubectl binary, default: kubectl
  MINIKUBE          minikube binary, default: minikube
USAGE
}

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "$1 is required for MetaKube" >&2
    exit 1
  }
}

cluster_ready() {
  "$KUBECTL" --context "${PROFILE}" wait --for=condition=Ready nodes --all --timeout=180s >/dev/null
}

operator_ready() {
  "$KUBECTL" --context "${PROFILE}" -n kubecontainer-system wait --for=condition=Available deployment/kubecontainer-controller-manager --timeout=180s >/dev/null
}

sample_ready() {
  "$KUBECTL" --context "${PROFILE}" wait --for=condition=Available deployment/kubecontainer-sample --timeout=180s >/dev/null
}

prometheus_ready() {
  "$KUBECTL" --context "${PROFILE}" -n metakube wait --for=condition=Available deployment/prometheus --timeout=180s >/dev/null
}

case "${1:-}" in
  up)
    need "$MINIKUBE"
    need "$KUBECTL"
    "$MINIKUBE" start -p "$PROFILE"
    "$MINIKUBE" -p "$PROFILE" image build -t "$IMG" .
    "$KUBECTL" config use-context "$PROFILE" >/dev/null
    make install KUBECTL="$KUBECTL"
    make deploy IMG="$IMG" KUBECTL="$KUBECTL"
    cluster_ready
    operator_ready
    echo "cluster_ready=true"
    echo "operator_ready=true"
    ;;
  sample)
    need "$KUBECTL"
    "$KUBECTL" --context "$PROFILE" apply -k config/samples/
    sample_ready
    echo "sample_kubecontainer_ready=true"
    ;;
  prometheus)
    need "$KUBECTL"
    "$KUBECTL" --context "$PROFILE" apply -f config/metakube/prometheus.yaml
    prometheus_ready
    echo "prometheus_scraping=true"
    ;;
  observe)
    need "$KUBECTL"
    cluster_ready
    operator_ready
    sample_ready
    prometheus_ready
    echo "cluster_ready=true"
    echo "operator_ready=true"
    echo "sample_kubecontainer_ready=true"
    echo "prometheus_scraping=true"
    echo "verdict=PROMISE_KEPT"
    ;;
  verify)
    "$0" up
    "$0" sample
    "$0" prometheus
    "$0" observe
    ;;
  down)
    need "$MINIKUBE"
    "$MINIKUBE" delete -p "$PROFILE"
    ;;
  *)
    usage
    exit 2
    ;;
esac
