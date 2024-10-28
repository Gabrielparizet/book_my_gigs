defmodule BookMyGigsWeb.UsersController do
  @moduledoc """
  The Users Controller
  """
  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Users
  alias BookMyGigsWeb.Users.Schemas
  alias OpenApiSpex.Schema

  operation(:get,
    summary: "Get all users",
    responses: [
      ok: {"Get users response", "application/json", Schemas.GetUsersRespoonse},
    ],
    ok: "Users successfully found"
  )

  def get(conn, _params) do
    users =
      Users.get_users()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, users)
  end

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
    request_body: {"Create user input", "application/json", Schemas.CreateUserInput},
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse},
      bad_request: "Invalid input values"
    ],
    ok: "User successfully created"
  )

  def create(conn, params) do
    account_id = conn.private[:guardian_default_resource].id

    user =
      params
      |> Users.create_user(account_id)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, user)
  end
end
