import FormalConjectures.GreensOpenProblems.«72»
theorem challenge_trivial (h : False) :
    Green72.NoKInLineFor 3 3 ↔ Green72.AllowedSetSize 3 3 = (3 - 1) * 3 :=
  h.elim
