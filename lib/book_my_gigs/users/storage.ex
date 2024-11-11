defmodule BookMyGigs.Users.Storage do
  @moduledoc """
  Module providing functionalities to interact with the users table.
  """

  import Ecto.Query

  alias BookMyGigs.Accounts.Storage.Account
  alias BookMyGigs.Users.Storage
  alias BookMyGigs.Users.Storage.UserGenre
  alias BookMyGigs.Utils
  alias BookMyGigs.Repo

  def get_users do
    Storage.User
    |> preload(:location)
    |> preload(:genres)
    |> Repo.all()
  end

  def get_user_by_id!(id) do
    Storage.User
    |> Repo.get!(id)
    |> Repo.preload(:location)
    |> Repo.preload(:genres)
  end

  def get_user_by_account_id(account_id) do
    Storage.User

    case Repo.get_by(Storage.User, account_id: account_id) do
      nil ->
        {:error, "No user found for this account"}

      user ->
        {
          :ok,
          user
          |> Repo.preload(:location)
          |> Repo.preload(:genres)
        }
    end
  end

  def get_user_by_username(username) do
    Repo.get_by(Storage.User, username: username)
    |> Repo.preload(:location)
    |> Repo.preload(:genres)
  end

  def create_user(user_params, account_id) do
    params = %{
      account_id: account_id,
      username: user_params["username"],
      first_name: user_params["first_name"],
      last_name: user_params["last_name"],
      birthday: Utils.DateUtils.parse_date(user_params["birthday"])
    }

    case Repo.get(Account, account_id) do
      nil ->
        {:error, :account_not_found}

      _account ->
        changeset = Storage.User.changeset(%Storage.User{}, params)

        case Repo.insert(changeset) do
          {:ok, user} ->
            user
            |> Repo.preload(:location)
            |> Repo.preload(:genres)

          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end

  def update_user(params, user_id) do
    params =
      params
      |> Map.take(["username", "first_name", "last_name", "birthday", "account_id", "location_id"])
      |> Enum.into(%{}, fn {key, value} -> {String.to_atom(key), value} end)

    %Storage.User{id: user_id}
    |> Storage.User.changeset(params)
    |> Repo.update!()
    |> Repo.preload(:location)
    |> Repo.preload(:genres)
  end

  def delete_user(id) do
    user = Repo.get!(Storage.User, id)

    case Repo.delete(user) do
      {:ok, _struct} ->
        "User successfully deleted"

      {:error, _changeset} ->
        "Something went wrong"
    end
  end

  def get_username_by_id(id) do
    query =
      from(
        u in Storage.User,
        where: u.id == ^id,
        select: u.username
      )

    Repo.one(query)
  end

  def get_first_name_by_id(id) do
    query =
      from(
        u in Storage.User,
        where: u.id == ^id,
        select: u.first_name
      )

    Repo.one(query)
  end

  def get_last_name_by_id(id) do
    query =
      from(
        u in Storage.User,
        where: u.id == ^id,
        select: u.last_name
      )

    Repo.one(query)
  end

  def get_birthday_by_id(id) do
    query =
      from(
        u in Storage.User,
        where: u.id == ^id,
        select: u.birthday
      )

    Repo.one(query)
  end

  def update_user_location(user, location_id) do
    params =
      user
      |> Map.from_struct()
      |> Map.put(:location_id, location_id)

    %Storage.User{id: user.id}
    |> Storage.User.changeset(params)
    |> Repo.update!()
    |> Repo.preload(:location)
    |> Repo.preload(:genres)
  end

  def update_user_genres(user_id, genre_id) do
    user_genre_attrs = %{
      user_id: user_id,
      genre_id: genre_id
    }

    %UserGenre{}
    |> UserGenre.changeset(user_genre_attrs)
    |> Repo.insert()
  end

  def delete_user_genres(user_id) do
    Repo.delete_all(from ug in UserGenre, where: ug.user_id == ^user_id)
  end
end
