import FormalConjectures.ErdosProblems.«105»

/-! Frozen statement for the erdos105 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict. -/

open EuclideanGeometry

/-- Erdős 105, variant `sub_four`, resolved negatively.
This is the negation of the universal statement in
`Erdos105.erdos_105.variants.sub_four` at formal-conjectures commit df3f12d7bd06. -/
theorem erdos_105_sub_four_false :
    ¬ ∀ A B : Finset ℝ², Disjoint A B → A.card = B.card + 4 →
      ¬ Collinear ℝ (A : Set ℝ²) →
      ∃ p ∈ A, ∃ q ∈ A, p ≠ q ∧ ∀ b ∈ B, b ∉ line[ℝ, p, q] := by
  sorry
