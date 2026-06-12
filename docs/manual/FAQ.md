# FAQ — Per Component

Part of the instruction manual. The founder's law of ownership: the
FAQ is cloud responsibility — the platform seat owns the questions,
because the question rule makes every question a defect report and
the cloud is where defects converge, get answered, and amend the
record. Sourcing honesty: this environment cannot browse forums; the
questions below are the canonical patterns asked of every project of
each component's kind (operators, CRDs, registries, licenses),
folded with the questions already asked of this record — each answer
anchored to its source. A question asked twice is a row missing
here; file it and the row appears.

## KubeContainer (the operator)

- **Which Kubernetes versions are supported?** The tested minor:
  1.35 (envtest and e2e both run it). Conformant clusters at that
  minor are the warranty's condition; others may work and are not
  promised (no one promises the unconditioned).
- **Why doesn't my KubeContainer reconcile?** Read the conditions:
  `kubectl describe kubecontainer <name>` — Ready/Progressing/
  Degraded carry the reason (reasons are always given). Degraded
  with ReconcileFailed names the exact child that refused.
- **If I delete the CR, does my workload die?** Yes — by design:
  owner references collect the children cleanly (exit is a stage,
  not an accident). The record of it remains.
- **Why does the operator refuse to set replicas when autoscale is
  on?** One writer per field: the HPA owns the count. Declaring
  both is inadmissible at the gate (CEL), not broken at runtime.
- **Do I need webhooks or cert-manager to install?** No. Invariants
  are CEL on the schema; install is one `kubectl apply` of one
  bundle. Cert-manager appears only if you bring your own TLS story.
- **Is there a Helm chart?** No, deliberately: plain `kubectl
  apply` must always work (vendor neutrality is policy); charts are
  adapters others may build.
- **Air-gapped?** Yes: mirror the one image and the bundle; nothing
  phones home; evidence is in your cluster and your clone.
- **How do I upgrade?** Apply the next era's bundle. Manifests
  valid in a released era remain valid forever (the compat corpus
  is CI-enforced) — a breaking change here is a bug, not a policy.

## The kube (the CRD and its declaration)

- **Why "inadmissible" instead of error messages at runtime?** The
  skeleton is declared before it is filled: a declaration missing a
  field is refused at the gate, where fixing is cheap.
- **Can one KubeContainer run two containers?** No — nothing rides
  alongside (no sidecars; tested). Two workloads are two kubes.
- **Ingress or ClusterIP?** Declare `expose.type`; Ingress requires
  a host (CEL enforces it — the face must be addressable).

## The tools (CodeCompiler, StructuredInstructions, SourceGround)

- **What does CodeCompiler check?** Compile, vet, vocabulary — one
  verdict: does it compile, and does it conform.
- **Why did StructuredInstructions reject my agent declaration?**
  It names every missing field and unacknowledged contract term —
  the output is the fix list. All ten terms and three signatures
  are required; the skeleton is the law (registry/SKELETON.json).
- **Why did the vocabulary gate fail my doc?** You bolded a term
  before defining it. Define it as a `- **Term** —` entry (then
  `make vocab`) or unbold rhetoric — bold is coinage here.

## The registry

- **Can I re-register the same agent name?** No — one entry per
  fact, duplicates refused. New version, new declaration, recorded
  amendment.
- **Who signs the platform line before the platform service
  exists?** Today: the fabric's own record (the repository) is the
  ground being vouched; the signature names what vouches. The seat
  fills as the platform service ships.

## Deployment (the ladder)

- **Can I try it on my laptop?** Yes — minikube fits the venv seat
  exactly (conformant, desk-grade). The same declaration then walks
  k3s on a VPS and OpenStack under an estate unchanged.
- **Why OpenStack and not a hyperscaler?** Both are lawful grounds —
  the decision record (deploy/STACK.md) carries the reasons; the
  exit stays real in either direction.
- **Where do I find every spec and seam?** deploy/REFERENCES.md —
  each component and contract with its living source URL.

## The license

- **Can I use it commercially?** Commercial rights are reserved to
  unboxd agency (the license's own NOTICE). Research, education,
  evaluation, security review, contribution: granted. The LICENSE
  text governs; docs/manual/LICENSES.md summarizes.
- **Is it open source?** Source-available, honestly labeled — not
  OSI open source, and the record never claims otherwise (honest
  words).

## Already asked of this record (and where they landed)

What is critical path → docs/PERSONAL.md. Why Cinder and not Ceph
or LXD → deploy/STACK.md. Does minikube fit → deploy/STACK.md.
Where should Keystone go → deploy/STACK.md (outside of core). What
are the exact contract terms → docs/PERSONAL.md. Each was a
question; each became a row in the record the same hour — the loop
this FAQ exists to run.
