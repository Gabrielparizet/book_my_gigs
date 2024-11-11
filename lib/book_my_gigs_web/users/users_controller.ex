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

  operation(:get_user_by_account_id,
    summary: "Get user by account id",
    parameters: [
      account_id: [
        in: :path,
        description: "Account id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse}
    ],
    ok: "User successfully found"
  )

  def get_user_by_account_id(conn, _params) do
    account_id = conn.params["id"]

    response =
      case Users.get_user_by_account_id(account_id) do
        {:error, msg} -> %{error: msg}
        {:ok, user} -> user
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(response))
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
      user_id: [
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

    case Users.create_user(params, account_id) do
      {:ok, user} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(user))

      {:error, :account_not_found} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{error: "Unauthorized"}))

      {:error, changeset_errors} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, Jason.encode!(%{error: changeset_errors}))
    end
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
    ok: "Location successfully updated"
  )

  def update_user_location(conn, params) do
    user_id = conn.path_params["id"]

    user =
      user_id
      |> Users.update_user_location(params)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, user)
  end

  operation(:update_user_genres,
    summary: "Add genres to a user",
    parameters: [
      user_id: [
        in: :path,
        description: "User id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    request_body: {"Add user genres", "application/json", Schemas.AddUserGenres},
    responses: [
      ok: {"User response", "application/json", Schemas.UserResponse},
      bad_request: "Invalid input values"
    ],
    ok: "Genres successfully updated"
  )

  def update_user_genres(conn, params) do
    user_id = conn.path_params["id"]

    user =
      user_id
      |> Users.update_user_genres(params)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, user)
  end

  operation(:delete_user_genres,
    summary: "Delete user genres",
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
    ok: "User genres successfully deleted"
  )

  def delete_user_genres(conn, _params) do
    user_id = conn.path_params["id"]

    user =
      user_id
      |> Users.delete_user_genres()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, user)
  end
end
