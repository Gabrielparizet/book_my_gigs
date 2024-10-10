defmodule BookMyGigs.Users.Storage.User do
  @moduledoc """
  The Ecto Schema for a User
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Accounts.Storage.Account
  alias BookMyGigs.Utils.DateUtils

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: :true}
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
    |> validate_format(:birthday, ~r/^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[012])\/\d{4}$/, message: "must be in the format DD/MM/YYYY")
    |> validate_birthday()
    |> unique_constraint(:username)
    |> unique_constraint(:account_id)
  end

  defp validate_birthday(changeset) do
    with birthday_string when not is_nil(birthday_string) <- get_field(changeset, :birthday),
         {:ok, date} <- DateUtils.parse_date(birthday_string),
         true <- Date.compare(date, Date.utc_today()) == :lt do
      put_change(changeset, :birthday, date)
    else
      nil ->
        changeset
      {:error, _} ->
        add_error(changeset, :birthday, "is invalid, must be in the format 'DD/MM/YYYY'")
      false ->
        add_error(changeset, :birthday, "must be in the past")
    end
  end
end
