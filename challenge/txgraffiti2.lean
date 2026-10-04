import FormalConjectures.Arxiv.«2507.17780».«2»

/-! Frozen statement for the txgraffiti2 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

TxGraffiti conjecture 2 says that a connected graph with maximum degree at most 3, other than K4, has zero forcing number at most its independence number plus 1. This target is its negation; M. Fischer (arXiv 2607.23664) gives a 24-vertex counterexample.
The statement is taken with `type_of%` from `Arxiv.«2507.17780».tx_graffiti_conjecture_2` at formal-conjectures commit df3f12d7bd06, so it is the negation of that statement by construction.
`tests/statement/txgraffiti2.lean` checks this again. -/

theorem txgraffiti2_false : ¬ (type_of% @Arxiv.«2507.17780».tx_graffiti_conjecture_2) := by
  sorry
