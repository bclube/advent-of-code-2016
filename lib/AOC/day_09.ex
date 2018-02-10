defmodule AOC.Day09 do
  defmodule Solve do
    def decompress(file), do: Stream.unfold(file, &decompress_one/1) |> Enum.join()

    defp decompress_one(""), do: nil

    defp decompress_one(file) do
      case Regex.run(~r/^([^\(]*)(?:\((\d+)x(\d+)\)(.*))?$/, file, capture: :all_but_first) do
        [chars, n_chars, replications, rest] ->
          n_chars = String.to_integer(n_chars)
          replications = String.to_integer(replications)
          {seg, rest} = String.split_at(rest, n_chars)
          repeats = for _ <- 1..replications, do: seg
          {[chars, repeats], rest}

        [chars] ->
          {chars, ""}
      end
    end

    def count_iolist_chars(io_list) when is_binary(io_list), do: String.length(io_list)

    def count_iolist_chars(io_list) when is_list(io_list),
      do: Stream.map(io_list, &count_iolist_chars/1) |> Enum.sum()
  end

  def solve_9a(input), do: Solve.decompress(input) |> Solve.count_iolist_chars()
end
