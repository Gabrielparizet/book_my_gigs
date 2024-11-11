defmodule BookMyGigs.Locations do
  @moduledoc """
  The locations context
  """

  alias BookMyGigs.Locations.Storage

  defmodule Location do
    @moduledoc """
    Module defining the context struct for a location.
    """

    @derive Jason.Encoder

    defstruct [:id, :city, :region, :country, :country_code]

    @type id :: String.t()
    @type t :: %__MODULE__{
            id: String.t(),
            city: String.t(),
            region: String.t(),
            country: String.t(),
            country_code: String.t()
          }
  end

  def get_locations() do
    case Storage.get_locations() do
      {:ok, locations} ->
        {:ok, Enum.map(locations, &to_context_struct/1)}

      {:error, msg} ->
        {:error, msg}
    end
  end

  def get_location_by_city!(city_name) do
    city_name
    |> Storage.get_location_by_city!()
    |> to_context_struct()
  end

  defp to_context_struct(%Storage.Location{} = index_db) do
    struct(Location, Map.from_struct(index_db))
  end
end
