import Challenge

/-! Statement check for the txgraffiti3 target, run by `verify.yml` after it builds the frozen challenge.
The frozen statement must be exactly `¬` applied to the formal-conjectures statement. -/

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let some ours := env.find? `txgraffiti3_false | throwError "the frozen statement is missing"
  let some theirs := env.find? `Arxiv.«2507.17780».tx_graffiti_conjecture_3
    | throwError "the formal-conjectures statement is missing"
  unless theirs.levelParams.isEmpty && ours.levelParams.isEmpty do
    throwError "check failed: unexpected universe variables"
  if ours.type == theirs.type then
    throwError "self-test failed: the frozen statement is not negated"
  unless ours.type == mkApp (mkConst ``Not) theirs.type do
    throwError "check failed: the frozen statement is not the negation of the formal-conjectures statement"
  logInfo "check passed: the frozen statement is the negation of the formal-conjectures statement"
