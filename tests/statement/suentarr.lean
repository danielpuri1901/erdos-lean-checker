import Challenge

/-! Statement check for the suentarr target, run by `verify.yml` after it builds the frozen challenge.
The frozen statement must be identical to the one in formal-conjectures, symbol for symbol.
The definitions it uses (domination number, box product) are the ones checked on small graphs in
`tests/statement/clarksuen.lean`. -/

open SimpleGraph

/-- The statement typed out again, and the weaker Clark-Suen form without the `min` term. The check must
find the first equal to `suen_tarr` and the second different, or the comparison itself is broken. -/
def sameStatement : Prop :=
  ∀ {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (G : SimpleGraph α) (H : SimpleGraph β),
    G.dominationNumber * H.dominationNumber + min G.dominationNumber H.dominationNumber ≤
      2 * (G □ H).dominationNumber

def weakerStatement : Prop :=
  ∀ {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (G : SimpleGraph α) (H : SimpleGraph β),
    G.dominationNumber * H.dominationNumber ≤ 2 * (G □ H).dominationNumber

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let some ours := env.find? `suen_tarr | throwError "the frozen statement suen_tarr is missing"
  let some theirs := env.find? `VizingConjecture.vizing_conjecture.variants.suen_tarr
    | throwError "the formal-conjectures statement is missing"
  let some same := (env.find? `sameStatement).bind (·.value?) | throwError "sameStatement is missing"
  let some weaker := (env.find? `weakerStatement).bind (·.value?) | throwError "weakerStatement is missing"
  unless ours.type == same && !(ours.type == weaker) do
    throwError "self-test failed: the comparison cannot tell statements apart"
  unless ours.type == theirs.type do
    throwError "check failed: the frozen statement differs from formal-conjectures"
  logInfo "check passed: the frozen statement is identical to formal-conjectures, and the comparison tells the weaker Clark-Suen form apart"
