#!/usr/bin/env bash
set -euo pipefail
set +H || true

APP_NAME="meta-chat-control-panel"
APP_DIR="${APP_DIR:-$HOME/meta-chat-control-panel}"
PORT="${PORT:-3000}"
URL="http://127.0.0.1:$PORT"
PUBLIC_URL="http://51.161.208.75:$PORT"
SURREAL_URL="${SURREAL_URL:-http://127.0.0.1:8000}"
SURREAL_WS="${SURREAL_WS:-ws://127.0.0.1:8000}"
SURREAL_USER="${SURREAL_USER:-root}"
SURREAL_PASS="${SURREAL_PASS:-ChangeMeNow}"
SURREAL_NS="${SURREAL_NS:-agennext}"
SURREAL_DB="${SURREAL_DB:-fabric}"
REPORT_DIR="${REPORT_DIR:-$HOME/fabric-ops-reports}"
REPORT="$REPORT_DIR/server-ops-$(date +%Y%m%d-%H%M%S).txt"
INSTALLER_URL="https://api.github.com/repos/unboxd-cloud/KubeContainer/contents/hack/install-chat-control-panel.sh?ref=claude/dreamy-darwin-wcepfb"

mkdir -p "$REPORT_DIR"

log() { printf '[server-ops] %s\n' "$*"; }
section() { printf '\n## %s\n' "$*"; }

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    return 1
  fi
}

install_deps() {
  log "installing base tools"
  sudo apt update
  sudo apt install -y curl ca-certificates jq git build-essential
}

install_panel() {
  install_deps
  log "installing chat control panel"
  cd "$HOME"
  rm -f one-chat-control-panel.sh
  curl -fsSL -H "Accept: application/vnd.github.raw" "$INSTALLER_URL" -o one-chat-control-panel.sh
  chmod +x one-chat-control-panel.sh
  ./one-chat-control-panel.sh
}

restart_panel() {
  log "restarting $APP_NAME"
  sudo systemctl daemon-reload
  sudo systemctl restart "$APP_NAME"
}

status_panel() {
  section "systemd"
  sudo systemctl status "$APP_NAME" --no-pager || true
}

health_panel() {
  section "health"
  echo "URL=$URL"
  curl -sS -I "$URL" | head -n 10 || true
  echo
  curl -sS "$URL/api/agents" | jq . || curl -sS "$URL/api/agents" || true
}

prove_panel() {
  section "chat proof"
  curl -sS -X POST "$URL/api/chat" \
    -H 'Content-Type: application/json' \
    -d '{"agent":"agent:fabric_architect","message":"automatic server-ops proof: Fabric control panel is alive"}' \
    | jq . || true

  section "surrealdb proof"
  if need_cmd surreal; then
    surreal sql \
      -e "$SURREAL_WS" \
      -u "$SURREAL_USER" \
      -p "$SURREAL_PASS" \
      --ns "$SURREAL_NS" \
      --db "$SURREAL_DB" \
      -q 'SELECT * FROM agent; SELECT * FROM chat_message ORDER BY created_at DESC LIMIT 5;' || true
  else
    echo "surreal CLI not found; skipping DB proof"
  fi
}

repair_panel() {
  log "repairing $APP_NAME"
  if ! systemctl list-unit-files | grep -q "^$APP_NAME.service"; then
    log "service missing; reinstalling"
    install_panel
    return
  fi

  if ! systemctl is-active --quiet "$APP_NAME"; then
    log "service inactive; restarting"
    restart_panel
  fi

  if ! curl -fsS "$URL/api/agents" >/dev/null 2>&1; then
    log "API unhealthy; reinstalling"
    install_panel
  fi
}

report_all() {
  {
    echo "Fabric Server Operations Report"
    echo "Generated: $(date -Is)"
    echo "App: $APP_NAME"
    echo "AppDir: $APP_DIR"
    echo "URL: $URL"
    echo "PublicURL: $PUBLIC_URL"
    echo "SurrealNS: $SURREAL_NS"
    echo "SurrealDB: $SURREAL_DB"
    status_panel
    health_panel
    prove_panel
    echo
    echo "VERDICT: SERVER_OPS_PROOF_RECORDED"
  } | tee "$REPORT"
  echo
  echo "Report: $REPORT"
}

watch_panel() {
  log "watching logs"
  sudo journalctl -u "$APP_NAME" -f
}

usage() {
  cat <<USAGE
Usage: $0 <command>

Commands:
  install   Install/reinstall the chat control panel
  status    Show systemd status
  health    Check HTTP/API health
  prove     Send proof message and query SurrealDB
  repair    Restart/reinstall if unhealthy
  restart   Restart service
  report    Run full report and write evidence
  watch     Follow service logs
  all       install -> repair -> report

Examples:
  $0 all
  $0 repair
  $0 report
USAGE
}

cmd="${1:-report}"
case "$cmd" in
  install) install_panel ;;
  status) status_panel ;;
  health) health_panel ;;
  prove) prove_panel ;;
  repair) repair_panel ;;
  restart) restart_panel ;;
  report) report_all ;;
  watch) watch_panel ;;
  all) install_panel; repair_panel; report_all ;;
  *) usage; exit 1 ;;
esac
