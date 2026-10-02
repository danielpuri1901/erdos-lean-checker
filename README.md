# erdos-lean-checker

The trusted verifier for `erdos-lean-formalization`.

This repository is never attached to a Claude Code session.
The agent cannot read or edit it.
It holds the frozen target statements, the Comparator configuration, and a GitHub Actions workflow.

The workflow checks out a named commit of the agent repository, builds the target, runs an axiom audit, and runs [Comparator](https://github.com/leanprover/comparator) under landrun against the frozen statement.
A green run here on commit X is the only definition of success for the project.

## Status

Skeleton.
The workflow is adapted from [nick-kuhn/erdos-619](https://github.com/nick-kuhn/erdos-619) and is not yet green.
Build step 3 of the design document makes Lean v4.33.1, Comparator, and lean4export agree, then proves the workflow green on a trivial statement.
Until then, no agent run starts.

## Layout

- `.github/workflows/verify.yml`: the check.
- `challenge/`: frozen statement files, pinned to a formal-conjectures commit. To be added.
- `comparator/`: Comparator configuration per target. To be added.
- `scripts/`: axiom audit and the check script. To be added.
