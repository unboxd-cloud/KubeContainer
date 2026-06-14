#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${METAKUBE_CLUSTER:-metakube}"

command -v minikube >/dev/null 2>&1 || {
  echo "missing required command: minikube" >&2
  exit 1
}

echo "Deleting MetaKube Minikube cluster: $CLUSTER_NAME"
minikube delete -p "$CLUSTER_NAME"
