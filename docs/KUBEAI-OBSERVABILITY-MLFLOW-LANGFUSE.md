# KubeAI Observability with MLflow and Langfuse

KubeAIObservability is the AI engineering, evaluation, and model/agent lifecycle kube for FabriKube.

```text
KubeAIObservability = AI run declaration + trace/eval loop + AI engineering face + model record + quality contract
```

## Reference placement

| Reference | Kube role |
|---|---|
| MLflow | experiment tracking, model evaluation, model registry, model deployment, AI/LLM/agent lifecycle |
| Langfuse | LLM and agent observability, traces, prompt management, evaluations, experiments, human annotation |
| ClickStack | general observability for logs, metrics, traces, and sessions |
| KubeArithmetic | token cost, latency, quality, route score, eval score, and risk math |
| KubeMath | model constraints, eval models, routing models, and proof requirements |

## KubeAIObservability contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeAIObservability
metadata:
  name: fabric-ai-observability
spec:
  lifecycle:
    experiments: mlflow
    modelRegistry: mlflow
    deploymentRecords: mlflow
    llmTraces: langfuse
    promptManagement: langfuse
    evaluations:
      - mlflow
      - langfuse
  records:
    - experiments
    - runs
    - traces
    - prompts
    - datasets
    - evals
    - model-versions
    - deployments
  governance:
    identityFabric: required
    dataClassification: required
    promptVersionRequired: true
    modelVersionRequired: true
    evalBeforeRelease: true
    costTrackingRequired: true
  evidence:
    requiredVerdicts:
      - AI_RUN_RECORDED
      - MODEL_VERSIONED
      - PROMPT_VERSIONED
      - EVAL_PASSED
      - COST_RECORDED
```

## MLflow role

MLflow is the lifecycle backbone for AI and ML assets.

```text
experiment -> run -> metrics -> model version -> registry -> deployment -> monitoring
```

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeModelRegistry
metadata:
  name: fabric-model-registry
spec:
  engine: mlflow
  tracks:
    - parameters
    - code-version
    - datasets
    - metrics
    - artifacts
    - model-versions
    - deployments
  governance:
    lineageRequired: true
    ownerRequired: true
    evalRequired: true
  verdicts:
    required:
      - EXPERIMENT_TRACKED
      - MODEL_VERSIONED
      - DEPLOYMENT_RECORDED
```

## Langfuse role

Langfuse is the LLM and agent behavior lens.

```text
request -> trace -> spans -> model calls -> tool calls -> retrieval -> prompt version -> eval -> annotation
```

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeLLMTrace
metadata:
  name: fabric-llm-trace
spec:
  engine: langfuse
  captures:
    - llm-calls
    - tool-invocations
    - retrieval-steps
    - prompts
    - sessions
    - cost
    - latency
    - eval-scores
  promptManagement:
    versioned: true
    rollback: true
  evaluation:
    llmAsJudge: optional
    heuristic: optional
    humanReview: optional
  verdicts:
    required:
      - TRACE_RECORDED
      - PROMPT_VERSIONED
      - EVAL_RECORDED
```

## Release gate

No AI app, model, prompt, or agent goes to production without an evidence gate.

```text
model version + prompt version + eval result + cost bound + data policy + owner approval -> AI_RELEASE_ALLOWED
```

## Relationship to KubeAgentRuntime

KubeAgentRuntime runs the agent. KubeAIObservability proves what the agent did and how well it did it.

```text
Agent runtime = act
AI observability = trace, evaluate, improve, prove
```

## Rule

No untraced model call. No unversioned prompt. No unevaluated release. No hidden token cost. No model registry entry without lineage.