defmodule BookMyGigsWeb.Users.UsersController do
  @moduledoc """
  The Users Controller
  """

  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema
  alias BookMyGigs.Users
  alias BookMyGigsWeb.Users.Schemas

  tags(["Users"])

  operation(:create,
    summary: "Create a user",
    parameters: [
      account_id: [
        in: :path,
        description: "Account id",
        schema: %Schema{type: :string, format: :uuid},
        example: "f1ccfa34-822c-4497-8f64-a9234e28ead0"
      ]
    ],
    request_body: {"Create user input", "application/json", Schemas.CreateUserInput},
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse},
      bad_request: "Invalid input values"
    ],
    ok: "User successfully created"
  )

  def create(conn, %{"user" => user_params}) do
    params = Map.put(user_params, "account_id", conn.params["account_id"])

    user =
      params
      |> Users.create_user()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, user)
  end
end
