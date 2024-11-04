defmodule BookMyGigs.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:account_id, references(:accounts, type: :uuid, on_delete: :delete_all), null: false)
      add(:location_id, references(:locations, type: :uuid, on_delete: :restrict))
      add(:username, :string)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:birthday, :date)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:account_id])
    create unique_index(:users, [:username])
  end
end
