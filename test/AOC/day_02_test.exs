defmodule AOC.Day02Test do
  use ExUnit.Case

  alias AOC.Day02

  @input """
  ULL
  RRDDD
  LURDL
  UUUUD
  """

  test "Day 2a solution" do
    assert "1985" == Day02.solve_2a(@input)
  end

  test "Day 2b solution" do
    assert "5DB3" == Day02.solve_2b(@input)
  end

end
