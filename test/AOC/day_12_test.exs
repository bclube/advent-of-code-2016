defmodule AOC.Day12Test do
  use ExUnit.Case, async: true

  alias AOC.Day12

  @puzzle """
  cpy 41 a
  inc a
  inc a
  dec a
  jnz a 2
  dec a
  """

  test "Day 12a solution" do
    assert 42 == Day12.solve_12a(@puzzle)
  end
end
