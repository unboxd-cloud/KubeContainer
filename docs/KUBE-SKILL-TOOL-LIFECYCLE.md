# Kube Skill and Tool Lifecycle

The product promise:

```text
Learn, build, showcase, and monetize any skill or any tool, your way, the Kubernetes way.
```

FabriKube turns a skill or tool into a kube-backed lifecycle: declared, built, run, observed, improved, showcased, and monetized with evidence attached.

## Lifecycle

```text
Learn -> Build -> Package -> Run -> Showcase -> Monetize -> Improve -> Retire
```

| Phase | Meaning | Kube office |
|---|---|---|
| Learn | acquire the skill, guided by personalized paths | KubeLearning |
| Build | create the tool, app, workflow, content, or service | KubeApp / KubePipeline |
| Package | make it reproducible and portable | KubeContainer / KubeStack |
| Run | operate it with Kubernetes-native contracts | KubeApp |
| Showcase | present capability, proof, demos, and outcomes | KubeExperience / KubeBrowser |
| Monetize | sell access, outcomes, subscriptions, or support | KubeMarket |
| Improve | use evidence and feedback to adapt | KubeLearning / Observance |
| Retire | remove runtime while preserving record | KubeApp lifecycle |

## The Kubernetes way

The Kubernetes way means every skill or tool is declared, reconciled, observable, portable, and policy-governed.

```text
Declaration: YAML or API contract
Loop: controller/operator keeps it true
Face: service, browser, API, or showcase page
Record: status, events, evidence, provenance
Contract: named promises with verdicts
```

## Your way

`Your way` means the platform does not force one surface, one language, one business model, or one teaching model.

A creator may bring:

- any skill;
- any tool;
- any application;
- any workflow;
- any learning path;
- any showcase surface;
- any monetization model allowed by policy and contract.

The fabric adds lifecycle, identity, data, evidence, automation, cost awareness, and access control.

## KubeSkill contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeSkill
metadata:
  name: prompt-engineering
spec:
  learner:
    profile: beginner-to-practitioner
    personalization: enabled
  outcomes:
    - name: build-a-working-agent
      evidence: required
    - name: publish-a-showcase
      evidence: required
  practice:
    tools:
      - name: agent-workbench
        kind: KubeTool
  monetization:
    allowed: true
    models:
      - course
      - subscription
      - paid-template
      - consulting
  verdicts:
    required:
      - LEARNING_APPLIED
      - SKILL_DEMONSTRATED
```

## KubeTool contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeTool
metadata:
  name: agent-workbench
spec:
  build:
    pipeline: kube-pipeline
  runtime:
    app: agent-workbench-app
  showcase:
    browser: kube-browser
    evidenceRequired: true
  access:
    identityFabric: required
  costOptimization:
    required: true
  monetization:
    plans:
      - name: free
        limits: holder-defined
      - name: pro
        price: holder-defined
  verdicts:
    required:
      - TOOL_RUNS
      - SHOWCASE_READY
      - ACCESS_MANAGED
      - COST_BOUNDED
```

## KubeMarket contract

KubeMarket is the monetization office. It does not replace payment providers; it records what is sold, what is promised, what was delivered, and which evidence supports the claim.

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeMarket
metadata:
  name: creator-market
spec:
  products:
    - name: prompt-engineering-course
      kind: KubeSkill
      pricing: holder-defined
    - name: agent-workbench-pro
      kind: KubeTool
      pricing: holder-defined
  evidence:
    proofRequired: true
  access:
    entitlementSource: identity-fabric
  verdicts:
    required:
      - OFFER_LISTED
      - ENTITLEMENT_BOUND
      - DELIVERY_PROVEN
```

## Showcase rule

A showcase is not an advertisement alone. It must show the skill or tool, the outcome it promises, the way to try or buy it, and the evidence that it works.

```text
Showcase = face + proof + path + offer
```

## Monetization rule

A thing may be monetized only as a contract: what is sold, to whom, under what access, with what evidence, and what happens when the promise is not kept.

```text
Money follows the kept promise, not the claim.
```

## One-line product language

```text
Bring any skill or tool. Learn it, build it, showcase it, monetize it, and run it your way on a Kubernetes-native fabric.
```