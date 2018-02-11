defmodule AOC.Day09 do
  defmodule Solve do
    def decompressed_length(input, :single_pass), do: count_decompressed_length(input, true)
    def decompressed_length(input), do: count_decompressed_length(input, false)

    defp count_decompressed_length("", _single_pass?), do: 0

    defp count_decompressed_length(file, single_pass?) do
      case Regex.run(~r/^([^\(]*)(?:\((\d+)x(\d+)\)(.*))?$/, file, capture: :all_but_first) do
        [chars, n_chars, replications, rest] ->
          n_chars = String.to_integer(n_chars)
          replications = String.to_integer(replications)
          {seg, rest} = String.split_at(rest, n_chars)

          if not single_pass?,
            do:
              String.length(chars) + replications * count_decompressed_length(seg, single_pass?) +
                count_decompressed_length(rest, single_pass?),
            else:
              String.length(chars) + replications * String.length(seg) +
                count_decompressed_length(rest, single_pass?)

        [chars] ->
          String.length(chars)
      end
    end
  end

  def solve_9a(input), do: Solve.decompressed_length(input, :single_pass)
  def solve_9b(input), do: Solve.decompressed_length(input)
end
