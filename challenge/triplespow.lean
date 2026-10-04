import FormalConjectures.Arxiv.«1609.08688».sIncreasingrTuples

/-! Frozen statement for the triplespow target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

If F(n) = n^e for some n > 1, then F(m) >= m^e for arbitrarily large m, where F(n) is the longest 2-increasing sequence of triples with entries in 1..n (Gowers and Long, arXiv 1609.08688).
The statement is taken with `type_of%` from `Arxiv.«1609.08688».maximalLength_pow` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/triplespow.lean` checks this again. -/

theorem increasing_triples_power : type_of% @Arxiv.«1609.08688».maximalLength_pow := by
  sorry
