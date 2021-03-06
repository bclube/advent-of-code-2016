defmodule AOC.Day04Test do
  use ExUnit.Case, async: true

  alias AOC.Day04.Solve

  test "Day 4a solution" do
    assert "abxyz" == Solve.calculate_checksum("aaaaa-bbb-z-y-x")
    assert "abcde" == Solve.calculate_checksum("a-b-c-d-e-f-g-h")
    assert "oarel" == Solve.calculate_checksum("not-a-real-room")
    assert "loart" == Solve.calculate_checksum("totally-real-room")
  end

  test "Day 4b solution" do
    assert "very encrypted name" == Solve.decrypt_name("qzmt-zixmtkozy-ivhz", 343)
  end
end
