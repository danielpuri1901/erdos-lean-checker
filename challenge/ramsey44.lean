import FormalConjectures.Wikipedia.RamseyNumbers

/-! Frozen statement for the ramsey44 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

R(4, 4) = 18 (Greenwood and Gleason, 1955).
The statement is taken with `type_of%` from `RamseyNumbers.ramsey_number_four_four` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/ramsey44.lean` checks this again. -/

theorem ramsey_4_4 : type_of% @RamseyNumbers.ramsey_number_four_four := by
  sorry
