defmodule BookMyGigs.Accounts.Storage do
  @moduledoc """
  Module providing functionalties to interact with the accounts table.
  """

  alias BookMyGigs.Accounts
  alias BookMyGigs.Accounts.Storage
  alias BookMyGigs.Repo

  def create_account(params) do
    params = %{
      email: params["email"],
      hash_password: params["hash_password"]
    }

    %Storage.Account{}
    |> Storage.Account.changeset(params)
    |> Repo.insert!()
    |> to_context_struct()
  end

  defp to_context_struct(%Storage.Account{} = index_db),
    do: struct(Accounts.Account, Map.from_struct(index_db))

  defp to_context_struct(nil), do: nil
end
