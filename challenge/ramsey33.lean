import FormalConjectures.Wikipedia.RamseyNumbers

/-! Frozen statement for the ramsey33 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

R(3, 3) = 6.
The statement is taken with `type_of%` from `RamseyNumbers.ramsey_number_three_three` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/ramsey33.lean` checks this again. -/

theorem ramsey_3_3 : type_of% @RamseyNumbers.ramsey_number_three_three := by
  sorry
