# KubeAtlas Data Governance

KubeAtlas is the metadata, classification, lineage, and stewardship kube for FabriKube.

Apache Atlas is the reference implementation pattern: open metadata management and governance for cataloging data assets, classifying and governing them, and enabling collaboration around those assets.

```text
KubeAtlas = metadata catalog + classification loop + lineage face + governance record + stewardship contract
```

## Placement

| Fabric | Role |
|---|---|
| Data Fabric | catalogs data assets, classifications, owners, lineage, and retention |
| Identity Fabric | binds owners, stewards, processors, agents, and access relations |
| KubeDataSync | checks classification and lineage before data moves |
| KubeSearch | indexes metadata, lineage, and governed search records |
| KubeApp lifecycle | proves app data access, movement, retention, and retirement |
| Data on desk | keeps owner-bound data local while cloud metadata remains governed |

## KubeAtlas contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeAtlas
metadata:
  name: fabric-atlas
spec:
  catalog:
    assets:
      - kubeapps
      - kubestores
      - datasets
      - indexes
      - models
      - images
      - skills
      - workflows
  classification:
    required: true
    labels:
      - public
      - internal
      - private
      - sensitive
      - regulated
  lineage:
    required: true
    recordTransformations: true
    recordSyncs: true
    recordExports: true
  stewardship:
    ownerRequired: true
    stewardRequired: true
    retentionOwnerRequired: true
  governance:
    blockUnclassifiedMovement: true
    blockUnknownOwner: true
    requirePurposeForSync: true
  evidence:
    requiredVerdicts:
      - ASSET_CATALOGED
      - CLASSIFICATION_APPLIED
      - LINEAGE_RECORDED
      - DATA_GUARDED
```

## Data movement gate

KubeDataSync must ask KubeAtlas before moving data.

```text
asset + classification + owner + purpose + target + retention -> DATA_SYNC_ALLOWED or DATA_SYNC_DENIED
```

Example:

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeDataSync
metadata:
  name: desk-to-app-cache
spec:
  source:
    asset: customer-profile
    location: owner-desk
  target:
    location: app-cloud-cache
    retention: 24h
  governance:
    atlas: fabric-atlas
    requireClassification: true
    requireLineage: true
    requirePurpose: runtime-cache
  verdicts:
    required:
      - CLASSIFICATION_APPLIED
      - LINEAGE_RECORDED
      - DATA_SYNC_ALLOWED
```

## Data-on-desk rule

KubeAtlas does not force owner data into cloud. It lets cloud systems know the metadata, classification, lineage, and allowed movement of desk-held data.

```text
Data may stay on desk.
Metadata may be cataloged in cloud.
Movement requires declared purpose, identity, policy, and lineage.
```

## Search integration

KubeSearch may index Atlas metadata and lineage, but search results must still pass Identity Fabric.

```text
query + principal + relation + classification -> filtered governed result set
```

## Rule

No unknown data. No unclassified movement. No ownerless asset. No lineage gap hidden as success.