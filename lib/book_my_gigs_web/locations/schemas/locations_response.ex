defmodule BookMyGigsWeb.Locations.Schemas.LocationsResponse do
  @moduledoc """
  Specs describing the valid response when fetching locations
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Locations response",
    description: "Valid response when fetching multiple locations",
    type: :array,
    items: %Schema{
      type: :object,
      properties: %{
        id: %Schema{
          type: :string,
          format: :uuid
        },
        city: %Schema{
          type: :string
        },
        region: %Schema{
          type: :string
        },
        country: %Schema{
          type: :string
        },
        country_code: %Schema{
          type: :string
        }
      },
      required: [:id, :city, :region, :country, :country_code]
    },
    example: %{
      "id" => "bd4ef420-1e29-4e93-9161-ab4aa7fd765",
      "city" => "Paris",
      "region" => "Ile-de_France",
      "country" => "France",
      "country_code" => "FR"
    }
  })
end
