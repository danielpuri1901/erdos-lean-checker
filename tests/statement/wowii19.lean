import Challenge

/-! Statement check for the wowii19 target, run by `verify.yml` after it builds the frozen challenge.
The frozen statement must be identical to the formal-conjectures statement, up to the names of universe variables. -/

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let some ours := env.find? `WrittenOnTheWallII.GraphConjecture19.conjecture19_check | throwError "the frozen statement is missing"
  let some theirs := env.find? `WrittenOnTheWallII.GraphConjecture19.conjecture19 | throwError "the formal-conjectures statement is missing"
  let some other := env.find? `Nat.add_comm | throwError "Nat.add_comm is missing"
  unless ours.levelParams.length == theirs.levelParams.length do
    throwError "check failed: the two statements have different universe variables"
  let oursTy := ours.type.instantiateLevelParams ours.levelParams (theirs.levelParams.map Level.param)
  if oursTy == other.type then
    throwError "self-test failed: the comparison cannot tell statements apart"
  unless oursTy == theirs.type do
    throwError "check failed: the frozen statement differs from formal-conjectures"
  logInfo "check passed: the frozen statement is identical to formal-conjectures"
