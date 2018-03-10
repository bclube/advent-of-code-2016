defmodule AOC.Day12 do
  defmodule State do
    defstruct next_instruction: 0,
              a: 0,
              b: 0,
              c: 0,
              d: 0
  end

  defmodule XForm do
    def identity(%State{} = state), do: state

    def inc_next_instruction(%State{} = state),
      do: Map.update!(state, :next_instruction, &(&1 + 1))

    def inc(%State{} = state, register), do: Map.update!(state, register, &(&1 + 1))

    def dec(%State{} = state, register), do: Map.update!(state, register, &(&1 - 1))

    def set_register(%State{} = state, register, value), do: Map.put(state, register, value)

    def copy_register(%State{} = state, from_reg, to_reg) do
      v = Map.get(state, from_reg)

      Map.put(state, to_reg, v)
    end

    def jump_reg_not_zero(%State{} = state, reg, distance) do
      v = Map.get(state, reg)

      if 0 == v,
        do: state,
        else: jump(state, distance)
    end

    def jump(state, distance),
      do: %{state | next_instruction: state.next_instruction + distance - 1}
  end

  defmodule Parse do
    def parse_instructions(instructions) do
      instructions
      |> String.split(~r/\n/, trim: true)
      |> Stream.map(&parse_instruction/1)
      |> Stream.with_index()
      |> Stream.map(fn {v, i} -> {i, v} end)
      |> Map.new()
    end

    defp parse_instruction("cpy " <> rest) do
      Regex.scan(~r/\S+/, rest)
      |> Enum.map(fn [v] -> try_parse_int(v) end)
      |> case do
        [val, reg] when is_integer(val) -> &XForm.set_register(&1, reg, val)
        [from_reg, to_reg] -> &XForm.copy_register(&1, from_reg, to_reg)
      end
    end

    defp parse_instruction("inc " <> rest), do: &XForm.inc(&1, String.to_atom(rest))

    defp parse_instruction("dec " <> rest), do: &XForm.dec(&1, String.to_atom(rest))

    defp parse_instruction("jnz " <> rest) do
      Regex.scan(~r/\S+/, rest)
      |> Enum.map(fn [v] -> try_parse_int(v) end)
      |> case do
        [cmp, dist] when 0 == cmp and is_integer(dist) ->
          if cmp != 0,
            do: &XForm.jump(&1, dist),
            else: &XForm.identity/1

        [reg, dist] when is_integer(dist) ->
          &XForm.jump_reg_not_zero(&1, reg, dist)
      end
    end

    defp try_parse_int(str) do
      if str =~ ~r/-?\d+/,
        do: String.to_integer(str),
        else: String.to_atom(str)
    end
  end

  defp solve_day_12(instructions, state_xform) do
    instr = Parse.parse_instructions(instructions)
    init_state = state_xform.(%State{})

    Stream.unfold(init_state, fn st ->
      case Map.get(instr, st.next_instruction) do
        f when is_function(f) ->
          new_st =
            st
            |> XForm.inc_next_instruction()
            |> f.()

          {st, new_st}

        nil ->
          nil
      end
    end)
    |> Enum.reduce(fn v, _acc -> v.a end)
  end

  def solve_12a(instructions), do: solve_day_12(instructions, &XForm.identity/1)

  def solve_12b(instructions), do: solve_day_12(instructions, &XForm.set_register(&1, :c, 1))
end
