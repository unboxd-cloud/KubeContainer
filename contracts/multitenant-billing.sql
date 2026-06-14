DEFINE TABLE IF NOT EXISTS tenant SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS name ON tenant TYPE string;
DEFINE FIELD IF NOT EXISTS slug ON tenant TYPE string;
DEFINE FIELD IF NOT EXISTS status ON tenant TYPE string;
DEFINE FIELD IF NOT EXISTS created_at ON tenant TYPE datetime;
DEFINE INDEX IF NOT EXISTS tenant_slug_idx ON tenant FIELDS slug UNIQUE;

DEFINE TABLE IF NOT EXISTS billing_plan SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS name ON billing_plan TYPE string;
DEFINE FIELD IF NOT EXISTS code ON billing_plan TYPE string;
DEFINE FIELD IF NOT EXISTS currency ON billing_plan TYPE string;
DEFINE FIELD IF NOT EXISTS monthly_price ON billing_plan TYPE number;
DEFINE FIELD IF NOT EXISTS included_usage ON billing_plan TYPE number;
DEFINE FIELD IF NOT EXISTS overage_price ON billing_plan TYPE number;
DEFINE FIELD IF NOT EXISTS status ON billing_plan TYPE string;
DEFINE INDEX IF NOT EXISTS billing_plan_code_idx ON billing_plan FIELDS code UNIQUE;

DEFINE TABLE IF NOT EXISTS subscription SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS tenant ON subscription TYPE record<tenant>;
DEFINE FIELD IF NOT EXISTS plan ON subscription TYPE record<billing_plan>;
DEFINE FIELD IF NOT EXISTS status ON subscription TYPE string;
DEFINE FIELD IF NOT EXISTS started_at ON subscription TYPE datetime;
DEFINE FIELD IF NOT EXISTS current_period_start ON subscription TYPE datetime;
DEFINE FIELD IF NOT EXISTS current_period_end ON subscription TYPE datetime;

DEFINE TABLE IF NOT EXISTS usage_event SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS tenant ON usage_event TYPE record<tenant>;
DEFINE FIELD IF NOT EXISTS meter ON usage_event TYPE string;
DEFINE FIELD IF NOT EXISTS quantity ON usage_event TYPE number;
DEFINE FIELD IF NOT EXISTS subject ON usage_event TYPE option<string>;
DEFINE FIELD IF NOT EXISTS evidence ON usage_event TYPE option<string>;
DEFINE FIELD IF NOT EXISTS created_at ON usage_event TYPE datetime;
DEFINE INDEX IF NOT EXISTS usage_tenant_meter_idx ON usage_event FIELDS tenant, meter;

DEFINE TABLE IF NOT EXISTS invoice SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS tenant ON invoice TYPE record<tenant>;
DEFINE FIELD IF NOT EXISTS status ON invoice TYPE string;
DEFINE FIELD IF NOT EXISTS currency ON invoice TYPE string;
DEFINE FIELD IF NOT EXISTS subtotal ON invoice TYPE number;
DEFINE FIELD IF NOT EXISTS tax ON invoice TYPE number;
DEFINE FIELD IF NOT EXISTS total ON invoice TYPE number;
DEFINE FIELD IF NOT EXISTS period_start ON invoice TYPE datetime;
DEFINE FIELD IF NOT EXISTS period_end ON invoice TYPE datetime;
DEFINE FIELD IF NOT EXISTS created_at ON invoice TYPE datetime;

DEFINE TABLE IF NOT EXISTS credit_ledger SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS tenant ON credit_ledger TYPE record<tenant>;
DEFINE FIELD IF NOT EXISTS amount ON credit_ledger TYPE number;
DEFINE FIELD IF NOT EXISTS reason ON credit_ledger TYPE string;
DEFINE FIELD IF NOT EXISTS evidence ON credit_ledger TYPE option<string>;
DEFINE FIELD IF NOT EXISTS created_at ON credit_ledger TYPE datetime;

UPSERT billing_plan:free SET
  name = "Free Builder",
  code = "free",
  currency = "USD",
  monthly_price = 0,
  included_usage = 100,
  overage_price = 0,
  status = "active";

UPSERT billing_plan:team SET
  name = "Team",
  code = "team",
  currency = "USD",
  monthly_price = 49,
  included_usage = 5000,
  overage_price = 0.01,
  status = "active";

UPSERT billing_plan:enterprise SET
  name = "Enterprise",
  code = "enterprise",
  currency = "USD",
  monthly_price = 499,
  included_usage = 100000,
  overage_price = 0.005,
  status = "active";
