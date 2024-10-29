defmodule BookMyGigs.Types.Folder.Type do
  @moduledoc """
  The Ecto Schema for a type
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Events.Storage.Event
  alias BookMyGigs.Events.Storage.EventType

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "types" do
    field(:name, :string)

    many_to_many(:events, Event, join_through: EventType)

    timestamps(type: :utc_datetime)
  end

  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
