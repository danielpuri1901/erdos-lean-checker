import FormalConjectures.Wikipedia.SteinerSystem

/-! Frozen statement for the witt24 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

The large Witt design exists: a Steiner system S(5, 8, 24) (Witt, 1938).
The statement is taken with `type_of%` from `SteinerSystems.steiner_system_5_8_24` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/witt24.lean` checks this again. -/

theorem witt_design_exists : type_of% @SteinerSystems.steiner_system_5_8_24 := by
  sorry
