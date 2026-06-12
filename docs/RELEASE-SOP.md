# Release SOP — set once, followed always

Every release walks this, in this order, no step skipped. The pipeline
enforces it (.github/workflows/release.yml); this is the human-readable
contract it implements.

1. Declare: write release/REQUEST (tag=, target=<sha>), commit, push.
2. Gauntlet, in order: test -> test-report -> lint -> vocab-check ->
   eval -> security-report. Any red stops the release.
3. Promise: ./hack/check-promise.sh — every clause of release/PROMISE
   green, or the release is blocked. (eval-report.json must exist by
   here — that is why eval runs before the check.)
4. Build: the installer, the homesetup binary.
5. Sign: SHA256SUMS over every artifact (install.yaml, eval-report,
   test-report, security-report, homesetup) — delivered as a signed
   artifact set, never loose files.
6. Publish: gh release create "$TAG" with all artifacts + SHA256SUMS.
7. Verify: confirm the release exists and assets carry digests before
   claiming "delivered". No "in the pipeline" without checking the run.

The rule: the process, once set, is followed always — not re-derived,
not skipped under pressure, not narrated as done before verified.
