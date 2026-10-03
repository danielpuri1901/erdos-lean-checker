import FormalConjectures.Wikipedia.VizingConjecture

/-! Frozen statement for the clarksuen target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict. -/

open SimpleGraph

/-- The Clark-Suen inequality (2000): for all finite simple graphs `G` and `H`,
`γ(G) γ(H) ≤ 2 γ(G □ H)`, where `γ` is the domination number and `□` the Cartesian product.
This is `VizingConjecture.vizing_conjecture.variants.clark_suen` at formal-conjectures commit df3f12d7bd06,
renamed so it does not clash with the imported declaration. `tests/statement/clarksuen.lean` checks that
the two statements are identical. -/
theorem clark_suen {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (G : SimpleGraph α) (H : SimpleGraph β) :
    G.dominationNumber * H.dominationNumber ≤ 2 * (G □ H).dominationNumber := by
  sorry
