defmodule BookMyGigsWeb.Users.Schemas.AddUserGenres do
  @moduledoc """
    Specs describing the input when adding genres to a user.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Add user genres",
    description: "Valid input to add genres to a user",
    type: :object,
    required: [:genres],
    properties: %{
      genres: %Schema{
        type: :array,
        items: %Schema{
          type: :string
        }
      }
    },
    example: %{
      "genres" => [
        "Techno",
        "Rap",
        "Rock"
      ]
    }
  })
end
