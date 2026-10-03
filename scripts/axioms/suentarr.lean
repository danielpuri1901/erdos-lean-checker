import Solution

/-! Axiom audit for the suentarr target. Documentation only: Comparator enforces the permitted axioms. -/

/-- info: 'suen_tarr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms suen_tarr
