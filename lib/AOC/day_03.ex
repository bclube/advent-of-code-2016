defmodule AOC.Day03 do
  defmodule Parse do
    def parse_input(input) do
      Regex.scan(~r|\d+|, input)
      |> Stream.concat()
      |> Stream.map(&String.to_integer/1)
    end
  end

  defmodule Solve do
    def horizontal_slices(sides),
      do: Stream.chunk_every(sides, 3, 3, :discard)
    def vertical_slices(sides) do
      sides
      |> Stream.chunk_every(3, 3, :discard)
      |> Stream.chunk_every(3, 3, :discard)
      |> Stream.flat_map(&Enum.zip/1)
      |> Stream.map(&Tuple.to_list/1)
    end

    def count_valid_triangles(sides, slice_fn) do
      sides
      |> slice_fn.()
      |> Enum.count(&valid_triangle?/1)
    end

    def valid_triangle?(sides) do
      max = Enum.max(sides)
      sum = Enum.sum(sides)
      sum > max * 2
    end
  end

  def solve_day_3(input, slice_fn) do
    input
    |> Parse.parse_input()
    |> Solve.count_valid_triangles(slice_fn)
  end

  def solve_3a(input), do: solve_day_3(input, &Solve.horizontal_slices/1)
  def solve_3b(input), do: solve_day_3(input, &Solve.vertical_slices/1)
end
