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
