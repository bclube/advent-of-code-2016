defmodule AOC.Grid do
  defmodule Coord do
    defstruct row: 0,
              col: 0

    def new(r, c) when is_integer(r) and is_integer(c),
      do: %__MODULE__{row: r, col: c}

    def origin, do: new(0, 0)

    def grid_distance(%Coord{row: a_row, col: a_col}, %Coord{row: b_row, col: b_col}),
      do: abs(b_row - a_row) + abs(b_col - a_col)
  end

  defmodule Vector do
    defstruct d_row: 0,
              d_col: 0

    def new(dr, dc) when is_integer(dr) and is_integer(dc),
      do: %__MODULE__{d_row: dr, d_col: dc}
  end

  defmodule Direction do
    @next_row Vector.new(1, 0)
    @prev_row Vector.new(-1, 0)
    @next_col Vector.new(0, 1)
    @prev_col Vector.new(0, -1)

    def next_row, do: @next_row
    def prev_row, do: @prev_row
    def next_col, do: @next_col
    def prev_col, do: @prev_col

    # Aliases
    def north, do: @prev_row
    def south, do: @next_row
    def east, do: @next_col
    def west, do: @prev_col
  end

  defmodule Turn do
    @right :right
    @left :left

    @right_turn_lookup [
                         Direction.north(),
                         Direction.east(),
                         Direction.south(),
                         Direction.west(),
                         Direction.north()
                       ]
                       |> Stream.chunk_every(2, 1, :discard)
                       |> Map.new(&List.to_tuple/1)

    @left_turn_lookup Map.new(@right_turn_lookup, fn {k, v} -> {v, k} end)

    def right, do: @right
    def left, do: @left

    def turn(dir, @right), do: Map.fetch!(@right_turn_lookup, dir)
    def turn(dir, @left), do: Map.fetch!(@left_turn_lookup, dir)
  end

  defmodule Move do
    def step(%Coord{} = pos, %Vector{} = dir),
      do: Coord.new(pos.row + dir.d_row, pos.col + dir.d_col)

    def move(%Coord{} = pos, %Vector{} = dir, n),
      do: Coord.new(pos.row + dir.d_row * n, pos.col + dir.d_col * n)
  end
end
