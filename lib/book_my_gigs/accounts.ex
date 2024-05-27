defmodule BookMyGigs.Accounts do
  @moduledoc """
  The accounts context
  """

  alias BookMyGigs.Accounts.Storage

  defmodule Account do
    @moduledoc """
    Module defining the context struct for an account.
    """

    @derive Jason.Encoder

    defstruct [:email, :hash_password]

    @type t :: %__MODULE__{
      email: String.t(),
      hash_password: String.t()
    }

  end

  def get_accounts() do
    Storage.get_accounts()
  end

  def create_account(%{"account" => account_params}) do
    Storage.create_account(account_params)
  end
end
