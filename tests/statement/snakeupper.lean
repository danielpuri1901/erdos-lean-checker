import Challenge

/-! Statement check for the snakeupper target, run by `verify.yml` after it builds the frozen challenge.
The frozen statement must be exactly the formal-conjectures statement. -/

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let some ours := env.find? `snake_le_two_pow | throwError "the frozen statement is missing"
  let some theirs := env.find? `SnakeInBox.snake_upper_bound
    | throwError "the formal-conjectures statement is missing"
  unless theirs.levelParams.isEmpty && ours.levelParams.isEmpty do
    throwError "check failed: unexpected universe variables"
  let some other := env.find? `Nat.add_comm | throwError "Nat.add_comm is missing"
  if ours.type == other.type then
    throwError "self-test failed: the comparison cannot tell statements apart"
  unless ours.type == theirs.type do
    throwError "check failed: the frozen statement does not match the formal-conjectures statement"
  logInfo "check passed: the frozen statement matches the formal-conjectures statement"
