defmodule BookMyGigs.Repo.Migrations.CreateEventsTypesTable do
  use Ecto.Migration

  def change do
    create table(:events_types, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:event_id, references(:events, type: :uuid, on_delete: :delete_all), null: false)
      add(:type_id, references(:genres, type: :uuid, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:events_types, [:event_id])
    create unique_index(:events_types, [:type_id])
  end
end
