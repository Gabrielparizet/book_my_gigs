defmodule BookMyGigsWeb.EventsController do
  @moduledoc """
  The Events Controller
  """
  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Events
  alias BookMyGigsWeb.Events.Schemas
  alias OpenApiSpex.Schema

  operation(:get_public_events,
    summary: "Get all events",
    responses: [
      ok: {"Public Events Response", "application/json", Schemas.PublicEventsResponse}
    ],
    ok: "Events successfully found"
  )

  def get_public_events(conn, _params) do
    events =
      Events.get_events()
      |> Enum.map(&Events.remove_user_from_event/1)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, events)
  end

  operation(:get_public_event_by_id,
    summary: "Get public event by id",
    parameters: [
      event_id: [
        in: :path,
        description: "Event id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    responses: [
      ok: {"Public_Event_response", "application/json", Schemas.PublicEventResponse}
    ],
    ok: "Event successfully found"
  )

  def get_public_event_by_id(conn, _params) do
    event_id = conn.params["id"]

    event =
      event_id
      |> Events.get_event_by_id()
      |> Events.remove_user_from_event()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, event)
  end

  operation(:create,
    summary: "Create an event",
    parameters: [
      user_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    request_body: {"Create event input", "application/json", Schemas.CreateEventInput},
    responses: [
      ok: {"Event response", "application/json", Schemas.EventResponse},
      bad_request: "Invalid input values"
    ],
    ok: "Event successfully created"
  )

  def create(conn, params) do
    user_id = conn.params["id"]

    event =
      params
      |> Events.create_event(user_id)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, event)
  end

  operation(:get_events_by_user,
    summary: "Get all events for a user",
    parameters: [
      user_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    responses: [
      ok: {"Events response", "application/json", Schemas.EventsResponse}
    ],
    ok: "Users's events successfully found"
  )

  def get_events_by_user(conn, _params) do
    user_id = conn.params["id"]

    event =
      user_id
      |> Events.get_events_by_user()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, event)
  end

  operation(:get_user_event_by_id,
    summary: "Get a user and an event with their ids",
    parameters: [
      user_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ],
      event_id: [
        in: :path,
        description: "Event id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c27"
      ]
    ],
    responses: [
      ok: {"Event response", "application/json", Schemas.EventResponse}
    ],
    ok: "Event successfully found"
  )

  def get_user_event_by_id(conn, _params) do
    event_id = conn.params["event_id"]
    user_id = conn.params["user_id"]

    event =
      event_id
      |> Events.get_user_event_by_id(user_id)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, event)
  end

  operation(:get_events_by_location,
    summary: "Get events by location and/ or filters",
    parameters: [
      location_name: [
        in: :path,
        description: "Location name",
        example: "Paris"
      ],
      genres: [
        in: :query,
        description: "Genre names",
        required: false,
        schema: %Schema{
          type: :array,
          items: %Schema{type: :string},
          example: ["Rock", "Techno", "Jazz"]
        }
      ],
      type: [
        in: :query,
        description: "type name",
        required: false,
        schema: %Schema{
          type: :string,
          example: "Club"
        }
      ]
    ],
    responses: [
      ok: {"Events response", "application/json", Schemas.EventsResponse}
    ],
    ok: "Events successfully found"
  )

  def get_events_by_location(conn, params) do
    location_name = conn.params["name"]
    genre_names = Map.get(params, "genres", [])
    type_name = Map.get(params, "type", nil)

    events =
      location_name
      |> Events.get_events_by_location(genre_names, type_name)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, events)
  end
end
