defmodule AOC.Day18Test do
  use ExUnit.Case, async: true

  alias AOC.Day18

  test "solve_day_18 function" do
    assert 38 == Day18.solve_day_18(".^^.^.^^^^", 10)
  end
end
