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
        properties: %{
          email: %Schema{
            type: :string,
          },
          password: %Schema{
            type: :string,
          }
        }
      }
    },
    example: %{
      "email" => "test@gmail.com",
      "hash_password" => "ThisIsMyPassword123?"
    }
  })
end
