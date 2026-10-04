import FormalConjectures.WrittenOnTheWallII.GraphConjecture19

/-! Frozen statement for the wowii19 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

Written on the Wall II, conjecture 19 (Graffiti.pc): in a connected graph with at least two vertices,
the largest induced bipartite subgraph has at least `⌊average eccentricity + max_v l(v)⌋` vertices,
where `l(v)` is the independence number of the neighbourhood of `v`.
This is `WrittenOnTheWallII.GraphConjecture19.conjecture19` at formal-conjectures commit df3f12d7bd06,
under a new name so it does not clash with the imported declaration.
`tests/statement/wowii19.lean` checks that the two statements are identical. -/

namespace WrittenOnTheWallII.GraphConjecture19

open SimpleGraph

variable {α : Type*} [Fintype α] [DecidableEq α]

theorem conjecture19_check (G : SimpleGraph α) [Nontrivial α] (h_conn : G.Connected) :
    ⌊(∑ v ∈ Finset.univ, ((G.eccent v).toNat : ℝ)) / (Fintype.card α : ℝ) +
      sSup (Set.range (indepNeighbors G))⌋ ≤ b G := by
  sorry

end WrittenOnTheWallII.GraphConjecture19
