# KubeMessageBus with Apache ActiveMQ Artemis Alignment

KubeMessageBus is the asynchronous messaging kube for FabriKube.

Apache ActiveMQ Artemis is the reference pattern: an asynchronous messaging system with addresses, queues, routing, broker management, and support for messaging patterns such as point-to-point work queues and publish/subscribe topics.

```text
KubeMessageBus = message declaration + routing loop + broker face + message record + delivery contract
```

## Placement

| Layer | Message bus role |
|---|---|
| KubeApp lifecycle | carries release, rollback, repair, retire, and status events |
| KubePipeline | carries build, admit, release, observe, and rollback commands |
| KubeDataSync | carries sync job commands, progress events, and completion verdicts |
| KubeAgentRuntime | carries agent work requests, tool events, artifact events, and schedule triggers |
| KubeObservability | receives event notifications and queue/broker health signals |
| KubeLedger | records delivered commands, decisions, and final verdicts |
| KubeMarket | carries entitlement, usage, delivery, settlement, and invoice events |
| KubeDeviceOS | carries edge/desk sync requests and device lifecycle events |
| KubeExperience | carries user journey events and support/workflow notifications |

## KubeMessageBus contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeMessageBus
metadata:
  name: fabric-message-bus
spec:
  engine: artemis
  addresses:
    - name: lifecycle
      purpose: app-lifecycle-events
      routing:
        - anycast
        - multicast
    - name: data-sync
      purpose: governed-data-movement
      routing:
        - anycast
    - name: ai-agent
      purpose: agent-work-and-tool-events
      routing:
        - anycast
        - multicast
    - name: marketplace
      purpose: entitlement-usage-settlement
      routing:
        - anycast
    - name: observability
      purpose: telemetry-events-and-alerts
      routing:
        - multicast
  delivery:
    durable: true
    acknowledgements: required
    retryPolicy: required
    deadLetterQueue: required
  governance:
    identityFabric: required
    messageSchemaRequired: true
    purposeRequired: true
    retentionPolicyRequired: true
    ledgerRecordRequired: true
  evidence:
    requiredVerdicts:
      - MESSAGE_BUS_READY
      - MESSAGE_ACCEPTED
      - MESSAGE_DELIVERED
      - DELIVERY_RECORDED
```

## Message record

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeMessageRecord
metadata:
  name: data-sync-request-000001
spec:
  bus: fabric-message-bus
  address: data-sync
  queue: data-sync-commands
  messageId: holder-defined
  producer: kubeapp/commerce-demo
  consumer: kubedatasync/commerce-data-sync
  purpose: runtime-cache-refresh
  payloadDigest: sha256:holder-defined
  ledgerEntry: lifecycle/000088
  verdict: MESSAGE_DELIVERED
```

## Routing model

```text
command -> anycast queue -> one worker handles it
announcement -> multicast topic/address -> many observers receive it
failure -> retry policy -> dead letter queue -> repair path
```

## Why a message bus

The cloud stack needs asynchronous coordination without coupling every component to every other component.

```text
KubeApp does not call every office directly.
It emits lifecycle intent.
The bus routes commands and events.
Each office acts within its own contract.
The ledger records the outcome.
```

## Observability

The message bus itself must be observable:

- message count;
- age of oldest message;
- delivery latency;
- dead-letter count;
- consumer count;
- retry count;
- address and queue health.

## Rule

No hidden side channel. No message without schema. No command without identity and purpose. No delivery claim without acknowledgement and ledger record.