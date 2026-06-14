# KubeAnswer Knowledge

KubeAnswer is the Q&A, help-center, and community knowledge kube for FabriKube.

Apache Answer is the reference implementation pattern: an open Q&A platform for teams, communities, help centers, and knowledge management, with questions, answers, comments, votes, tags, integrations, and reputation.

```text
KubeAnswer = declared knowledge community + moderation loop + answer face + knowledge record + trust contract
```

## Placement

| Layer | Role |
|---|---|
| Skill Cloud | captures learning questions, answers, practice paths, and proof |
| Experience Management | powers support journeys and help-center surfaces |
| KubeSearch | indexes questions, answers, tags, accepted answers, and support records |
| Identity Fabric | binds author, reviewer, moderator, owner, learner, and customer relations |
| KubeMarket | connects paid skills/tools to support, entitlement, and proof |

## KubeAnswer contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeAnswer
metadata:
  name: fabric-answer
spec:
  community:
    scope: skill-and-tool-support
    audiences:
      - learners
      - builders
      - customers
      - operators
  knowledge:
    questions: enabled
    answers: enabled
    comments: enabled
    voting: enabled
    acceptedAnswer: required
    tags: required
  moderation:
    identityFabric: required
    ownerReview: required-for-official-answer
    reputation: enabled
  search:
    engine: kubesearch
    indexes:
      - answers
      - skills
      - tools
      - evidence
  evidence:
    requiredVerdicts:
      - QUESTION_RECORDED
      - ANSWER_ACCEPTED
      - KNOWLEDGE_INDEXED
      - TRUST_RECORDED
```

## Support lifecycle

```text
Question -> Triage -> Answer -> Accept -> Index -> Learn -> Improve product
```

## Official answer rule

An official answer is not just a comment. It must have an owner, source, scope, and verdict.

```text
official answer = answer + owner + evidence + scope + review verdict
```

## Monetized skill/tool support

KubeAnswer may support monetized skills and tools, but entitlement is checked before private support content is shown.

```text
principal + entitlement + question scope -> allowed knowledge view
```

## Rule

No anonymous official answer. No unsupported claim. No private answer without entitlement. No accepted answer without a record.