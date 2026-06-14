# KubeLedger with Apache BookKeeper Alignment

KubeLedger is the durable append-only record kube for FabriKube.

Apache BookKeeper's Ledger API is the reference pattern: direct interaction with ledgers, creating ledgers, adding entries, reading entries, closing ledgers, deleting ledgers, and using ledgers as a replicated log.

```text
KubeLedger = ledger declaration + append loop + read face + immutable record + consistency contract
```

## Placement

| Layer | Ledger role |
|---|---|
| KubeApp lifecycle | records lifecycle decisions, releases, rollbacks, repairs, and retirements |
| Evidence | stores append-only proof records and verdict history |
| KubeArithmetic | records formula versions, inputs, measurements, and calculation results |
| KubeMath | records model versions, constraints, proofs, and action gates |
| KubeAIObservability | records model runs, prompt versions, evals, and releases |
| KubeAgentRuntime | records agent plans, tool calls, artifacts, and run history |
| Data Fabric | records data sync, lineage, retention, and governance events |
| Identity Fabric | records access decisions, principal actions, and reasons |
| Marketplace | records metering, entitlement, delivery, and settlement events |

## KubeLedger contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeLedger
metadata:
  name: fabric-ledger
spec:
  engine: bookkeeper
  ledgers:
    - name: lifecycle
      purpose: app-lifecycle-record
      retention: holder-defined
    - name: evidence
      purpose: verdict-history
      retention: append-only
    - name: arithmetic
      purpose: formulas-and-measures
      retention: append-only
    - name: identity
      purpose: access-decisions
      retention: policy-bound
    - name: ai-runs
      purpose: model-agent-run-history
      retention: policy-bound
  entries:
    digest: required
    sequence: monotonic
    timestamp: required
    owner: required
    verdict: required
  governance:
    identityFabric: required
    dataClassification: required
    retentionPolicyRequired: true
    deleteRequiresPolicy: true
  evidence:
    requiredVerdicts:
      - LEDGER_CREATED
      - ENTRY_APPENDED
      - ENTRY_READABLE
      - RECORD_IMMUTABLE
```

## Ledger entry

Every entry must be self-describing enough to prove what happened later.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeLedgerEntry
metadata:
  name: release-commerce-demo-000001
spec:
  ledger: lifecycle
  sequence: 1
  subject:
    kind: KubeApp
    name: commerce-demo
  action: release
  principal: user:owner@example.com
  reason: approved-release-window
  payloadDigest: sha256:holder-defined
  previousEntryDigest: sha256:holder-defined
  verdict: ROLLOUT_COMPLETE
```

## Append flow

```text
event occurs
  -> identity and policy are checked
  -> payload is digested
  -> ledger entry is appended
  -> read face exposes entry by ledger and sequence
  -> evidence binds entry to verdict
```

## BookKeeper fit

BookKeeper provides the core ledger operations that KubeLedger needs:

- create a ledger;
- add entries to the ledger;
- read entries from the ledger;
- close the ledger so no further writes are possible;
- delete ledgers under policy;
- use ledgers as replicated logs for consistent ordered records.

## Relationship to KubeStore

KubeStore owns state. KubeLedger owns ordered record.

```text
KubeStore = current and durable data state
KubeLedger = append-only history of actions and verdicts
```

## Rule

No lifecycle claim without a ledger entry. No arithmetic result without inputs recorded. No AI release without eval record. No deletion without retention policy and governance verdict.