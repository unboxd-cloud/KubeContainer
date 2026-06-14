# KubeAgent Runtime with MindsHub Alignment

KubeAgentRuntime is the AI agent runtime kube for FabriKube.

MindsHub is the reference pattern for hosted open-agent infrastructure: run open agents with models, tools, data, credentials, scratchpads, memory, scheduling, logs, persistence, and operational control.

```text
KubeAgentRuntime = agent declaration + execution loop + workspace face + run record + agent contract
```

## Placement

| Layer | Role |
|---|---|
| AI Cloud | runs agents with model routing, tools, memory, and execution safety |
| Skill Cloud | lets people learn, build, showcase, and monetize agent skills/tools |
| KubeApp lifecycle | runs agents as managed application components |
| KubeOrchestrator | schedules recurring agent jobs and workflow steps |
| KubeDataSync | gives agents governed access to data, never raw uncontrolled movement |
| Identity Fabric | binds agents, users, credentials, tools, and allowed actions |
| KubeArithmetic | controls model cost, token budgets, latency, and routing math |
| KubeAnswer | captures agent support, Q&A, and knowledge artifacts |

## KubeAgentRuntime contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeAgentRuntime
metadata:
  name: fabric-agent-runtime
spec:
  agents:
    - name: openclaw
      source: open-agent
    - name: anton
      source: open-agent
    - name: hermes
      source: open-agent
  workspace:
    face: cowork-style
    artifacts: required
    inspectableScratchpad: true
  modelRouter:
    enabled: true
    routeBy:
      - capability
      - cost
      - latency
      - context-window
      - safety-policy
  toolsAndData:
    connectors:
      - databases
      - warehouses
      - docs-files
      - saas-apps
      - email-chat
      - calendars
      - crm
      - api
      - mcp
    governance:
      identityFabric: required
      credentialsVault: required
      dataClassification: required
      purposeRequired: true
  execution:
    persistent: true
    scheduled: true
    logsRequired: true
    replayable: true
  evidence:
    requiredVerdicts:
      - AGENT_RUNTIME_READY
      - MODEL_ROUTED
      - CREDENTIALS_GUARDED
      - TOOL_ACCESS_DECIDED
      - RUN_RECORDED
```

## Model routing

Model routing is arithmetic plus governance.

```text
task + capability + cost + latency + policy + context -> model choice + reason + verdict
```

No agent should hard-code one model when the work may need reasoning, coding, extraction, vision, low-cost background processing, or long-context recall.

## Credentials vault

Agents may use credentials but must not see raw credentials.

```text
agent requests action
  -> identity fabric checks relation
  -> vault grants scoped tool session
  -> action is recorded
  -> credential remains hidden
```

## Scratchpad and memory

Scratchpads are reproducible execution spaces. Memory is cross-run recall. Both must be governed.

```text
scratchpad = inspectable temporary work state
memory = persistent record-bound recall
```

Memory may personalize work, but it may not silently change authorization, pricing, or data access.

## Agent run record

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeAgentRun
metadata:
  name: anton-weekly-report-2026-06-14
spec:
  agent: anton
  principal: user:owner@example.com
  goal: weekly-business-report
  models:
    - role: planning
      selectedBy: model-router
    - role: extraction
      selectedBy: model-router
  tools:
    - docs-files
    - analytics
    - spreadsheet
  data:
    classification: private
    movement: no-copy-by-default
  artifacts:
    - weekly-report
  verdicts:
    required:
      - ACCESS_DECIDED
      - MODEL_ROUTED
      - TOOL_ACCESS_DECIDED
      - ARTIFACT_DELIVERED
      - RUN_RECORDED
```

## Rule

No agent without identity. No tool without access decision. No credential exposure. No model call without route reason. No artifact without run record.