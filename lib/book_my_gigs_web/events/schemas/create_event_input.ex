defmodule BookMyGigsWeb.Events.Schemas.CreateEventInput do
  @moduledoc """
    Specs describing the valid input when creating an event.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Create event input",
    description: "Valid input to create an event",
    type: :object,
    properties: %{
      event: %Schema{
        type: :object,
        properties: %{
          date_and_time: %Schema{
            type: :object,
            properties: %{
              date: %Schema{
                type: :string
              },
              time: %Schema{
                type: :string
              }
            },
            required: [:date, :time]
          },
          venue: %Schema{
            type: :string
          },
          title: %Schema{
            type: :string
          },
          description: %Schema{
            type: :string
          },
          address: %Schema{
            type: :string
          },
          url: %Schema{
            type: :string
          },
          location: %Schema{
            type: :string
          },
          type: %Schema{
            type: :string
          },
          genres: %Schema{
            type: :array,
            items: %Schema{
              type: :string
            }
          }
        },
        required: [
          :date_and_time,
          :venue,
          :title,
          :description,
          :address,
          :url,
          :location,
          :type,
          :genres
        ]
      }
    },
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
