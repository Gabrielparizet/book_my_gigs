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
    example: [
      %{
        "id" => "84f93be3-dc27-4ba7-a8ce-ca58501055a2",
        "email" => "test@email.com"
      },
      %{
        "id" => "84f93be3-dc27-4ba7-a8ce-ca58501055a3",
        "email" => "test2@email.com"
      }
    ]
  })
end
