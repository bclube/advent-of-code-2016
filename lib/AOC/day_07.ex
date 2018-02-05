defmodule AOC.Day07 do
  defmodule Solve do
    def supports_tls?(ip_address),
      do: has_abba_outside_of_brackets?(ip_address) and not has_abba_within_brackets?(ip_address)

    def supports_ssl?(ip_address) do
      supernet_patterns =
        ip_address
        |> supernet_sequences()
        |> Stream.flat_map(&aba_patterns/1)
        |> MapSet.new()

      ip_address
      |> hypernet_sequences()
      |> Stream.flat_map(&aba_patterns/1)
      |> Stream.map(&Enum.reverse/1)
      |> Enum.any?(&MapSet.member?(supernet_patterns, &1))
    end

    defp contains_abba_pattern?(s), do: Regex.match?(~r/(.)(?!\1)(.)\2\1/, s)
    defp aba_patterns(s), do: Regex.scan(~r/(?<a>.)(?=(?!\1)(?<b>.)\1)/, s, capture: ["a", "b"])

    @bracketed_regex ~r/\[([^\[]*)\]/

    defp supernet_sequences(ip_address), do: String.split(ip_address, @bracketed_regex)

    defp hypernet_sequences(ip_address),
      do: Regex.scan(@bracketed_regex, ip_address, capture: :all_but_first) |> Stream.concat()

    defp has_abba_within_brackets?(ip_address) do
      ip_address
      |> hypernet_sequences()
      |> Enum.any?(&contains_abba_pattern?/1)
    end

    defp has_abba_outside_of_brackets?(ip_address) do
      ip_address
      |> supernet_sequences()
      |> Enum.any?(&contains_abba_pattern?/1)
    end
  end

  defp solve_day_7(input, filter_fn) do
    input
    |> String.split()
    |> Enum.count(filter_fn)
  end

  def solve_7a(input), do: solve_day_7(input, &Solve.supports_tls?/1)
  def solve_7b(input), do: solve_day_7(input, &Solve.supports_ssl?/1)
end
