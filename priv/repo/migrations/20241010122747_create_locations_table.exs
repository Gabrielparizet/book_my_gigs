defmodule BookMyGigs.Repo.Migrations.CreateLocationsTable do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:city, :string)
      add(:region, :string)
      add(:country, :string)
      add(:country_code, :string)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:locations, [:city, :region])
  end
end
