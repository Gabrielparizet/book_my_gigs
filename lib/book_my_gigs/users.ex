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

  def create_user(account_id, %{"user" => {user_params}}) do
    Storage.create_user(account_id, user_params)
  end
end
