import FormalConjectures.Wikipedia.AgohGiuga

/-! Frozen statement for the giuga9 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

A strong Giuga number has at least 9 distinct prime factors (Giuga, 1950).
The statement is taken with `type_of%` from `AgohGiuga.agoh_giuga.variants.le_primeFactors_card_of_isStrongGiuga` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/giuga9.lean` checks this again. -/

theorem strong_giuga_nine_primes : type_of% @AgohGiuga.agoh_giuga.variants.le_primeFactors_card_of_isStrongGiuga := by
  sorry
