defmodule AOC.Day07Test do
  use ExUnit.Case, async: true

  alias AOC.Day07

  test "supports_tls?" do
    assert true == Day07.Solve.supports_tls?("abba[mnop]qrst")
    assert false == Day07.Solve.supports_tls?("abcd[bddb]xyyx")
    assert false == Day07.Solve.supports_tls?("aaaa[qwer]tyui")
    assert true == Day07.Solve.supports_tls?("ioxxoj[asdfgh]zxcvbn")
  end
end
