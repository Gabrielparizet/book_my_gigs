defmodule BookMyGigs.Utils.DateUtils do
  @moduledoc """
  Function utils to parse and work with dates
  """

  def parse_date(date_string) do
    with [day, month, year] <- String.split(date_string, "/"),
      {day, ""} <- Integer.parse(day),
      {month, ""} <- Integer.parse(month),
      {year, ""} <- Integer.parse(year) do
        Date.new(year, month, day)
      else
        _ -> :error
      end
  end
end
