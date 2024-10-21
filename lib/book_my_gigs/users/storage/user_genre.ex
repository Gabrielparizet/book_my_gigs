defmodule BookMyGigs.Users.Storage.UserGenre do
  @moduledoc """
  The Ecto Schema for the users_genres join table
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Users.Storage.User
  alias BookMyGigs.Genres.Storage.Genre

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users_genres" do
    belongs_to(:user, User, type: Ecto.UUID)
    belongs_to(:genre, Genre, type: Ecto.UUID)

    timestamps(type: :utc_datetime)
  end

  def changeset(user_genre, attrs) do
    user_genre
    |> cast(attrs, [:user_id, :genre_id])
    |> validate_required([:user_id, :genre_id])
    |> unique_constraint(:user_id, :genre_id)
  end
end
