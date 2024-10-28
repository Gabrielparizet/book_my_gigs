defmodule BookMyGigs.Users do
  @moduledoc """
  The users context
  """

  alias BookMyGigs.Accounts
  alias BookMyGigs.Users.Storage
  alias BookMyGigs.Utils

  defmodule User do
    @moduledoc """
    Module defining the context struct for a user.
    """

    @derive Jason.Encoder

    defstruct [:id, :account_id, :username, :first_name, :last_name, :birthday]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: Accounts.Account.id(),
            username: String.t(),
            first_name: String.t(),
            last_name: String.t(),
            birthday: Date.t()
          }
  end

  def get_users() do
    Storage.get_users()
  end

  def get_user_by_id!(id) do
    id
    |> Storage.get_user_by_id!()
    |> to_context_struct()
  end

  def create_user(%{"user" => user_params}, account_id) do
    Storage.create_user(user_params, account_id)
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
      "birthday" => Utils.DateUtils.parse_date(birthday)
    }

    Storage.update_user(params, user_id)
  end

  def update_user(%{"user" => %{"username" => username}}, user_id) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => username,
      "account_id" => user.account_id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "birthday" => user.birthday
    }

    Storage.update_user(params, user_id)
  end

  def update_user(%{"user" => %{"first_name" => first_name}}, user_id) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => user.username,
      "account_id" => user.account_id,
      "first_name" => first_name,
      "last_name" => user.last_name,
      "birthday" => user.birthday
    }

    Storage.update_user(params, user_id)
  end

  def update_user(%{"user" => %{"last_name" => last_name}}, user_id) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => user.username,
      "account_id" => user.account_id,
      "first_name" => user.first_name,
      "last_name" => last_name,
      "birthday" => user.birthday
    }

    Storage.update_user(params, user_id)
  end

  def update_user(%{"user" => %{"birthday" => birthday}}, user_id) do
    user = Storage.get_user_by_id!(user_id)

    params = %{
      "username" => user.username,
      "account_id" => user.account_id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "birthday" => Utils.DateUtils.parse_date(birthday)
    }

    Storage.update_user(params, user_id)
  end

  def delete_user(id) do
    Storage.delete_user(id)
  end

  def to_context_struct(%Storage.User{} = index_db) do
    struct(User, Map.from_struct(index_db))
  end
end
