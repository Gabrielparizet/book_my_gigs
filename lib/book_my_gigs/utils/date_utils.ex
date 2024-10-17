defmodule BookMyGigs.Utils.DateUtils do
  @moduledoc """
  Function utils to parse and work with dates
  """

  def parse_date(date_string) do
    [day, month, year] = String.split(date_string, "/")
    [year, month, day] = Enum.map([year, month, day], &String.to_integer/1)
    Date.new!(year, month, day)
  end
end
