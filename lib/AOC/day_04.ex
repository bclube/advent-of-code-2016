defmodule AOC.Day04 do
  defmodule Parse do
    def parse_input(input) do
      Regex.scan(~r|([a-z-]+)-(\d+)\[([a-z]+)\]|, input, capture: :all_but_first)
      |> Stream.map(&parse_room/1)
    end

    defp parse_room([encrypted_name, sector_id, checksum]) do
      {
        encrypted_name,
        String.to_integer(sector_id),
        checksum
      }
    end
  end

  defmodule Solve do
    def sum_valid_sector_ids(rooms) do
      rooms
      |> Stream.flat_map(fn {encrypted_name, sector_id, checksum} ->
        if valid_room_checksum?(encrypted_name, checksum),
          do: [sector_id],
          else: []
      end)
      |> Enum.sum()
    end

    defp valid_room_checksum?(encrypted_name, checksum) do
      calculate_checksum(encrypted_name) == checksum
    end

    def decrypt_name(encrypted_name, shift_amount) do
      encrypted_name
      |> String.to_charlist()
      |> Enum.map(&shift_letter(&1, shift_amount))
      |> List.to_string()
    end

    defp shift_letter(?-, _shift_amount), do: " "

    defp shift_letter(letter, shift_amount) do
      shifted =
        (letter - ?a + shift_amount)
        |> rem(26)

      shifted + ?a
    end

    def calculate_checksum(encrypted_name) do
      encrypted_name
      |> String.codepoints()
      |> Stream.reject(fn v -> v == "-" end)
      |> Enum.reduce(%{}, &Map.update(&2, &1, 1, fn v -> v + 1 end))
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Enum.sort_by(&elem(&1, 0), &>/2)
      |> Stream.map(&elem(&1, 1))
      |> Stream.flat_map(&Enum.sort/1)
      |> Stream.take(5)
      |> Enum.join()
    end
  end

  def solve_4a(input) do
    input
    |> Parse.parse_input()
    |> Solve.sum_valid_sector_ids()
  end

  def solve_4b(input) do
    input
    |> Parse.parse_input()
    |> Enum.find_value(fn {e, s, _c} ->
      if e |> Solve.decrypt_name(s) |> String.match?(~r/object storage/), do: s
    end)
  end
end
