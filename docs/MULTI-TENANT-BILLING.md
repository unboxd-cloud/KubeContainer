# Multi-Tenant Billing

Unboxd billing is tenant-first.

```text
Tenant -> Subscription -> Plan -> Usage -> Invoice -> Credit Ledger
```

## Goals

```text
multi-tenant
usage-based
credit-aware
evidence-backed
human-readable
marketplace-ready
```

## Core records

| Record | Meaning |
|---|---|
| tenant | customer/workspace/account boundary |
| billing_plan | price and included usage |
| subscription | tenant's active commercial agreement |
| usage_event | metered event with evidence |
| invoice | billable period summary |
| credit_ledger | credits, refunds, adjustments |

## Initial plans

```text
Free Builder   $0/month     100 included usage
Team           $49/month    5,000 included usage
Enterprise     $499/month   100,000 included usage
```

## Meters

```text
chat_messages
agent_commands
workspace_created
campaign_created
publish_jobs
proof_runs
kubecontainers_scored
evidence_records
```

## Billing rule

```text
billable_usage = max(0, usage_total - included_usage)
usage_charge = billable_usage * overage_price
invoice_total = monthly_price + usage_charge + tax - credits
```

## Tenant isolation

Every business object should carry a tenant boundary.

```text
tenant_id
workspace_id
created_by
created_at
evidence
```

## Canonical line

Billing is not just payment; billing is the commercial memory of tenant usage, value delivered, credits owed, and evidence kept.
