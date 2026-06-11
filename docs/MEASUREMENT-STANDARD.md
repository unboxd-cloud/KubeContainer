# The Measurement Standard

A kube is a box with meaning and a measurement — a bounded thing whose
value is *defined* (what it is) and *measured* (how much). This document
is the constitutional rule for how meaning and measurement are
expressed, so that value on the fabric is never a private invention
dressed as a number.

## The standards rule

Meaning and measurement are presented in terms of real-world,
international, globally accepted standards — always, by default, and
named. A kube's quantities ride recognized units and schemas, never
bespoke ones:

- *Money* — ISO 4217 currency codes; amounts as decimal minor units,
  never floats.
- *Time* — ISO 8601 / RFC 3339 timestamps; UTC at the record, with
  zone where it carries meaning (the temporal dimension).
- *Place* — ISO 3166 regions; Open Location Code for points (the
  geospatial dimension).
- *Identity* — W3C DID / Verifiable Credentials (did:web).
- *Goods & trade* — GS1 (GTIN/GLN), HS commodity codes, UN/CEFACT
  where applicable.
- *Units* — SI / ISO 80000 for physical quantity.
- *Language & domain* — published schemas (ISO, W3C, the relevant SDO)
  for each bounded context; meaning cites its ontology.

The rule generalizes: where a globally accepted standard exists for a
quantity, the kube uses it and names it — measurement without a named
standard is an opinion with a number on it.

## The gap clause (where no standard exists)

In the absence of any globally accepted standard for a given meaning or
measurement, the definition and delivery of it is left to the contract
holder. The contract holder then:

1. *Defines it explicitly* — the unit, the method, the boundaries —
   published in the registry entry, not assumed.
2. *Delivers against that definition* — the world-test measures what
   was defined; the verdict is against the holder's own published
   meter.
3. *Owns the consequence* — a holder-defined measure is the holder's
   to stand behind, and is marked as holder-defined, never passed off
   as a global standard it is not.

Holder-defined is honest; holder-defined-disguised-as-standard is the
cardinal measurement sin (a claim wearing a verdict's clothes).

## The supply-chain integrity rule

A kube's bill of materials (BOM) and supply-chain record (SCM) must
contain no prior transaction before the end-user touch point. The
measurement and its provenance begin clean at delivery to the
principal: what is measured and sold is *this* kube's value, established
at *this* touch, not inherited, laundered, or back-dated from upstream
dealings. Provenance runs forward from a clean origin; it is not a
ledger of everyone who handled the goods before they became the
customer's. (This protects the customer — they buy a clean, attributable
unit — and the standard — no upstream noise contaminates the measure.)

## The two paths to a standard you can keep

When no global standard exists and a holder-defined measure is not
enough — when the value must be *interoperable*, comparable across
parties — there are exactly two honest paths, and no third:

1. *Own the entire supply chain end to end* — control every step so
   the standard is yours, your way, internally consistent because one
   party defines and delivers all of it. (Vertical integration as the
   price of a private standard.)
2. *Reach out / form an international body* — convene the parties and
   align on a common, interoperable way of defining and measuring the
   quantity, so the standard is shared and no single party owns it.
   (The SDO path — slower, but the only route to a measure others will
   accept as theirs too.)

The dishonest third path — declaring a private measure "the standard"
without owning the chain or convening the body — is forbidden: it is the
openwashing of measurement, a claim of universality with neither the
control nor the consent that would make it true.

## Worked example: the chocolate box

A box of chocolates is the kube in miniature, and its value composes
transparently from measured parts — exactly how a kube's price is built:

```
chocolate box value
  = Σ (value of each chocolate)     # the contents, the work itself
  + service charges                 # the boxing, the keeping, the handling
  + taxes                           # the jurisdiction's claim, by its rate
```

Each line rides a standard: the chocolates' value in ISO-4217 currency,
minor units; the service charge an itemized, named line (not a hidden
markup — priced by the piece); the tax computed at the rate of the ISO
3166 jurisdiction of the touch point, by that jurisdiction's published
code. The bill is itemized to the same grain as the evidence — the buyer
sees what the contents cost, what the service cost, what the state took —
and nothing in the total is a number without a named basis. Generalize
the three lines and you have every kube's price: *contents + service +
obligations*, each measured to standard, each on the manifest, summing
to a total anyone can re-derive. (And per the supply-chain rule: the
chocolates' value begins at the customer's touch point — the wholesale
dealings that put them in the box are not the customer's BOM.)

## Why this is constitutional

Measurement is where value becomes checkable, and value is what the
fabric sells. A measure on a recognized standard is a verdict anyone can
re-run; a measure on a private unit is a claim only the seller can
confirm — which collapses provenance, assurance, and the registry's
whole worth. The kube carries meaning and measurement; this standard
keeps both honest, so that "priced by the piece" means priced in units
the world already agreed on, or units the holder openly owns, and never
units pretending to be either.
