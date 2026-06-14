# Fine-Grained Control for Every KubeApp

Every app gets fine-grained control across lifecycle, identity, access, data, cost, automation, experience, and monetization.

```text
Fine-grained control = every action has a principal, scope, policy, reason, evidence, and verdict.
```

## Control surfaces

| Control | Question answered | First verdict |
|---|---|---|
| Identity | Who or what is acting? | IDENTITY_BOUND |
| Access | May this party do this action here? | ACCESS_DECIDED |
| Lifecycle | Which phase may change now? | LIFECYCLE_ALLOWED |
| Automation | Which loops may act without being re-asked? | AUTOMATION_ALLOWED |
| Data | Which data may be read, written, moved, indexed, or retained? | DATA_ACCESS_DECIDED |
| Cost | What budget, limit, or optimization applies? | COST_BOUNDED |
| Policy | Which rules must pass before action? | POLICY_PASSED |
| Experience | Which surface, journey, or audience is affected? | EXPERIENCE_GUARDED |
| Monetization | Who is entitled to use or buy this capability? | ENTITLEMENT_BOUND |
| Evidence | What proves the action was allowed and worked? | EVIDENCE_ATTACHED |

## KubeApp control contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeApp
metadata:
  name: commerce-demo
spec:
  controls:
    identity:
      required: true
      provider: identity-fabric
    access:
      mode: relationship-and-policy
      decisions:
        - action: release
          allowedRelations: [owner]
        - action: repair
          allowedRelations: [owner, editor]
        - action: observe
          allowedRelations: [owner, editor, viewer]
    lifecycle:
      phaseGates:
        release:
          requires: [POLICY_PASSED, COST_BOUNDED, ACCESS_DECIDED]
        rollback:
          requires: [BREACH_RECORDED, ACCESS_DECIDED]
        retire:
          requires: [OWNER_APPROVED, RECORD_PRESERVED]
    automation:
      allowedActions:
        - sync
        - observe
        - recommend
        - repair-with-runbook
      forbiddenActions:
        - delete-without-owner-verdict
        - spend-above-budget
    data:
      classificationRequired: true
      lineageRequired: true
      searchAccessFiltered: true
    cost:
      budgetRequired: true
      rightSizingRequired: true
      idleDetectionRequired: true
    experience:
      journeyImpactRequired: true
    evidence:
      attachToEveryDecision: true
```

## Decision record

Every fine-grained action produces a decision record.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeDecision
metadata:
  name: release-commerce-demo-2026-06-14
spec:
  principal: user:owner@example.com
  app: commerce-demo
  action: release
  scope: production
  reason: approved-release-window
  checks:
    - ACCESS_DECIDED
    - POLICY_PASSED
    - COST_BOUNDED
    - EVIDENCE_ATTACHED
  verdict: LIFECYCLE_ALLOWED
```

## Control rule

No app action is invisible.

```text
No principal, no action.
No scope, no action.
No policy, no action.
No reason, no action.
No verdict, no claim.
```