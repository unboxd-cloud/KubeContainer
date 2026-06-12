# Benchmarks — Published Numbers

Status: v1, measured. Every number below was produced by a named
command against a named commit in a named environment, per the house
rule: a number without a verdict is a claim, and claims don't ship.
What is benchmarked is KubeContainer v0.1.0 and its record — the one
kube built so far. The brand names the unit; numbers attach only to
artifacts, and artifacts are what exist.

## Environment of measurement

| Property | Value |
|---|---|
| Date | 2026-06-12 |
| Commit | `765d328` |
| CPU | Intel Xeon @ 2.10 GHz, 4 vCPU |
| OS / arch | linux/amd64 |
| Go | go1.25.7 |
| envtest control plane | Kubernetes 1.35.0 |

Numbers from CI carry their run URL instead; CI hardware is
GitHub-hosted `ubuntu-latest`.

## Correctness (the gate numbers)

| Metric | Number | Verdict source |
|---|---|---|
| Test specs (envtest integration suite) | 9 / 9 pass, 0 pending, 0 skipped | `go test ./internal/controller/ -v` |
| Suite wall time, incl. control-plane boot | 5.9–13.8 s (two runs) | same |
| Full `go test ./...` wall time | 20.6 s | `time go test ./...` |
| Eval registry resolution | 3 / 3 (100.00 %) | `make eval` → `dist/eval-report.json` (commit-stamped) |
| Vocabulary check | green, 151 defined terms | `make vocab-check` |
| Backward-compat corpus | 3 / 3 era-v0.1.0 manifests converge | compat suite (subset of the 9 specs) |

## Build & artifact (the size numbers)

| Metric | Number | Verdict source |
|---|---|---|
| Manager build, warm cache | 2.2 s | `time go build -o /tmp/m cmd/main.go` |
| Manager build, cold cache | ~90 s | same, first run in a fresh container |
| Manager binary (dev, unstripped) | 73,134,676 B (≈70 MiB) | `stat -c %s` |
| Install bundle (`dist/install.yaml`, v0.1.0) | 29,282 B | `stat -c %s` — one `kubectl apply` installs everything |
| CRD manifest | 443 lines | `wc -l config/crd/bases/*.yaml` |
| Operator Go source | 2,178 lines | `wc -l` over `*.go` (excluding `bin/`) |

The ratio worth reading: 2,178 lines of Go reconcile a contract whose
guarantees take seven rows to state (KUBE-SPEC §4), and the entire
install is a 29 KB file.

## Pipeline (the delivery numbers)

| Metric | Number | Verdict source |
|---|---|---|
| Declared request → published release | 4 m 16 s | [release run 27307931328](https://github.com/unboxd-agency/KubeContainer/actions/runs/27307931328) (2026-06-10, conclusion: success) |
| What that 4 m 16 s contains | tests, lint, vocab check, eval registry, image build + GHCR push, kind e2e with real HTTP traffic, tag + release + evidence report | `.github/workflows/release.yml` |
| Empty repository → released v0.1.0 | one day (2026-06-10) | the git record; first commit and the release share a date |
| Drift audit cadence | weekly, plus on demand | `.github/workflows/drift-audit.yml` |

## Not yet benchmarked (named, not hidden)

A guarantee without a verdict is a roadmap item; the same holds for
numbers. These are declared as future world-tests, not implied:

- Reconcile latency distribution under sustained load (p50/p99).
- Time-to-Ready on a real cluster, emitted as a number (the e2e gate
  proves convergence and live traffic but does not yet time it).
- Manager memory/CPU at steady state.
- Scale ceiling: KubeContainers per manager before degradation.
- A stripped release binary (`-ldflags "-s -w"`) and image size on
  GHCR, measured and published.

When each lands it gets a measured row above and, where it can run in
CI, a task in the eval registry so the number can never silently rot.

## Methodology

Numbers are reproduced, not trusted: every row names the command;
anyone with the repo can re-run it and compare. Local numbers vary
with hardware — the commit and environment table exist so that a
different number on different iron is a data point, not a dispute.
CI numbers link the run, which carries its own logs, hashes, and
artifacts. This file is updated by re-measurement only; editing a
number without re-running its command is drift, and the drift audit's
business.
