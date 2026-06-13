# Deploying Publications as a kube

Publications (github.com/openautonomyx/Publications) is an Astro + React
app over SurrealDB — and it independently uses this house's pinned
picks: Fabric.js (canvas) and SurrealDB/SurrealQL. To run it on the
runtime as a kube:

1. **Build the image** (in the Publications repo, where the source lives):
   drop `Dockerfile` (this directory) at the repo root; its CI builds
   and pushes `ghcr.io/openautonomyx/publications:<tag>`. Set Astro's
   `output: 'static'` for the served face; the dynamic editor/studio
   talk to the SurrealDB sibling over the cluster.

2. **Pin** the image tag and the SurrealDB image in `kube.yaml`
   (pin-before-code: exact versions, never `latest`).

3. **Apply** on the faces box (cert-manager + ingress already present):
   `sudo k3s kubectl apply -f kube.yaml`

4. **DNS**: A record `publications.openautonomyx.com` -> the faces box IP.

The face comes up at `https://publications.openautonomyx.com`; the DB
keeps its data on the 5Gi claim. This is the backend contract in
practice: a headless DB sibling, the face surface-native, both kubes.
