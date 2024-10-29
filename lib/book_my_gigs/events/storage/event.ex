defmodule BookMyGigs.Events.Storage.Event do
  @moduledoc """
  The Ecto Schema for an event
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Events.Storage.EventGenre
  alias BookMyGigs.Genres.Storage.Genre
  alias BookMyGigs.Locations.Storage.Location
  alias BookMyGigs.Types.Storage.Type
  alias BookMyGigs.Users.Storage.User

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "events" do
    field(:date_and_time, :utc_datetime)
    field(:venue, :string)
    field(:description, :string)
    field(:address, :string)
    field(:url, :string)

    belongs_to(:user, User, type: Ecto.UUID)
    belongs_to(:location, Location, type: Ecto.UUID)
    belongs_to(:type, Type, type: Ecto.UUID)
    many_to_many(:genres, Genre, join_through: EventGenre)

    timestamps(type: :utc_datetime)
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :date_and_time,
      :venue,
      :description,
      :address,
      :url,
      :user_id,
      :location_id,
      :type_id
    ])
    |> validate_required([
      :date_and_time,
      :venue,
      :address,
      :url,
      :user_id,
      :location_id,
      :type_id
    ])
    |> validate_length(:desciption, max: 3000)
    |> validate_url(:url)
    |> unique_constraint(:url)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:location_id)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, url ->
      case URI.parse(url) do
        %URI{scheme: scheme, host: host} when not is_nil(scheme) and not is_nil(host) ->
          []

        _ ->
          [{field, "must be a valid URL"}]
      end
    end)
  end
end
