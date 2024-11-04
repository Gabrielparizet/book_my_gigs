defmodule BookMyGigs.Accounts.Storage do
  @moduledoc """
  Module providing functionalities to interact with the accounts table.
  """

  import Ecto.Query

  alias BookMyGigs.Accounts
  alias BookMyGigs.Accounts.Storage
  alias BookMyGigs.Repo

  def get_accounts do
    Storage.Account
    |> Repo.all()
    |> Enum.map(&Accounts.to_context_struct/1)
  end

  def get_account_by_id!(id) do
    Storage.Account
    |> Repo.get!(id)
  end

  def get_account_by_email(email) do
    Repo.get_by(Storage.Account, email: email)
  end

  def create_account(params) do
    params = %{
      email: params["email"],
      password: params["password"]
    }

    changeset = Storage.Account.changeset(%Storage.Account{}, params)

    case Repo.insert(changeset) do
      {:ok, account} ->
        {:ok, Accounts.to_context_struct(account)}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update_account(params, account_id) do
    params =
      params
      |> Map.take(["email", "password"])
      |> Enum.into(%{}, fn {key, value} -> {String.to_atom(key), value} end)

    %Storage.Account{id: account_id}
    |> Storage.Account.changeset(params)
    |> Repo.update!()
    |> Accounts.to_context_struct()
  end

  def delete_account(id) do
    account = Repo.get!(Storage.Account, id)

    case Repo.delete(account) do
      {:ok, _struct} ->
        "Account successfully deleted"

      {:error, _changeset} ->
        "Something went wrong"
    end
  end

  def get_email_by_id(id) do
    query =
      from(
        a in Storage.Account,
        where: a.id == ^id,
        select: a.email
      )

    Repo.one(query)
  end

  def get_password_by_id(id) do
    query =
      from(
        a in Storage.Account,
        where: a.id == ^id,
        select: a.password
      )

    Repo.one(query)
  end
end
