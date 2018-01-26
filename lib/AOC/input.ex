defmodule AOC.Input do
  @cookie System.get_env("cookie")
  || throw "Don't forget to set cookie (i.e. > export cookie=\"cookie-value\""

  def get_input(day) when day in 1..25 do
    {:ok, %{body: body}} = HTTPoison.get("http://adventofcode.com/2016/day/#{day}/input", ["Cookie": @cookie])
    body
  end
end
