import Solution

/-! Axiom audit for the green72 target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'green72_no_three_in_line_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms green72_no_three_in_line_le
