defmodule AOC.Day10 do
  defmodule Parse do
    def parse_instruction("bot" <> rest) do
      bot_id =
        Regex.run(~r/\d+/, rest)
        |> List.first()
        |> String.to_integer()

      [lo_target, hi_target] =
        Regex.scan(~r/(bot|output) (\d+)/, rest, capture: :all_but_first)
        |> Enum.map(fn [target, id] -> {String.to_atom(target), String.to_integer(id)} end)

      {:bot, bot_id, [], hi_target, lo_target}
    end

    def parse_instruction("value" <> rest) do
      [val, bot_id] =
        Regex.scan(~r/\d+/, rest)
        |> Stream.concat()
        |> Enum.map(&String.to_integer/1)

      {:put, val, {:bot, bot_id}}
    end
  end

  defp solve_day_10(input) do
    input
    |> String.split(~r/\n/, trim: true)
    |> Stream.map(&Parse.parse_instruction/1)
    |> Enum.reduce({[], %{}}, fn
      {:bot, bot_id, _, _, _} = bot, {puts, bots} -> {puts, Map.put(bots, bot_id, bot)}
      {:put, _, _} = put, {puts, bots} -> {[put | puts], bots}
    end)
    |> Stream.unfold(fn
      {[], _bots} ->
        nil

      {[{:put, _val, {:output, _output_id}} = put | puts], bots} ->
        {put, {puts, bots}}

      {[{:put, val, {:bot, bot_id}} | puts], bots} ->
        {:bot, bot_id, vals, hi_target, lo_target} = Map.get(bots, bot_id)
        new_vals = [val | vals] |> Enum.sort()
        new_bot = {:bot, bot_id, new_vals, hi_target, lo_target}
        new_bots = Map.put(bots, bot_id, new_bot)

        case new_vals do
          [_v] ->
            {new_bot, {puts, new_bots}}

          [mn, mx] ->
            new_puts = [{:put, mn, lo_target}, {:put, mx, hi_target} | puts]
            {new_bot, {new_puts, new_bots}}
        end
    end)
  end

  def solve_10a(input) do
    input
    |> solve_day_10()
    |> Enum.find_value(fn
      {:bot, bot_id, [17, 61], _, _} -> bot_id
      _ -> nil
    end)
  end

  def solve_10b(input) do
    input
    |> solve_day_10()
    |> Stream.flat_map(fn
      {:put, val, {:output, output_id}} when output_id in 0..2 -> [val]
      _ -> []
    end)
    |> Stream.take(3)
    |> Enum.reduce(&*/2)
  end
end
