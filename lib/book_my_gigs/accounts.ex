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

    defstruct [:id, :email, :password]

    @type id :: String.t()
    @type t :: %__MODULE__{
            id: String.t(),
            email: String.t(),
            password: String.t()
          }
  end

  def get_accounts() do
    accounts = Storage.get_accounts()
    Enum.map(accounts, &delete_password_from_response/1)
  end

  def get_account_by_id!(id) do
    Storage.get_account_by_id!(id)
  end

  def get_account_by_email(email) do
    Storage.get_account_by_email(email)
  end

  def create_account(%{"account" => account_params}) do
    hash_password = hash_password(account_params["password"])

    account_params = Map.put(account_params, "password", hash_password)

    case Storage.create_account(account_params) do
      {:ok, account} -> {:ok, delete_password_from_response(account)}
      {:error, reason} -> {:error, reason}
    end
  end

  def update_account(%{"account" => %{"email" => email, "password" => password}}, account_id) do
    account_params = %{
      "email" => email,
      "password" => hash_password(password)
    }

    account_params
    |> Storage.update_account(account_id)
    |> delete_password_from_response()
  end

  def update_account(%{"account" => %{"email" => email}}, account_id) do
    account_params = %{"email" => email, "password" => Storage.get_password_by_id(account_id)}

    account_params
    |> Storage.update_account(account_id)
    |> delete_password_from_response()
  end

  def update_account(%{"account" => %{"password" => password}}, account_id) do
    account_params = %{
      "password" => hash_password(password),
      "email" => Storage.get_email_by_id(account_id)
    }

    account_params
    |> Storage.update_account(account_id)
    |> delete_password_from_response()
  end

  def delete_account(id) do
    Storage.delete_account(id)
  end

  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  defp delete_password_from_response(account_response) do
    account_map = Map.from_struct(account_response)
    account_map_without_password = Map.delete(account_map, :password)
    struct = struct!(account_response.__struct__, account_map_without_password)

    build_response(struct)
  end

  defp build_response(struct) do
    struct
    |> Map.from_struct()
    |> Enum.filter(fn {_key, val} -> val != nil end)
    |> Enum.into(%{})
  end

  def to_context_struct(%Storage.Account{} = index_db) do
    struct(Account, Map.from_struct(index_db))
  end
end
