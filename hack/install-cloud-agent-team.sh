#!/usr/bin/env bash
set -euo pipefail
set +H || true

SURREAL_WS="${SURREAL_WS:-ws://127.0.0.1:8000}"
SURREAL_USER="${SURREAL_USER:-root}"
SURREAL_PASS="${SURREAL_PASS:-ChangeMeNow}"
SURREAL_NS="${SURREAL_NS:-agennext}"
SURREAL_DB="${SURREAL_DB:-fabric}"
SQL_URL="https://api.github.com/repos/unboxd-cloud/KubeContainer/contents/contracts/cloud-agent-team.sql?ref=claude/dreamy-darwin-wcepfb"
SQL_FILE="$HOME/cloud-agent-team.sql"
REPORT="$HOME/cloud-agent-team-report.txt"

if ! command -v surreal >/dev/null 2>&1; then
  echo "surreal CLI not found. Install SurrealDB CLI first."
  exit 1
fi

curl -fsSL -H "Accept: application/vnd.github.raw" "$SQL_URL" -o "$SQL_FILE"

printf 'Installing Cloud Agent Team into %s/%s via %s\n' "$SURREAL_NS" "$SURREAL_DB" "$SURREAL_WS"

surreal sql \
  -e "$SURREAL_WS" \
  -u "$SURREAL_USER" \
  -p "$SURREAL_PASS" \
  --ns "$SURREAL_NS" \
  --db "$SURREAL_DB" < "$SQL_FILE"

{
  echo "Cloud Agent Team Report"
  echo "Generated: $(date -Is)"
  echo
  printf 'SELECT * FROM agent ORDER BY name;\n' | surreal sql \
    -e "$SURREAL_WS" \
    -u "$SURREAL_USER" \
    -p "$SURREAL_PASS" \
    --ns "$SURREAL_NS" \
    --db "$SURREAL_DB"
  echo
  echo "VERDICT: CLOUD_AGENT_TEAM_SEEDED"
} | tee "$REPORT"

echo "Report: $REPORT"
