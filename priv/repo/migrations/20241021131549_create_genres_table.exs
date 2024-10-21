defmodule BookMyGigs.Repo.Migrations.CreateGenresTable do
  use Ecto.Migration

  def change do
    create table(:genres, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:genres, [:name])
  end
end
