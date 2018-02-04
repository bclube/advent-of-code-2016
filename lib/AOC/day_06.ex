defmodule AOC.Day06 do
  defp solve_day_6(input, select_fn) do
    input
    |> String.split()
    |> Stream.flat_map(&(&1 |> String.codepoints() |> Stream.with_index()))
    |> Enum.reduce(%{}, &Map.update(&2, &1, 1, fn v -> v + 1 end))
    |> Enum.group_by(fn {{_, i}, _} -> i end, fn {{ch, _}, freq} -> {freq, ch} end)
    |> Stream.map(fn {idx, vs} -> {idx, select_fn.(vs, fn {freq, _} -> freq end)} end)
    |> Enum.sort_by(fn {idx, _} -> idx end)
    |> Enum.map_join(fn {_, {_, ch}} -> ch end)
  end

  def solve_6a(input), do: solve_day_6(input, &Enum.max_by/2)
  def solve_6b(input), do: solve_day_6(input, &Enum.min_by/2)
end
