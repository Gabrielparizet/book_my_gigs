defmodule BookMyGigs.Locations.Storage do
  @moduledoc """
  Module providing functionalities to interact with the locations table.
  """

  alias BookMyGigs.Locations.Storage
  alias BookMyGigs.Repo

  def get_locations() do
    case Repo.all(Storage.Location) do
      [] -> {:error, "Failed to fetch locations"}
      locations -> {:ok, locations}
    end
  end

  def get_location_by_city!(city_name) do
    Repo.get_by(Storage.Location, city: city_name)
  end
end
