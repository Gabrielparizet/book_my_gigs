defmodule BookMyGigs.Locations.Storage.Location do
  @moduledoc """
  The Ecto Schema for a Location
  """

  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "locations" do
    field(:name, :string)

    timestamps(type: :utc_datetime)
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

end
