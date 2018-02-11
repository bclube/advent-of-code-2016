defmodule AOC.Day09Test do
  use ExUnit.Case, async: true

  alias AOC.Day09

  test "Day 9a solution" do
    assert 6 == Day09.solve_9a("ADVENT")
    assert 7 == Day09.solve_9a("A(1x5)BC")
    assert 9 == Day09.solve_9a("(3x3)XYZ")
    assert 11 == Day09.solve_9a("A(2x2)BCD(2x2)EFG")
    assert 6 == Day09.solve_9a("(6x1)(1x3)A")
    assert 18 == Day09.solve_9a("X(8x2)(3x3)ABCY")
  end

  test "Day 9b solution" do
    assert 20 == Day09.solve_9b("X(8x2)(3x3)ABCY")
    assert 9 == Day09.solve_9b("(3x3)XYZ")
    assert 20 == Day09.solve_9b("X(8x2)(3x3)ABCY")
    assert 241_920 == Day09.solve_9b("(27x12)(20x12)(13x14)(7x10)(1x12)A")
    assert 445 == Day09.solve_9b("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
  end
end
