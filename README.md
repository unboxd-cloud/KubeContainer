# KubeContainer

A Kubernetes operator that runs a containerized workload from a single,
opinionated custom resource. You declare *what* to run — image, port, scaling,
exposure — and the operator materializes and continuously manages the
underlying Deployment, Service/Ingress, and HorizontalPodAutoscaler.

```yaml
apiVersion: kubecontainer.unboxd.cloud/v1alpha1
kind: KubeContainer
metadata:
  name: my-app
spec:
  image: ghcr.io/acme/my-app:1.4.2
  port: 8080
  scaling:
    autoscale:
      minReplicas: 2
      maxReplicas: 10
  expose:
    type: Ingress
    host: my-app.example.com
  healthCheck:
    path: /healthz
```

The full architecture, CRD schema, and roadmap live in
[docs/DESIGN.md](docs/DESIGN.md).

## Features

- **One CRD for the common case** — Deployment + Service + optional
  Ingress/HPA from a dozen lines of YAML.
- **Self-healing** — drift in any managed child is reverted by the reconcile
  loop; deleting the CR garbage-collects everything via owner references.
- **Safe scaling semantics** — fixed `replicas` or an `autoscale` block
  (mutually exclusive, enforced by CEL validation); under autoscaling the HPA
  owns the replica count and the operator never fights it.
- **Observable** — `Ready`/`Progressing`/`Degraded` conditions, events on
  every child change, and a computed `endpoint` in status:

  ```
  $ kubectl get kubecontainers
  NAME     IMAGE                     AVAILABLE   READY   ENDPOINT
  my-app   ghcr.io/acme/my-app:1.4.2 2           True    my-app.example.com
  ```

## Quickstart

Prerequisites: a Kubernetes v1.30+ cluster, `kubectl`, and (to build) Go and
Docker.

```sh
# Install CRDs and deploy the operator
make docker-build docker-push IMG=<registry>/kubecontainer:v0.1.0
make deploy IMG=<registry>/kubecontainer:v0.1.0

# Run a workload
kubectl apply -k config/samples/
kubectl get kubecontainers

# Tear down
kubectl delete -k config/samples/
make undeploy
```

Or install from the prebuilt bundle (CRDs, RBAC, and manager in one file):

```sh
kubectl apply -f dist/install.yaml
```

Notes:

- `expose.type: Ingress` requires an ingress controller in the cluster;
  `scaling.autoscale` requires metrics-server. Everything else works on any
  conformant cluster — the operator uses only stable upstream APIs.
- HPA scaling decisions need CPU `resources.requests` on the workload.

## Development

```sh
make build      # generate, fmt, vet, compile
make test       # envtest-based unit/integration suite
make lint       # golangci-lint
make run        # run the manager locally against your kubeconfig
```

See [CLAUDE.md](CLAUDE.md) for conventions and
[docs/DESIGN.md](docs/DESIGN.md) for the architecture. Run `make help` for all
targets.

## License

Apache License 2.0 — see [LICENSE](LICENSE). Copyright 2026.
