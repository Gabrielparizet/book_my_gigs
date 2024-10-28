defmodule BookMyGigs.Users.Storage do
  @moduledoc """
  Module providing functionalities to interact with the users table.
  """

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
end
