#!/usr/bin/env bash
set -euo pipefail

./hack/metakube/verify.sh
python3 ./hack/metakube/score.py
