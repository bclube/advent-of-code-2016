defmodule AOC.Day14 do
  defp detect_repeats(pattern) do
    ptrn = for <<x::4 <- pattern>>, do: x

    {
      find_first_3_repeat(ptrn),
      find_5_repeats(ptrn)
    }
  end

  defp find_first_3_repeat(pattern) do
    pattern
    |> Stream.chunk_every(3, 1, :discard)
    |> Enum.find_value(:none, fn
      [x, x, x] -> x
      _ -> nil
    end)
  end

  defp find_5_repeats(pattern) do
    pattern
    |> Stream.chunk_every(5, 1, :discard)
    |> Enum.flat_map(fn
      [x, x, x, x, x] -> [x]
      _ -> []
    end)
  end

  defp solve_day_14(salt, hash_fn) do
    0
    |> Stream.iterate(&(&1 + 1))
    |> Task.async_stream(fn v ->
      (salt <> Integer.to_string(v))
      |> hash_fn.()
      |> detect_repeats()
    end)
    |> Stream.map(fn {:ok, v} -> v end)
    |> Stream.with_index()
    |> Stream.transform({:queue.new(), Map.new()}, fn {{_m3, m5s} = v, i}, {q, s} ->
      q_plus = :queue.in(v, q)
      s_plus = Enum.reduce(m5s, s, &Map.update(&2, &1, 1, fn v -> v + 1 end))

      if i >= 1000 do
        {{:value, {mm3, mm5s}}, new_q} = :queue.out(q_plus)
        new_s = Enum.reduce(mm5s, s_plus, &Map.update(&2, &1, -1, fn v -> v - 1 end))

        {[{mm3, new_s}], {new_q, new_s}}
      else
        {[], {q_plus, s_plus}}
      end
    end)
    |> Stream.with_index()
    |> Stream.reject(&match?({{:none, _}, _}, &1))
    |> Stream.filter(fn {{v, m5s}, _i} -> 0 < Map.get(m5s, v, -1) end)
    |> Stream.drop(63)
    |> Enum.find_value(fn {_, i} -> i end)
  end

  defp stretched_hash(v) do
    v
    |> :erlang.md5()
    |> Stream.iterate(&(&1 |> Base.encode16(case: :lower) |> :erlang.md5()))
    |> Stream.drop(2016)
    |> Enum.find_value(& &1)
  end

  def solve_14a(salt), do: solve_day_14(salt, &:erlang.md5/1)

  def solve_14b(salt), do: solve_day_14(salt, &stretched_hash/1)
end
