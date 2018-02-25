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

    def empty_floor, do: <<0::16>>

    def floor(generators, microchips) do
      gen = construct(generators)
      mic = construct(microchips)

      <<gen::8, mic::8>>
    end

    defp construct(elements) do
      elements
      |> Stream.map(&Map.fetch!(@vals, &1))
      |> Enum.reduce(0, &bor/2)
    end
  end

  defmodule Rules do
    def win?(<<4::8, x::8, x::8, 0::48>>), do: true
    def win?(_), do: false

    def valid_floor?(floor) do
      case <<floor::16>> do
        <<0::8, _microchips::8>> ->
          true

        <<generators::8, microchips::8>> ->
          0 == (microchips ^^^ generators &&& microchips)
      end
    end
  end

  defp start_state do
    loc = 1
    floor4 = State.empty_floor()
    floor3 = State.empty_floor()

    floor2 =
      State.floor([], [
        :polonium,
        :promethium
      ])

    floor1 =
      State.floor(
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

    <<loc::8>> <> floor4 <> floor3 <> floor2 <> floor1
  end

  defp start_state_b do
    loc = 1
    floor4 = State.empty_floor()
    floor3 = State.empty_floor()

    floor2 =
      State.floor([], [
        :polonium,
        :promethium
      ])

    floor1 =
      State.floor(
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

    <<loc::8>> <> floor4 <> floor3 <> floor2 <> floor1
  end

  def next(1), do: [2]
  def next(2), do: [3, 1]
  def next(3), do: [4, 2]
  def next(4), do: [3]

  def combinations(<<generators::8, microchips::8>>) do
    bits = Enum.map(0..7, &bsl(1, &1))
    both = generators &&& microchips

    gen_bits =
      bits
      |> Stream.map(&band(generators, &1))
      |> Enum.reject(&(&1 == 0))

    micro_bits =
      bits
      |> Stream.map(&band(microchips, &1))
      |> Enum.reject(&(&1 == 0))

    gen_micro =
      bits
      |> Stream.map(&band(both, &1))
      |> Stream.reject(&(&1 == 0))
      |> Stream.map(fn v ->
        <<vv::16>> = <<v::8, v::8>>
        vv
      end)

    two_gen =
      gen_bits
      |> Stream.iterate(&Enum.drop(&1, 1))
      |> Stream.take_while(fn l -> not Enum.empty?(l) end)
      |> Stream.flat_map(fn [v | vs] ->
        Stream.map(vs, fn v2 ->
          combined = v ||| v2
          <<vv::16>> = <<combined::8, 0::8>>
          vv
        end)
      end)

    two_micro =
      micro_bits
      |> Stream.iterate(&Enum.drop(&1, 1))
      |> Stream.take_while(fn l -> not Enum.empty?(l) end)
      |> Stream.flat_map(fn [v | vs] ->
        Stream.map(vs, fn v2 ->
          combined = v ||| v2
          <<vv::16>> = <<0::8, combined::8>>
          vv
        end)
      end)

    one_gen =
      gen_bits
      |> Stream.map(fn v ->
        <<vv::16>> = <<v::8, 0::8>>
        vv
      end)

    one_micro =
      micro_bits
      |> Stream.map(fn v ->
        <<vv::16>> = <<0::8, v::8>>
        vv
      end)

    Enum.concat([
      gen_micro,
      two_gen,
      two_micro,
      one_gen,
      one_micro
    ])
  end

  def get_floor(1, floor1, _f2, _f3, _f4), do: floor1
  def get_floor(2, _f1, floor2, _f3, _f4), do: floor2
  def get_floor(3, _f1, _f2, floor3, _f4), do: floor3
  def get_floor(4, _f1, _f2, _f3, floor4), do: floor4

  def update_floor(<<_loc::8, floor4::16, floor3::16, floor2::16, _floor1::16>>, 1, floor),
    do: <<1::8, floor4::16, floor3::16, floor2::16, floor::16>>

  def update_floor(<<_loc::8, floor4::16, floor3::16, _floor2::16, floor1::16>>, 2, floor),
    do: <<2::8, floor4::16, floor3::16, floor::16, floor1::16>>

  def update_floor(<<_loc::8, floor4::16, _floor3::16, floor2::16, floor1::16>>, 3, floor),
    do: <<3::8, floor4::16, floor::16, floor2::16, floor1::16>>

  def update_floor(<<_loc::8, _floor4::16, floor3::16, floor2::16, floor1::16>>, 4, floor),
    do: <<4::8, floor::16, floor3::16, floor2::16, floor1::16>>

  def next_moves(<<loc::8, floor4::16, floor3::16, floor2::16, floor1::16>> = state) do
    floor = get_floor(loc, floor1, floor2, floor3, floor4)
    combos = combinations(<<floor::16>>)
    next_loc = next(loc)

    for n_loc <- next_loc,
        n_floor = get_floor(n_loc, floor1, floor2, floor3, floor4),
        cargo <- combos,
        from_floor = floor ^^^ cargo,
        Rules.valid_floor?(from_floor),
        to_floor = n_floor ||| cargo,
        Rules.valid_floor?(to_floor),
        do:
          state
          |> update_floor(loc, from_floor)
          |> update_floor(n_loc, to_floor)
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

  def solve_11a, do: start_state() |> solve_day_ll()

  def solve_11b, do: start_state_b() |> solve_day_ll()
end
