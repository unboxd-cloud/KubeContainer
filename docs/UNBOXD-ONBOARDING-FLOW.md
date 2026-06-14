# Unboxd Onboarding Flow

## Product line

```text
Unboxd — Code First Cloud Where Anyone Can Build
```

## Goal

The onboarding flow turns a fresh VPS into a governed cloud workspace with a Fabric store, chat control panel, cloud agent team, and proof report.

## Flow

```text
1. Welcome
2. Server check
3. Kubernetes check
4. SurrealDB bridge
5. Fabric store check
6. Chat control panel
7. Cloud Agent Team seed
8. Proof command
9. Evidence report
10. Ready screen
```

## User journey

### 1. Welcome

User sees:

```text
Welcome to Unboxd Code First Cloud.
This setup will turn your server into a builder-ready cloud control plane.
```

### 2. Server check

Checks:

```text
OS
CPU
memory
disk
network
systemd
curl
node
k3s
surreal CLI
```

### 3. Kubernetes check

Checks:

```bash
sudo k3s kubectl get nodes
sudo k3s kubectl -n fabric get pods,svc
```

Required:

```text
node Ready
surrealdb-0 Running
service/surrealdb available
```

### 4. SurrealDB bridge

Starts or verifies:

```text
surreal-port-forward.service
```

Bridge:

```text
127.0.0.1:8000 -> service/surrealdb:8000
```

### 5. Fabric store check

Checks:

```text
namespace: agennext
database: fabric
table: agent
record: agent:fabric_architect
```

### 6. Chat control panel

Installs or repairs:

```text
meta-chat-control-panel.service
```

URL:

```text
http://SERVER_IP:3000
```

### 7. Cloud Agent Team seed

Creates:

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

### 8. Proof command

Sends:

```text
prove Unboxd Code First Cloud onboarding is alive
```

### 9. Evidence report

Writes:

```text
~/unboxd-onboarding-report.txt
```

### 10. Ready screen

Final verdict:

```text
UNBOXD_CLOUD_READY
```

## Onboarding states

```text
NOT_STARTED
SERVER_READY
K8S_READY
FABRIC_READY
CHAT_READY
TEAM_READY
PROOF_RECORDED
UNBOXD_CLOUD_READY
```

## Success criteria

```text
server reachable
k3s node Ready
SurrealDB running
localhost bridge active
chat panel active
agent team seeded
chat proof recorded
report written
```

## Canonical line

Unboxd onboarding is not a signup form; it is a proof flow that turns a server into a builder-ready cloud control plane.
