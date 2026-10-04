import FormalConjectures.Wikipedia.AgohGiuga

/-! Frozen statement for the weakgiuga target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

A composite number n is a weak Giuga number exactly when the sum of 1/p over its prime factors minus 1/n is a whole number.
The statement is taken with `type_of%` from `AgohGiuga.isWeakGiuga_iff_sum_primeFactors` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/weakgiuga.lean` checks this again. -/

theorem weak_giuga_iff_sum : type_of% @AgohGiuga.isWeakGiuga_iff_sum_primeFactors := by
  sorry
