defmodule BookMyGigs.Repo.Migrations.ImportTypesFromJson do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"")
    "priv/data/types/types_list.json"
    |> File.read!()
    |> Jason.decode!()
    |> Enum.each(fn %{"type" => type, "description" => _description} ->
      query = """
      INSERT INTO public.types
      (id, name, inserted_at, updated_at)
      VALUES (uuid_generate_v4(), '#{parse_type(type)}', NOW(), NOW())
      ON CONFLICT (name) DO NOTHING
      """
      execute(query)
    end)
  end

  def down do
    execute("TRUNCATE public.types")
  end

  defp parse_type(type) do
    [hd | rest] = String.split(type, "_")
    Enum.join([String.capitalize(hd) | rest], " ")
  end
end
