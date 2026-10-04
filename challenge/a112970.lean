import FormalConjectures.OEIS.«112970»

/-! Frozen statement for the a112970 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

For the sequence A112970, a(2^n) = floor(n^2 / 4) + 1.
The statement is taken with `type_of%` from `OeisA112970.conjecture1_value` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/a112970.lean` checks this again. -/

theorem a112970_power_of_two : type_of% @OeisA112970.conjecture1_value := by
  sorry
