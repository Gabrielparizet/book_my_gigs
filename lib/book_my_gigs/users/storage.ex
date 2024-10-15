defmodule BookMyGigs.Users.Storage do
  @moduledoc """
  Module providing functionalities to interact with the users table.
  """

  import Ecto.Query

  alias BookMyGigs.Accounts
  alias BookMyGigs.Users
  alias BookMyGigs.Users.Storage
  alias BookMyGigs.Repo

  def create_user(user_params, account_id) do
    IO.inspect(user_params, label: "user params")

    params = %{
      account_id: account_id,
      username: params["username"],
      first_name: params["first_name"],
      last_name: params["last_name"],
      birthday: params["birthday"]
    }
  end
end
