defmodule BookMyGigs.Events.Storage.EventType do
  @moduledoc """
  The Ecto Schema for the events_types join table
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BookMyGigs.Events.Storage.Event
  alias BookMyGigs.Types.Storage.Type

  @schema_prefix "public"
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "events_types" do
    belongs_to(:event, Event, type: Ecto.UUID)
    belongs_to(:type, Type, type: Ecto.UUID)

    timestamps(type: :utc_datetime)
  end

  def changeset(event_type, attrs) do
    event_type
    |> cast(attrs, [:event_id, :type_id])
    |> validate_required([:event_id, :type_id])
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:type_id)
  end
end
