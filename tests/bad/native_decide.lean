import FormalConjectures.GreensOpenProblems.«72»
theorem helper : (2 : Nat) + 2 = 4 := by native_decide
theorem challenge_trivial :
    Green72.NoKInLineFor 3 3 ↔ Green72.AllowedSetSize 3 3 = (3 - 1) * 3 :=
  have _ := helper
  Iff.rfl
