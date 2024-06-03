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

  def update_account(%{"account" => %{"email" => _email, "hash_password" => _hash_password} = account_params}, account_id) do
    Storage.update_account(account_params, account_id)
  end

  def update_account(%{"account" => %{"email" => email}}, account_id) do
    params = %{"email" => email, "hash_password" => Storage.get_hash_password_by_id(account_id)}

    Storage.update_account(params, account_id)
  end

  def update_account(%{"account" => %{"hash_password" => hash_password}}, account_id) do
    params = %{"hash_password" => hash_password, "email" => Storage.get_email_by_id(account_id)}
    Storage.update_account(params, account_id)
  end

end
