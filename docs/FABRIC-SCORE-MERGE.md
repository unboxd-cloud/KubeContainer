# Fabric Score Merge

Fabric score is merged upward from child kubes.

A kube keeps one promise. A Fabric keeps the promises between kubes. Therefore every score must be local enough to explain and global enough to govern.

## Merge rule

Each parent score is a weighted decimal aggregate of child scores.

```text
ParentScore = sum(weight_i * ChildScore_i) / sum(weight_i)
```

All scores live in the closed interval:

```text
0.0 <= score <= 1.0
```

## Meaning

```text
0.0 = no proof
0.5 = partial proof
1.0 = promise kept with evidence
```

## Default Fabric merge

```text
FabricScore =
  0.40 * KubeContainerScore
+ 0.30 * MetaKubeScore
+ 0.20 * MetaPlatformScore
+ 0.10 * GovernanceScore
```

The weights must sum to `1.0`.

## Score source hierarchy

```text
FabricScore
  <- MetaPlatformScore
      <- MetaKubeScore
          <- KubeContainerScore
              <- RuntimeChecks
                  <- CRD
                  <- Operator
                  <- Workload
                  <- Health
                  <- Evidence
```

## KubeContainerScore

```text
KubeContainerScore = average(
  CRDInstalled,
  OperatorReady,
  WorkloadCreated,
  HealthPassing,
  EvidenceEmitted
)
```

Example:

```text
CRDInstalled     = 1.0
OperatorReady    = 1.0
WorkloadCreated  = 1.0
HealthPassing    = 0.0
EvidenceEmitted  = 1.0

KubeContainerScore = 4 / 5 = 0.80
```

## MetaKubeScore

```text
MetaKubeScore = average(
  ClusterReady,
  ImageBuilt,
  OperatorDeployed,
  PrometheusWitnessPresent,
  ObservanceVerdictEmitted
)
```

## MetaPlatformScore

```text
MetaPlatformScore = average(
  CoreScore,
  StoreScore,
  OperationsScore,
  GovernanceScore,
  TrustScore,
  ReleaseReadinessScore
)
```

## GovernanceScore

```text
GovernanceScore = average(
  IdentityResolved,
  RelationsResolved,
  PolicyDefined,
  PolicyEnforced,
  EvidenceComplete,
  ReleaseGatePresent
)
```

## Critical caps

Weighted average is not enough for governance. Some failures must cap the parent score even if other areas are healthy.

| Critical failure | Score cap |
|---|---:|
| no identity for subject | 0.60 |
| no evidence artifact | 0.70 |
| release gate missing | 0.70 |
| operator not ready | 0.50 |
| workload not created | 0.50 |
| policy explicitly denies release | 0.40 |
| security breach or broken seal | 0.30 |

Final score is:

```text
FinalScore = min(WeightedScore, CriticalCap)
```

If no critical cap applies:

```text
FinalScore = WeightedScore
```

## Verdict mapping

```text
score >= 0.90 -> PROMISE_KEPT
score >= 0.70 -> PROMISE_PARTIAL
score <  0.70 -> PROMISE_BROKEN
```

## Merge example

```text
KubeContainerScore = 0.80
MetaKubeScore      = 0.90
MetaPlatformScore  = 0.75
GovernanceScore    = 0.80

WeightedScore =
  0.40 * 0.80
+ 0.30 * 0.90
+ 0.20 * 0.75
+ 0.10 * 0.80

WeightedScore = 0.82
```

If no critical cap applies:

```text
FinalScore = 0.82
Verdict = PROMISE_PARTIAL
```

If the evidence artifact is missing:

```text
CriticalCap = 0.70
FinalScore = min(0.82, 0.70) = 0.70
Verdict = PROMISE_PARTIAL
```

If the operator is not ready:

```text
CriticalCap = 0.50
FinalScore = min(0.82, 0.50) = 0.50
Verdict = PROMISE_BROKEN
```

## Why merge this way

Average alone hides fatal failures. Hard gates alone hide useful partial progress. Fabric uses both:

```text
weighted average = maturity
critical cap = governance safety
```

## Canonical line

Scores merge upward by weighted evidence, but governance can cap the result when a broken promise is too important to average away.
