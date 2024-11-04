defmodule BookMyGigs.Locations.Storage.Location do
  @moduledoc """
  The Ecto Schema for a location
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Events.Storage.Event
  alias BookMyGigs.Users.Storage.User

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "locations" do
    field(:city, :string)
    field(:region, :string)
    field(:country, :string)
    field(:country_code, :string)

    has_many(:users, User)
    has_many(:events, Event)

    timestamps(type: :utc_datetime)
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, [:city, :region, :country, :country_code])
    |> validate_required([:city, :region, :country, :country_code])
    |> validate_length(:country_code, min: 2, max: 3)
    |> validate_format(:country_code, ~r/^[A-Z]+$/)
    |> unique_constraint(:city)
  end
end
