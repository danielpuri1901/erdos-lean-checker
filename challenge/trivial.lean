import FormalConjectures.GreensOpenProblems.«72»

/-! Frozen statement for the trivial target. The checker overwrites this file before every verdict. -/

/-- Trivial challenge used to prove the checker pipeline works end to end.
It unfolds the repository's own definition, so it also tests importing a
module-system file from formal-conjectures. -/
theorem challenge_trivial :
    Green72.NoKInLineFor 3 3 ↔ Green72.AllowedSetSize 3 3 = (3 - 1) * 3 := by
  sorry
