defmodule BookMyGigs.Repo.Migrations.CreateTypesTable do
  use Ecto.Migration

  def change do
    create table(:types, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:types, [:name])
  end
end
