defmodule BookMyGigsWeb.Users.Schemas.UpdateUserInput do
  @moduledoc """
  specs describing the input for updating a user
  """
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Update user input",
    description: "Valid input values to update a user",
    type: :object,
    properties: %{
      user: %Schema{
        type: :object,
        properties: %{
          username: %Schema{
            type: :string
          },
          first_name: %Schema{
            type: :string
          },
          last_name: %Schema{
            type: :string
          },
          birthday: %Schema{
            type: :string
          }
        },
        required: [:username, :first_name, :last_name, :birthday],
        additionalProperties: false
      }
    },
    example: %{
      "user" => %{
        "username" => "Gabdu20",
        "first_name" => "Gabriel",
        "last_name" => "Parizet",
        "birthday" => "04/07/1994"
      }
    }
  })
end
