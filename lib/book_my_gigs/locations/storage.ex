defmodule BookMyGigs.Locations.Storage do
  @moduledoc """
  Module providing functionalities to interact with the locations table.
  """

  alias BookMyGigs.Locations.Storage
  alias BookMyGigs.Repo

  def get_location_by_city!(city_name) do
    Repo.get_by(Storage.Location, city: city_name)
  end
end
