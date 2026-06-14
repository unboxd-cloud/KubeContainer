# Release Gate

The release gate is the human-readable contract for publishing KubeContainer as a proven MACH Fabric unit.

## Gate name

```text
MetaKube Verify
```

## Gate command

```bash
make metakube-verify
```

or in CI:

```text
.github/workflows/metakube.yml
```

## Green condition

A release is green only when the evidence report contains:

```text
Verdict: PROMISE_KEPT
```

## Evidence artifact

```text
dist/metakube-report.txt
```

## Required checks

| Check | Required verdict |
|---|---|
| Minikube cluster starts | Ready |
| CRD installs | Installed |
| Operator deploys | Ready |
| Sample KubeContainer applies | Present or Ready |
| Generated workload exists | Running or reconciling |
| Metrics service exists | ServicePresent |
| Observance report emits | Written |
| Final verdict | PROMISE_KEPT |

## Release doctrine

```text
MACH composes.
KubeContainer packages.
MetaKube proves.
Prometheus witnesses.
Cortex preserves.
Fabric governs.
Repair reconciles.
Market exchanges.
```

## If red

A red gate is not a failure of publishing. It is a repair signal.

1. Read `dist/metakube-report.txt`.
2. Inspect the controller logs.
3. Inspect Kubernetes events.
4. Check Prometheus target health when telemetry is enabled.
5. Follow the matching runbook.
6. Patch the code or declaration.
7. Re-run the gate.

## Publish rule

No tag, release note, marketplace listing, or public claim should be made until the release gate is green.

## Canonical line

A KubeContainer release is not published because it was built. It is published because MetaKube proved the promise was kept.
