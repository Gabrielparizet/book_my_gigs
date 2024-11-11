defmodule BookMyGigsWeb.LocationsController do
  @moduledoc """
  The Locations Controller
  """

  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Locations
  alias BookMyGigsWeb.Locations.Schemas

  operation(:get_locations_names,
    summary: "Get all locations",
    responses: [
      ok: {"Locations response", "application/json", Schemas.LocationsResponse}
    ],
    ok: "Locations successfully found"
  )

  def get_locations_names(conn, _params) do
    case Locations.get_locations_names() do
      {:ok, locations_names} ->
        {:ok, locations_names}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(locations_names))

      {:error, msg} ->
        response = %{error: msg}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(response))
    end
  end
end
