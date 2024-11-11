defmodule BookMyGigsWeb.Genres.Schemas.GenresNamesResponse do
  @moduledoc """
  Specs describing the valid response when fetching locations
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Genres names response",
    description: "Valid response when fetching multiple genres names",
    type: :array,
    items: %Schema{
      type: :string
    },
    example: ["Rock", "Techno"]
  })
end
