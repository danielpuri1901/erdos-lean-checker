#!/usr/bin/env bash
# Judges one submit commit the way verify.yml does, as the unprivileged user `referee`.
# Prints one line: VERDICT <target> <agent commit> <success|failure> <description>.
# The verdict is Comparator's exit code plus its last line, as in verify.yml.
set -uo pipefail
TARGET=${1:?target}
SHA=${2:?agent commit}
export PATH="$HOME/.elan/bin:$PATH"
R=/opt/referee
C=$R/checker
W=$R/runs/$TARGET-${SHA:0:7}
fail() { echo "VERDICT $TARGET $SHA failure $1"; exit 1; }
rm -rf "$W" && mkdir -p "$W" && cd "$W" || fail "cannot create the run directory"
git clone -q "$R/agent.git" agent && git -C agent checkout -q "$SHA" || fail "the commit is not in the bundle"
# Freeze the challenge and the build configuration; the agent's copies are replaced or removed.
cp "$C/challenge/$TARGET.lean" agent/Challenge.lean || fail "unknown target"
cp "$C/scripts/axioms/$TARGET.lean" agent/AxiomCheck.lean
cp "$C/frozen/lakefile.toml" "$C/frozen/lake-manifest.json" "$C/frozen/lean-toolchain" agent/
rm -rf agent/lakefile.lean agent/.lake agent/.claude agent/scripts/hooks
cp -a "$R/base/.lake" agent/.lake
cd agent || fail "no agent checkout"
lake build Challenge > "$W/challenge.log" 2>&1 || fail "the frozen challenge does not build"
f="$C/tests/statement/$TARGET.lean"
if [ -f "$f" ]; then
  lake env lean "$f" > "$W/statement.log" 2>&1 || fail "the statement check failed"
fi
# Only trusted code has run so far, so the packages built for the challenge are kept for later runs.
rsync -a .lake/packages/ "$R/base/.lake/packages/"
cd "$W"
AGENT_DIR="$W/agent" \
COMPARATOR_BIN="$R/tools/comparator/.lake/build/bin/comparator" \
COMPARATOR_LEAN4EXPORT="$R/tools/comparator/.lake/packages/lean4export/.lake/build/bin/lean4export" \
COMPARATOR_LANDRUN="$R/bin/landrun" \
bash "$C/scripts/check.sh" "$C/comparator/$TARGET.json" > "$W/comparator.log" 2>&1
code=$?
if [ "$code" -eq 0 ] && [ "$(tail -n 1 "$W/comparator.log")" = "Your solution is okay!" ]; then
  (cd agent && lake env lean AxiomCheck.lean > "$W/axioms.log" 2>&1) || true
  echo "VERDICT $TARGET $SHA success Your solution is okay!"
else
  last=$(grep -v '^[[:space:]]*$' "$W/comparator.log" 2>/dev/null | tail -n 1 | cut -c1-140)
  echo "VERDICT $TARGET $SHA failure ${last:-no Comparator verdict}"
fi
