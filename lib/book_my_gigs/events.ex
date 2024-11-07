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

  def create_event(%{"event" => event_params}, user_id) do
    {:ok, event} = Storage.create_event(event_params, user_id)
    to_context_struct(event)
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
end
