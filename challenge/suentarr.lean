import FormalConjectures.Wikipedia.VizingConjecture

/-! Frozen statement for the suentarr target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict. -/

open SimpleGraph

/-- The Suen-Tarr inequality (2012): for all finite simple graphs `G` and `H`,
`γ(G) γ(H) + min(γ(G), γ(H)) ≤ 2 γ(G □ H)`, which improves the Clark-Suen bound.
This is `VizingConjecture.vizing_conjecture.variants.suen_tarr` at formal-conjectures commit df3f12d7bd06,
renamed so it does not clash with the imported declaration. `tests/statement/suentarr.lean` checks that
the two statements are identical. -/
theorem suen_tarr {α β : Type} [Fintype α] [Fintype β] [DecidableEq α] [DecidableEq β]
    (G : SimpleGraph α) (H : SimpleGraph β) :
    G.dominationNumber * H.dominationNumber + min G.dominationNumber H.dominationNumber ≤
      2 * (G □ H).dominationNumber := by
  sorry
