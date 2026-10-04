import FormalConjectures.Wikipedia.SnakeInTheBox

/-! Frozen statement for the snakeupper target. The checker overwrites the agent's `Challenge.lean` with this file before every verdict.

For n at least 1, an induced path in the n-dimensional cube has at most 2^(n-1) edges (Danzer and Klee, 1967).
The statement is taken with `type_of%` from `SnakeInBox.snake_upper_bound` at formal-conjectures commit df3f12d7bd06, so it is that statement by construction.
`tests/statement/snakeupper.lean` checks this again. -/

theorem snake_le_two_pow : type_of% @SnakeInBox.snake_upper_bound := by
  sorry
