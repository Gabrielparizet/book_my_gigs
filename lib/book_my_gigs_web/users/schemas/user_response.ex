defmodule BookMyGigsWeb.Users.Schemas.UserResponse do
  @moduledoc """
  Specs describing the response when creating an user
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "User response",
    description: "Schema describing the response when creating an user",
    type: :object,
    properties: %{
      id: %Schema{
        type: :string,
        format: :uuid
      },
      account_id: %Schema{
        type: :string,
        format: :uuid
      },
      username: %Schema{
        type: :string
      },
      artist: %Schema{
        type: :boolean
      },
      promoter: %Schema{
        type: :boolean
      },
      first_name: %Schema{
        type: :string
      },
      last_name: %Schema{
        type: :string
      },
      billing_address: %Schema{
        type: :string
      },
      birthday: %Schema{
        type: :string,
        format: :date
      },
      sex: %Schema{
        type: :string
      },
      siret: %Schema{
        type: :string
      },
      phone: %Schema{
        type: :string
      }
    },
    example: %{
      "id" => "5c15f299-512b-403f-b5be-5309c7cba1b8",
      "account_id" => "d7de8038-37f8-4e60-a17f-b7b502129578",
      "username" => "MyUserName",
      "artist" => true,
      "promoter" => false,
      "first_name" => "John",
      "last_name" => "Doe",
      "billing_address" => "20 W 34th St., New York, NY 10001, United States",
      "birthday" => "20/04/2000",
      "sex" => "M",
      "siret" => "12345678901234",
      "phone" => "+33612131415"
    }
  })
end
