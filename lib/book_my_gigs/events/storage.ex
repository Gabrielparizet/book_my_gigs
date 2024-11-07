defmodule BookMyGigs.Events.Storage do
  @moduledoc """
  Module providing functionalities to interact with the events table and its join tables.
  """

  import Ecto.Query

  alias BookMyGigs.Events.Storage.Event
  alias BookMyGigs.Events.Storage.EventGenre
  alias BookMyGigs.Genres
  alias BookMyGigs.Locations
  alias BookMyGigs.Repo
  alias BookMyGigs.Types
  alias BookMyGigs.Utils

  def get_events() do
    Event
    |> Repo.all()
    |> Enum.map(&Repo.preload(&1, [:location, :type, :genres, :user]))
  end

  def get_event_by_id(id) do
    Event
    |> Repo.get_by(%{id: id})
    |> Repo.preload([:location, :type, :genres, :user])
  end

  def create_event(event_params, user_id) do
    params = %{
      user_id: user_id,
      date_and_time: Utils.DateUtils.parse_date_and_time(event_params["date_and_time"]),
      venue: event_params["venue"],
      title: event_params["title"],
      description: event_params["description"],
      address: event_params["address"],
      url: event_params["url"],
      location_id: get_location_id(event_params["location"]),
      type_id: get_type_id(event_params["type"]),
      genres_ids: Enum.map(event_params["genres"], &get_genre_id(&1))
    }

    case %Event{} |> Event.changeset(params) |> Repo.insert() do
      {:ok, event} ->
        # Associate genres
        Enum.each(params.genres_ids, fn genre_id ->
          %EventGenre{
            event_id: event.id,
            genre_id: genre_id
          }
          |> Repo.insert!()
        end)

        {:ok, Repo.preload(event, [:location, :type, :genres, :user])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_events_by_user(user_id) do
    Event
    |> where(user_id: ^user_id)
    |> Repo.all()
    |> Enum.map(&Repo.preload(&1, [:location, :type, :genres, :user]))
  end

  defp get_location_id(location_name) do
    location_name
    |> Locations.get_location_by_city!()
    |> Map.get(:id)
  end

  defp get_type_id(type_name) do
    Types.get_type_by_name(type_name)
    |> Map.get(:id)
  end

  defp get_genre_id(genre_name) do
    Genres.get_genre_by_name(genre_name)
    |> Map.get(:id)
  end
end
