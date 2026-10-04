import Solution

/-! Axiom audit for the txgraffiti3 target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'txgraffiti3_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms txgraffiti3_false
