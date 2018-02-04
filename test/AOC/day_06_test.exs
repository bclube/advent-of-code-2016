defmodule AOC.Day06Test do
  use ExUnit.Case, async: true

  alias AOC.Day06

  @input """
  eedadn
  drvtee
  eandsr
  raavrd
  atevrs
  tsrnev
  sdttsa
  rasrtv
  nssdts
  ntnada
  svetve
  tesnvt
  vntsnd
  vrdear
  dvrsen
  enarar
  """

  test "Day 6a solution" do
    assert "easter" == Day06.solve_6a(@input)
  end

  test "Day 6b solution" do
    assert "advent" == Day06.solve_6b(@input)
  end
end
