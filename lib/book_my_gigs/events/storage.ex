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

  def get_user_event_by_id(event_id, user_id) do
    Event
    |> Repo.get_by(%{id: event_id, user_id: user_id})
    |> Repo.preload([:location, :type, :genres, :user])
  end

  def get_events_by_location(location_name) do
    location_id = get_location_id(location_name)

    Event
    |> where(location_id: ^location_id)
    |> Repo.all()
    |> Enum.map(&Repo.preload(&1, [:location, :type, :genres, :user]))
  end

  def get_events_by_location_and_genres(location_name, genre_names) do
    location_id = get_location_id(location_name)
    genre_ids = Enum.map(genre_names, &get_genre_id/1)

    Event
    |> join(:inner, [e], eg in EventGenre, on: e.id == eg.event_id)
    |> where([e, eg], e.location_id == ^location_id and eg.genre_id in ^genre_ids)
    |> distinct([e], e.id)
    |> Repo.all()
    |> Enum.map(&Repo.preload(&1, [:location, :type, :genres, :user]))
  end

  def get_events_by_location_and_type(location_name, type_name) do
    location_id = get_location_id(location_name)
    type_id = get_type_id(type_name)

    Event
    |> where([e], location_id: ^location_id, type_id: ^type_id)
    |> Repo.all()
    |> Enum.map(&Repo.preload(&1, [:location, :type, :genres, :user]))
  end

  def get_events_by_location_genres_and_type(location_name, genre_names, type_name) do
    location_id = get_location_id(location_name)
    genre_ids = Enum.map(genre_names, &get_genre_id/1)
    type_id = get_type_id(type_name)

    Event
    |> join(:inner, [e], eg in EventGenre, on: e.id == eg.event_id)
    |> where(
      [e, eg],
      e.location_id == ^location_id and e.type_id == ^type_id and eg.genre_id in ^genre_ids
    )
    |> distinct([e], e.id)
    |> Repo.all()
    |> Enum.map(&Repo.preload(&1, [:location, :type, :genres, :user]))
  end

  def update_event(event_id, user_id, params) do
    event =
      Event
      |> Repo.get_by(%{id: event_id, user_id: user_id})
      |> Repo.preload([:location, :type, :genres, :user])

    changeset_params = parse_update_params(params)

    updated_event =
      event
      |> Ecto.Changeset.change(changeset_params)
      |> Repo.update!()

    if genres = Map.get(params, "genres") do
      # Delete existing associations
      Repo.delete_all(from(eg in EventGenre, where: eg.event_id == ^event_id))

      # Create new ones
      Enum.each(genres, fn genre_name ->
        %EventGenre{
          event_id: event_id,
          genre_id: get_genre_id(genre_name)
        }
        |> Repo.insert!()
      end)
    end

    updated_event |> Repo.preload([:location, :type, :genres, :user])
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

  defp parse_update_params(params) do
    %{
      address: Map.get(params, "address", nil),
      date_and_time: Map.get(params, "date_and_time", nil) |> update_event_date_and_time(),
      venue: Map.get(params, "venue", nil),
      location_id: if(loc = Map.get(params, "location"), do: get_location_id(loc)),
      title: Map.get(params, "title", nil),
      description: Map.get(params, "description", nil),
      url: Map.get(params, "url", nil),
      type_id: if(type = Map.get(params, "type"), do: get_type_id(type))
    }
    |> Enum.filter(fn {_key, val} -> not is_nil(val) end)
  end

  defp update_event_date_and_time(date_and_time) do
    case date_and_time do
      nil -> nil
      date_and_time -> Utils.DateUtils.parse_date_and_time(date_and_time)
    end
  end

  def update_event_genres(genres) do
    case genres do
      nil -> nil
      genres -> Enum.map(genres, &get_genre_id(&1))
    end
  end
end
