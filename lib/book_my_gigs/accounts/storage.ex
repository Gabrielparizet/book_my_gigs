defmodule BookMyGigs.Accounts.Storage do
  @moduledoc """
  Module providing functionalties to interact with the accounts table.
  """

  import Ecto.Query

  alias BookMyGigs.Accounts
  alias BookMyGigs.Accounts.Storage
  alias BookMyGigs.Repo

  def get_accounts do
    Storage.Account
    |> Repo.all()
    |> Enum.map(&to_context_struct/1)
  end

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

  def update_account(params, account_id) do
    params =
      params
      |> Map.take(["email", "hash_password"])
      |> Enum.into(%{}, fn {key, value} -> {String.to_atom(key), value} end)

    %Storage.Account{id: account_id}
    |> Storage.Account.changeset(params)
    |> Repo.update!()
    |> to_context_struct()
  end

  defp to_context_struct(%Storage.Account{} = index_db) do
    struct(Accounts.Account, Map.from_struct(index_db))
  end

  def get_email_by_id(id) do
    query =
      from(
        l in Storage.Account,
        where: l.id == ^id,
        select: l.email
      )

    Repo.one(query)
  end

  def get_hash_password_by_id(id) do
    query =
      from(
        l in Storage.Account,
        where: l.id == ^id,
        select: l.hash_password
      )

    Repo.one(query)
  end
end
