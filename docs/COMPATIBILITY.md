# Compatibility, Upgrade, and Rollback

This document records what KubeContainer has actually been verified against and the supported operational procedure for changing versions.

## Verified release baseline

The hardened v0.2.24 release was built and gated on GitHub Actions with:

- Go 1.25.7.
- envtest Kubernetes 1.35.
- kind v0.32.0.
- kind node image `kindest/node:v1.36.1`.
- Ubuntu 24.04 GitHub-hosted runner.

Release evidence:

- Release: https://github.com/unboxd-cloud/KubeContainer/releases/tag/v0.2.24
- Release workflow: https://github.com/unboxd-cloud/KubeContainer/actions/runs/37457861236

The release gate proved installation, KubeContainer convergence, HTTP 200 traffic, child-resource recovery after induced drift, owner-reference cleanup, OCI digest capture, SPDX SBOM generation, provenance/SBOM attestations, and digest-pinned installer generation.

## Kubernetes compatibility policy

KubeContainer uses stable Kubernetes APIs for managed resources:

- `apps/v1`
- `v1`
- `networking.k8s.io/v1`
- `autoscaling/v2`

The project targets conformant Kubernetes v1.30+ clusters. A version is considered **release-verified** only when the live release gate has exercised it successfully.

Current release-verified versions:

| Release | envtest | live kind cluster |
|---|---:|---:|
| v0.2.24 | 1.35 | 1.36.1 |

Support claims beyond this table are compatibility targets, not evidence-backed release certifications.

## Install or upgrade

Always install from the immutable release bundle, not from a moving branch.

```bash
curl -fLO https://github.com/unboxd-cloud/KubeContainer/releases/download/v0.2.24/install.yaml
curl -fLO https://github.com/unboxd-cloud/KubeContainer/releases/download/v0.2.24/SHA256SUMS
sha256sum --check --ignore-missing SHA256SUMS
kubectl apply -f install.yaml
```

Before upgrading:

1. Export current KubeContainer custom resources.
2. Record the current operator image digest.
3. Review CRD/schema changes and CHANGELOG.
4. Apply the new release bundle.
5. Wait for the controller Deployment to become Available.
6. Verify existing KubeContainers retain `Ready=True`, `observedGeneration`, and their expected endpoints.
7. Run a smoke request against at least one representative workload.

Useful commands:

```bash
kubectl get kubecontainers -A -o yaml > kubecontainers-backup.yaml
kubectl -n kubecontainer-system get deployment kubecontainer-controller-manager -o yaml > operator-backup.yaml
kubectl get kubecontainers -A
kubectl -n kubecontainer-system rollout status deployment/kubecontainer-controller-manager
```

## Rollback

Rollback is release-based and declarative.

1. Select the last known-good tagged release.
2. Download that release's `install.yaml` and `SHA256SUMS`.
3. Verify checksums.
4. Apply the prior bundle.
5. Verify controller rollout and KubeContainer readiness.
6. Do not delete CRDs as part of a normal rollback.

Example:

```bash
VERSION=v0.2.24
curl -fLO "https://github.com/unboxd-cloud/KubeContainer/releases/download/$VERSION/install.yaml"
curl -fLO "https://github.com/unboxd-cloud/KubeContainer/releases/download/$VERSION/SHA256SUMS"
sha256sum --check --ignore-missing SHA256SUMS
kubectl apply -f install.yaml
kubectl -n kubecontainer-system rollout status deployment/kubecontainer-controller-manager
kubectl get kubecontainers -A
```

If a future release introduces a CRD storage-version migration or an irreversible schema change, that release must publish a dedicated migration/rollback procedure before it can pass the production release gate.

## Failure safety

The live E2E suite proves that:

- unknown fields are rejected by the API server;
- mutually exclusive fixed-replica/autoscale configuration is rejected;
- Ingress without a host is rejected;
- invalid container ports are rejected;
- a native Kubernetes `ValidatingAdmissionPolicy` denial fails closed.

These tests exist so malformed or policy-denied KubeContainer requests cannot silently become partially applied workloads.
