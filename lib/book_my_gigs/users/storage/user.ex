defmodule BookMyGigs.Users.Storage.User do
  @moduledoc """
  The Ecto Schema for a User.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Accounts.Storage
  alias BookMyGigs.Users

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field(:artist, :boolean, default: false)
    field(:promoter, :boolean, default: false)
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:billing_address, :string)
    field(:birthday, :date)
    field(:sex, :string)
    field(:siret, :string)
    field(:phone, :string)

    belongs_to(:account, Storage.Account,
      type: Ecto.UUID,
      references: :id,
      foreign_key: :account_id
    )

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    attrs = Map.update!(attrs, "birthday", &Users.format_birthday/1)

    user
    |> cast(attrs, [
      :account_id,
      :artist,
      :promoter,
      :username,
      :first_name,
      :last_name,
      :billing_address,
      :birthday,
      :sex,
      :siret,
      :phone
    ])
    |> validate_required([:username, :siret, :phone, :account_id])
    |> unique_constraint([:username, :siret, :phone, :account_id])
    |> validate_length(:username, min: 6, max: 25)
    |> validate_format(:siret, ~r/^[0-9]+$/)
    |> validate_length(:siret, min: 14, max: 14)
    |> validate_format(:phone, ~r/^[0-9+]+$/)
    |> validate_length(:phone, min: 10, max: 13)
  end
end
