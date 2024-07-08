defmodule BookMyGigsWeb.Users.Schemas.CreateUserInput do
  @moduledoc """
  Specs describing the valid input to create an user.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Create user input",
    description: "Valid input to create an user",
    type: :object,
    properties: %{
      user: %Schema{
        type: :object,
        properties: %{
          artist: %Schema{
            type: :boolean
          },
          promoter: %Schema{
            type: :boolean
          },
          username: %Schema{
            type: :string
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
            type: :string
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
        }
      }
    },
    example: %{
      "user" => %{
        "artist" => true,
        "promoter" => false,
        "username" => "MyUserName",
        "first_name" => "John",
        "last_name" => "Doe",
        "billing_address" => "20 W 34th St., New York, NY 10001, United States",
        "birthday" => "20/04/2000",
        "sex" => "M",
        "siret" => "12345678901234",
        "phone" => "+33612131415"
      }
    }
  })
end
