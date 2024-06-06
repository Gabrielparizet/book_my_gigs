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
    field(:password, :string)

    timestamps(type: :utc_datetime)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_format(
      :password,
      ~r/^(?=.*[!?;:@*=+])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).+$/,
      [
        {:message,
         "Password must have a minimum of 8 characters long, include 1 downcase letter, 1 capital letter, 1 number and a special character (!?;:@*=+)"}
      ]
    )
    |> validate_length(:password, min: 8)
  end
end
