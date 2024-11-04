defmodule BookMyGigsWeb.Users.Schemas.AddUserLocation do
  @moduledoc """
    Specs describing the input when adding locations to a user.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Add users location",
    description: "Valid input to add a location to a user",
    type: :object,
    required: [:location],
    properties: %{
      location: %Schema{
        type: :string
      }
    },
    example: %{
      "location" => "Paris"
    }
  })
end
