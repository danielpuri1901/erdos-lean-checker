import Solution

/-! Axiom audit for the green66 target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'green66_trivial_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms green66_trivial_bound
