# KubeSearch with Apache Solr and OpenSearch

KubeSearch is the search and indexing kube for FabriKube.

```text
KubeSearch = declared search index + indexing loop + query face + record + search contract
```

Apache Solr and OpenSearch are both valid open search engines for KubeSearch. Solr is the Apache-native option, built on Lucene with full-text, vector, and geospatial search capabilities. OpenSearch remains a Kubernetes-friendly option for indexing application records, evidence, runtime metadata, and experience events.

## Placement

| Layer | Role |
|---|---|
| Data Fabric | indexes records, evidence, lineage, and app metadata |
| Experience Management | powers search across apps, journeys, verdicts, and surfaces |
| Identity Fabric | filters query results by principal, relation, and access verdict |
| KubeApp lifecycle | searches releases, rollbacks, repairs, cost recommendations, and evidence |
| Skill Cloud | searches skills, tools, showcases, learning records, and monetized offers |
| KubeAnswer | searches questions, answers, tags, reputation, and community knowledge |

## Engine policy

| Engine | Use when |
|---|---|
| Apache Solr | Apache-native stack, Lucene-centered search, full-text/vector/geospatial search, SolrCloud, or Solr Operator alignment |
| OpenSearch | OpenSearch-centered observability/search estates, Elasticsearch-compatible workflows, or existing OpenSearch operations |

## KubeSearch contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeSearch
metadata:
  name: fabric-search
spec:
  engine: solr
  version: "10"
  alternateEngines:
    - opensearch
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
    - name: answers
      source: kubeanswer
      retention: 365d
  access:
    filterByRelation: true
    provider: identity-fabric
  operations:
    backup: required
    restoreTest: required
    rollover: required
    replication: required
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
| `answers` | Q&A, tags, accepted answers, comments, reputation, support records | KubeAnswer |

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

In MetaKube, search is optional because the first Minikube proof stays small. The local stack may enable KubeSearch after the core proof passes:

```sh
make metakube-verify
make metakube-search
```

`metakube-search` is a future target until the Solr/OpenSearch manifest is added. The contract is recorded here first so the implementation has a stable promise to satisfy.