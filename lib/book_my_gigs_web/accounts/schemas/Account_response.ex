defmodule BookMyGigsWeb.Accounts.Schemas.AccountResponse do
  @moduledoc """
    Specs describing the response when creating an account.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Account response",
    description: "Schema describing the response when creating an account",
    type: :object,
    properties: %{
      account: %Schema{
        type: :object,
        properties: %{
          id: %Schema{
            type: :string,
            format: :uuid
          },
          email: %Schema{
            type: :string,
            format: :email
          }
        }
      },
      token: %Schema{
        type: :string,
        format: :jwt
      }
    },
    example: %{
      "id" => "fc93394f-9d13-4726-aa2b-aaa43c0f60ea",
      "email" => "test@gmail.com"
    }
  })
end
