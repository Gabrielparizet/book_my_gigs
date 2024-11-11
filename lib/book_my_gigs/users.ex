defmodule BookMyGigs.Users do
  @moduledoc """
  The users context
  """

  alias BookMyGigs.Accounts
  alias BookMyGigs.Genres
  alias BookMyGigs.Locations
  alias BookMyGigs.Users.Storage
  alias BookMyGigs.Utils

  defmodule User do
    @moduledoc """
    Module defining the context struct for a user.
    """

    @derive Jason.Encoder

    defstruct [
      :id,
      :account_id,
      :username,
      :first_name,
      :last_name,
      :birthday,
      :location,
      :genres
    ]

    @type id :: String.t()
    @type t :: %__MODULE__{
            id: String.t(),
            account_id: Accounts.Account.id(),
            username: String.t(),
            first_name: String.t(),
            last_name: String.t(),
            birthday: Date.t(),
            location: String.t() | nil,
            genres: [String.t()] | nil
          }
  end

  def get_users() do
    users = Storage.get_users()

    users
    |> Enum.map(&get_user_location/1)
    |> Enum.map(&get_user_genres/1)
    |> Enum.map(&to_context_struct/1)
  end

  def get_user_by_id!(id) do
    id
    |> Storage.get_user_by_id!()
    |> get_user_location()
    |> get_user_genres()
    |> to_context_struct()
  end

  def get_user_by_account_id(account_id) do
    case Storage.get_user_by_account_id(account_id) do
      {:error, msg} ->
        {:error, msg}

      {:ok, user} ->
        {
          :ok,
          user
          |> get_user_location()
          |> get_user_genres()
          |> to_context_struct()
        }
    end
  end

  def get_user_by_username(username) do
    username
    |> Storage.get_user_by_username()
    |> get_user_location()
    |> get_user_genres()
    |> to_context_struct()
  end

  def create_user(%{"user" => user_params}, account_id) do
    case Storage.create_user(user_params, account_id) do
      {:ok, user} -> {:ok, to_context_struct(user)}
      {:error, :account_not_found} -> {:error, :account_not_found}
      {:error, changeset} -> {:error, changeset_errors(changeset)}
    end
  end

  def update_user(
        %{
          "user" => %{
            "username" => username,
            "first_name" => first_name,
            "last_name" => last_name,
            "birthday" => birthday
          }
        },
        user_id
      ) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => username,
      "account_id" => user.account_id,
      "first_name" => first_name,
      "last_name" => last_name,
      "birthday" => Utils.DateUtils.parse_date(birthday),
      "location_id" => user.location_id
    }

    params
    |> Storage.update_user(user_id)
    |> get_user_location()
    |> get_user_genres()
    |> to_context_struct()
  end

  def update_user(%{"user" => %{"username" => username}}, user_id) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => username,
      "account_id" => user.account_id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "birthday" => user.birthday,
      "location_id" => user.location_id
    }

    params
    |> Storage.update_user(user_id)
    |> get_user_location()
    |> get_user_genres()
    |> to_context_struct()
  end

  def update_user(%{"user" => %{"first_name" => first_name}}, user_id) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => user.username,
      "account_id" => user.account_id,
      "first_name" => first_name,
      "last_name" => user.last_name,
      "birthday" => user.birthday,
      "location_id" => user.location_id
    }

    params
    |> Storage.update_user(user_id)
    |> get_user_location()
    |> get_user_genres()
    |> to_context_struct()
  end

  def update_user(%{"user" => %{"last_name" => last_name}}, user_id) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => user.username,
      "account_id" => user.account_id,
      "first_name" => user.first_name,
      "last_name" => last_name,
      "birthday" => user.birthday,
      "location_id" => user.location_id
    }

    params
    |> Storage.update_user(user_id)
    |> get_user_location()
    |> get_user_genres()
    |> to_context_struct()
  end

  def update_user(%{"user" => %{"birthday" => birthday}}, user_id) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => user.username,
      "account_id" => user.account_id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "birthday" => Utils.DateUtils.parse_date(birthday),
      "location_id" => user.location_id
    }

    params
    |> Storage.update_user(user_id)
    |> get_user_location()
    |> get_user_genres()
    |> to_context_struct()
  end

  def delete_user(id) do
    Storage.delete_user(id)
  end

  def update_user_location(user_id, %{"location" => location_name}) do
    location = Locations.get_location_by_city!(location_name)
    user = get_user_by_id!(user_id)

    user
    |> Storage.update_user_location(location.id)

    user_id
    |> get_user_by_id!()
  end

  def update_user_genres(user_id, %{"genres" => genres_list}) do
    delete_user_genres(user_id)

    genres_ids =
      genres_list
      |> Enum.map(&Genres.get_genre_by_name(&1))
      |> Enum.map(fn genre -> genre.id end)

    Enum.each(genres_ids, &Storage.update_user_genres(user_id, &1))

    user_id
    |> get_user_by_id!()
  end

  def delete_user_genres(user_id) do
    Storage.delete_user_genres(user_id)
    get_user_by_id!(user_id)
  end

  def to_context_struct(%Storage.User{} = index_db) do
    struct(User, Map.from_struct(index_db))
  end

  defp get_user_location(user) do
    Map.update!(user, :location, fn location ->
      case location do
        nil -> nil
        location -> location.city
      end
    end)
  end

  defp get_user_genres(user) do
    Map.update!(user, :genres, fn genres ->
      case genres do
        nil ->
          nil

        genres ->
          Enum.map(genres, fn genre ->
            genre.name
          end)
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
