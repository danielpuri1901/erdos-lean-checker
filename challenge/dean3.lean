import FormalConjectures.Arxiv.«2605.02731».DeanCycles

/-! Frozen statement for the dean3 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

Every finite graph with minimum degree at least 3 has a cycle whose length is divisible by 3 (Chen and Saito, 1994).
The statement is taken with `type_of%` from `Arxiv.«2605.02731».dean_conjecture.variants.three` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/dean3.lean` checks this again. -/

theorem dean_three : type_of% @Arxiv.«2605.02731».dean_conjecture.variants.three := by
  sorry
