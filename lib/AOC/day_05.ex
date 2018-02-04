defmodule AOC.Day05 do
  def solve_5a(input) do
    input
    |> find_interesting_hashes()
    |> Stream.map(fn %{sixth_char: v} -> v end)
    |> Stream.take(8)
    |> Stream.chunk_every(2)
    |> Enum.reduce(<<>>, fn [a, b], acc -> acc <> <<a::size(4), b::size(4)>> end)
    |> Base.encode16(case: :lower)
  end

  defp find_interesting_hashes(input) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(fn v -> input <> Integer.to_string(v) end)
    |> Stream.map(&:erlang.md5/1)
    |> Stream.flat_map(fn
      <<0::size(20), sixth_char::size(4), seventh_char::size(4), _::size(4), _rest::binary>> ->
        [%{sixth_char: sixth_char, seventh_char: seventh_char}]
      _ -> []
    end)
  end
end
