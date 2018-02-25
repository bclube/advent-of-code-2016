defmodule AOC.Day11 do
  defmodule Rules do
    def win?(state) do
      state.loc == 4 &&
        1..3
        |> Stream.map(&Map.get(state, &1))
        |> Enum.all?(&Enum.empty?(&1))
    end

    def valid_state?(state) do
      1..4
      |> Stream.map(&Map.get(state, &1))
      |> Enum.all?(&valid_floor?/1)
    end

    def valid_floor?(items) do
      not has_generator(items) || not has_unpaired_microchip(items)
    end

    defp has_generator(items) do
      items
      |> Stream.map(&elem(&1, 1))
      |> Enum.any?(&match?(:generator, &1))
    end

    defp has_unpaired_microchip(items) do
      items
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Map.values()
      |> Enum.any?(&match?([:microchip], &1))
    end
  end

  defp start_state do
    %{
      :loc => 1,
      4 => MapSet.new(),
      3 => MapSet.new(),
      2 =>
        MapSet.new([
          {:polonium, :microchip},
          {:promethium, :microchip}
        ]),
      1 =>
        MapSet.new([
          {:cobalt, :generator},
          {:cobalt, :microchip},
          {:polonium, :generator},
          {:promethium, :generator},
          {:ruthenium, :generator},
          {:ruthenium, :microchip},
          {:thulium, :generator},
          {:thulium, :microchip}
        ])
    }
  end

  def next(loc) do
    Enum.filter([loc + 1, loc - 1], fn v -> v in 1..4 end)
  end

  def combinations(floor) do
    floor
    |> MapSet.to_list()
    |> Stream.iterate(&Enum.drop(&1, 1))
    |> Stream.take_while(fn l -> not Enum.empty?(l) end)
    |> Stream.flat_map(fn [v | vs] ->
      Stream.map(vs, fn v2 -> [v, v2] end)
    end)
    |> Stream.filter(&Rules.valid_floor?/1)
    |> Stream.concat(MapSet.to_list(floor) |> Stream.map(&List.wrap/1))
    |> Stream.map(&MapSet.new/1)
  end

  def next_moves(state) do
    loc = state.loc
    floor = Map.get(state, loc)
    next_loc = next(loc)

    for cargo <- combinations(floor),
        n_loc <- next_loc,
        from_floor = Map.get(state, loc) |> MapSet.difference(cargo),
        Rules.valid_floor?(from_floor),
        to_floor = Map.get(state, n_loc) |> MapSet.union(cargo),
        Rules.valid_floor?(to_floor),
        do:
          %{state | loc: n_loc}
          |> Map.put(loc, from_floor)
          |> Map.put(n_loc, to_floor)
  end

  defp solve_day_ll(state) do
    q = :queue.from_list([{state, []}])
    seen = MapSet.new()

    Stream.unfold({q, seen}, fn {nxt, seen} ->
      case :queue.out(nxt) do
        {{:value, {st, pth} = v}, new_q} ->
          next = next_moves(st) |> Enum.reject(&MapSet.member?(seen, &1))

          new_queue =
            Enum.reduce(next, new_q, fn nxt, q ->
              n = {nxt, [st | pth]}

              if not Rules.win?(nxt),
                do: :queue.in(n, q),
                else: :queue.in_r(n, q)
            end)

          new_seen = Enum.reduce(next, seen, &MapSet.put(&2, &1))

          {v, {new_queue, new_seen}}

        {:empty, _new_q} ->
          nil
      end
    end)
    |> Enum.find_value(fn {state, path} ->
      if Rules.win?(state), do: path
    end)
    |> Enum.count()
  end

  def solve_11a, do: start_state()  |> solve_day_ll()
end
