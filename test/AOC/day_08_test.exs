defmodule AOC.Day08Test do
  use ExUnit.Case, async: true

  alias AOC.Day08

  @puzzle """
  rect 3x2
  rotate column x=1 by 1
  rotate row y=0 by 4
  rotate column x=1 by 1
  """

  @result """
          .#..#.#
          #.#....
          .#.....
          """
          |> String.trim()

  test "Day 8a solution" do
    assert 6 == Day08.solve_day_8a(@puzzle, 3, 7)
  end

  test "Day 8b solution" do
    assert @result == Day08.solve_day_8b(@puzzle, 3, 7)
  end
end
