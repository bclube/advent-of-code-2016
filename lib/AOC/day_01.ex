defmodule AOC.Day01 do
  alias AOC.Grid.{
    Coord,
    Direction,
    Move,
    Turn
  }

  defmodule State do
    defstruct dir: Direction.north(),
              pos: Coord.origin()

    def new, do: %__MODULE__{}

    def turn(%__MODULE__{} = state, tn), do: %{state | dir: Turn.turn(state.dir, tn)}
    def step(%__MODULE__{} = state), do: %{state | pos: Move.step(state.pos, state.dir)}
    def move(%__MODULE__{} = state, n), do: %{state | pos: Move.move(state.pos, state.dir, n)}

    def pos(%__MODULE__{pos: pos}), do: pos
  end

  def solve_1a(input), do: solve_day_1(input, &follow_directions/1)
  def solve_1b(input), do: solve_day_1(input, &find_first_duplicate_location/1)

  defp solve_day_1(input, loc_fn) do
    input
    |> parse_input()
    |> loc_fn.()
    |> calc_distance()
  end

  defp parse_input(input) do
    Regex.scan(~r"([RL])(\d+)", input, capture: :all_but_first)
    |> Stream.flat_map(&parse_instruction/1)
  end

  defp parse_instruction([turn, magnitude]) do
    [parse_turn(turn), String.to_integer(magnitude)]
  end

  defp parse_turn("R"), do: Turn.right()
  defp parse_turn("L"), do: Turn.left()

  defp follow_directions(directions) do
    directions
    |> Enum.reduce(State.new(), fn
      n, state when is_integer(n) -> State.move(state, n)
      tn, state -> State.turn(state, tn)
    end)
    |> State.pos()
  end

  defp find_first_duplicate_location(directions) do
    # Duplicate positions occur when changing directions (i.e. end of one segment and beginning of another).
    directions
    |> Stream.transform(State.new(), fn
      n, state when is_integer(n) -> {move_forward_by_steps(state, n), State.move(state, n)}
      tn, state -> {[], State.turn(state, tn)}
    end)
    |> Stream.map(&State.pos/1)
    |> Stream.dedup()
    |> find_first_duplicate()
  end

  defp move_forward_by_steps(state, n) do
    state
    |> Stream.iterate(&State.step/1)
    |> Stream.take(n + 1)
  end

  defp find_first_duplicate(positions) do
    Enum.reduce_while(positions, MapSet.new(), fn pos, seen ->
      if not MapSet.member?(seen, pos),
        do: {:cont, MapSet.put(seen, pos)},
        else: {:halt, pos}
    end)
  end

  defp calc_distance(pos), do: Coord.grid_distance(pos, Coord.origin())
end
