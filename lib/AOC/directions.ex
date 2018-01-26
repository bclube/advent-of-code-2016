defmodule AOC.Directions do
  def origin, do: {0, 0}

  def north, do: {1, 0}
  def south, do: {-1, 0}
  def east, do: {0, 1}
  def west, do: {0, -1}

  def turn_right({dx, dy}), do: {-dy, dx}
  def turn_left({dx, dy}), do: {dy, -dx}

  def move_forward(n, {x, y}, {dx, dy}), do: {x+dx*n, y+dy*n}
end
