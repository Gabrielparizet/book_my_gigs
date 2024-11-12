defmodule BookMyGigsWeb.TypesController do
  @moduledoc """
    The Types Controller
  """

  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Types
  alias BookMyGigsWeb.Types.Schemas

  operation(:get_types_names,
    summary: "Get all types",
    responses: [
      ok: {"Types response", "application/json", Schemas.TypesResponse}
    ],
    ok: "Types successfully found"
  )

  def get_types_names(conn, _params) do
    case Types.get_types_names() do
      {:ok, types_names} ->
        {:ok, types_names}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(types_names))

      {:error, msg} ->
        response = %{error: msg}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(response))
    end
  end
end
