# erdos-lean-checker

The trusted verifier for `erdos-lean-formalization`.

This repository is never attached to a Claude Code session.
The agent cannot read or edit it.
It holds the frozen target statements, the Comparator configuration, and a GitHub Actions workflow.

The workflow checks out a named commit of the agent repository, builds the target, runs an axiom audit, and runs [Comparator](https://github.com/leanprover/comparator) under landrun against the frozen statement.
A green run here on commit X is the only definition of success for the project.

## Status

The workflow is adapted from [nick-kuhn/erdos-619](https://github.com/nick-kuhn/erdos-619).
No agent run starts until it is green on the trivial target.

## Pins

- Comparator: tag `v4.33.0`, commit `3927ad383f208ae977c340a91c48ac9b497d2097` (a lightweight tag, so the tag object is the commit).
  Its `lean-toolchain` says `v4.33.0`; the workflow overwrites it with `frozen/lean-toolchain` (`v4.33.1`) before the build, so lean4export reads oleans of the same Lean version as the agent project.
- lean4export: commit `15f6055e299ad5b89345e533cc2192f4cc00f659`, from the Comparator manifest.
- landrun: commit `5ed4a3db3a4a`.
- formal-conjectures: `df3f12d7bd06feb3f71ae37abae0ca7cb798d9b1`, through `frozen/lake-manifest.json`.

## Trust model

Comparator assumes that the lakefile and every prebuilt olean are trusted, and that the solution was never compiled outside its sandbox.
So the workflow:

- overwrites `Challenge.lean`, `lakefile.toml`, `lake-manifest.json`, and `lean-toolchain` in the agent checkout with the copies in `challenge/` and `frozen/`, and deletes `lakefile.lean` and `.lake`;
- builds only `Challenge` outside the sandbox, and lets Comparator build `Solution` under landrun;
- checks out the agent repository without persisting the token, because the token can write commit statuses;
- stops Docker before Comparator runs, because landrun does not filter Unix sockets;
- runs the `#print axioms` audit only after the commit status is written, because it imports the solution outside the sandbox.

When the agent project needs a new library or dependency, Daniel updates `frozen/` by hand.

## Layout

- `.github/workflows/verify.yml`: the check.
- `challenge/<target>.lean`: frozen statements, pinned to a formal-conjectures commit.
- `comparator/<target>.json`: Comparator configuration per target.
- `frozen/`: the build configuration the agent project is checked with.
- `scripts/check.sh`: runs Comparator on the agent checkout.
- `scripts/axioms/<target>.lean`: axiom audit per target.
- `tests/bad/<case>.lean`: negative fixtures.

## Negative tests

Run https://github.com/danielpuri1901/erdos-lean-checker/actions/runs/37029994928 (2026-10-02): `verify` green, and Comparator rejected every bad solution for its own reason.

| fixture | Comparator's reason |
|---------|---------------------|
| `sorry` | `Illegal axiom detected: 'sorryAx'` |
| `axiom` | `Illegal axiom detected: 'cheat'` |
| `native_decide` | `Illegal axiom detected: 'helper._native.native_decide.ax_1_1'` |
| `wrong_statement` | `Challenge and solution theorem statement do not match: 'challenge_trivial'` |
| `redefine` | `Const does not match between challenge and target 'Green72.AllowedSetSize'` |

The `redefine` fixture shadows the definitions without importing formal-conjectures, so it compiles and only Comparator's definition check can catch it.
