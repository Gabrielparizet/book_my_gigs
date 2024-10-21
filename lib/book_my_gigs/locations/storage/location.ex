defmodule BookMyGigs.Locations.Storage.Location do
  @moduledoc """
  The Ecto Schema for a location
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Users.Storage.User
  alias BookMyGigs.Users.Storage.UserLocation

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "locations" do
    field(:name, :string)

    many_to_many(:users, User, join_through: UserLocation)

    timestamps(type: :utc_datetime)
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
