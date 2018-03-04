defmodule AOC.Day11 do
  use Bitwise

  defmodule State do
    @vals %{
      cobalt: 1 <<< 0,
      dilithium: 1 <<< 1,
      elerium: 1 <<< 2,
      polonium: 1 <<< 3,
      promethium: 1 <<< 4,
      ruthenium: 1 <<< 5,
      thulium: 1 <<< 6
    }

    def empty_floor, do: 0

    def new_floor(generators, microchips) do
      gen = construct(generators) <<< 7
      mic = construct(microchips)

      gen + mic
    end

    defp construct(elements) do
      elements
      |> Stream.map(&Map.fetch!(@vals, &1))
      |> Enum.reduce(0, &bor/2)
    end

    @microchip_mask 0b1111111
    @floor_mask 0b11111111111111
    @floor_2_shift 14
    @floor_3_shift 28
    @floor_4_shift 42
    @loc_shift 56

    def generators(floor), do: floor >>> 7
    def microchips(floor), do: floor &&& @microchip_mask

    def win_state(state) do
      floor_4 = floor(state, 1) ||| floor(state, 2) ||| floor(state, 3) ||| floor(state, 4)

      0
      |> set_loc(4)
      |> set_floor(4, floor_4)
    end

    def loc(state), do: state >>> @loc_shift
    def floor(state, 1), do: state &&& @floor_mask
    def floor(state, 2), do: state >>> @floor_2_shift &&& @floor_mask
    def floor(state, 3), do: state >>> @floor_3_shift &&& @floor_mask
    def floor(state, 4), do: state >>> @floor_4_shift &&& @floor_mask

    @floor_1_mask 0b1111111111111111111111111111111111111111111111111100000000000000
    @floor_2_mask 0b1111111111111111111111111111111111110000000000000011111111111111
    @floor_3_mask 0b1111111111111111111111000000000000001111111111111111111111111111
    @floor_4_mask 0b1111111100000000000000111111111111111111111111111111111111111111
    @loc_mask 0b0000000011111111111111111111111111111111111111111111111111111111

    def set_loc(state, loc), do: (state &&& @loc_mask) ||| loc <<< @loc_shift
    def set_floor(state, 1, floor), do: (state &&& @floor_1_mask) ||| floor
    def set_floor(state, 2, floor), do: (state &&& @floor_2_mask) ||| floor <<< @floor_2_shift
    def set_floor(state, 3, floor), do: (state &&& @floor_3_mask) ||| floor <<< @floor_3_shift
    def set_floor(state, 4, floor), do: (state &&& @floor_4_mask) ||| floor <<< @floor_4_shift
  end

  defmodule Rules do
    def valid_floor?(floor) do
      generators = State.generators(floor)
      microchips = State.microchips(floor)
      0 == generators || 0 == (generators ^^^ microchips &&& microchips)
    end
  end

  defp start_state do
    0
    |> State.set_loc(1)
    |> State.set_floor(4, State.empty_floor())
    |> State.set_floor(3, State.empty_floor())
    |> State.set_floor(
      2,
      State.new_floor([], [
        :polonium,
        :promethium
      ])
    )
    |> State.set_floor(
      1,
      State.new_floor(
        [
          :cobalt,
          :polonium,
          :promethium,
          :ruthenium,
          :thulium
        ],
        [
          :cobalt,
          :ruthenium,
          :thulium
        ]
      )
    )
  end

  defp start_state_b do
    0
    |> State.set_loc(1)
    |> State.set_floor(4, State.empty_floor())
    |> State.set_floor(3, State.empty_floor())
    |> State.set_floor(
      2,
      State.new_floor([], [
        :polonium,
        :promethium
      ])
    )
    |> State.set_floor(
      1,
      State.new_floor(
        [
          :cobalt,
          :dilithium,
          :elerium,
          :polonium,
          :promethium,
          :ruthenium,
          :thulium
        ],
        [
          :cobalt,
          :dilithium,
          :elerium,
          :ruthenium,
          :thulium
        ]
      )
    )
  end

  def next(1), do: [2]
  def next(2), do: [3, 1]
  def next(3), do: [4, 2]
  def next(4), do: [3]

  @bits Enum.map(0..7, &bsl(1, &1))

  def combinations(floor) do
    generators = State.generators(floor)
    microchips = State.microchips(floor)

    gen_bits =
      @bits
      |> Stream.map(&band(generators, &1))
      |> Enum.reject(&(&1 == 0))

    micro_bits =
      @bits
      |> Stream.map(&band(microchips, &1))
      |> Enum.reject(&(&1 == 0))

    gen_micro =
      @bits
      |> Stream.map(&band(generators &&& microchips, &1))
      |> Stream.reject(&(&1 == 0))
      |> Stream.map(fn v -> (v <<< 7) + v end)

    two_gen =
      gen_bits
      |> Stream.iterate(&Enum.drop(&1, 1))
      |> Stream.take_while(fn l -> not Enum.empty?(l) end)
      |> Stream.flat_map(fn [v | vs] ->
        Stream.map(vs, fn v2 -> (v ||| v2) <<< 7 end)
      end)

    two_micro =
      micro_bits
      |> Stream.iterate(&Enum.drop(&1, 1))
      |> Stream.take_while(fn l -> not Enum.empty?(l) end)
      |> Stream.flat_map(fn [v | vs] ->
        Stream.map(vs, fn v2 -> v ||| v2 end)
      end)

    one_gen =
      gen_bits
      |> Stream.map(fn v -> v <<< 7 end)

    Enum.concat([
      gen_micro,
      two_gen,
      two_micro,
      one_gen,
      micro_bits
    ])
  end

  def next_moves(state) do
    loc = State.loc(state)
    floor = State.floor(state, loc)
    combos = combinations(floor)
    next_loc = next(loc)

    for n_loc <- next_loc,
        n_floor = State.floor(state, n_loc),
        cargo <- combos,
        from_floor = floor ^^^ cargo,
        Rules.valid_floor?(from_floor),
        to_floor = n_floor ||| cargo,
        Rules.valid_floor?(to_floor),
        do:
          state
          |> State.set_loc(n_loc)
          |> State.set_floor(loc, from_floor)
          |> State.set_floor(n_loc, to_floor)
  end

  defp solve_day_ll(state) do
    win_state = State.win_state(state)
    q = :queue.from_list([{state, 0}])
    seen = MapSet.new()

    Stream.unfold({q, seen}, fn {nxt, seen} ->
      case :queue.out(nxt) do
        {{:value, {st, path_len} = v}, new_q} ->
          next = next_moves(st) |> Enum.reject(&MapSet.member?(seen, &1))

          new_queue =
            Enum.reduce(next, new_q, fn nxt, q ->
              n = {nxt, path_len + 1}

              if nxt != win_state,
                do: :queue.in(n, q),
                else: :queue.in_r(n, q)
            end)

          new_seen = Enum.reduce(next, seen, &MapSet.put(&2, &1))

          {v, {new_queue, new_seen}}

        {:empty, _new_q} ->
          nil
      end
    end)
    |> Enum.find_value(fn {state, path_len} ->
      if state == win_state, do: path_len
    end)
  end

  def solve_11a, do: start_state() |> solve_day_ll()

  def solve_11b, do: start_state_b() |> solve_day_ll()
end
