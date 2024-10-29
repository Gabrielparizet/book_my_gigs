defmodule BookMyGigs.Events.Storage.EventGenre do
  @moduledoc """
  The Ecto Schema for the events_genres join table
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Events.Storage.Event
  alias BookMyGigs.Genres.Storage.Genre

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "events_genres" do
    belongs_to(:event, Event, type: Ecto.UUID)
    belongs_to(:genre, Genre, type: Ecto.UUID)

    timestamps(type: :utc_datetime)
  end

  def changeset(event_genre, attrs) do
    event_genre
    |> cast(attrs, [:event_id, :genre_id])
    |> validate_required(:event_id, :genre_id)
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:genre_id)
  end
end
