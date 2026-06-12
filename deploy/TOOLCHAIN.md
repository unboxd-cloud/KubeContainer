# The Delivery Trinity — Operator Framework, OpenTofu, Buildpacks

The founder's ruling: everything must be operator framework, OpenTofu,
and buildpack — buildpack native. Three seats, one per layer, each the
leaders' open standard, none a bespoke invention:

| Layer | The seat | Point of reference |
|---|---|---|
| The keeping (runtime) | **Operator framework** — the operator pattern, Kubebuilder; already this house's kernel | https://kubebuilder.io/ · https://github.com/kubernetes-sigs/kubebuilder |
| The ground (infrastructure) | **OpenTofu** — infrastructure declared, planned, applied, idempotent; Linux Foundation, the open fork that kept the commons open | https://opentofu.org/ · https://github.com/opentofu/opentofu |
| The image (build) | **Cloud Native Buildpacks** — buildpack native: no Dockerfile authored by hand; source in, OCI image out, BOM attached by the build itself; CNCF, on the founder's reading list from day one | https://buildpacks.io/ · https://github.com/buildpacks/pack |

The reading: the operator keeps what runs, OpenTofu declares what it
runs on, buildpacks produce what is run — three declarative seats
covering run, ground, and artifact, so that nothing anywhere is an
imperative script pretending to be infrastructure. And the SDK seat,
named as the founder named it: what the end user is handed is a
binary or an SDK — HomeSetup remains the hand-over binary, and its
imperative infra steps migrate into the OpenTofu module
(deploy/tofu/) as the declared form: the binary becomes a thin walker
of declarations (command as code invoking config as code), never the
place where infrastructure lives.

Buildpack migration, declared: project.toml at the repo root pins the
build; the pipeline's docker-build step is replaced by `pack build`
(pinned pack, pinned builder) the first run after a runner with a
Docker daemon verifies it — the swap is recorded here so it cannot
drift in silently.
