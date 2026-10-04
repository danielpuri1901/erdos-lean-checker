import Solution

/-! Axiom audit for the txgraffiti2 target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'txgraffiti2_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms txgraffiti2_false
