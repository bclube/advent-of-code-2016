defmodule AOC.Day05 do
  def solve_5a(input) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(fn v -> input <> Integer.to_string(v) end)
    |> Stream.map(&:erlang.md5/1)
    |> Stream.flat_map(fn
      <<0::size(20), c::size(4), _rest::binary>> -> [c]
      _ -> []
    end)
    |> Stream.take(8)
    |> Stream.chunk_every(2)
    |> Enum.reduce(<<>>, fn [a, b], acc -> acc <> <<a::size(4), b::size(4)>> end)
    |> Base.encode16(case: :lower)
  end
end
