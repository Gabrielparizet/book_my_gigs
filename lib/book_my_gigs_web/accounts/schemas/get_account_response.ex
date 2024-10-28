defmodule BookMyGigsWeb.Accounts.Schemas.GetAccountResponse do
  @moduledoc """
  Specs describing the valid response for getting one account.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Get account response",
    description: "Account response",
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
    },
    example: %{
      "id" => "84f93be3-dc27-4ba7-a8ce-ca58501055a2",
      "email" => "test@email.com"
    }
  })
end
