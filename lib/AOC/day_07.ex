defmodule AOC.Day07 do
  defmodule Solve do
    def supports_tls?(ip_address) do
      has_abba_outside_of_brackets?(ip_address) and not has_abba_within_brackets?(ip_address)
    end

    defp contains_abba_pattern?(s), do: Regex.match?(~r/(.)(?!\1)(.)\2\1/, s)

    defp has_abba_within_brackets?(ip_address) do
      Regex.scan(~r/\[([^\]]*)\]/, ip_address, capture: :all_but_first)
      |> Stream.concat()
      |> Enum.any?(&contains_abba_pattern?/1)
    end

    defp has_abba_outside_of_brackets?(ip_address) do
      Regex.scan(~r/(?:^|\])([^\[]*)(?:$|\[)/, ip_address, capture: :all_but_first)
      |> Stream.concat()
      |> Enum.any?(&contains_abba_pattern?/1)
    end
  end

  def solve_7a(input) do
    input
    |> String.split()
    |> Enum.count(&Solve.supports_tls?/1)
  end
end
