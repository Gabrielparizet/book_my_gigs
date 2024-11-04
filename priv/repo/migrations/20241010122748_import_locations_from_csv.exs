defmodule BookMyGigs.Repo.Migrations.ImportLocationsFromCsv do
  use Ecto.Migration

  alias NimbleCSV.RFC4180, as: CSV

  def up do
    csv_path_list = [
      "data/locations/belgium_locations.csv",
      "data/locations/france_locations.csv",
      "data/locations/germany_locations.csv",
      "data/locations/italy_locations.csv",
      "data/locations/spain_locations.csv",
      "data/locations/united_kingdom_locations.csv"
    ]

    Enum.each(csv_path_list, fn csv_path -> insert_csv_locations(csv_path) end)
  end

  defp insert_csv_locations(csv_path) do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"")
    csv_path = Path.join(:code.priv_dir(:book_my_gigs), csv_path)

    csv_path
    |> File.read!()
    |> CSV.parse_string(skip_headers: false)
    |> Enum.each(fn [city, _lat, _long, country, country_code, region | _rest] ->
      query = """
      INSERT INTO public.locations
      (id, city, region, country, country_code, inserted_at, updated_at)
      VALUES (uuid_generate_v4(), '#{city}', '#{region}', '#{country}', '#{country_code}', NOW(), NOW())
      ON CONFLICT (city, region) DO NOTHING
      """

      execute(query)
    end)
  end

  def down do
    execute("TRUNCATE public.locations")
  end
end
