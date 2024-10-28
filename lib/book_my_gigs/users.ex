defmodule BookMyGigs.Users do
  @moduledoc """
  The users context
  """

  alias BookMyGigs.Accounts
  alias BookMyGigs.Users.Storage

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

  def to_context_struct(%Storage.User{} = index_db) do
    struct(User, Map.from_struct(index_db))
  end
end
