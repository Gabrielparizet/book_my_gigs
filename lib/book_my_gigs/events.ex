defmodule BookMyGigs.Events do
  @moduledoc """
    The events context
  """

  alias BookMyGigs.Events.Storage
  alias BookMyGigs.Users

  defmodule Event do
    @moduledoc """
    Module defining the context struct for an event
    """

    @derive Jason.Encoder

    defstruct [
      :id,
      :date_and_time,
      :venue,
      :title,
      :description,
      :address,
      :url,
      :user_id,
      :user,
      :location,
      :type,
      :genres
    ]

    @type id :: String.t()
    @type t :: %__MODULE__{
            id: String.t(),
            date_and_time: Date.t(),
            venue: String.t(),
            title: String.t(),
            description: String.t(),
            address: String.t(),
            url: String.t(),
            user_id: Users.User.id(),
            user: String.t(),
            location: String.t(),
            type: String.t(),
            genres: [String.t()]
          }
  end

  def get_events() do
    Storage.get_events()
    |> Enum.map(&to_context_struct(&1))
  end

  def get_event_by_id(event_id) do
    event_id
    |> Storage.get_event_by_id()
    |> to_context_struct()
  end

  def create_event(%{"event" => event_params}, user_id) do
    case Storage.create_event(event_params, user_id) do
      {:ok, event} ->
        {:ok, to_context_struct(event)}

      {:error, changeset} ->
        {:error, changeset_errors(changeset)}
    end
  end

  def get_events_by_user(user_id) do
    user_id
    |> Storage.get_events_by_user()
    |> Enum.map(&to_context_struct(&1))
  end

  def get_user_event_by_id(event_id, user_id) do
    event_id
    |> Storage.get_user_event_by_id(user_id)
    |> to_context_struct()
  end

  def get_events_by_location(location_name, [], nil) do
    location_name
    |> Storage.get_events_by_location()
    |> Enum.map(&to_context_struct/1)
  end

  def get_events_by_location(location_name, genre_names, nil) when is_list(genre_names) do
    location_name
    |> Storage.get_events_by_location_and_genres(genre_names)
    |> Enum.map(&to_context_struct/1)
  end

  def get_events_by_location(location_name, [], type_name) when type_name != nil do
    location_name
    |> Storage.get_events_by_location_and_type(type_name)
    |> Enum.map(&to_context_struct/1)
  end

  def get_events_by_location(location_name, genre_names, type_name)
      when is_list(genre_names) and type_name != nil do
    location_name
    |> Storage.get_events_by_location_genres_and_type(genre_names, type_name)
    |> Enum.map(&to_context_struct/1)
  end

  def update_event(params) do
    event_id = params["event_id"]
    user_id = params["user_id"]

    event_params =
      params["event"]
      |> Map.delete("user_id")
      |> Map.delete("event_id")

    event_id
    |> Storage.update_event(user_id, event_params)
    |> to_context_struct()
  end

  def delete_event(event_id, user_id) do
    Storage.delete_event(event_id, user_id)
  end

  def remove_user_from_event(event) do
    %{event | user: nil, user_id: nil}
  end

  defp to_context_struct(%Storage.Event{} = index_db) do
    storage_struct =
      index_db
      |> get_username()
      |> get_location()
      |> get_genres()
      |> get_type()

    struct(Event, Map.from_struct(storage_struct))
  end

  defp get_username(event) do
    Map.update!(event, :user, fn user ->
      case user do
        nil -> {:error, "An event must be linked to a user"}
        user -> user.username
      end
    end)
  end

  defp get_location(event) do
    Map.update!(event, :location, fn location ->
      case location do
        nil -> {:error, "An event must have a location"}
        location -> location.city
      end
    end)
  end

  defp get_genres(event) do
    Map.update!(event, :genres, fn genres ->
      case genres do
        nil ->
          {:error, "An event must have genres"}

        genres ->
          Enum.map(genres, fn genre ->
            genre.name
          end)
      end
    end)
  end

  defp get_type(event) do
    Map.update!(event, :type, fn type ->
      case type do
        nil -> {:error, "An event must have a type"}
        type -> type.name
      end
    end)
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
