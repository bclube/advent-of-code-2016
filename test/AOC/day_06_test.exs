defmodule AOC.Day06Test do
  use ExUnit.Case, async: true

  alias AOC.Day06

  test "Day 6a solution" do
    assert "easter" ==
             Day06.solve_6a("""
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
             """)
  end
end
