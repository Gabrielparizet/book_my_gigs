defmodule BookMyGigs.Users.Storage do
  @moduledoc """
  Module providing functionalities to interact with the users table.
  """

  import Ecto.Query

  alias BookMyGigs.Accounts.Storage.Account
  alias BookMyGigs.Users
  alias BookMyGigs.Users.Storage
  alias BookMyGigs.Utils
  alias BookMyGigs.Repo

  def get_users do
    Storage.User
    |> Repo.all()
    |> Enum.map(&Users.to_context_struct/1)
  end

  def get_user_by_id!(id) do
    Storage.User
    |> Repo.get!(id)
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
            Users.to_context_struct(user)

          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end

  def update_user(params, user_id) do
    params =
      params
      |> Map.take(["username", "first_name", "last_name", "birthday", "account_id"])
      |> Enum.into(%{}, fn {key, value} -> {String.to_atom(key), value} end)

    %Storage.User{id: user_id}
    |> Storage.User.changeset(params)
    |> Repo.update!()
    |> Users.to_context_struct()
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
end
