import Solution

/-! Axiom audit for the erdos105 target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'erdos_105_sub_four_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms erdos_105_sub_four_false
