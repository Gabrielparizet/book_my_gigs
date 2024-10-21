defmodule BookMyGigs.Repo.Migrations.CreateEventsTable do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false)
      add(:location_id, references(:locations, type: :uuid, on_delete: :delete_all), null: false)
      add(:genre_id, references(:genres, type: :uuid, on_delete: :delete_all), null: false)
      add(:date_and_time, :utc_datetime)
      add(:venue, :string)
      add(:description, :text)
      add(:address, :string)
      add(:url, :string)

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:user_id])
    create index(:events, [:location_id])
    create index(:events, [:genre_id])
    create index(:events, [:date_and_time])
    create unique_index(:events, [:url])
  end
end
