#!/usr/bin/env bash
# One-time setup of the referee machine (Ubuntu 24.04, run as root): tools, an unprivileged user,
# Comparator and landrun at the pins of verify.yml, and the Mathlib cache for the frozen build configuration.
# Expects /opt/referee/checker to be a clone of this repository.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update -q
apt-get install -yq git curl zstd rsync golang-go
id referee >/dev/null 2>&1 || useradd -m -s /bin/bash referee
chown -R referee:referee /opt/referee
sudo -u referee -H bash -euo pipefail <<'INNER'
cd /opt/referee
curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y --default-toolchain none
export PATH="$HOME/.elan/bin:$PATH"
[ -d tools/comparator ] || git clone -q https://github.com/leanprover/comparator tools/comparator
git -C tools/comparator checkout -q 3927ad383f208ae977c340a91c48ac9b497d2097
cp checker/frozen/lean-toolchain tools/comparator/lean-toolchain
(cd tools/comparator && lake build lean4export comparator)
GOBIN=/opt/referee/bin go install github.com/zouuup/landrun/cmd/landrun@5ed4a3db3a4a
/opt/referee/bin/landrun --best-effort --ro / --rw /dev -ldd -add-exec /usr/bin/echo hello
# Trusted base: the frozen build configuration with the Mathlib cache. Every run starts from a copy of it.
mkdir -p base
cp checker/frozen/lakefile.toml checker/frozen/lake-manifest.json checker/frozen/lean-toolchain base/
(cd base && lake exe cache get)
INNER
echo "SETUP DONE"
