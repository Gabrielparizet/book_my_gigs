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

    @type t :: %__MODULE__{
            id: String.t(),
            region: String.t(),
            country: String.t(),
            country_code: String.t()
          }
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
