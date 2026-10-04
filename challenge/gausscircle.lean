import FormalConjectures.Wikipedia.GaussCircleProblem

/-! Frozen statement for the gausscircle target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

Gauss's bound for the circle problem: for large r, the number of integer points in the disc of radius r differs from pi r^2 by at most 2 sqrt(2) pi r.
The statement is taken with `type_of%` from `GaussCircleProblem.error_le` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/gausscircle.lean` checks this again. -/

theorem gauss_circle_error_le : type_of% @GaussCircleProblem.error_le := by
  sorry
