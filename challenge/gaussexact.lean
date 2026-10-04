import FormalConjectures.Wikipedia.GaussCircleProblem

/-! Frozen statement for the gaussexact target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

The number of integer points in the disc of radius r is 1 + 4 * sum over i of (floor(r^2/(4i+1)) - floor(r^2/(4i+3))).
The statement is taken with `type_of%` from `GaussCircleProblem.exact_form_floor` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/gaussexact.lean` checks this again. -/

theorem gauss_circle_exact_form : type_of% @GaussCircleProblem.exact_form_floor := by
  sorry
