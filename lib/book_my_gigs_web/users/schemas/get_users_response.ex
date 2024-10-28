defmodule BookMyGigsWeb.Users.Schemas.GetUsersResponse do
  @moduledoc """
  Specs describing the valid response for getting all users.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Get users response",
    description: "User list response",
    type: :array,
    items: %Schema{
      type: :object,
      properties: %{
        id: %Schema{
          type: :string,
          format: :uuid
        },
        username: %Schema{
          type: :string
        },
        account_id: %Schema{
          type: :string,
          format: :uuid,
        },
        first_name: %Schema{
          type: :string
        },
        last_name: %Schema{
          type: :string
        },
        birthday: %Schema{
          type: :string,
          format: :date,
          description: "Date in ISO 8601 format (YYYY-MM-DD)"
        }
      }
    },
    example: [
      %{
        id: "fc93394f-9d13-4726-aa2b-aaa43c0f60ea",
        username: "MyUserName",
        account_id: "75a95cb3-379c-477e-b578-cf4503c37614",
        first_name: "John",
        last_name: "Doe",
        birthday: "1990-01-01"
      },
      %{
        id: "fc93394f-9d13-4726-aa2b-aaa43c0f60eb",
        username: "MyOtherUserName",
        account_id: "75a95cb3-379c-477e-b578-cf4503c37615",
        first_name: "Laura",
        last_name: "Palmer",
        birthday: "1990-01-01"
      }
    ]
  })
end
