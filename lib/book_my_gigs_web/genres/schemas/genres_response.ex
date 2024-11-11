defmodule BookMyGigsWeb.Genres.Schemas.GenresResponse do
  @moduledoc """
  Specs describing the valid response when fetching locations
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Genres response",
    description: "Valid response when fetching multiple genres",
    type: :array,
    items: %Schema{
      type: :object,
      properties: %{
        id: %Schema{
          type: :string,
          format: :uuid
        },
        name: %Schema{
          type: :string
        }
      },
      required: [:id, :name]
    },
    example: %{
      "id" => "bd4ef420-1e29-4e93-9161-ab4aa7fd765",
      "name" => "Rock"
    }
  })
end
