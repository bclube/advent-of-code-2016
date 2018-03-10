defmodule AOC.Day13Test do
  use ExUnit.Case, async: true

  alias AOC.Day13

  test "Day 13a solution" do
    assert 11 = Day13.solve_13a(10, {7, 4})
  end
end
