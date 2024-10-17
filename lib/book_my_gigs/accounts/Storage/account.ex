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
    has_one(:user, BookMyGigs.Users.Storage.User)

    timestamps(type: :utc_datetime)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/,
      message: "must have the @ sign and no spaces"
    )
    |> validate_length(:email, max: 160)
    |> validate_length(:password, min: 8)
    |> validate_format(:password, ~r/[a-z]/,
      message: "must include at least one lowercase letter"
    )
    |> validate_format(:password, ~r/[A-Z]/,
      message: "must include at least one uppercase letter"
    )
    |> validate_format(:password, ~r/[0-9]/, message: "must include at least one number")
    |> validate_format(:password, ~r/[?!.,@*€$\-_#:]/,
      message: "must include at least one special character (?!.,@*€$-_#:)"
    )
    |> unique_constraint(:email)
  end
end
