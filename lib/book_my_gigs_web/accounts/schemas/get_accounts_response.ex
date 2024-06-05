defmodule BookMyGigsWeb.Accounts.Schemas.GetAccountsResponse do
  @moduledoc """
  Specs describing the valid response for getting all accounts.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Get accounts response",
    description: "Account list response",
    type: :array,
    items: %Schema{
      type: :object,
      properties: %{
        email: %Schema{
          type: :string
        },
        hash_password: %Schema{
          type: :string
        }
      }
    },
    example: [
      %{
        "email" => "test@email.com",
        "hash_password" => "ThisIsMyPassword123?"
      },
      %{
        "email" => "test@email.com",
        "hash_password" => "ThisIsMyPassword123?"
      }
    ]
  })
end