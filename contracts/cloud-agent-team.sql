DEFINE TABLE IF NOT EXISTS agent SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS name ON agent TYPE string;
DEFINE FIELD IF NOT EXISTS objective ON agent TYPE string;
DEFINE FIELD IF NOT EXISTS status ON agent TYPE string;
DEFINE FIELD IF NOT EXISTS trust_score ON agent TYPE number;
DEFINE FIELD IF NOT EXISTS role ON agent TYPE option<string>;
DEFINE FIELD IF NOT EXISTS governance_scope ON agent TYPE option<string>;
DEFINE FIELD IF NOT EXISTS created_at ON agent TYPE datetime DEFAULT time::now();
DEFINE FIELD IF NOT EXISTS updated_at ON agent TYPE datetime VALUE time::now();

UPSERT agent:cloud_commander SET
  name = "Cloud Commander",
  objective = "Coordinate the Cloud Agent Team and issue final operational verdicts",
  status = "active",
  role = "commander",
  governance_scope = "cloud",
  trust_score = 100;

UPSERT agent:k8s_operator SET
  name = "K8s Operator Agent",
  objective = "Operate Kubernetes pods, services, workloads, and local bridges",
  status = "active",
  role = "kubernetes_operator",
  governance_scope = "kubernetes",
  trust_score = 100;

UPSERT agent:surrealdb_store SET
  name = "SurrealDB Fabric Store Agent",
  objective = "Operate the Fabric namespace, database, schema, and records",
  status = "active",
  role = "fabric_store_operator",
  governance_scope = "surrealdb",
  trust_score = 100;

UPSERT agent:chat_control SET
  name = "Chat Control Agent",
  objective = "Operate the human-to-agent command panel and record commands as Fabric evidence",
  status = "active",
  role = "chat_control_operator",
  governance_scope = "control_panel",
  trust_score = 100;

UPSERT agent:observance SET
  name = "Observance Agent",
  objective = "Convert telemetry and records into governed verdicts",
  status = "active",
  role = "observance",
  governance_scope = "evidence",
  trust_score = 100;

UPSERT agent:repair SET
  name = "Repair Agent",
  objective = "Repair unhealthy services and reconcile broken promises",
  status = "active",
  role = "repair",
  governance_scope = "operations",
  trust_score = 100;

UPSERT agent:release_gate SET
  name = "Release Gate Agent",
  objective = "Block releases unless proof, SLA, and evidence gates are green",
  status = "active",
  role = "release_gate",
  governance_scope = "release",
  trust_score = 100;

UPSERT agent:marketplace SET
  name = "Marketplace Agent",
  objective = "Prepare AWS Marketplace package, listing evidence, and support readiness",
  status = "active",
  role = "marketplace",
  governance_scope = "commercial",
  trust_score = 100;
