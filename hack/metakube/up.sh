#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${METAKUBE_CLUSTER:-metakube}"
DRIVER="${METAKUBE_DRIVER:-docker}"
IMAGE="${IMG:-kubecontainer-controller:metakube}"

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing required command: $1" >&2
    exit 1
  }
}

require minikube
require kubectl
require docker

if ! minikube status -p "$CLUSTER_NAME" >/dev/null 2>&1; then
  echo "Starting MetaKube Minikube cluster: $CLUSTER_NAME"
  minikube start -p "$CLUSTER_NAME" --driver="$DRIVER"
else
  echo "MetaKube cluster already running: $CLUSTER_NAME"
fi

kubectl config use-context "$CLUSTER_NAME"

echo "Building operator image inside MetaKube Docker daemon: $IMAGE"
eval "$(minikube -p "$CLUSTER_NAME" docker-env)"
docker build -t "$IMAGE" .

echo "Installing CRDs"
make install KUBECTL=kubectl

echo "Deploying KubeContainer operator"
make deploy IMG="$IMAGE" KUBECTL=kubectl

echo "Waiting for controller manager"
kubectl -n kubecontainer-system rollout status deploy/kubecontainer-controller-manager --timeout=180s

echo "MetaKube is ready"
