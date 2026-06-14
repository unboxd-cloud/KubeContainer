#!/usr/bin/env bash
set -euo pipefail
set +H || true

SERVER_IP="${SERVER_IP:-51.161.208.75}"
PORT="${PORT:-3000}"
REPORT="${REPORT:-$HOME/unboxd-onboarding-report.txt}"
SURREAL_WS="${SURREAL_WS:-ws://127.0.0.1:8000}"
SURREAL_USER="${SURREAL_USER:-root}"
SURREAL_PASS="${SURREAL_PASS:-ChangeMeNow}"
SURREAL_NS="${SURREAL_NS:-agennext}"
SURREAL_DB="${SURREAL_DB:-fabric}"
BRANCH="${BRANCH:-claude/dreamy-darwin-wcepfb}"
REPO_API="https://api.github.com/repos/unboxd-cloud/KubeContainer/contents"

log() { printf '[unboxd-onboard] %s\n' "$*"; }
step() { printf '\n## %s\n' "$*" | tee -a "$REPORT"; }
raw_download() {
  local path="$1"
  local out="$2"
  curl -fsSL -H "Accept: application/vnd.github.raw" "$REPO_API/$path?ref=$BRANCH" -o "$out"
}

: > "$REPORT"
{
  echo "Unboxd Onboarding Report"
  echo "Product: Unboxd — Code First Cloud Where Anyone Can Build"
  echo "Generated: $(date -Is)"
  echo "Server: $SERVER_IP"
  echo
} >> "$REPORT"

step "1. Server check"
uname -a | tee -a "$REPORT"
df -h / | tee -a "$REPORT"
free -h | tee -a "$REPORT"

step "2. Dependencies"
sudo apt update
sudo apt install -y curl ca-certificates jq git build-essential | tee -a "$REPORT"

step "3. Kubernetes check"
if command -v k3s >/dev/null 2>&1; then
  sudo k3s kubectl get nodes | tee -a "$REPORT" || true
  sudo k3s kubectl -n fabric get pods,svc | tee -a "$REPORT" || true
else
  echo "k3s not found" | tee -a "$REPORT"
fi

step "4. SurrealDB bridge"
cat > "$HOME/surreal-port-forward.sh" <<'PF'
#!/usr/bin/env bash
set -euo pipefail
exec sudo k3s kubectl -n fabric port-forward svc/surrealdb 8000:8000 --address 127.0.0.1
PF
chmod +x "$HOME/surreal-port-forward.sh"

sudo tee /etc/systemd/system/surreal-port-forward.service >/dev/null <<SERVICE
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
SERVICE
sudo systemctl daemon-reload
sudo systemctl enable --now surreal-port-forward | tee -a "$REPORT" || true
sudo systemctl restart surreal-port-forward || true
sleep 3
sudo systemctl status surreal-port-forward --no-pager | tee -a "$REPORT" || true

step "5. Chat control panel install/repair"
raw_download "hack/install-chat-control-panel.sh" "$HOME/install-chat-control-panel.sh"
chmod +x "$HOME/install-chat-control-panel.sh"
PORT="$PORT" "$HOME/install-chat-control-panel.sh" | tee -a "$REPORT"
sudo systemctl restart meta-chat-control-panel || true
sleep 3
sudo systemctl status meta-chat-control-panel --no-pager | tee -a "$REPORT" || true

step "6. Cloud Agent Team seed"
raw_download "hack/install-cloud-agent-team.sh" "$HOME/install-cloud-agent-team.sh"
chmod +x "$HOME/install-cloud-agent-team.sh"
"$HOME/install-cloud-agent-team.sh" | tee -a "$REPORT" || true

step "7. API health"
curl -sS "http://127.0.0.1:$PORT/api/agents" | jq . | tee -a "$REPORT" || true

step "8. Proof command"
curl -sS -X POST "http://127.0.0.1:$PORT/api/chat" \
  -H 'Content-Type: application/json' \
  -d '{"agent":"agent:cloud_commander","message":"prove Unboxd Code First Cloud onboarding is alive"}' \
  | jq . | tee -a "$REPORT" || true

step "9. Fabric store proof"
if command -v surreal >/dev/null 2>&1; then
  printf 'SELECT * FROM agent ORDER BY name; SELECT * FROM chat_message ORDER BY created_at DESC LIMIT 5;\n' | surreal sql \
    -e "$SURREAL_WS" \
    -u "$SURREAL_USER" \
    -p "$SURREAL_PASS" \
    --ns "$SURREAL_NS" \
    --db "$SURREAL_DB" | tee -a "$REPORT" || true
else
  echo "surreal CLI not found" | tee -a "$REPORT"
fi

step "10. Verdict"
if curl -fsS "http://127.0.0.1:$PORT/api/agents" >/dev/null 2>&1; then
  echo "VERDICT: UNBOXD_CLOUD_READY" | tee -a "$REPORT"
else
  echo "VERDICT: UNBOXD_CLOUD_PARTIAL" | tee -a "$REPORT"
fi

echo
log "Report: $REPORT"
log "Open: http://$SERVER_IP:$PORT"
