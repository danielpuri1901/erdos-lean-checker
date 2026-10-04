import FormalConjectures.Arxiv.«2507.17780».«3»

/-! Frozen statement for the txgraffiti3 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

TxGraffiti conjecture 3 says that every r-regular graph (r ≥ 1) has independent domination number at most its saturation number.
This target is its negation: the conjecture is false.
The statement is `¬` applied to the type of `Arxiv.«2507.17780».tx_graffiti_conjecture_3` at formal-conjectures commit df3f12d7bd06, taken with `type_of%`, so it negates exactly that statement.
`tests/statement/txgraffiti3.lean` checks this again. -/

theorem txgraffiti3_false : ¬ (type_of% @Arxiv.«2507.17780».tx_graffiti_conjecture_3) := by
  sorry
