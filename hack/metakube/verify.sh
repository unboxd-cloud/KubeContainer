#!/usr/bin/env bash
set -euo pipefail

./hack/metakube/up.sh
./hack/metakube/apply-sample.sh
./hack/metakube/observe.sh
