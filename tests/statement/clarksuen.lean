import Challenge

/-! Statement checks for the clarksuen target, run by `verify.yml` after it builds the frozen challenge.
Check 1: the frozen statement is identical to the one in formal-conjectures, symbol for symbol.
Check 2: the domination number and the box product give the answers a person counts by hand on small
graphs, so the statement is not trivially true and means what the English says. -/

open SimpleGraph

/-- The statement typed out again, and a weaker one with 3 in place of 2. Check 1 must find the first
equal to `clark_suen` and the second different, or the comparison itself is broken. -/
def sameStatement : Prop :=
  ∀ {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (G : SimpleGraph α) (H : SimpleGraph β),
    G.dominationNumber * H.dominationNumber ≤ 2 * (G □ H).dominationNumber

def weakerStatement : Prop :=
  ∀ {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (G : SimpleGraph α) (H : SimpleGraph β),
    G.dominationNumber * H.dominationNumber ≤ 3 * (G □ H).dominationNumber

open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let some ours := env.find? `clark_suen | throwError "the frozen statement clark_suen is missing"
  let some theirs := env.find? `VizingConjecture.vizing_conjecture.variants.clark_suen
    | throwError "the formal-conjectures statement is missing"
  let some same := (env.find? `sameStatement).bind (·.value?) | throwError "sameStatement is missing"
  let some weaker := (env.find? `weakerStatement).bind (·.value?) | throwError "weakerStatement is missing"
  unless ours.type == same && !(ours.type == weaker) do
    throwError "check 1 self-test failed: the comparison cannot tell statements apart"
  unless ours.type == theirs.type do
    throwError "check 1 failed: the frozen statement differs from formal-conjectures"
  logInfo "check 1 passed: the frozen statement is identical to formal-conjectures, and the comparison tells a weaker statement apart"

/-- The path `0 - 1 - ... - (n-1)`: dot `i` is joined to dot `i + 1`. -/
def path (n : ℕ) : SimpleGraph (Fin n) := SimpleGraph.fromRel fun a b => a.val + 1 = b.val

instance (n : ℕ) : DecidableRel (path n).Adj := fun a b =>
  decidable_of_iff (a ≠ b ∧ (a.val + 1 = b.val ∨ b.val + 1 = a.val)) Iff.rfl

-- No dots: nothing to dominate.
example : (⊥ : SimpleGraph (Fin 0)).dominationNumber = 0 := by
  rw [dom_num_eq_computable]; decide +kernel
-- One dot alone.
example : (⊥ : SimpleGraph (Fin 1)).dominationNumber = 1 := by
  rw [dom_num_eq_computable]; decide +kernel
-- Two dots, no line: each must be picked.
example : (⊥ : SimpleGraph (Fin 2)).dominationNumber = 2 := by
  rw [dom_num_eq_computable]; decide +kernel
-- Triangle: any one corner touches the other two.
example : (⊤ : SimpleGraph (Fin 3)).dominationNumber = 1 := by
  rw [dom_num_eq_computable]; decide +kernel
-- A - B - C: pick B.
example : (path 3).dominationNumber = 1 := by
  rw [dom_num_eq_computable]; decide +kernel
-- A - B - C - D: one dot touches at most three, so two are needed.
example : (path 4).dominationNumber = 2 := by
  rw [dom_num_eq_computable]; decide +kernel
-- Square: the box product of two single lines is a ring of four dots.
example : (path 2 □ path 2).dominationNumber = 2 := by
  rw [dom_num_eq_computable]; decide +kernel
-- 3 by 3 grid: the box product of two 3-dot paths. The centre alone misses the four corners.
example : (path 3 □ path 3).dominationNumber = 3 := by
  rw [dom_num_eq_computable]; decide +kernel

run_cmd Lean.logInfo "check 2 passed: γ = 0, 1, 2, 1, 1, 2, 2, 3 for the empty graph, one dot, two dots, triangle, A-B-C, A-B-C-D, square, 3x3 grid"
