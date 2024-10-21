defmodule BookMyGigs.Users.Storage.UserLocation do
  @moduledoc """
  The Ecto Schema for a users_locations join table
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Users.Storage.User
  alias BookMyGigs.Locations.Storage.Location

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users_locations" do
    belongs_to(:user, User, type: Ecto.UUID)
    belongs_to(:location, Location, type: Ecto.UUID)

    timestamps(type: :utc_datetime)
  end

  def changeset(user_location, attrs) do
    user_location
    |> cast(attrs, [:user_id, :location_id])
    |> validate_required([:user_id, :location_id])
    |> unique_constraint(:user_id, :locations_id)
  end
end
