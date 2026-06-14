# KubeObjectStore with RustFS Alignment

KubeObjectStore is the object storage kube for FabriKube.

RustFS is the reference pattern: high-performance, S3-compatible, distributed object storage for AI/ML, analytics, cloud, private cloud, and edge workloads, with versioning, replication, encryption, and WORM/object-lock style compliance.

```text
KubeObjectStore = bucket declaration + storage loop + object face + object record + durability contract
```

## Placement

| Layer | Object storage role |
|---|---|
| KubeStore | stores unstructured objects, artifacts, backups, exports, images, and model files |
| KubeLedger | stores ordered entry metadata and digests, while objects hold larger payloads |
| Image Cloud | stores source images, generated images, transformations, thumbnails, and provenance bundles |
| AI Cloud | stores models, checkpoints, datasets, embeddings, eval artifacts, and agent artifacts |
| Skill Cloud | stores course assets, tool packages, showcase media, and delivery artifacts |
| Data Fabric | stores data lake objects, snapshots, archives, and governed exports |
| KubeAnalytics | reads governed data lake objects for query and compute |
| KubeDeviceOS | supports desk/edge object caches and owner-controlled local storage |

## KubeObjectStore contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeObjectStore
metadata:
  name: fabric-object-store
spec:
  engine: rustfs
  protocol: s3-compatible
  buckets:
    - name: artifacts
      purpose: app-agent-skill-artifacts
      versioning: enabled
    - name: images
      purpose: image-cloud-assets
      versioning: enabled
    - name: models
      purpose: ai-model-checkpoints
      versioning: enabled
    - name: evidence
      purpose: evidence-bundles
      objectLock: enabled
    - name: archive
      purpose: cold-retention
      objectLock: enabled
  durability:
    replication: active
    erasureCoding: optional
    crossCloud: optional
  security:
    encryption: required
    identityFabric: required
    accessPolicyRequired: true
  governance:
    atlasClassification: required
    lineageRequired: true
    retentionRequired: true
    deleteRequiresPolicy: true
  evidence:
    requiredVerdicts:
      - OBJECT_STORE_READY
      - OBJECT_WRITTEN
      - OBJECT_VERSIONED
      - RETENTION_ENFORCED
```

## Object record

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeObjectRecord
metadata:
  name: agent-report-artifact-2026-06-14
spec:
  store: fabric-object-store
  bucket: artifacts
  key: agents/anton/weekly-report-2026-06-14.pdf
  version: holder-defined
  digest: sha256:holder-defined
  owner: user:owner@example.com
  classification: private
  lineage:
    ledgerEntry: ai-runs/000001
    app: commerce-demo
  retention: 90d
  verdict: OBJECT_WRITTEN
```

## Ledger and object store split

KubeLedger and KubeObjectStore work together.

```text
KubeLedger = ordered proof, event sequence, digest, verdict
KubeObjectStore = large payload, artifact, versioned object, retained blob
```

A ledger entry should point to object digests rather than embedding large payloads.

## Data-on-desk rule

Object storage can live in cloud, private cloud, edge, or desk nodes. Owner-bound data stays on desk unless governance permits movement.

```text
object location + classification + owner + policy -> object access verdict
```

## Rule

No object without owner. No artifact without digest. No evidence object without retention. No delete without governance verdict.