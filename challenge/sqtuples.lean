import FormalConjectures.Arxiv.«1609.08688».sIncreasingrTuples

/-! Frozen statement for the sqtuples target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

For a perfect square n there is a 2-increasing sequence of triples with entries in 1..n of length n^(3/2) (Gowers and Long, arXiv 1609.08688).
The statement is taken with `type_of%` from `Arxiv.«1609.08688».maximalLength_ge_of_isSquare` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/sqtuples.lean` checks this again. -/

theorem increasing_triples_square : type_of% @Arxiv.«1609.08688».maximalLength_ge_of_isSquare := by
  sorry
