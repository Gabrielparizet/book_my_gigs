defmodule BookMyGigs.Repo.Migrations.CreateLocationsTable do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:locations, [:name])
  end
end
