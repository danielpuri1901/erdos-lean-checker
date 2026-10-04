import FormalConjectures.Wikipedia.LeinsterGroup

/-! Frozen statement for the dihedral target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

The dihedral group of order 2n is a Leinster group exactly when n is an odd perfect number (Leinster, 2001).
The statement is taken with `type_of%` from `LeinsterGroup.dihedral_is_leinster_iff_odd_perfect` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/dihedral.lean` checks this again. -/

theorem dihedral_leinster_iff : type_of% @LeinsterGroup.dihedral_is_leinster_iff_odd_perfect := by
  sorry
