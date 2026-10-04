import Solution

/-! Axiom audit for the danilov target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'hall_danilov' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hall_danilov
