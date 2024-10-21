defmodule BookMyGigs.Repo.Migrations.CreateEventsGenresTable do
  use Ecto.Migration

  def change do
    create table(:events_genres, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:event_id, references(:events, type: :uuid, on_delete: :delete_all), null: false)
      add(:genre_id, references(:genres, type: :uuid, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:events_genres, [:event_id])
    create unique_index(:events_genres, [:genre_id])
  end
end
