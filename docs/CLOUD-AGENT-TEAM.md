# Cloud Agent Team

Cloud Agent Team is the first operational team inside the Fabric.

It turns server, Kubernetes, database, release, evidence, and repair work into named agents with clear responsibilities.

## Team shape

```text
CloudAgentTeam
  ├── Cloud Commander
  ├── K8s Operator Agent
  ├── SurrealDB Fabric Store Agent
  ├── Chat Control Agent
  ├── Observance Agent
  ├── Repair Agent
  ├── Release Gate Agent
  └── Marketplace Agent
```

## Agents

| Agent | Purpose | Evidence |
|---|---|---|
| Cloud Commander | coordinates the full team | command log, final verdict |
| K8s Operator Agent | checks pods, services, port-forward, workloads | kubectl output |
| SurrealDB Fabric Store Agent | owns namespace, database, schema, agent records | SurrealDB query output |
| Chat Control Agent | runs human-to-agent command panel | HTTP/API proof |
| Observance Agent | converts telemetry into verdict | proof report |
| Repair Agent | restarts, repairs, reconciles unhealthy services | repair log |
| Release Gate Agent | blocks release unless proof is green | release score |
| Marketplace Agent | prepares AWS Marketplace evidence package | listing checklist |

## Fabric records

Every cloud agent is stored as a Fabric `agent` record.

```text
agent:cloud_commander
agent:k8s_operator
agent:surrealdb_store
agent:chat_control
agent:observance
agent:repair
agent:release_gate
agent:marketplace
```

## Trust scoring

Each agent receives a decimal trust score.

```text
100 = trusted initial standing
 70 = probation threshold
 50 = broken operational standing
```

## Command chain

```text
Human command
  -> Chat Control Panel
  -> Cloud Commander
  -> specialist agent
  -> Kubernetes / SurrealDB / systemd
  -> evidence
  -> observance verdict
  -> Fabric history
```

## Standard verdicts

```text
CLOUD_TEAM_READY
CLOUD_TEAM_PARTIAL
CLOUD_TEAM_BROKEN
```

## Canonical line

Cloud Agent Team is the operating crew of the Fabric: each cloud responsibility becomes a named, scored, repairable agent with evidence.
