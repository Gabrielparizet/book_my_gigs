defmodule BookMyGigsWeb.Users.Schemas.CreateUserInput do
  @moduledoc """
    Specs describing the response when creating an user.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Create User Input",
    description: "Valid input values to create an user",
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
        }
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
