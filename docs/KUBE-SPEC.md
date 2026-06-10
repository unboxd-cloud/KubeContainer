# The Kube — Product Specification

Status: v1, normative. Terms used here are defined in
[AGENT-PLATFORM.md](AGENT-PLATFORM.md) and governed by
[FOUNDING-PRINCIPLES.md](FOUNDING-PRINCIPLES.md). The reference
implementation is this repository's `KubeContainer` (v0.1.0, released).

## 1. Definition

A kube is the platform's unit of product: a declared outcome, kept by an
autonomous loop, presenting one contractual face to the world, with its
provenance attached. It is whole and indivisible — there is no fraction
of a kube — and it is what a customer buys, what the registry records,
what the surface is tiled from, and what the fabric packs.

One sentence for the buyer: *you declare what you want; the kube makes
it true, keeps it true, proves it was true, and answers for it.*

## 2. Anatomy

Every kube consists of exactly five parts; remove any one and it is not
a kube.

| Part | What it is | KubeContainer v0.1.0 instance |
|---|---|---|
| Declaration | The spec: intent in schema, validated before admission | The `KubeContainer` CR (CEL-validated) |
| Loop | The autonomous keeper: observe, compare, act, record | The reconciler (level-triggered, idempotent) |
| Face | The one stable surface point it answers at | `status.endpoint` (Service/Ingress) |
| Record | Its state, history, and evidence, externalized | spec/status in etcd; events; conditions |
| Contract | The promises, with their verdicts named in advance | Ready/Progressing/Degraded; the gauntlet |

## 3. Lifecycle

Declare → Admit → Converge → Serve → Evidence → Exit.

1. *Declare:* the principal states the outcome (file, CR, request).
   Vague intent is returned for definition, not guessed at.
2. *Admit:* schema validation, policy, authorization — the gates. A
   kube that cannot be admitted does not partially exist.
3. *Converge:* the loop closes the distance to the declaration, one
   adjacent step at a time, without jumps.
4. *Serve:* the face answers — stable, minimal, guarded. The kube is
   now load-bearing at its point of the surface.
5. *Evidence:* continuously — status reflects truth, events record
   actions, verdicts accumulate in the record. Done is only ever
   claimed by citing a verdict.
6. *Exit:* graceful by design — work landed or released, state
   committed, the face handed over or retired, the name and record
   surviving the instance.

## 4. Guarantees (each with its verdict)

| Guarantee | Verdict that proves it |
|---|---|
| Declared state converges | Ready condition; e2e gate (real traffic) |
| Drift is reverted | Reconcile on child mutation (tested) |
| Valid once, valid forever | Golden compat corpus (append-only, CI-enforced) |
| Nothing rides alongside | One workload container; no sidecars (tested) |
| One writer per field | HPA non-interference (tested) |
| Provenance attached | Evidence report shipped with every release |
| Clean removal | Owner-reference garbage collection (tested) |

A guarantee without a listed verdict is a roadmap item, not a guarantee.

## 5. Interfaces

- Declarative: `kubectl apply` of the CR — the only required interface;
  works on any conformant Kubernetes cluster.
- Observational: `kubectl get` (printer columns), status conditions,
  events, Prometheus metrics.
- No proprietary wire, no required CLI, no console dependency: the API
  is the product surface; consoles and tools are adapters.

## 6. Non-goals (what a kube is not)

- Not a template engine, not a package manager, not a PaaS console.
- Not a fraction: there are no partial deployments of a kube, no
  degraded tiers sold as whole ones.
- Not a cage: deleting the declaration removes the kube cleanly; the
  record of it remains (exit ends the acting, never the accountability).

## 7. Conformance (what may call itself a kube)

A thing is a kube if and only if:

1. its outcome is declared in a published schema and validated at
   admission;
2. an autonomous loop keeps it, and the loop survives restart with
   nothing lost (state external, ACID);
3. it presents one identified, stable face, owned by exactly one
   contract;
4. every guarantee it claims names the verdict that proves it, and the
   verdicts run in CI or in cluster — not in slideware;
5. its history is recorded, append-only, and attached to what it
   delivers.

KubeContainer v0.1.0 conforms (verdicts in §4). Future kinds — Release,
SolidStateDatabase, agent workloads — must clear the same five clauses
before wearing the name.

## 8. The product line

The kube is the unit; products are counts and kinds of kubes:

- One kube: the pilot (the MVP — the whole thesis at quantity one).
- Many kubes, one tenant: the estate (governance, drift audits, eval
  registry over their workloads).
- Many kinds: the platform (new CRDs clearing §7).
- Many tenants, many fabrics: the economy (federation, certification,
  the partner network).

Scaling is packing, not rebuilding: the difference between MVP and
platform is count, not kind.
