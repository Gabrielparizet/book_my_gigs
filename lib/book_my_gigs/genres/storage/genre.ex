defmodule BookMyGigs.Genres.Storage.Genre do
  @moduledoc """
  The Ecto Schema for a genre
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Users.Storage.User
  alias BookMyGigs.Users.Storage.UserGenre

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "genres" do
    field(:name, :string)

    many_to_many(:users, User, join_through: UserGenre)

    timestamps(type: :utc_datetime)
  end

  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
