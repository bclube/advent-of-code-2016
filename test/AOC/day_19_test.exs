defmodule AOC.Day19Test do
  use ExUnit.Case, async: true

  alias AOC.Day19

  test "Day 19a solution" do
    assert 1 == Day19.solve_19a(1)
    assert 1 == Day19.solve_19a(2)
    assert 3 == Day19.solve_19a(3)
    assert 1 == Day19.solve_19a(4)
    assert 3 == Day19.solve_19a(5)
    assert 5 == Day19.solve_19a(6)
  end

  test "Day 19b solution" do
    assert 1 == Day19.solve_19b(1)
    assert 1 == Day19.solve_19b(2)
    assert 3 == Day19.solve_19b(3)
    assert 1 == Day19.solve_19b(4)
    assert 2 == Day19.solve_19b(5)
    assert 3 == Day19.solve_19b(6)
  end
end
