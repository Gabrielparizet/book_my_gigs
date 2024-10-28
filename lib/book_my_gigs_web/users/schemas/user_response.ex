defmodule BookMyGigsWeb.Users.Schemas.UserResponse do
  @moduledoc """
    Specs describing the response when creating a user.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "User response",
    description: "Schema describing the response when creating a user",
    type: :object,
    properties: %{
      id: %Schema{
        type: :string,
        format: :uuid
      },
      account_id: %Schema{
        type: :string,
        format: :uuid
      },
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
        type: :string,
        format: :date,
        description: "Date in ISO 8601 format (YYYY-MM-DD)"
      }
    },
    example: %{
      "id" => "b57ed6b1-02a7-4cf3-89bb-34ac1f424b79",
      "account_id" => "1e531b65-44dc-44d8-a772-0f2353133444",
      "username" => "MyUsername",
      "first_name" => "Gabriel",
      "last_name" => "Parizet",
      "birthday" => "1994-04-20"
    }
  })
end
