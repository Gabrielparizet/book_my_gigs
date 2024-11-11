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
      ok: {"Genres response", "application/json", Schemas.GenresResponse}
    ],
    ok: "Genres successfully found"
  )

  def get(conn, _params) do
    case Genres.get_genres() do
      {:ok, genres} ->
        {:ok, genres}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(genres))

      {:error, msg} ->
        response = %{error: msg}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(response))
    end
  end
end
