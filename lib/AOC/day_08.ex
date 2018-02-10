defmodule AOC.Day08 do
  defmodule Solve do
    def make_rect(board, rows, cols) do
      for r <- 0..(rows - 1),
          c <- 0..(cols - 1),
          do: {r, c},
          into: board
    end

    def rotate_row(board, row, magnitude, col_count) do
      MapSet.new(board, fn
        {^row, col} -> {row, rem(col + magnitude, col_count)}
        coord -> coord
      end)
    end

    def rotate_col(board, col, magnitude, row_count) do
      MapSet.new(board, fn
        {row, ^col} -> {rem(row + magnitude, row_count), col}
        coord -> coord
      end)
    end
  end

  defmodule Parse do
    def parse_input(input, row_count, col_count) do
      input
      |> String.split(~r/\n/, trim: true)
      |> Stream.map(&parse_instruction(&1, row_count, col_count))
    end

    defp parse_instruction("rect" <> rest, _col_count, _row_count) do
      [cols, rows] = rest |> String.split(~r/\D+/, trim: true) |> Enum.map(&String.to_integer/1)

      &Solve.make_rect(&1, rows, cols)
    end

    defp parse_instruction("rotate row" <> rest, _row_count, col_count) do
      [row, mag] = rest |> String.split(~r/\D+/, trim: true) |> Enum.map(&String.to_integer/1)

      &Solve.rotate_row(&1, row, mag, col_count)
    end

    defp parse_instruction("rotate col" <> rest, row_count, _col_count) do
      [col, mag] = rest |> String.split(~r/\D+/, trim: true) |> Enum.map(&String.to_integer/1)

      &Solve.rotate_col(&1, col, mag, row_count)
    end
  end

  defp solve_day_8(input, row_count, col_count) do
    input
    |> Parse.parse_input(row_count, col_count)
    |> Enum.reduce(MapSet.new(), fn inst, bd -> inst.(bd) end)
  end

  defp print_grid(coords, row_count, col_count) do
    for r <- 0..(row_count - 1) do
      for c <- 0..(col_count - 1),
          do: if(MapSet.member?(coords, {r, c}), do: "#", else: "."),
          into: ""
    end
    |> Enum.join("\n")
  end

  def solve_day_8a(input, row_count, col_count),
    do: solve_day_8(input, row_count, col_count) |> Enum.count()

  def solve_day_8b(input, row_count, col_count),
    do: solve_day_8(input, row_count, col_count) |> print_grid(row_count, col_count)

  def solve_8a(input), do: solve_day_8a(input, 6, 50)
  def solve_8b(input), do: solve_day_8b(input, 6, 50)
end
