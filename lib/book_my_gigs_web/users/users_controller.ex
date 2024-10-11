defmodule BookMyGigsWeb.Users.UsersController do
  @moduledoc """
  The Users Controller
  """
  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Users
  alias BookMyGigsWeb.Users.Schemas
  alias OpenApiSpex.Schema

  operation(:create,
    summary: "Create an user",
    parameters: [
      account_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    request_body: {"Update account input", "application/json", Schemas.CreateUserInput},
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse},
      bad_request: "Invalid input values"
    ],
    ok: "User successfully created"
  )

  def create(conn, params) do
    account_id = conn.path_params["id"]

    user =
      params
      |> User.create_user(account_id, params)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, user)
  end
end
