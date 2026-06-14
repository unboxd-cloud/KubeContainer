# Kube Landscape

The kube landscape names the first product family above `KubeContainer`.

```text
FabriKube = the family of kubes that build, run, browse, store, deliver, and prove applications.
KubeApp = the composed application contract.
KubeStore = the managed state and evidence contract.
KubeBrowser = the human surface for browsing kubes, records, and verdicts.
KubePipeline = the delivery path that builds, admits, releases, and rolls back kubes.
KubeStack = the graph inside one KubeApp: workloads, stores, dependencies, and faces.
MetaKube = the local proving fabric, complete with Minikube.
```

## Placement

| Name | Office | First proof |
|---|---|---|
| KubeContainer | workload kube | One image becomes a Deployment, Service, optional Ingress, and status verdict |
| KubeApp | application kube | A declared stack composes workloads and services into one app contract |
| KubeStore | state kube | A declared store owns data, retention, backup, restore, and evidence policy |
| KubeBrowser | surface kube | A declared browser reads the registry, records, and verdicts without owning runtime |
| KubePipeline | delivery kube | A declared path builds, checks, releases, observes, and rolls back |
| KubeStack | composition graph | The components and dependencies inside one KubeApp |
| FabriKube | product family | The named fabric that contains the kube family |
| MetaKube | proving fabric | Minikube plus operator plus sample plus Prometheus witness plus verdict |

## Canonical names

`KUBEPIPKLIEN` is recorded as `KubePipeline`: the delivery path kube.

`FABRIKUBE` is recorded as `FabriKube`: the family name.

`KUBERSTORE` is recorded as `KubeStore`: the state and evidence store kube.

`KUBE LANGSAPE` is recorded as `Kube Landscape`: the map of the family.

## KubeApp contract

`KubeApp` is the first higher-level contract above `KubeContainer`. It does not replace `KubeContainer`; it owns a stack of them and binds them to stores, browsers, pipelines, policies, and evidence.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeApp
metadata:
  name: commerce-demo
spec:
  stack:
    components:
      - name: web
        kind: KubeContainer
        image: nginx:1.27
        port: 80
        dependsOn: []
      - name: api
        kind: KubeContainer
        image: ghcr.io/acme/api:1.0.0
        port: 8080
        dependsOn: [store]
      - name: store
        kind: KubeStore
        engine: postgres
        storage:
          size: 20Gi
  face:
    browser: kube-browser
    host: commerce.local
  pipeline:
    release: kube-pipeline
    rollback: automatic-on-breach
  evidence:
    witness: prometheus
    requiredVerdict: PROMISE_KEPT
```

## KubeStore contract

`KubeStore` is the state-bearing kube. It is not a volume template. It is a promise about data ownership, durability, retention, backup, restore, and the evidence that those promises held.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeStore
metadata:
  name: commerce-store
spec:
  engine: postgres
  version: "16"
  storage:
    size: 20Gi
    className: standard
  backup:
    schedule: "0 */6 * * *"
    retention: 7d
  restore:
    tested: true
  evidence:
    metrics: true
    lastBackupVerdict: REQUIRED
```

## KubeBrowser contract

`KubeBrowser` is the surface for people. It browses declarations, records, evidence, and verdicts. It does not become the control plane and it does not own runtime truth.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeBrowser
metadata:
  name: kube-browser
spec:
  sources:
    - registry
    - kubernetes-api
    - prometheus
  views:
    - apps
    - stores
    - pipelines
    - evidence
    - verdicts
```

## KubePipeline contract

`KubePipeline` is the path a kube follows from source to release. It is where build, admission, policy, rollout, observation, and rollback become one declared path.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubePipeline
metadata:
  name: kube-pipeline
spec:
  stages:
    - name: build
      verdict: IMAGE_BUILT
    - name: admit
      verdict: POLICY_PASSED
    - name: release
      verdict: ROLLOUT_COMPLETE
    - name: observe
      verdict: PROMISE_KEPT
    - name: rollback
      on: BREACH
```

## MetaKube proof

MetaKube is how the landscape proves its first unit locally.

```sh
make metakube-up
make metakube-sample
make metakube-prometheus
make metakube-observe
make metakube-verify
```

The first local verdict remains deliberately small:

```text
cluster_ready=true
operator_ready=true
sample_kubecontainer_ready=true
prometheus_scraping=true
verdict=PROMISE_KEPT
```

## Rule

Every new kube in the landscape must clear the kube conformance rule before it wears the name: declaration, loop, face, record, and contract, each with a verdict.