defmodule AOC.Day13 do
  alias AOC.Grid.{Coord, Direction, Move}

  defmodule Maze do
    use Bitwise

    def new(n, max_x, max_y) do
      for y <- 0..max_y,
          yy = y * (y + 1) + n,
          x <- 0..max_x,
          xx = x * (3 + x + 2 * y) + yy,
          0 === for(<<1::1 <- :binary.encode_unsigned(xx)>>, do: 1) |> Enum.reduce(0, &bxor/2),
          do: Coord.new(x, y),
          into: MapSet.new()
    end
  end

  defp next_steps(pos) do
    [
      Direction.south(),
      Direction.east(),
      Direction.north(),
      Direction.west()
    ]
    |> Enum.map(&Move.step(pos, &1))
  end

  defp walk_day_13_map(n) do
    start = Coord.new(1, 1)

    {
      :queue.from_list([{start, 0}]),
      Maze.new(n, 99, 99) |> MapSet.delete(start)
    }
    |> Stream.unfold(fn {q, unvisited} ->
      case :queue.out(q) do
        {{:value, {pos, path_len} = v}, new_q} ->
          next = pos |> next_steps() |> Enum.filter(&MapSet.member?(unvisited, &1))
          new_queue = Enum.reduce(next, new_q, &:queue.in({&1, path_len + 1}, &2))
          new_unvisited = Enum.reduce(next, unvisited, &MapSet.delete(&2, &1))

          {v, {new_queue, new_unvisited}}

        {:empty, _new_q} ->
          nil
      end
    end)
  end

  def solve_13a(n, {dest_x, dest_y}) do
    dest = Coord.new(dest_x, dest_y)

    walk_day_13_map(n)
    |> Enum.find_value(-1, fn
      {^dest, path_len} -> path_len
      _ -> nil
    end)
  end

  def solve_13b(n) do
    walk_day_13_map(n)
    |> Stream.take_while(fn {_, path_len} -> path_len <= 50 end)
    |> Enum.count()
  end
end
