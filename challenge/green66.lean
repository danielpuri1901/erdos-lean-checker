import FormalConjectures.GreensOpenProblems.«66»

/-! Frozen statement for the green66 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

The trivial bound in Green's problem 66: every large X has a sum of two squares within C X^(1/4) below it.
The statement is taken with `type_of%` from `Green66.green_66.variants.trivial_bound` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/green66.lean` checks this again. -/

theorem green66_trivial_bound : type_of% @Green66.green_66.variants.trivial_bound := by
  sorry
