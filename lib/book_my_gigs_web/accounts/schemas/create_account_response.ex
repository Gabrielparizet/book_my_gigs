defmodule BookMyGigsWeb.Accounts.Schemas.CreateAccountResponse do
  @moduledoc """
    Specs describing the response when creating an account.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Create account response",
    description: "Schema describing the response when creating an account",
    type: :object,
    properties: %{
      account: %Schema{
        type: :object,
        additionalProperties: %{
          email: %Schema{
            type: :string,
            format: :email
          },
          password: %Schema{
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
