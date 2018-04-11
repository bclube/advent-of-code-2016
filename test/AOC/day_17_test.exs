defmodule AOC.Day17Test do
  use ExUnit.Case, async: true

  alias AOC.Day17

  test "Day 17a solution" do
    assert "DDRRRD" == Day17.solve_17a("ihgpwlah")
    assert "DDUDRLRRUDRD" == Day17.solve_17a("kglvqrro")
    assert "DRURDRUDDLLDLUURRDULRLDUUDDDRR" == Day17.solve_17a("ulqzkmiv")
  end

  @tag :slow
  test "Day 17b solution" do
    assert 370 == Day17.solve_17b("ihgpwlah")
    assert 492 == Day17.solve_17b("kglvqrro")
    assert 830 == Day17.solve_17b("ulqzkmiv")
  end
end
