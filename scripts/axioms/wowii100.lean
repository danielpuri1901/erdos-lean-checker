import Solution

/-! Axiom audit for the wowii100 target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'wowii100_matches' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms wowii100_matches
