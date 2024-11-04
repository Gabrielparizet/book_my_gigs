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
      ok: {"Get users response", "application/json", Schemas.GetUsersResponse}
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

  operation(:get_user_by_id,
    summary: "Get user by id",
    parameters: [
      user_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse}
    ],
    ok: "User successfully found"
  )

  def get_user_by_id(conn, _params) do
    user_id = conn.path_params["id"]

    user =
      user_id
      |> Users.get_user_by_id!()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, user)
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

  operation(:update,
    summary: "Update a user",
    parameters: [
      user_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    request_body: {"Update user input", "application/json", Schemas.UpdateUserInput},
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse},
      bad_request: "Invalid input values"
    ],
    ok: "User successfully updated"
  )

  def update(conn, params) do
    user_id = conn.path_params["id"]

    updated_user =
      params
      |> Users.update_user(user_id)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, updated_user)
  end

  operation(:delete,
    summary: "Delete a user",
    parameters: [
      user_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    responses: [
      ok: "User successfully deleted"
    ],
    ok: "User successfully deleted"
  )

  def delete(conn, _params) do
    user_id = conn.path_params["id"]

    response = Users.delete_user(user_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  operation(:update_user_location,
    summary: "Add locations to a user",
    parameters: [
      user_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    request_body: {"Add user location", "application/json", Schemas.AddUserLocation},
    responses: [
      ok: {"User Response", "application/json", Schemas.UserResponse},
      bad_request: "Invalid input values"
    ],
    ok: "User successfully created"
  )

  def update_user_location(conn, params) do
    user_id = conn.path_params["id"]

    user_location =
      user_id
      |> Users.update_user_location(params)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, user_location)
  end
end
