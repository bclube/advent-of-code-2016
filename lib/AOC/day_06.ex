defmodule AOC.Day06 do
  def solve_6a(input) do
    input
    |> String.split()
    |> Stream.flat_map(&(&1 |> String.codepoints() |> Stream.with_index()))
    |> Enum.reduce(%{}, &Map.update(&2, &1, 1, fn v -> v + 1 end))
    |> Enum.group_by(fn {{_, i}, _} -> i end, fn {{ch, _}, freq} -> {freq, ch} end)
    |> Stream.map(fn {idx, vs} -> {idx, Enum.max_by(vs, fn {freq, _} -> freq end)} end)
    |> Enum.sort_by(fn {idx, _} -> idx end)
    |> Enum.map_join(fn {_, {_, ch}} -> ch end)
  end
end
