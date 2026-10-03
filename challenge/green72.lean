import FormalConjectures.GreensOpenProblems.«72»

/-! Frozen statement for the green72 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict. -/

/-- Green's Open Problem 72 for small grids: for 3 ≤ N ≤ 60 the pigeonhole bound 2N is attained.
This is `Green72.no_three_in_line_le` at formal-conjectures commit df3f12d7bd06, renamed so it does not clash with the imported declaration. -/
theorem green72_no_three_in_line_le {N : ℕ} (hN : 3 ≤ N) (hN' : N ≤ 60) :
    Green72.NoKInLineFor 3 N := by
  sorry
