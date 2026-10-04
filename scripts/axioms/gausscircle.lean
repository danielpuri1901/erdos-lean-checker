import Solution

/-! Axiom audit for the gausscircle target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'gauss_circle_error_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gauss_circle_error_le
