defmodule BookMyGigs.Users.Storage.User do
  @moduledoc """
  The Ecto Schema for a User.
  """

  use Ecto.Schema

  alias BookMyGigs.Accounts.Storage

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
end
