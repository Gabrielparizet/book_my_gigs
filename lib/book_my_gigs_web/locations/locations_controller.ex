defmodule BookMyGigsWeb.LocationsController do
  @moduledoc """
  The Locations Controller
  """

  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Locations
  alias BookMyGigsWeb.Locations.Schemas

  operation(:get,
    summary: "Get all locations",
    responses: [
      ok: {"Locations response", "application/json", Schemas.LocationsResponse}
    ],
    ok: "Locations successfully found"
  )

  def get(conn, _params) do
    case Locations.get_locations() do
      {:ok, locations} ->
        {:ok, locations}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(locations))

      {:error, msg} ->
        response = %{error: msg}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(response))
    end
  end
end
