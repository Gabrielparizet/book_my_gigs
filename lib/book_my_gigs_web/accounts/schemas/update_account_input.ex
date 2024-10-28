defmodule BookMyGigsWeb.Accounts.Schemas.UpdateAccountInput do
  @moduledoc """
  Specs describing the input for updating an account
  """
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Update account input",
    description: "Valid input values to update an account",
    type: :object,
    properties: %{
      account: %Schema{
        type: :object,
        properties: %{
          email: %Schema{
            type: :string,
            format: :email
          },
          password: %Schema{
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
        "password" => "ThisIsMyPassword123?"
      }
    }
  })
end
