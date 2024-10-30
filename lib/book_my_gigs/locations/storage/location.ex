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
    field(:name, :string)

    has_many(:users, User)
    has_many(:events, Event)

    timestamps(type: :utc_datetime)
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
