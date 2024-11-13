defmodule BookMyGigsWeb.Types.Schemas.TypesResponse do
  @moduledoc """
  Specs describing the valid response when fetching types
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Types names response",
    description: "Valid response when fetching multiple types names",
    type: :array,
    items: %Schema{
      type: :string
    },
    example: ["Concert", "Club"]
  })
end
