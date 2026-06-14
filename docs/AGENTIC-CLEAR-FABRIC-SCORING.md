# Agentic CLEAR and Fabric Scoring

This note maps the Agentic CLEAR evaluation idea into Fabric scoring.

Reference: arXiv:2605.22608, "Agentic CLEAR: Automating Multi-Level Evaluation of LLM Agents" by Asaf Yehudai, Lilach Eden, and Michal Shmueli-Scheuer.

## Why it matters

Agentic CLEAR argues that agentic systems need evaluation above basic observability. It produces insights at three levels of granularity:

```text
system
trace
node
```

Fabric scoring needs the same structure because a kube-of-kubes cannot be judged only from one metric or one log line.

## Fabric mapping

| Agentic CLEAR level | Fabric level | Meaning |
|---|---|---|
| system | FabricScore / MetaPlatformScore | whole platform promise |
| trace | MetaKubeScore / release gate flow | declare -> build -> reconcile -> witness -> verdict |
| node | KubeContainerScore / runtime checks | CRD, operator, workload, health, evidence |

## Multi-level score model

```text
SystemScore = FabricScore
TraceScore  = MetaKubeProofLoopScore
NodeScore   = KubeContainerRuntimeScore
```

The parent score should not hide child failures. Therefore the Fabric merge rule still applies:

```text
FinalScore = min(WeightedScore, CriticalCap)
```

## Evaluation above observability

Prometheus observes. Agentic CLEAR-style evaluation interprets.

```text
Prometheus metric -> evidence
Kubernetes event  -> state transition
Runbook output    -> procedure evidence
Observance        -> verdict
Fabric scoring    -> multi-level evaluation
```

## Fabric CLEAR dimensions

Fabric uses a CLEAR-style mnemonic for release scoring:

```text
C = Context: what promise was declared?
L = Lineage: what evidence chain proves the journey?
E = Execution: what actions actually ran?
A = Alignment: did observed state match declared state and policy?
R = Repair: if broken, was the repair path executed and evidenced?
```

## Decimal scoring

Each level receives a decimal score from `0.0` to `1.0`.

```text
0.0 = no proof
0.5 = partial proof
1.0 = promise kept with evidence
```

## System score

```text
SystemScore = weighted_average(
  ContextScore,
  LineageScore,
  ExecutionScore,
  AlignmentScore,
  RepairScore
)
```

## Trace score

A trace is the release proof path:

```text
Declare -> Build -> Reconcile -> Witness -> Store -> Judge -> Repair -> Publish
```

```text
TraceScore = average(
  DeclarationPresent,
  BuildComplete,
  ReconcileObserved,
  WitnessPresent,
  EvidenceStored,
  VerdictEmitted,
  RepairAvailable,
  PublishGateEnforced
)
```

## Node score

A node is a concrete runtime or decision point:

```text
NodeScore = average(
  NodeReady,
  NodeEvidencePresent,
  NodePolicySatisfied,
  NodeErrorRateHealthy,
  NodeRepairable
)
```

## Governance caps

Multi-level evaluation cannot average away fatal gaps.

| Gap | Cap |
|---|---:|
| no context / no declaration | 0.50 |
| no lineage / no evidence chain | 0.60 |
| no execution proof | 0.60 |
| policy misalignment | 0.40 |
| unrepaired critical failure | 0.50 |

## Canonical line

Agentic CLEAR evaluates agents above observability. Fabric scoring evaluates kubes above telemetry: system, trace, and node evidence merge into one governed verdict.
