defmodule BookMyGigs.Genres.Storage.Genre do
  @moduledoc """
  The Ecto Schema for a genre
  """

  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "genres" do
    field(:name, :string)

    timestamps(type: :utc_datetime)
  end

  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
