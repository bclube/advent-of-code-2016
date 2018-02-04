defmodule AOC.Day05Test do
  use ExUnit.Case, async: true

  alias AOC.Day05

  @tag :slow
  test "Day 5a solution" do
    assert "18f47a30" == Day05.solve_5a("abc")
  end
end
