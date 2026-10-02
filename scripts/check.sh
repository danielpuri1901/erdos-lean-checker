#!/usr/bin/env bash
# Runs Comparator on the agent checkout at $AGENT_DIR using $CONFIG.
set -euo pipefail
CONFIG="${1:?config path}"
AGENT_DIR="${AGENT_DIR:?agent checkout dir}"
COMPARATOR_BIN="${COMPARATOR_BIN:?}"
COMPARATOR_LEAN4EXPORT="${COMPARATOR_LEAN4EXPORT:?}"
COMPARATOR_LANDRUN="${COMPARATOR_LANDRUN:?}"
for b in "$COMPARATOR_BIN" "$COMPARATOR_LEAN4EXPORT" "$COMPARATOR_LANDRUN"; do
  [[ -x "$b" ]] || { echo "not executable: $b" >&2; exit 2; }
done
SHIM_DIR="$(mktemp -d)"
ln -sfn "$(readlink -f "$COMPARATOR_LANDRUN")" "$SHIM_DIR/landrun"
ln -sfn "$(readlink -f "$COMPARATOR_LEAN4EXPORT")" "$SHIM_DIR/lean4export"
CONFIG_ABS="$(readlink -f "$CONFIG")"
cd "$AGENT_DIR"
PATH="$SHIM_DIR:$PATH" exec lake env "$(readlink -f "$COMPARATOR_BIN")" "$CONFIG_ABS"
