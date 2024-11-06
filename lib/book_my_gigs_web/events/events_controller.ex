defmodule BookMyGigsWeb.EventsController do
  @moduledoc """
  The Events Controller
  """
  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Events
  alias BookMyGigsWeb.Events.Schemas
  alias OpenApiSpex.Schema

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

  def create(conn, _params) do
    conn
  end
end
