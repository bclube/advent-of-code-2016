defmodule AOC.Day14Test do
  use ExUnit.Case, async: true

  alias AOC.Day14

  @tag :slow
  test "Day 14a solution" do
    assert 22728 == Day14.solve_14a("abc")
  end

  @tag :slow
  test "Day 14b solution" do
    assert 22551 == Day14.solve_14b("abc")
  end
end
