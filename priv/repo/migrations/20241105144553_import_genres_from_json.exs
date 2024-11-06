defmodule BookMyGigs.Repo.Migrations.ImportGenresFromJson do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"")

    "priv/data/genres/genres_list.json"
    |> File.read!()
    |> Jason.decode!()
    |> Enum.each(fn %{"id" => _id, "name" => name} ->
      query = """
      INSERT INTO public.genres
      (id, name, inserted_at, updated_at)
      VALUES (uuid_generate_v4(), '#{name}', NOW(), NOW())
      ON CONFLICT (name) DO NOTHING
      """
      execute(query)
    end)
  end

  def down do
    execute("TRUNCATE public.genres")
  end
end
