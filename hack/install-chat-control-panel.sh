#!/usr/bin/env bash
set -euo pipefail
set +H || true

APP_DIR="$HOME/meta-chat-control-panel"
PORT="${PORT:-3000}"
SURREAL_URL="${SURREAL_URL:-http://127.0.0.1:8000}"
SURREAL_USER="${SURREAL_USER:-root}"
SURREAL_PASS="${SURREAL_PASS:-ChangeMeNow}"
SURREAL_NS="${SURREAL_NS:-agennext}"
SURREAL_DB="${SURREAL_DB:-fabric}"

sudo apt update
sudo apt install -y curl ca-certificates git build-essential

if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install -y nodejs
fi

rm -rf "$APP_DIR"
mkdir -p "$APP_DIR"
cd "$APP_DIR"

cat > package.json <<'PKG'
{"name":"meta-chat-control-panel","version":"0.1.0","private":true,"type":"module","scripts":{"start":"node server.js"},"dependencies":{"express":"^4.19.2"}}
PKG

cat > server.js <<'NODE'
import express from "express";

const app = express();
app.use(express.json({ limit: "1mb" }));

const cfg = {
  surrealUrl: process.env.SURREAL_URL || "http://127.0.0.1:8000",
  user: process.env.SURREAL_USER || "root",
  pass: process.env.SURREAL_PASS || "ChangeMeNow",
  ns: process.env.SURREAL_NS || "agennext",
  db: process.env.SURREAL_DB || "fabric"
};

function escapeSqlString(value) {
  return String(value).replaceAll("\\", "\\\\").replaceAll('"', '\\"');
}

async function surreal(sql) {
  const res = await fetch(`${cfg.surrealUrl}/sql`, {
    method: "POST",
    headers: {
      "Accept": "application/json",
      "Content-Type": "text/plain",
      "Authorization": "Basic " + Buffer.from(`${cfg.user}:${cfg.pass}`).toString("base64"),
      "Surreal-NS": cfg.ns,
      "Surreal-DB": cfg.db
    },
    body: sql
  });

  const text = await res.text();
  if (!res.ok) throw new Error(text);
  try { return JSON.parse(text); } catch { return text; }
}

async function ensureSchema() {
  await surreal(`
    DEFINE TABLE IF NOT EXISTS agent SCHEMAFULL;
    DEFINE FIELD IF NOT EXISTS name ON agent TYPE string;
    DEFINE FIELD IF NOT EXISTS objective ON agent TYPE string;
    DEFINE FIELD IF NOT EXISTS status ON agent TYPE string;
    DEFINE FIELD IF NOT EXISTS trust_score ON agent TYPE number;

    DEFINE TABLE IF NOT EXISTS chat_message SCHEMAFULL;
    DEFINE FIELD IF NOT EXISTS agent ON chat_message TYPE record<agent>;
    DEFINE FIELD IF NOT EXISTS role ON chat_message TYPE string;
    DEFINE FIELD IF NOT EXISTS content ON chat_message TYPE string;
    DEFINE FIELD IF NOT EXISTS created_at ON chat_message TYPE datetime;

    UPSERT agent:fabric_architect SET
      name = "Fabric Architect",
      objective = "Build and govern the Fabric",
      status = "active",
      trust_score = 100;
  `);
}

app.get("/", (_, res) => {
  res.type("html").send(`<!doctype html>
<html>
<head>
<meta charset="utf-8"/>
<title>Meta Platform Chat Control Panel</title>
<style>
body{font-family:Inter,system-ui,sans-serif;margin:0;background:#f7f9fc;color:#101828}
header{padding:22px 28px;background:#0b5fff;color:white}
main{display:grid;grid-template-columns:360px 1fr;gap:16px;padding:16px}
.card{background:white;border:1px solid #e4e7ec;border-radius:14px;padding:16px;box-shadow:0 1px 2px rgba(16,24,40,.06)}
pre{white-space:pre-wrap;background:#101828;color:#d0d5dd;padding:12px;border-radius:10px;overflow:auto}
input,textarea,button{width:100%;box-sizing:border-box;padding:10px;border-radius:10px;border:1px solid #d0d5dd;margin-top:8px}
button{background:#0b5fff;color:white;font-weight:700;cursor:pointer}
.agent{padding:10px;border-bottom:1px solid #eaecf0}
.muted{color:#667085}
</style>
</head>
<body>
<header>
<h1>Meta Platform Chat Control Panel</h1>
<div>Fabric Store: ${cfg.ns}/${cfg.db} · SurrealDB: ${cfg.surrealUrl}</div>
</header>
<main>
<section class="card">
<h2>Agents</h2>
<button onclick="loadAgents()">Refresh Agents</button>
<div id="agents" class="muted">Loading...</div>
</section>
<section class="card">
<h2>Chat Command</h2>
<input id="agent" value="agent:fabric_architect"/>
<textarea id="message" rows="6">What is the current Fabric objective?</textarea>
<button onclick="sendChat()">Send</button>
<h3>Response</h3>
<pre id="out">Ready.</pre>
</section>
</main>
<script>
async function loadAgents(){
  const r=await fetch('/api/agents'); const data=await r.json();
  document.getElementById('agents').innerHTML=(data.agents||[]).map(a =>
    '<div class="agent"><b>'+a.id+'</b><br>'+a.name+
    '<br><span class="muted">status='+a.status+' trust='+a.trust_score+'</span></div>'
  ).join('') || 'No agents found';
}
async function sendChat(){
  const r=await fetch('/api/chat',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({
    agent:document.getElementById('agent').value,
    message:document.getElementById('message').value
  })});
  document.getElementById('out').textContent=JSON.stringify(await r.json(),null,2);
  loadAgents();
}
loadAgents();
</script>
</body>
</html>`);
});

app.get("/api/agents", async (_, res) => {
  try {
    const data = await surreal("SELECT * FROM agent;");
    res.json({ agents: data?.[0]?.result || [] });
  } catch (e) {
    res.status(500).json({ error: String(e.message || e) });
  }
});

app.post("/api/chat", async (req, res) => {
  const agent = String(req.body.agent || "agent:fabric_architect");
  const message = String(req.body.message || "");

  try {
    const sql = `
      CREATE chat_message SET
        agent = ${agent},
        role = "user",
        content = "${escapeSqlString(message)}",
        created_at = time::now();

      RETURN {
        agent: ${agent},
        received: "${escapeSqlString(message)}",
        response: "Fabric control panel received the command. Router/LLM wiring comes next.",
        verdict: "RECORDED"
      };
    `;
    const data = await surreal(sql);
    res.json({ ok: true, result: data });
  } catch (e) {
    res.status(500).json({ ok: false, error: String(e.message || e) });
  }
});

ensureSchema().then(() => {
  app.listen(Number(process.env.PORT || 3000), "0.0.0.0", () => {
    console.log(`Meta Chat Control Panel listening on :${process.env.PORT || 3000}`);
  });
}).catch(err => {
  console.error("Failed to initialize schema:", err);
  process.exit(1);
});
NODE

npm install

cat > .env <<ENV
PORT=$PORT
SURREAL_URL=$SURREAL_URL
SURREAL_USER=$SURREAL_USER
SURREAL_PASS=$SURREAL_PASS
SURREAL_NS=$SURREAL_NS
SURREAL_DB=$SURREAL_DB
ENV

sudo tee /etc/systemd/system/meta-chat-control-panel.service >/dev/null <<SERVICE
[Unit]
Description=Meta Platform Chat Control Panel
After=network.target

[Service]
Type=simple
WorkingDirectory=$APP_DIR
EnvironmentFile=$APP_DIR/.env
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5
User=$USER

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload
sudo systemctl enable --now meta-chat-control-panel
sudo ufw allow "$PORT"/tcp || true

echo "DONE: http://51.161.208.75:$PORT"
echo "Logs: sudo journalctl -u meta-chat-control-panel -f"
