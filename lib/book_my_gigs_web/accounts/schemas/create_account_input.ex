defmodule BookMyGigsWeb.Accounts.Schemas.CreateAccountInput do
  @moduledoc """
  Specs describing the valid inout values to create an account.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Create account input",
    description: "Valid input values to create an account",
    type: :object,
    properties: %{
      account: %Schema{
        type: :object,
        additionalProperties: %{
          email: %Schema{
            type: :string,
            format: :email
          },
          hash_password: %Schema{
            type: :string,
          }
        }
      }
    },
    example: %{
      "email" => "test@gmail.com",
      "password" => "ThisIsMyPassword123?"
    }
  })
end
