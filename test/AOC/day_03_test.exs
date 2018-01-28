defmodule AOC.Day03Test do
  use ExUnit.Case

  alias AOC.Day03

  test "Day 3a solution" do
    assert true == Day03.Solve.valid_triangle?([3, 4, 5])
    assert true == Day03.Solve.valid_triangle?([3, 3, 5])
    assert false == Day03.Solve.valid_triangle?([3, 2, 5])
  end
end
