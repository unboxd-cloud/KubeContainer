#!/usr/bin/env bash
set -euo pipefail
set +H || true

APP_DIR="$HOME/unboxd-cloud-stack-panel"
PORT="${PORT:-3001}"
SURREAL_URL="${SURREAL_URL:-http://127.0.0.1:8000}"
SURREAL_USER="${SURREAL_USER:-root}"
SURREAL_PASS="${SURREAL_PASS:-ChangeMeNow}"
SURREAL_NS="${SURREAL_NS:-agennext}"
SURREAL_DB="${SURREAL_DB:-fabric}"
PUBLIC_IP="${PUBLIC_IP:-51.161.208.75}"

sudo apt update
sudo apt install -y curl ca-certificates jq git build-essential

if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt install -y nodejs
fi

rm -rf "$APP_DIR"
mkdir -p "$APP_DIR"
cd "$APP_DIR"

cat > package.json <<'PKG'
{"name":"unboxd-cloud-stack-panel","version":"0.1.0","private":true,"type":"module","scripts":{"start":"node server.js"},"dependencies":{"express":"^4.19.2"}}
PKG

cat > server.js <<'NODE'
import express from "express";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const exec = promisify(execFile);
const app = express();
app.use(express.json({ limit: "1mb" }));

const cfg = {
  surrealUrl: process.env.SURREAL_URL || "http://127.0.0.1:8000",
  user: process.env.SURREAL_USER || "root",
  pass: process.env.SURREAL_PASS || "ChangeMeNow",
  ns: process.env.SURREAL_NS || "agennext",
  db: process.env.SURREAL_DB || "fabric",
  publicIp: process.env.PUBLIC_IP || "51.161.208.75",
  port: process.env.PORT || "3001"
};

function esc(value) { return String(value).replaceAll("\\", "\\\\").replaceAll('"', '\\"'); }

async function run(cmd, args = []) {
  try {
    const { stdout, stderr } = await exec(cmd, args, { timeout: 12000, maxBuffer: 1024 * 1024 });
    return { ok: true, stdout, stderr };
  } catch (e) {
    return { ok: false, stdout: e.stdout || "", stderr: e.stderr || e.message };
  }
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
    DEFINE TABLE IF NOT EXISTS workspace SCHEMAFULL;
    DEFINE FIELD IF NOT EXISTS name ON workspace TYPE string;
    DEFINE FIELD IF NOT EXISTS builder_type ON workspace TYPE string;
    DEFINE FIELD IF NOT EXISTS goal ON workspace TYPE string;
    DEFINE FIELD IF NOT EXISTS created_at ON workspace TYPE datetime;

    DEFINE TABLE IF NOT EXISTS agent SCHEMAFULL;
    DEFINE FIELD IF NOT EXISTS name ON agent TYPE string;
    DEFINE FIELD IF NOT EXISTS objective ON agent TYPE string;
    DEFINE FIELD IF NOT EXISTS status ON agent TYPE string;
    DEFINE FIELD IF NOT EXISTS trust_score ON agent TYPE number;
    DEFINE FIELD IF NOT EXISTS role ON agent TYPE option<string>;
    DEFINE FIELD IF NOT EXISTS governance_scope ON agent TYPE option<string>;

    DEFINE TABLE IF NOT EXISTS chat_message SCHEMAFULL;
    DEFINE FIELD IF NOT EXISTS agent ON chat_message TYPE record<agent>;
    DEFINE FIELD IF NOT EXISTS role ON chat_message TYPE string;
    DEFINE FIELD IF NOT EXISTS content ON chat_message TYPE string;
    DEFINE FIELD IF NOT EXISTS response ON chat_message TYPE option<string>;
    DEFINE FIELD IF NOT EXISTS created_at ON chat_message TYPE datetime;

    UPSERT agent:cloud_commander SET name="Cloud Commander", objective="Coordinate the cloud stack", status="active", role="commander", governance_scope="cloud", trust_score=100;
    UPSERT agent:k8s_operator SET name="K8s Operator Agent", objective="Operate Kubernetes pods, services, and bridges", status="active", role="kubernetes_operator", governance_scope="kubernetes", trust_score=100;
    UPSERT agent:surrealdb_store SET name="SurrealDB Fabric Store Agent", objective="Operate Fabric database and schema", status="active", role="fabric_store_operator", governance_scope="surrealdb", trust_score=100;
    UPSERT agent:chat_control SET name="Chat Control Agent", objective="Record commands as Fabric evidence", status="active", role="chat_control_operator", governance_scope="control_panel", trust_score=100;
    UPSERT agent:observance SET name="Observance Agent", objective="Turn telemetry into verdicts", status="active", role="observance", governance_scope="evidence", trust_score=100;
    UPSERT agent:repair SET name="Repair Agent", objective="Repair unhealthy services", status="active", role="repair", governance_scope="operations", trust_score=100;
    UPSERT agent:release_gate SET name="Release Gate Agent", objective="Gate release readiness", status="active", role="release_gate", governance_scope="release", trust_score=100;
    UPSERT agent:marketplace SET name="Marketplace Agent", objective="Prepare commercial marketplace package", status="active", role="marketplace", governance_scope="commercial", trust_score=100;
    UPSERT agent:fabric_architect SET name="Fabric Architect", objective="Build and govern the Fabric", status="active", role="architect", governance_scope="fabric", trust_score=100;
  `);
}

function agentReply(agent, message) {
  if (agent.includes("k8s_operator")) return "K8s Operator: check nodes, fabric namespace pods/services, SurrealDB bridge, and workload health.";
  if (agent.includes("surrealdb_store")) return "SurrealDB Store: verify namespace agennext, database fabric, agent records, workspace, and chat evidence.";
  if (agent.includes("repair")) return "Repair Agent: restart surreal-port-forward, restart cloud stack panel, then re-run health proof.";
  if (agent.includes("release_gate")) return "Release Gate: require stack health green, agent team loaded, chat proof recorded, and evidence report written.";
  if (agent.includes("marketplace")) return "Marketplace Agent: package product story, install path, support policy, evidence report, pricing, and AWS listing checklist.";
  if (agent.includes("observance")) return "Observance Agent: convert systemd, Kubernetes, SurrealDB, API, and chat proof into a governed verdict.";
  if (agent.includes("chat_control")) return "Chat Control: command recorded as Fabric evidence.";
  return "Cloud Commander: Unboxd Cloud Stack received the command and routed it to the Fabric agent team.";
}

app.get("/", (_, res) => {
  res.type("html").send(`<!doctype html><html><head><meta charset="utf-8"/><title>Unboxd Cloud Stack Panel</title><style>
body{font-family:Inter,system-ui,sans-serif;margin:0;background:#f6f8fb;color:#101828}header{background:#0b5fff;color:white;padding:18px 26px}h1{margin:0}.sub{opacity:.9}.layout{display:grid;grid-template-columns:320px 1fr;min-height:calc(100vh - 76px)}aside{background:white;border-right:1px solid #e4e7ec;padding:14px;overflow:auto}.main{padding:16px;display:grid;gap:16px}.grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px}.card{background:white;border:1px solid #e4e7ec;border-radius:14px;padding:14px;box-shadow:0 1px 2px rgba(16,24,40,.06)}.agent{padding:9px;border-bottom:1px solid #eaecf0}.agent b{color:#475467}button{background:#0b5fff;color:white;border:0;border-radius:10px;padding:10px;font-weight:700;cursor:pointer}input,select,textarea{width:100%;box-sizing:border-box;padding:10px;border:1px solid #d0d5dd;border-radius:10px;margin-top:8px}pre{background:#101828;color:#d0d5dd;border-radius:10px;padding:12px;white-space:pre-wrap;overflow:auto}.ok{color:#067647}.bad{color:#b42318}.muted{color:#667085}.pill{display:inline-block;background:#eef4ff;border-radius:999px;padding:4px 8px;margin:2px;color:#0b5fff;font-weight:700}.tabs button{margin-right:6px;background:#eef4ff;color:#0b5fff}.tabs button.active{background:#0b5fff;color:white}@media(max-width:900px){.layout{grid-template-columns:1fr}.grid{grid-template-columns:1fr}}
</style></head><body><header><h1>Unboxd Cloud Stack Panel</h1><div class="sub">Code First Cloud Where Anyone Can Build · Fabric Store ${cfg.ns}/${cfg.db} · http://${cfg.publicIp}:${cfg.port}</div></header><div class="layout"><aside><button onclick="loadAll()">Refresh Stack</button><h3>Cloud Agent Team</h3><div id="agents" class="muted">Loading...</div></aside><section class="main"><div class="tabs"><button class="active" onclick="show('onboard')">Onboard</button><button onclick="show('stack')">Stack</button><button onclick="show('chat')">Chat</button><button onclick="show('proof')">Proof</button></div><div id="onboard" class="panel card"><h2>User Onboarding</h2><p class="muted">Create the first workspace and route the builder into the cloud stack.</p><input id="wsName" placeholder="Workspace name" value="Unboxd Builder Workspace"/><select id="builderType"><option>Individual Builder</option><option>Startup / Team</option><option>Agency</option><option>Enterprise Operator</option><option>Marketplace Partner</option></select><select id="goal"><option>Build an Agent</option><option>Build an App</option><option>Build an API / Backend</option><option>Build a Kubernetes Service</option><option>Prepare Marketplace Product</option></select><button onclick="createWorkspace()">Create Workspace</button><pre id="onboardOut">Ready.</pre></div><div id="stack" class="panel" style="display:none"><div class="grid"><div class="card"><h3>Systemd</h3><pre id="systemd">Loading...</pre></div><div class="card"><h3>Kubernetes</h3><pre id="k8s">Loading...</pre></div><div class="card"><h3>SurrealDB</h3><pre id="db">Loading...</pre></div></div><div class="card"><h3>Repair</h3><button onclick="repair()">Restart Panel Service</button><pre id="repairOut">Ready.</pre></div></div><div id="chat" class="panel card" style="display:none"><h2>Agent Chat</h2><select id="agent"><option value="agent:cloud_commander">Cloud Commander</option><option value="agent:k8s_operator">K8s Operator</option><option value="agent:surrealdb_store">SurrealDB Store</option><option value="agent:chat_control">Chat Control</option><option value="agent:observance">Observance</option><option value="agent:repair">Repair</option><option value="agent:release_gate">Release Gate</option><option value="agent:marketplace">Marketplace</option><option value="agent:fabric_architect">Fabric Architect</option></select><textarea id="message" rows="5">What should I build next?</textarea><button onclick="sendChat()">Send</button><pre id="chatOut">Ready.</pre><h3>Recent Messages</h3><pre id="messages">Loading...</pre></div><div id="proof" class="panel card" style="display:none"><h2>Proof</h2><button onclick="proof()">Run Proof</button><pre id="proofOut">Ready.</pre></div></section></div><script>
function show(id){document.querySelectorAll('.panel').forEach(p=>p.style.display='none');document.getElementById(id).style.display='block';document.querySelectorAll('.tabs button').forEach(b=>b.classList.remove('active'));event.target.classList.add('active')}
async function j(url,opts){const r=await fetch(url,opts);return await r.json()}
function pretty(x){return JSON.stringify(x,null,2)}
async function loadAgents(){const d=await j('/api/agents');document.getElementById('agents').innerHTML=(d.agents||[]).map(a=>'<div class="agent"><b>'+a.id+'</b><br>'+a.name+'<br><span class="muted">'+a.role+' · trust='+a.trust_score+'</span></div>').join('')}
async function loadStack(){const d=await j('/api/stack');document.getElementById('systemd').textContent=d.systemd;document.getElementById('k8s').textContent=d.k8s;document.getElementById('db').textContent=pretty(d.db)}
async function loadMessages(){const d=await j('/api/messages');document.getElementById('messages').textContent=pretty(d.messages||[])}
async function createWorkspace(){const d=await j('/api/onboard',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({name:wsName.value,builderType:builderType.value,goal:goal.value})});onboardOut.textContent=pretty(d);loadMessages()}
async function sendChat(){const d=await j('/api/chat',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({agent:agent.value,message:message.value})});chatOut.textContent=pretty(d);loadMessages()}
async function proof(){const d=await j('/api/proof',{method:'POST'});proofOut.textContent=pretty(d);loadMessages()}
async function repair(){const d=await j('/api/repair',{method:'POST'});repairOut.textContent=pretty(d);setTimeout(loadStack,1500)}
async function loadAll(){await loadAgents();await loadStack();await loadMessages()}loadAll();
</script></body></html>`);
});

app.get("/api/agents", async (_, res) => {
  try { const d = await surreal("SELECT * FROM agent ORDER BY name;"); res.json({ agents: d?.[0]?.result || [] }); } catch (e) { res.status(500).json({ error: String(e.message || e) }); }
});

app.get("/api/messages", async (_, res) => {
  try { const d = await surreal("SELECT * FROM chat_message ORDER BY created_at DESC LIMIT 10;"); res.json({ messages: d?.[0]?.result || [] }); } catch (e) { res.status(500).json({ error: String(e.message || e) }); }
});

app.get("/api/stack", async (_, res) => {
  const systemd = await run("systemctl", ["is-active", "unboxd-cloud-stack-panel"]);
  const bridge = await run("systemctl", ["is-active", "surreal-port-forward"]);
  const k8s = await run("sudo", ["k3s", "kubectl", "-n", "fabric", "get", "pods,svc"]);
  let db = { ok: false };
  try { const d = await surreal("INFO FOR DB;"); db = { ok: true, info: d }; } catch (e) { db = { ok: false, error: String(e.message || e) }; }
  res.json({ systemd: `panel=${systemd.stdout.trim() || systemd.stderr.trim()}\nsurreal-port-forward=${bridge.stdout.trim() || bridge.stderr.trim()}`, k8s: k8s.stdout || k8s.stderr, db });
});

app.post("/api/onboard", async (req, res) => {
  const name = esc(req.body.name || "Unboxd Workspace");
  const builderType = esc(req.body.builderType || "Individual Builder");
  const goal = esc(req.body.goal || "Build an Agent");
  try {
    const d = await surreal(`CREATE workspace SET name="${name}", builder_type="${builderType}", goal="${goal}", created_at=time::now(); CREATE chat_message SET agent=agent:cloud_commander, role="system", content="Workspace onboarded: ${name} / ${builderType} / ${goal}", response="UNBOXD_WORKSPACE_READY", created_at=time::now();`);
    res.json({ ok: true, verdict: "UNBOXD_WORKSPACE_READY", result: d });
  } catch (e) { res.status(500).json({ ok: false, error: String(e.message || e) }); }
});

app.post("/api/chat", async (req, res) => {
  const agent = String(req.body.agent || "agent:cloud_commander");
  const message = String(req.body.message || "");
  const response = agentReply(agent, message);
  try {
    const d = await surreal(`CREATE chat_message SET agent=${agent}, role="user", content="${esc(message)}", response="${esc(response)}", created_at=time::now(); RETURN {agent:${agent}, received:"${esc(message)}", response:"${esc(response)}", verdict:"RECORDED"};`);
    res.json({ ok: true, result: d });
  } catch (e) { res.status(500).json({ ok: false, error: String(e.message || e) }); }
});

app.post("/api/proof", async (_, res) => {
  try {
    const agents = await surreal("SELECT count() FROM agent GROUP ALL;");
    const messages = await surreal("SELECT count() FROM chat_message GROUP ALL;");
    const d = await surreal(`CREATE chat_message SET agent=agent:observance, role="system", content="Cloud stack proof executed", response="CLOUD_STACK_PANEL_ALIVE", created_at=time::now();`);
    res.json({ ok: true, verdict: "CLOUD_STACK_PANEL_ALIVE", agents, messages, evidence: d });
  } catch (e) { res.status(500).json({ ok: false, verdict: "CLOUD_STACK_PANEL_BROKEN", error: String(e.message || e) }); }
});

app.post("/api/repair", async (_, res) => {
  const restart = await run("sudo", ["systemctl", "restart", "unboxd-cloud-stack-panel"]);
  res.json({ ok: restart.ok, action: "restart unboxd-cloud-stack-panel", result: restart });
});

ensureSchema().then(() => {
  app.listen(Number(cfg.port), "0.0.0.0", () => console.log(`Unboxd Cloud Stack Panel listening on :${cfg.port}`));
}).catch(err => { console.error(err); process.exit(1); });
NODE

npm install

cat > .env <<ENV
PORT=$PORT
SURREAL_URL=$SURREAL_URL
SURREAL_USER=$SURREAL_USER
SURREAL_PASS=$SURREAL_PASS
SURREAL_NS=$SURREAL_NS
SURREAL_DB=$SURREAL_DB
PUBLIC_IP=$PUBLIC_IP
ENV

sudo tee /etc/systemd/system/unboxd-cloud-stack-panel.service >/dev/null <<SERVICE
[Unit]
Description=Unboxd Cloud Stack Panel
After=network.target surreal-port-forward.service
Wants=surreal-port-forward.service

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
sudo systemctl enable --now unboxd-cloud-stack-panel
sudo ufw allow "$PORT"/tcp || true

echo "DONE: http://$PUBLIC_IP:$PORT"
echo "Logs: sudo journalctl -u unboxd-cloud-stack-panel -f"
