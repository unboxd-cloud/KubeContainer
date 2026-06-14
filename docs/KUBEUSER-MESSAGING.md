# KubeUser Messaging

KubeUserMessaging is the user-to-user communication kube for FabriKube.

```text
KubeUserMessaging = conversation declaration + delivery loop + conversation face + message record + consent contract
```

It covers direct messages, collaboration, creator/customer support, marketplace communication, skill mentorship, tool handoff, agent-assisted replies, and peer-to-peer exchange.

## Placement

| Layer | User-to-user role |
|---|---|
| Identity Fabric | binds users, teams, agents, customers, creators, and relations |
| KubeMessageBus | routes messages, notifications, commands, and events |
| KubeAnswer | turns support conversations into governed knowledge when allowed |
| KubeMarket | binds buyer/seller messages to offers, entitlements, delivery, and dispute records |
| Skill Cloud | supports mentors, learners, creators, reviewers, and collaborators |
| KubeExperience | provides inbox, chat, comments, review, support, and collaboration surfaces |
| KubeLedger | records message digests, consent, delivery, moderation, and dispute verdicts |
| KubeAgentRuntime | allows agent-assisted drafting, summarization, and task handoff under consent |

## Conversation types

| Type | Meaning | First verdict |
|---|---|---|
| Direct | one user to one user | MESSAGE_DELIVERED |
| Team | multiple users inside a governed group | CONVERSATION_BOUND |
| Support | customer to creator/operator/support owner | SUPPORT_RECORDED |
| Marketplace | buyer, seller, entitlement, delivery, and settlement context | ENTITLEMENT_BOUND |
| Learning | learner, mentor, evaluator, or cohort | LEARNING_SUPPORT_RECORDED |
| Agent-assisted | user delegates drafting, summary, or follow-up to an agent | AGENT_ASSIST_ALLOWED |

## KubeUserMessaging contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeUserMessaging
metadata:
  name: fabric-user-messaging
spec:
  conversations:
    supported:
      - direct
      - team
      - support
      - marketplace
      - learning
      - agent-assisted
  identity:
    fabric: required
    principalRequired: true
    relationRequired: true
  consent:
    required: true
    blockList: supported
    mute: supported
    reporting: supported
  delivery:
    messageBus: fabric-message-bus
    durable: true
    acknowledgements: required
    readReceipts: optional
  privacy:
    dataClassification: required
    retentionPolicyRequired: true
    exportRequired: true
    deleteOrArchivePolicyRequired: true
  safety:
    moderationPolicyRequired: true
    agentAssistanceRequiresConsent: true
    noRawCredentialSharing: true
  evidence:
    requiredVerdicts:
      - CONVERSATION_BOUND
      - MESSAGE_ACCEPTED
      - MESSAGE_DELIVERED
      - CONSENT_RECORDED
```

## Message record

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeUserMessage
metadata:
  name: creator-support-message-000001
spec:
  conversation: support/commerce-template-support
  from: user:customer@example.com
  to: user:creator@example.com
  purpose: support
  entitlement: marketplace/commerce-template-pro
  payloadDigest: sha256:holder-defined
  classification: private
  delivery:
    bus: fabric-message-bus
    address: user-messaging
    queue: support-messages
  ledgerEntry: user-messages/000001
  verdict: MESSAGE_DELIVERED
```

## Agent-assisted communication

Agents may help, but they do not become invisible participants.

```text
user asks agent to draft
  -> consent and scope are checked
  -> agent drafts or summarizes
  -> user approves or rejects
  -> final message records human/agent contribution
```

## Marketplace rule

Marketplace messages carry entitlement context.

```text
buyer + seller + offer + entitlement + message -> governed conversation
```

A paid support conversation must show what was bought, what support is included, who owns the response, and what record proves delivery.

## Knowledge promotion

A support conversation may become KubeAnswer knowledge only when policy allows.

```text
private conversation -> redaction -> owner approval -> answer record -> searchable knowledge
```

## Rule

No user-to-user message without identity. No marketplace support without entitlement context. No agent-assisted message without disclosure and consent. No private conversation promoted to knowledge without approval.