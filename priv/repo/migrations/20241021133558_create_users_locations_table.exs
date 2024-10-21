defmodule BookMyGigs.Repo.Migrations.CreateUsersLocationsTable do
  use Ecto.Migration

  def change do
    create table(:users_locations, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false)
      add(:location_id, references(:locations, type: :uuid, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users_locations, [:user_id])
    create unique_index(:users_locations, [:location_id])
  end
end
