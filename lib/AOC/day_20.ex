defmodule AOC.Day20 do
  defp parse_line(line) do
    [[from], [to]] = Regex.scan(~r/\d+/, line)

    {String.to_integer(from), String.to_integer(to)}
  end

  defp merge_overlapping_pairs(vs) do
    Enum.concat([[{-1, -1}], vs, [{4_294_967_296, 4_294_967_296}]])
    |> Stream.unfold(fn
      [{a_from, a_to} | [{b_from, b_to} | rst] = rrst] ->
        if a_to + 1 >= b_from,
          do: {[], [{a_from, max(a_to, b_to)} | rst]},
          else: {[{a_to + 1, b_from - 1}], rrst}

      _ ->
        nil
    end)
    |> Stream.concat()
  end

  defp solve_day_20(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Stream.map(&parse_line/1)
    |> Enum.sort_by(&elem(&1, 0))
    |> merge_overlapping_pairs()
  end

  def solve_20a(input) do
    input
    |> solve_day_20()
    |> Enum.find_value(-1, fn {from, _to} -> from end)
  end

  def solve_20b(input) do
    input
    |> solve_day_20()
    |> Stream.map(fn {from, to} -> to - from + 1 end)
    |> Enum.sum()
  end
end
