defmodule BookMyGigs.Repo.Migrations.CreateGenresLocationsTable do
  use Ecto.Migration

  def change do
    create table(:users_genres, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false)
      add(:genre_id, references(:genres, type: :uuid, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users_genres, [:user_id])
    create unique_index(:users_genres, [:genre_id])
  end
end
