# Standard Kubernetes Chat Control Commands

This is the operator instruction sheet for running the Meta Platform chat control panel against SurrealDB in Kubernetes.

## Current architecture

```text
Browser
  -> host Node.js service on :3000
  -> localhost:8000
  -> kubectl port-forward
  -> Kubernetes service/surrealdb
  -> SurrealDB pod
```

## 1. Check Kubernetes SurrealDB

```bash
sudo k3s kubectl -n fabric get pods,svc
```

Expected:

```text
pod/surrealdb-0     1/1 Running
service/surrealdb   ClusterIP 8000/TCP
```

## 2. Start SurrealDB local bridge

Run this in terminal 1 and keep it open:

```bash
sudo k3s kubectl -n fabric port-forward svc/surrealdb 8000:8000 --address 127.0.0.1
```

Expected:

```text
Forwarding from 127.0.0.1:8000 -> 8000
```

## 3. Restart chat control panel

Run this in terminal 2:

```bash
sudo systemctl restart meta-chat-control-panel
sudo systemctl status meta-chat-control-panel --no-pager
```

## 4. Test agents API

```bash
curl -s http://127.0.0.1:3000/api/agents | jq .
```

Expected:

```json
{
  "agents": [
    {
      "id": "agent:fabric_architect",
      "name": "Fabric Architect",
      "objective": "Build and govern the Fabric",
      "status": "active",
      "trust_score": 100
    }
  ]
}
```

## 5. Send chat command

```bash
curl -s -X POST http://127.0.0.1:3000/api/chat \
  -H 'Content-Type: application/json' \
  -d '{"agent":"agent:fabric_architect","message":"prove the Fabric chat control plane is alive"}' | jq .
```

Expected verdict:

```text
RECORDED
```

## 6. Verify in SurrealDB

```bash
printf 'SELECT * FROM agent; SELECT * FROM chat_message ORDER BY created_at DESC LIMIT 5;\n' | surreal sql \
  -e ws://127.0.0.1:8000 \
  -u root \
  -p ChangeMeNow \
  --ns agennext \
  --db fabric
```

## 7. Make SurrealDB bridge permanent

```bash
cat > ~/surreal-port-forward.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
exec sudo k3s kubectl -n fabric port-forward svc/surrealdb 8000:8000 --address 127.0.0.1
EOF

chmod +x ~/surreal-port-forward.sh

sudo tee /etc/systemd/system/surreal-port-forward.service >/dev/null <<EOF
[Unit]
Description=SurrealDB local port-forward for Fabric
After=network-online.target k3s.service
Wants=network-online.target

[Service]
Type=simple
User=ubuntu
ExecStart=/home/ubuntu/surreal-port-forward.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now surreal-port-forward
sudo systemctl restart meta-chat-control-panel
```

## 8. Standard health command

```bash
sudo systemctl status surreal-port-forward --no-pager || true
sudo systemctl status meta-chat-control-panel --no-pager || true
curl -s http://127.0.0.1:3000/api/agents | jq .
```

## 9. Standard repair command

```bash
sudo systemctl restart surreal-port-forward
sudo systemctl restart meta-chat-control-panel
sleep 3
curl -s http://127.0.0.1:3000/api/agents | jq .
```

## 10. Public URL

```text
http://51.161.208.75:3000
```

## Verdict chain

```text
Kubernetes SurrealDB Running
+ localhost bridge active
+ chat control panel active
+ agent API responds
+ chat command recorded
= CHAT_CONTROL_PLANE_ALIVE
```

## Canonical line

The standard K8s chat control operation is: keep SurrealDB in Kubernetes, bridge it to localhost, run the host chat service, and record every human command as Fabric evidence.
