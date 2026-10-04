import FormalConjectures.Paper.ClaudesCycles

/-! Frozen statement for the claudecycles2 target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

The cube digraph on (Z/2)^3 has no decomposition of its arcs into three directed Hamiltonian cycles (Aubert and Schneider, 1982).
The statement is taken with `type_of%` from `ClaudesCycles.cube_hamiltonian_arc_decomposition_impossible_m2` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/claudecycles2.lean` checks this again. -/

theorem cube_no_decomposition_m2 : type_of% @ClaudesCycles.cube_hamiltonian_arc_decomposition_impossible_m2 := by
  sorry
