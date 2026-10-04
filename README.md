# erdos-lean-checker

The trusted verifier for `erdos-lean-formalization`.

This repository is never attached to a Claude Code session.
The agent cannot edit it.
It was private until 2026-10-04 and is public since then, so the agent can now read it.
The verdict does not depend on secrecy: it is Comparator's exit code on the frozen statement.
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
- runs the `#print axioms` audit only after the commit status is written, because it imports the solution outside the sandbox;
- takes the verdict from Comparator's exit code and its exact last line, never from a search of the log, because the log also holds the solution's own build output (see `tests/bad/print_ok.lean`).

On failure, the commit status description is Comparator's last line, cut to 140 characters.

When the agent project needs a new library or dependency, Daniel updates `frozen/` by hand.

## Layout

- `.github/workflows/verify.yml`: the check.
- `challenge/<target>.lean`: frozen statements, pinned to a formal-conjectures commit.
- `comparator/<target>.json`: Comparator configuration per target.
- `frozen/`: the build configuration the agent project is checked with.
- `scripts/check.sh`: runs Comparator on the agent checkout.
- `scripts/pending_submits.py`: finds `submit(` commits without a verdict.
- `.github/workflows/check-submits.yml`: the 15-minute poller.
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
| `print_ok` | `Challenge and solution theorem statement do not match: 'challenge_trivial'` |

The `redefine` fixture shadows the definitions without importing formal-conjectures, so it compiles and only Comparator's definition check can catch it.

`print_ok` prints `Your solution is okay!` during its own build and proves the wrong statement.
Before 2026-10-03 the workflow searched the whole log for that line, so this solution got a green status (run https://github.com/danielpuri1901/erdos-lean-checker/actions/runs/37120516617).
After the fix the same commit is rejected (run https://github.com/danielpuri1901/erdos-lean-checker/actions/runs/37121166249), and the negative job pins it.

## Automatic checks

`check-submits.yml` is a polling loop: one job checks the agent repository every 2 minutes.
GitHub's own schedule fired only twice in 7.5 hours on 2026-10-03, so the loop keeps itself alive: it stops after 2 hours without a push, and near the 6-hour job limit it starts a fresh run of itself.
Start it by hand when a run begins (`gh workflow run check-submits.yml -R danielpuri1901/erdos-lean-checker`); the schedule only restarts it if it ever stopped.
Each pass lists the last 30 commits of `main`, every `run/*` branch (one per measured run), and every `claude/*` branch (where cloud sessions push) of the agent repository and runs `verify.yml` for each commit whose message starts with `submit(<target>):`, where `challenge/<target>.lean` exists, and that has no `comparator/<target>` status yet.
A pending status counts, so a running check is never started twice.
If a check's runner dies (for example out of memory, as on 2026-10-03 for agent commit `de3bff9`), its final status step never runs; the next pass turns that stale `pending` into a `failure` whose description says so, and the agent gets feedback.
The selection logic is in `scripts/pending_submits.py`, tested by `tests/test_pending_submits.py`.
Nothing in the agent repository can trigger it; the agent only pushes commits.

Runner limits: as a private repository (until 2026-10-04) this repository got GitHub's small runner, 7.8 GB of memory and a 72 GB disk that is 99 percent full after the Mathlib cache.
Two green72 submissions on 2026-10-03 built heavy kernel checks in parallel and the runner was killed.
`verify.yml` now removes unused SDKs (about 18 GB) and adds a swap file of up to 16 GB, so a large check slows down instead of dying.
Run https://github.com/danielpuri1901/erdos-lean-checker/actions/runs/37151232633 re-checked one of those submissions (`bc2e23b`, a copy of `de3bff9`) with 14 GB of swap: Comparator took 24 minutes and accepted it.

Cost: on a private repository GitHub bills each job by the minute, rounded up.
The poller bills every minute it runs, so a run day costs about the run's hours plus 2 idle hours, and each verdict about 30 to 50 minutes.
On 2026-10-04 the account's minutes for private repositories ran out and GitHub stopped starting jobs.
The repository was made public that evening, because GitHub does not bill standard runners on public repositories.
Verdicts took about 7 minutes after the change, against 11 to 25 minutes before.
`infra/referee-ec2.yaml` and `scripts/referee/` are a fallback that runs the same check on one EC2 machine; it was written that evening and has never been run.
Disable it between runs with `gh workflow disable check-submits.yml -R danielpuri1901/erdos-lean-checker`.
