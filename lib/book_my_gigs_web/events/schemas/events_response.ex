defmodule BookMyGigsWeb.Events.Schemas.EventsResponse do
  @moduledoc """
    Specs describing the valid response when fetching events.
  """

  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Events response",
    description: "Valid response when fetching multiple events",
    type: :array,
    items: %Schema{
      type: :object,
      properties: %{
        id: %Schema{
          type: :string,
          format: :uuid
        },
        user_id: %Schema{
          type: :string,
          format: :uuid
        },
        title: %Schema{
          type: :string
        },
        type: %Schema{
          type: :string
        },
        user: %Schema{
          type: :string
        },
        address: %Schema{
          type: :string
        },
        description: %Schema{
          type: :string
        },
        location: %Schema{
          type: :string
        },
        url: %Schema{
          type: :string,
          format: :uri
        },
        genres: %Schema{
          type: :array,
          items: %Schema{
            type: :string
          }
        },
        date_and_time: %Schema{
          type: :string,
          format: "date-time"
        },
        venue: %Schema{
          type: :string
        }
      }
    },
    example: [
      %{
        "id" => "bd4ef420-1e29-4e93-9161-ab4aa7fd7653",
        "type" => "Concert",
        "user" => "Gabdu207",
        "address" => "7 Port de la Gare, 75013 Paris",
        "description" =>
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        "location" => "Paris",
        "title" => "Animistic Beliefs at Petit Bain, December 15th",
        "url" => "https://petitbain.org/evenement/sahten-2/",
        "user_id" => "6a9a2737-4a52-43aa-9242-70ab42ad1c0e",
        "genres" => [
          "Techno",
          "Rap"
        ],
        "date_and_time" => "2024-12-15T20:00:00Z",
        "venue" => "Le Petit Bain"
      },
      %{
        "id" => "bd4ef420-1e29-4e93-9161-ab4aa7fd7654",
        "type" => "Club",
        "user" => "Gabdu207",
        "address" => "3bis Rue Papin, 75003 Paris",
        "description" =>
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        "location" => "Paris",
        "title" => "Minor Science: Live at La Gaité Lyrique",
        "url" => "https://petitbain.org/evenement/sahten-2/",
        "user_id" => "6a9a2737-4a52-43aa-9242-70ab42ad1c0e",
        "genres" => [
          "Techno",
          "Electronic"
        ],
        "date_and_time" => "2024-11-30T00:00:00Z",
        "venue" => "La Gaité Lyrique"
      }
    ]
  })
end
