# AgentSLA and Fabric Contracts

This note maps AgentSLA into Fabric scoring and Meta Platform release gates.

Reference: arXiv:2511.02885v1, "AgentSLA: Towards a Service Level Agreement for AI Agents" by Gwendal Jouneaux and Jordi Cabot.

## Why it matters

AgentSLA proposes a quality model and a JSON-based domain-specific language for defining Service Level Agreements for AI agents. Its core concepts map directly into Fabric:

```text
SLA -> promise contract
GuaranteeTerm -> governed promise term
SLO -> measurable obligation
QoSMetric -> score input
DerivedQoSMetric -> aggregate evidence
QoSDriftMetric -> trust movement over time
Provider -> witness / measurement provider
Uncertainty -> confidence adjustment
```

## Fabric mapping

| AgentSLA concept | Fabric concept | Meaning |
|---|---|---|
| SLA | Promise contract | agreement between consumer and provider |
| GuaranteeTerm | governed term | bounded obligation |
| Scope | promise subject | agent, KubeContainer, service, platform layer |
| QualifyingCondition | precondition | when the term applies |
| SLO | release objective | measurable pass/fail obligation |
| QoSMetric | score input | latency, readiness, repair time, error rate, trust |
| DerivedQoSMetric | evidence window | average, median, percentile over time |
| QoSDriftMetric | drift detector | quality movement across windows |
| Provider | witness | metric provider with confidence and reputation |
| Uncertainty | score confidence | nondeterminism and measurement error |

## Fabric SLA equation

```text
FabricSLA = Scope + SLOs + Metrics + Evidence + Provider + Uncertainty + Drift
```

A kube is releasable only when its SLA score is green:

```text
SLAComplianceScore >= threshold
```

## Decimal scoring with SLA

Each SLO evaluates to a decimal score:

```text
SLOScore = 1.0 if objective is satisfied
SLOScore = 0.0 if objective is violated
SLOScore = partial value for graded objectives
```

Then uncertainty adjusts the score:

```text
AdjustedSLOScore = SLOScore * (1 - uncertainty)
```

Provider confidence can raise or reduce trust in the evidence:

```text
TrustedSLOScore = AdjustedSLOScore * ProviderConfidence
```

## SLA score merge

```text
SLAComplianceScore = weighted_average(TrustedSLOScores)
```

Then the Fabric merge rule still applies:

```text
FinalScore = min(SLAComplianceScore, CriticalCap)
```

## Example MetaKube SLA

```json
{
  "SLA": "MetaKube Proof Gate",
  "Scope": "Meta Platform v0.1.0",
  "SLO": [
    {
      "name": "OperatorReady",
      "metric": "operator_ready",
      "operator": "EQUALS",
      "value": 1,
      "weight": 0.25
    },
    {
      "name": "KubeContainerReady",
      "metric": "kubecontainer_ready",
      "operator": "EQUALS",
      "value": 1,
      "weight": 0.25
    },
    {
      "name": "PrometheusWitnessPresent",
      "metric": "prometheus_witness_present",
      "operator": "EQUALS",
      "value": 1,
      "weight": 0.20
    },
    {
      "name": "EvidenceArtifactWritten",
      "metric": "evidence_artifact_written",
      "operator": "EQUALS",
      "value": 1,
      "weight": 0.20
    },
    {
      "name": "RepairPathDefined",
      "metric": "repair_path_defined",
      "operator": "EQUALS",
      "value": 1,
      "weight": 0.10
    }
  ]
}
```

## Drift

AgentSLA introduces drift metrics for quality movement over time. Fabric uses this for trust:

```text
TrustDrift = CurrentWindowScore - PreviousWindowScore
```

If trust drift is negative for consecutive windows, the kube may enter probation:

```text
if TrustDrift < -0.10 for 3 windows -> status = PROBATION
```

## Release gate integration

Meta Platform release readiness now has two checks:

```text
ObservanceVerdict = PROMISE_KEPT
SLAComplianceScore >= 0.90
```

If either fails, the release is not green.

## Canonical line

AgentSLA gives Fabric the contract grammar: every promise becomes a scoped SLA, every SLO becomes a score input, and every score becomes governable evidence.
