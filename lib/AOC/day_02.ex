defmodule AOC.Day02 do
  alias AOC.Grid.{
    Coord,
    Direction,
    Move
  }

  def solve_2a(input), do: solve_day_2(input, map_2a_labels())
  def solve_2b(input), do: solve_day_2(input, map_2b_labels())

  defp solve_day_2(input, label_map) do
    input
    |> parse_input()
    |> process_moves(label_map)
    |> Enum.join()
  end

  defp parse_input(input) do
    input
    |> String.graphemes()
    |> Stream.map(fn
      "U" -> Direction.prev_row()
      "D" -> Direction.next_row()
      "L" -> Direction.prev_col()
      "R" -> Direction.next_col()
      "\n" -> :emit
    end)
  end

  defp process_moves(moves, label_map) do
    Stream.transform(moves, Coord.new(1, 1), fn
      :emit, state ->
        {[Map.get(label_map, state)], state}

      dir, state ->
        nxt = Move.step(state, dir)
        next = if Map.has_key?(label_map, nxt), do: nxt, else: state
        {[], next}
    end)
  end

  defp valid_2a_positions do
    for r <- 0..2,
        c <- 0..2,
        do: Coord.new(r, c)
  end

  defp valid_2b_positions do
    for r <- -2..2,
        c <- -2..2,
        2 >= abs(r) + abs(c),
        do: Coord.new(r + 1, c + 3)
  end

  defp label_map(positions) do
    labels =
      Stream.concat(?1..?9, ?A..?Z)
      |> Stream.map(fn i -> to_string([i]) end)

    positions
    |> Stream.zip(labels)
    |> Map.new()
  end

  defp map_2a_labels, do: label_map(valid_2a_positions())
  defp map_2b_labels, do: label_map(valid_2b_positions())
end
