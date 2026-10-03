import Solution

/-! Axiom audit for the clarksuen target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'clark_suen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms clark_suen
