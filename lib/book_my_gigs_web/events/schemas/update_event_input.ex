defmodule BookMyGigsWeb.Events.Schemas.UpdateEventInput do
  @moduledoc """
    Specs describing the valid input for updating an event
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Update event input",
    description: "Valid input to update an event",
    type: :object,
    properties: %{
      event: %Schema{
        type: :object,
        properties: %{
          date_and_time: %Schema{
            type: :object,
            nullable: true,
            properties: %{
              date: %Schema{
                type: :string,
                nullable: true
              },
              time: %Schema{
                type: :string,
                nullable: true
              }
            }
          },
          venue: %Schema{
            type: :string,
            nullable: true
          },
          title: %Schema{
            type: :string,
            nullable: true
          },
          description: %Schema{
            type: :string,
            nullable: true
          },
          address: %Schema{
            type: :string,
            nullable: true
          },
          url: %Schema{
            type: :string,
            format: :uri,
            nullable: true
          },
          location: %Schema{
            type: :string,
            nullable: true
          },
          type: %Schema{
            type: :string,
            nullable: true
          },
          genres: %Schema{
            type: :array,
            items: %Schema{
              type: :string
            },
            nullable: true
          }
        }
      }
    },
    required: [:event],
    example: %{
      "event" => %{
        "date_and_time" => %{"date" => "15/12/2024", "time" => "20:00"},
        "venue" => "Le Petit Bain",
        "title" => "Animistic Beliefs at Petit Bain, December 15th",
        "description" =>
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        "address" => "7 Port de la Gare, 75013 Paris",
        "url" => "https://petitbain.org/evenement/sahten-2/",
        "location" => "Paris",
        "type" => "Concert",
        "genres" => ["Techno"]
      }
    }
  })
end
