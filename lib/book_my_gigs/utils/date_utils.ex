defmodule BookMyGigs.Utils.DateUtils do
  @moduledoc """
  Function utils to parse and work with dates
  """

  def parse_date(date_string) do
    [day, month, year] = String.split(date_string, "/")
    [year, month, day] = Enum.map([year, month, day], &String.to_integer/1)
    Date.new!(year, month, day)
  end

  def parse_date_and_time(date_time_values) do
    date = parse_date(date_time_values["date"])

    [hour, minute] = String.split(date_time_values["time"], ":")

    NaiveDateTime.new!(date, Time.new!(String.to_integer(hour), String.to_integer(minute), 00))
  end
end
