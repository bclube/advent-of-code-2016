defmodule AOC.Day17 do
  alias AOC.Grid.{
    Coord,
    Direction,
    Move
  }

  @valid_positions for r <- 0..3,
                       c <- 0..3,
                       do: Coord.new(r, c),
                       into: MapSet.new()

  defp next_moves(key, path, pos) do
    for(<<x::4 <- :crypto.hash(:md5, key <> path)>>, do: x)
    |> Stream.zip([
      {"U", Direction.up()},
      {"D", Direction.down()},
      {"L", Direction.left()},
      {"R", Direction.right()}
    ])
    |> Stream.flat_map(fn
      {v, d} when v > 10 -> [d]
      _ -> []
    end)
    |> Stream.map(fn {d, dr} -> {path <> d, Move.step(pos, dr)} end)
    |> Stream.filter(fn {_d, dr} -> MapSet.member?(@valid_positions, dr) end)
  end

  defp solve_day_17(key) do
    start_pos = Coord.new(0, 0)
    vault_pos = Coord.new(3, 3)

    :queue.from_list([{"", start_pos}])
    |> Stream.unfold(fn q ->
      case :queue.out(q) do
        {{:value, {path, ^vault_pos}}, new_q} ->
          {[path], new_q}

        {{:value, {path, pos}}, new_q} ->
          new_queue =
            next_moves(key, path, pos)
            |> Enum.reduce(new_q, &:queue.in(&1, &2))

          {[], new_queue}

        {:empty, _new_q} ->
          nil
      end
    end)
    |> Stream.concat()
  end

  def solve_17a(key) do
    key
    |> solve_day_17()
    |> Enum.find_value("", & &1)
  end

  def solve_17b(key) do
    key
    |> solve_day_17()
    |> Enum.reduce("", fn a, _b -> a end)
    |> String.length()
  end
end
