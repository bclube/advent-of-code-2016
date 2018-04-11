defmodule AOC.Day18 do
  defp parse_input(input) do
    input
    |> String.trim()
    |> String.codepoints()
    |> Enum.map(&if(&1 == ".", do: 1, else: 0))
  end

  defp next_row(row) do
    Stream.concat([[1], row, [1]])
    |> Stream.chunk_every(3, 1, :discard)
    |> Enum.map(fn
      [x, x, x] -> 1
      [x, x, _] -> 0
      [_, x, x] -> 0
      _ -> 1
    end)
  end

  def solve_day_18(input, rows) do
    input
    |> parse_input()
    |> Stream.iterate(&next_row/1)
    |> Stream.take(rows)
    |> Stream.concat()
    |> Enum.sum()
  end

  def solve_18a(input), do: solve_day_18(input, 40)

  def solve_18b(input), do: solve_day_18(input, 400_000)
end
