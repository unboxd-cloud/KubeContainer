# KubeSearch with OpenSearch

KubeSearch is the search and indexing kube for FabriKube.

```text
KubeSearch = declared search index + indexing loop + query face + record + search contract
```

OpenSearch is the first engine because it is open, Kubernetes-friendly, and suitable for indexing application records, evidence, runtime metadata, and experience events.

## Placement

| Layer | Role |
|---|---|
| Data Fabric | indexes records, evidence, lineage, and app metadata |
| Experience Management | powers search across apps, journeys, verdicts, and surfaces |
| Identity Fabric | filters query results by principal, relation, and access verdict |
| KubeApp lifecycle | searches releases, rollbacks, repairs, cost recommendations, and evidence |

## KubeSearch contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeSearch
metadata:
  name: fabric-search
spec:
  engine: opensearch
  version: "2"
  indexes:
    - name: kubeapps
      source: registry
      retention: 365d
    - name: evidence
      source: prometheus-and-events
      retention: 365d
    - name: experience
      source: kubeexperience
      retention: 180d
    - name: audit
      source: identity-fabric
      retention: 730d
  access:
    filterByRelation: true
    provider: identity-fabric
  operations:
    backup: required
    restoreTest: required
    rollover: required
  evidence:
    requiredVerdicts:
      - SEARCH_READY
      - INDEXING_CURRENT
      - ACCESS_FILTERED
```

## First indexes

| Index | Contains | Owner |
|---|---|---|
| `kubeapps` | KubeApp names, versions, components, lifecycle phase, faces | KubeApp |
| `evidence` | verdicts, events, status snapshots, Prometheus-derived records | MetaKube / Observance |
| `experience` | journeys, surfaces, latency, availability, user-impact records | KubeExperience |
| `audit` | identity, access checks, principal/action/reason records | KubeIdentity |

## Access rule

Search is never raw access to every record. Query results must be filtered through Identity Fabric before they are returned.

```text
principal + query + relation -> allowed result set + reason + verdict
```

## Lifecycle rule

KubeSearch participates in application lifecycle management:

```text
Declare index -> Admit policy -> Provision engine -> Index records -> Query face -> Backup -> Restore test -> Retire with record
```

## Local proof path

In MetaKube, OpenSearch is optional because the first Minikube proof stays small. The local stack may enable KubeSearch after the core proof passes:

```sh
make metakube-verify
make metakube-search
```

`metakube-search` is a future target until the OpenSearch manifest is added. The contract is recorded here first so the implementation has a stable promise to satisfy.