# The Org Name — the Domain Is the Org

The founder's ruling: keep it simple — unboxd.cloud; the domain is
the org. GitHub renders it unboxd-cloud (dots are not legal there);
the domain stays the only name. The walk, in order, each step
declared (the rename itself is the founder's hand — org settings):

1. Rename the GitHub org: unboxd-agency → unboxd-cloud.
2. Park the vacated name at once: re-create unboxd-agency as an
   empty placeholder org — redirects live only while the old name
   is unsquatted; parking makes them effectively permanent.
3. The Go module path heals itself: go.mod already reads
   github.com/unboxd-cloud/kubecontainer — after this rename it is
   exactly right again, and the deferred module-migration debt is
   closed by the rename instead of caused by it.
4. Images: the next release publishes to ghcr.io/unboxd-cloud/...
   and its install bundle points there; prior releases stay valid
   through the parked redirect.
5. Docs: one pass replacing github.com/unboxd-agency/ with
   github.com/unboxd-cloud/ (after the rename, not before).
6. The site: bind the custom domain — the Pages URL stops
   mattering the day unboxd.cloud serves it, which is the ruling's
   whole point.

What never moves: the API group (kubecontainer.unboxd.cloud), the
DID (did:web:unboxd.cloud), the canon in every clone. The domain
was always the name; this walk just makes every pointer agree.

## Kube as its own org — the individual's home, enacted

The founder enacts the individual-identity law: KubeContainer moves
to a separate org — its own home, with unboxd.cloud as parent-by-
relation, never by cage. The same law names the new org: the domain
is the org, and KubeContainer's domain is kubecontainer.xyz — so the
GitHub rendering is `kubecontainer` (simple, the individual's own
name; the -xyz suffix only if the bare name is taken). The walk:

1. Create the org (the founder's hand) and transfer the repository
   into it — GitHub carries issues, PRs, releases, and redirects
   with a transfer.
2. Park the vacated path as always: the old org keeps a placeholder
   fork-redirect; no name left unsquatted.
3. The module path follows the individual, once, deliberately:
   go.mod becomes github.com/<neworg>/kubecontainer in a single
   recorded migration (imports rewritten in the same commit, the
   gauntlet proving it) — the last rename this module ever needs,
   because the individual's home does not change when parents do.
4. Images re-publish under the new org's namespace at the next
   release; prior releases stay valid through redirects.
5. The site binds kubecontainer.xyz — the individual's own door.
6. Honest session note: this working session's writ is scoped to
   the current repo path; after a transfer, redirects normally
   carry it, and if the proxy refuses the new home, the session
   ends at its boundary and the work continues from any clone —
   exit real, for agents too.

Parent unboxd.cloud remains exactly what the law says parents are:
a relation in the record — the agency answering commercially for
the product — while the product's name, home, and record are its
own. One family, every member named in their own right.
