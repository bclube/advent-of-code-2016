defmodule AOC.Day15 do
  def solve_day_15(extras \\ []) do
    {
      0,
      Enum.concat(extras, [
        {3, 0},
        {5, 3},
        {7, 6},
        {13, 9},
        {17, 13},
        {19, 14}
      ])
    }
    |> Stream.iterate(fn {t, vs} ->
      factor =
        vs
        |> Stream.filter(&match?({_, 0}, &1))
        |> Stream.map(fn {v, _} -> v end)
        |> Enum.reduce(1, &(&1 * &2))

      {
        t + factor,
        Enum.map(vs, fn {f, v} ->
          {f, rem(v + factor, f)}
        end)
      }
    end)
    |> Enum.find_value(fn {t, vs} ->
      if Enum.all?(vs, &match?({_, 0}, &1)), do: t
    end)
  end

  def solve_15a, do: solve_day_15()

  def solve_15b, do: solve_day_15([{11, 7}])
end
