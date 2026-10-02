import Solution

/-! Axiom audit for the trivial target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'challenge_trivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms challenge_trivial
