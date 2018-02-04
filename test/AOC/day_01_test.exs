defmodule AOC.Day01Test do
  use ExUnit.Case, async: true

  alias AOC.Day01

  test "Day 1a solution" do
    assert 5 == Day01.solve_1a("R2, L3")
    assert 2 == Day01.solve_1a("R2, R2, R2")
    assert 12 == Day01.solve_1a("R5, L5, R5, R3")
  end

  test "Day 1b solution" do
    assert 4 == Day01.solve_1b("R8, R4, R4, R8")
  end
end
