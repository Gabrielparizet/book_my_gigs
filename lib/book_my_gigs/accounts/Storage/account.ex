defmodule BookMyGigs.Accounts.Storage.Account do
  @moduledoc """
  The Ecto Schema for an Account
  """
  use Ecto.Schema
  import Ecto.Changeset

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "accounts" do
    field(:email, :string)
    field(:hash_password, :string)

    timestamps(type: :utc_datetime)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :hash_password])
    |> validate_required([:email, :hash_password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_format(:hash_password, ~r/^(?=.*[!?;:@*=+])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).+$/, [{:message, "Password must have a minimum of 8 characters long, include 1 downcase letter, 1 capital letter, 1 number and a special character (!?;:@*=+)"}])
    |> validate_length(:hash_password, min: 8)
  end
end
