defmodule AOC.Day20Test do
  use ExUnit.Case, async: true

  alias AOC.Day20

  test "Day 20a solution" do
    assert -1 = Day20.solve_20a("0-4294967296")
    assert 0 == Day20.solve_20a("")
    assert 0 == Day20.solve_20a("1-1")
    assert 1 == Day20.solve_20a("0-0")
    assert 1_000 == Day20.solve_20a("0-999")
    assert 5 == Day20.solve_20a("6-10\n0-4")
    assert 21 == Day20.solve_20a("99-100\n6-10\n0-20")
  end

  test "Day 20b solution" do
    assert 0 = Day20.solve_20b("0-4294967296")
    assert 4_294_967_296 = Day20.solve_20b("")
    assert 4_294_967_295 = Day20.solve_20b("0-0")
    assert 1 = Day20.solve_20b("0-999\n1001-4294967296")
    assert 0 = Day20.solve_20b("0-1001\n999-4294967296")
  end
end
