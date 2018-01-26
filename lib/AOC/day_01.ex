defmodule AOC.Day01 do
  alias AOC.Directions

  def solve_1a(input) do
    input
    |> parse_input()
    |> follow_directions()
    |> calc_distance()
  end

  def solve_1b(input) do
    input
    |> parse_input()
    |> find_first_duplicate_location()
    |> calc_distance()
  end

  defp parse_input(input) do
    Regex.scan(~r"([RL])(\d+)", input, capture: :all_but_first)
    |> Stream.flat_map(fn i -> parse_instruction(i) end)
  end

  defp parse_instruction([turn, magnitude]), do: [turn, String.to_integer(magnitude)]

  defp follow_directions(directions) do
    directions
    |> Enum.reduce(initial_state(), fn
      "R", state -> turn_right(state)
      "L", state -> turn_left(state)
      n, state when is_integer(n) -> move_forward(state, n)
    end)
    |> elem(0)
  end

  defp find_first_duplicate_location(directions) do
    directions
    |> Stream.transform(initial_state(), fn
      "R", state -> {[], turn_right(state)}
      "L", state -> {[], turn_left(state)}
      n, state when is_integer(n) -> {move_forward_by_steps(state, n), move_forward(state, n)}
    end)
    |> Stream.map(&elem(&1, 0))
    |> Stream.dedup() # Duplicate positions occur when changing directions (i.e. end of one segment and beginning of another).
    |> find_first_duplicate()
  end

  defp initial_state, do: {Directions.origin(), Directions.north()}

  defp turn_right({pos, dir}), do: {pos, Directions.turn_right(dir)}
  defp turn_left({pos, dir}), do: {pos, Directions.turn_left(dir)}
  defp move_forward({pos, dir}, n), do: {Directions.move_forward(n, pos, dir), dir}

  defp move_forward_by_steps(state, n) do
    state
    |> Stream.iterate(fn st -> move_forward(st, 1) end)
    |> Stream.take(n + 1)
  end

  defp find_first_duplicate(positions) do
    Enum.reduce_while(positions, MapSet.new(), fn pos, seen ->
      if not MapSet.member?(seen, pos),
        do: {:cont, MapSet.put(seen, pos)},
        else: {:halt, pos}
    end)
  end

  defp calc_distance({x, y}), do: abs(x) + abs(y)
end
