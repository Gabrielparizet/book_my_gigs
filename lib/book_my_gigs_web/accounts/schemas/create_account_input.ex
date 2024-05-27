defmodule BookMyGigsWeb.Accounts.Schemas.CreateAccountParams do
  @moduledoc """
  Specs describing the valid input values to create an account.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Create account params",
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
            type: :string,
          }
        }
      }
    },
    example:
  %{
    "account" => %{
      "email" => "test@gmail.com",
      "hash_password" => "ThisIsMyPassword123?"
    }
  }
  })
end
