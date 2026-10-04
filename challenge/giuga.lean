import FormalConjectures.Wikipedia.AgohGiuga

/-! Frozen statement for the giuga target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

A composite number is a strong Giuga number exactly when it is a Carmichael number and the sum of 1/p over its prime factors minus 1/a is a whole number (Giuga, 1950).
The statement is taken with `type_of%` from `AgohGiuga.isStrongGiuga_iff` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/giuga.lean` checks this again. -/

theorem strong_giuga_iff : type_of% @AgohGiuga.isStrongGiuga_iff := by
  sorry
