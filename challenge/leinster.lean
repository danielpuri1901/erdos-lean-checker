import FormalConjectures.Wikipedia.LeinsterGroup

/-! Frozen statement for the leinster target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

A non-abelian Leinster group exists (Leinster, 2001).
The statement is taken with `type_of%` from `LeinsterGroup.exists_nonabelian_leinster_group` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/leinster.lean` checks this again. -/

theorem leinster_nonabelian_exists : type_of% @LeinsterGroup.exists_nonabelian_leinster_group := by
  sorry
