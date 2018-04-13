defmodule AOC.Day19 do
  defp remove_n(q, n) do
    {es, qq} =
      q
      |> Stream.unfold(fn qq ->
        {_e, new_q} = all = :queue.out(qq)
        {all, new_q}
      end)
      |> Stream.take(n)
      |> Enum.unzip()

    {es, List.last(qq)}
  end

  defp rotate(q) do
    case :queue.out(q) do
      {{:value, e}, new_q} -> :queue.in(e, new_q)
      {:empty, new_q} -> new_q
    end
  end

  defp rotate_n(q, n) do
    {es, new_q} = remove_n(q, n)
    new_q = rotate(new_q)

    {es, new_q}
  end

  defp solve_day_19(q, n) do
    q
    |> Stream.unfold(&rotate_n(&1, n))
    |> Stream.concat()
    |> Stream.take_while(&match?({:value, _e}, &1))
    |> Enum.reduce(fn a, _ -> a end)
    |> fn {:value, e} -> e end.()
  end

  def solve_19a(n) when n > 0 do
    1..n
    |> Enum.to_list()
    |> :queue.from_list()
    |> rotate()
    |> solve_day_19(1)
  end

  def solve_19b(n) when n > 0 do
    split = div(n, 2)
    tl = (split + 1)..n |> Stream.take_while(&(&1 <= n))
    hd = 1..split |> Stream.take_while(&(&1 < n))

    Enum.concat(tl, hd)
    |> :queue.from_list()
    |> fn q -> # Ensure we always start with an even number of elements in the circle.
      if rem(n, 2) === 0,
        do: q,
        else: :queue.in_r(:placeholder, q)
    end.()
    |> solve_day_19(2)
  end
end
