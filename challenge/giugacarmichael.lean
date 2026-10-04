import FormalConjectures.Wikipedia.AgohGiuga

/-! Frozen statement for the giugacarmichael target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

Every strong Giuga number is a Carmichael number (Giuga, 1950).
The statement is taken with `type_of%` from `AgohGiuga.agoh_giuga.variants.isStrongGiuga_implies_isCarmichael` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/giugacarmichael.lean` checks this again. -/

theorem strong_giuga_is_carmichael : type_of% @AgohGiuga.agoh_giuga.variants.isStrongGiuga_implies_isCarmichael := by
  sorry
