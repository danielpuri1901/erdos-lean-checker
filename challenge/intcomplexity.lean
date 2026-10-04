import FormalConjectures.Mathoverflow.«75792»

/-! Frozen statement for the intcomplexity target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

The least number of ones needed to write 3^n with addition and multiplication is 3n (Selfridge).
The statement is taken with `type_of%` from `Mathoverflow75792.complexity_three_pow` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/intcomplexity.lean` checks this again. -/

theorem complexity_of_three_pow : type_of% @Mathoverflow75792.complexity_three_pow := by
  sorry
