defmodule BookMyGigsWeb.GenresController do
  @moduledoc """
  The Genres controller
  """

  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Genres
  alias BookMyGigsWeb.Genres.Schemas

  operation(:get,
    summary: "Get all genres",
    responses: [
      ok: {"Genres names response", "application/json", Schemas.GenresNamesResponse}
    ],
    ok: "Genres successfully found"
  )

  def get_genres_names(conn, _params) do
    case Genres.get_genres_names() do
      {:ok, genres_names} ->
        {:ok, genres_names}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(genres_names))

      {:error, msg} ->
        response = %{error: msg}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(response))
    end
  end
end
