defmodule AOC.Day06 do
  defp solve_day_6(input, select_fn) do
    input
    |> String.split()
    |> Stream.map(&String.codepoints/1)
    |> Stream.zip()
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&get_result_char(&1, select_fn))
    |> Enum.join()
  end

  defp get_result_char(chs, select_fn) do
    chs
    |> Enum.reduce(%{}, &Map.update(&2, &1, 1, fn v -> v + 1 end))
    |> select_fn.(&elem(&1, 1))
    |> elem(0)
  end

  def solve_6a(input), do: solve_day_6(input, &Enum.max_by/2)
  def solve_6b(input), do: solve_day_6(input, &Enum.min_by/2)
end
