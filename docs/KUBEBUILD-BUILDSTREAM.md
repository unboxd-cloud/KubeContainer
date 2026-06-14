# KubeBuild with Apache BuildStream Alignment

KubeBuild is the build and software integration kube for FabriKube.

Apache BuildStream is the reference pattern: a software integration tool for automating integration of software components, including operating systems, using declarative stack definitions, source fetching, dependency building, and artifact production.

```text
KubeBuild = build declaration + integration loop + artifact face + build record + reproducibility contract
```

## Placement

| Layer | Build role |
|---|---|
| KubePipeline | builds, checks, packages, signs, and releases artifacts |
| KubeApp lifecycle | turns source and stack declarations into runnable application artifacts |
| KubeDeviceOS | builds device OS images and edge/desk node images |
| KubeContainer | builds container images for workload kubes |
| KubeObjectStore | stores build artifacts, bundles, images, and provenance |
| KubeLedger | records build decisions, source digests, artifact digests, and release verdicts |
| KubeMath | records build graph models, constraints, and reproducibility proofs |
| Skill Cloud | builds tool packages, demos, and showcase artifacts |

## KubeBuild contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeBuild
metadata:
  name: fabric-build
spec:
  engine: buildstream
  declarations:
    format: declarative-stack
    includes:
      - sources
      - dependencies
      - build-steps
      - artifacts
      - cache-policy
  sources:
    versionControl:
      - git
      - github
      - gitlab
      - bitbucket
    nonGitSources: allowed-with-digest
  artifacts:
    types:
      - container-image
      - static-binary
      - package
      - bundle
      - device-os-image
      - model-artifact
      - skill-tool-package
    store: kubeobjectstore
  reproducibility:
    sourceDigestRequired: true
    dependencyDigestRequired: true
    artifactDigestRequired: true
    buildRecordRequired: true
  governance:
    identityFabric: required
    policyRequired: true
    vulnerabilityScanRequired: true
    provenanceRequired: true
  evidence:
    requiredVerdicts:
      - BUILD_DECLARED
      - SOURCES_FETCHED
      - DEPENDENCIES_BUILT
      - ARTIFACT_PRODUCED
      - PROVENANCE_ATTACHED
```

## Build record

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeBuildRecord
metadata:
  name: commerce-demo-build-2026-06-14
spec:
  build: fabric-build
  subject:
    kind: KubeApp
    name: commerce-demo
  sourceDigest: sha256:holder-defined
  dependencyDigest: sha256:holder-defined
  artifactDigest: sha256:holder-defined
  artifact:
    store: fabric-object-store
    bucket: artifacts
    key: apps/commerce-demo/controller-image.tar
  ledgerEntry: lifecycle/000042
  verdict: ARTIFACT_PRODUCED
```

## Reproducibility rule

A build is not just a command. It is a declared graph with source, dependency, environment, artifact, and evidence.

```text
source + dependencies + build graph + environment + artifact digest -> reproducible build record
```

## Relationship to KubePipeline

KubePipeline owns the delivery path. KubeBuild owns the artifact construction step.

```text
KubeBuild -> artifact
KubePipeline -> release path
KubeLedger -> record
KubeObjectStore -> artifact storage
```

## Rule

No artifact without source digest. No release without build record. No build graph hidden inside a script. No reproducibility claim without evidence.