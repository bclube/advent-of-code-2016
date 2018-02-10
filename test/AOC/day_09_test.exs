defmodule AOC.Day08Test do
  use ExUnit.Case, async: true

  alias AOC.Day09.Solve

  test "Day 9a solution" do
    assert "ADVENT" == Solve.decompress("ADVENT")
    assert "ABBBBBC" == Solve.decompress("A(1x5)BC")
    assert "XYZXYZXYZ" == Solve.decompress("(3x3)XYZ")
    assert "ABCBCDEFEFG" == Solve.decompress("A(2x2)BCD(2x2)EFG")
    assert "(1x3)A" == Solve.decompress("(6x1)(1x3)A")
    assert "X(3x3)ABC(3x3)ABCY" == Solve.decompress("X(8x2)(3x3)ABCY")
  end
end
