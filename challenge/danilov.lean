import FormalConjectures.Wikipedia.Hall

/-! Frozen statement for the danilov target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

Danilov's theorem: the exponent 1/2 in Hall's conjecture cannot be replaced by a larger number.
The statement is taken with `type_of%` from `Hall.danilov` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/danilov.lean` checks this again. -/

theorem hall_danilov : type_of% @Hall.danilov := by
  sorry
