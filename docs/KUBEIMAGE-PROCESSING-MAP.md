# KubeImage Creative Processing Map

KubeImage is the creative image processing kube for FabriKube Image Cloud.

```text
KubeImage = image declaration + processing loop + image face + provenance record + rights contract
```

It covers generation, editing, transformation, enhancement, storage, search, delivery, showcase, and monetization of image work.

## Map

```text
Prompt / source image / asset brief
  -> identity and rights check
  -> safety policy
  -> creative processing plan
  -> generation or edit job
  -> object storage
  -> provenance ledger entry
  -> search index
  -> showcase surface
  -> entitlement or monetization
  -> delivery record
```

## Offices

| Office | Duty | First verdict |
|---|---|---|
| KubeImage | declares the creative image job | IMAGE_DECLARED |
| KubeImageProcessor | runs generation, edits, transforms, and enhancement | IMAGE_PROCESSED |
| KubeObjectStore | stores source, output, versions, thumbnails, and evidence bundles | OBJECT_WRITTEN |
| KubeLedger | records prompt, source digest, output digest, policy, and delivery | PROVENANCE_ATTACHED |
| KubeSearch | indexes images, tags, prompts, rights metadata, and evidence | IMAGE_INDEXED |
| KubeAtlas | classifies image assets and records lineage | CLASSIFICATION_APPLIED |
| KubeAIObservability | traces model calls, prompt versions, evals, latency, and cost | AI_RUN_RECORDED |
| KubeExperience | shows the gallery, editor, review, and showcase surfaces | EXPERIENCE_DELIVERED |
| KubeMarket | sells images, templates, packs, rights, subscriptions, or services | DELIVERY_PROVEN |

## KubeImage contract

```yaml
apiVersion: fabric.unboxd.cloud/v1alpha1
kind: KubeImage
metadata:
  name: brand-hero-image
spec:
  intent:
    type: generate-and-edit
    prompt: holder-defined
    sourceImages:
      - bucket: images
        key: sources/brand-reference.png
  processing:
    operations:
      - generate
      - upscale
      - background-remove
      - color-grade
      - export-variants
    modelRouting: required
  safety:
    identityRequired: true
    rightsMetadataRequired: true
    contentPolicyRequired: true
    provenanceRequired: true
  storage:
    objectStore: fabric-object-store
    bucket: images
    versioning: enabled
  search:
    index: images
    tagsRequired: true
  evidence:
    requiredVerdicts:
      - IMAGE_DECLARED
      - IMAGE_GUARDED
      - IMAGE_PROCESSED
      - PROVENANCE_ATTACHED
      - IMAGE_INDEXED
```

## Processing modes

| Mode | Meaning |
|---|---|
| Generate | create a new image from prompt, references, or structured brief |
| Edit | modify an existing image by instruction |
| Transform | change size, format, style, background, composition, or color treatment |
| Enhance | upscale, denoise, sharpen, relight, restore, or improve technical quality |
| Extract | produce masks, cutouts, metadata, captions, tags, or embeddings |
| Package | export social variants, thumbnails, product shots, or marketplace bundles |

## Search map

Creative search must combine metadata, provenance, visual features, and access policy.

```text
query + principal + rights + tags + embeddings + lineage -> allowed image results
```

Search indexes:

| Index | Contains |
|---|---|
| `images` | image records, tags, prompt summaries, owners, rights, object digests |
| `image-provenance` | source image, model, prompt version, transformations, ledger entries |
| `image-embeddings` | visual search vectors and similarity metadata |
| `image-market` | offers, licenses, templates, packs, subscriptions, delivery proofs |

## Safety rule

No image work is anonymous. No generated image ships without provenance. No source image is reused without rights metadata. No search result bypasses identity and entitlement.

## Rule

Creative freedom lives inside accountable processing: identity, rights, safety, provenance, storage, search, and delivery all travel with the image.