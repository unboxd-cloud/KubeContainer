# KubeDeviceOS with LineageOS Alignment

KubeDeviceOS is the device operating system kube for FabriKube edge and desk nodes.

LineageOS is the reference pattern: a free and open-source operating system for many devices, based on the Android mobile platform.

```text
KubeDeviceOS = device OS declaration + update loop + device face + device record + lifecycle contract
```

## Placement

| Layer | Role |
|---|---|
| KubeNode | gives desk, edge, mobile, and appliance nodes an OS-level contract |
| Data on desk | keeps owner-bound data local on controlled devices where required |
| Identity Fabric | binds device, owner, user, agent, and allowed actions |
| KubeDataSync | syncs only policy-approved data between device and cloud |
| KubeAgentRuntime | runs local or edge agents with scoped tools and data |
| KubeExperience | provides mobile, desk, and edge user surfaces |
| KubeGovernance | records update, patch, access, and data movement decisions |

## Node types

| Device node | Meaning | First verdict |
|---|---|---|
| Desk device | user-owned local device that can hold private data | DESK_BOUND |
| Mobile device | phone or tablet as a personal app/data/agent node | DEVICE_BOUND |
| Edge device | location-bound node for offline or near-device workloads | EDGE_READY |
| Appliance device | dedicated device for kiosk, dashboard, media, or operations | APPLIANCE_READY |

## KubeDeviceOS contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeDeviceOS
metadata:
  name: owner-phone-os
spec:
  family: android-based
  reference: lineageos
  device:
    owner: user:owner@example.com
    type: mobile
    role: desk-node
  lifecycle:
    install: declared
    update: ota-or-image
    patch: required
    retire: wipe-or-release-with-record
  data:
    defaultLocation: owner-desk
    movementRequiresPolicy: true
    exportRequired: true
  access:
    identityFabric: required
    deviceAttestation: required
    seatTunnel: optional
  workloads:
    allowed:
      - local-agent
      - private-cache
      - data-sync
      - experience-surface
    denied:
      - ungoverned-cloud-copy
      - unmanaged-credential-storage
  evidence:
    requiredVerdicts:
      - DEVICE_BOUND
      - OWNER_CONTROL_HELD
      - PATCH_STATE_RECORDED
      - DATA_GUARDED
```

## Everything in cloud, data on desk

KubeDeviceOS is how the desk side of the sovereignty rule becomes concrete.

```text
Cloud runs orchestration, apps, AI, analytics, and marketplace loops.
Device OS holds owner-bound local data and local execution where required.
Data sync moves only what governance permits.
```

## Device lifecycle

```text
Declare device -> Admit owner -> Install OS -> Bind identity -> Sync policy -> Run local workloads -> Patch -> Retire with record
```

## Rule

No unmanaged device may hold governed data. No device workload runs without owner, identity, patch state, access policy, and evidence.