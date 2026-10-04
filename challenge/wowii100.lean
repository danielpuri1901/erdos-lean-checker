import FormalConjectures.WrittenOnTheWallII.GraphConjecture100

/-! Frozen statement for the wowii100 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

Written on the Wall II, conjecture 100 (Graffiti.pc): in a connected graph with at least two vertices,
`α(G) ≤ ⌈(max_v l(v) + ½ · ‖degrees of the complement‖₂) / 2⌉`.
The statement is taken with `type_of%` from
`WrittenOnTheWallII.GraphConjecture100.conjecture100` at formal-conjectures commit df3f12d7bd06,
so it is that statement by construction; the original contains a tactic-built proof term, which a retyped copy might not reproduce exactly.
`tests/statement/wowii100.lean` checks the match again. -/

theorem wowii100_matches.{u} :
    type_of% @WrittenOnTheWallII.GraphConjecture100.conjecture100.{u} := by
  sorry
