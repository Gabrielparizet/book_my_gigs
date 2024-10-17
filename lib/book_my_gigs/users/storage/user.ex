defmodule BookMyGigs.Users.Storage.User do
  @moduledoc """
  The Ecto Schema for a User
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Accounts.Storage.Account

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:birthday, :date)

    belongs_to(:account, Account, type: Ecto.UUID)

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :last_name, :birthday, :account_id])
    |> validate_required([:username, :account_id])
    |> validate_length(:username, min: 6, max: 20)
    |> validate_birthday()
    |> unique_constraint(:username)
    |> unique_constraint(:account_id)
  end

  defp validate_birthday(changeset) do
    birthday = get_change(changeset, :birthday)

    if Date.compare(birthday, Date.utc_today()) == :lt do
      changeset
    else
      add_error(changeset, :birthday, "must be in the past")
    end
  end
end
