defmodule BookMyGigs.Types.Storage.Type do
  @moduledoc """
  The Ecto Schema for a type
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Events.Storage.Event

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "types" do
    field(:name, :string)

    has_many(:events, Event, on_delete: :delete_all)

    timestamps(type: :utc_datetime)
  end

  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
