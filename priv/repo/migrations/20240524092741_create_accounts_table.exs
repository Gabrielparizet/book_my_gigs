defmodule BookMyGigs.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false, prefix: "public") do
      add(:id, :uuid, primary_key: true)
      add(:email, :string)
      add(:hash_password, :string)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:accounts, [:email])
  end
end
