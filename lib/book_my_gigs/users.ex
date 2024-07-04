defmodule BookMyGigs.Users do
  @moduledoc """
  The users context
  """

  alias BookMyGigs.Users.Storage

  defmodule User do
    @moduledoc """
    Module defininf the context struct for a user.
    """
    alias BookMyGigs.Accounts

    @derive Jason.Encoder

    defstruct [
      :id,
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
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            account_id: Accounts.Account.id(),
            artist: boolean(),
            promoter: boolean(),
            username: String.t(),
            first_name: String.t(),
            last_name: String.t(),
            billing_address: String.t(),
            birthday: String.t(),
            sex: String.t(),
            siret: String.t(),
            phone: String.t()
          }
  end

  def create_user(account_params) do
    Storage.create_user(account_params)
  end

  def to_context_struct(%Storage.User{} = index_db) do
    struct(User, Map.from_struct(index_db))
  end

  def format_birthday(birthday) do
    [day, month, year] =
      birthday
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)

    Date.new!(year, month, day)
  end
end
