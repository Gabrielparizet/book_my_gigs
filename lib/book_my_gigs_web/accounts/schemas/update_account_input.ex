defmodule BookMyGigsWeb.Accounts.Schemas.UpdateAccountInput do
  @moduledoc false
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Update account input",
    description: "Valid input values to create an account",
    type: :object,
    properties: %{
      account: %Schema{
        type: :object,
        properties: %{
          email: %Schema{
            type: :string,
            format: :email
          },
          hash_password: %Schema{
            type: :string
          }
        },
        required: [],
        additionalProperties: false
      }
    },
    example: %{
      "account" => %{
        "email" => "test@gmail.com",
        "hash_password" => "ThisIsMyPassword123?"
      }
    }
  })
end
