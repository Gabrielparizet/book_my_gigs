defmodule BookMyGigsWeb.EventsController do
  @moduledoc """
  The Events Controller
  """
  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Events
  alias BookMyGigsWeb.Events.Schemas
  alias OpenApiSpex.Schema

  operation(:get,
    summary: "Get all events",
    responses: [
      ok: {"Public Events Response", "application/json", Schemas.PublicEventsResponse}
    ],
    ok: "Events successfully found"
  )

  def get(conn, _params) do
    events =
      Events.get_events()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, events)
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
      ok: {"Events Response", "application/json", Schemas.EventsResponse}
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
end
