defmodule BookMyGigsWeb.AccountsController do
  @moduledoc """
  The Accounts Controller
  """
  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Accounts
  alias BookMyGigsWeb.Accounts.Schemas
  alias OpenApiSpex.Schema

  operation(:get,
    summary: "Get all accounts",
    responses: [
      ok: {"Get accounts response", "application/json", Schemas.GetAccountsResponse}
    ],
    ok: "Accounts successfully found"
  )

  def get(conn, _params) do
    accounts =
      Accounts.get_accounts()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, accounts)
  end

  operation(:create,
    summary: "Create an account",
    request_body: {"Create account input", "application/json", Schemas.CreateAccountInput},
    responses: [
      ok: {"Account response", "application/json", Schemas.AccountResponse},
      bad_request: "Invalid input values"
    ],
    ok: "Account successfully created"
  )

  operation(:get_account_by_id,
    summary: "Get account by id",
    parameters: [
      account_id: [
        in: :path,
        description: "Account id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    responses: [
      ok: {"Get account response", "application/json", Schemas.GetAccountResponse}
    ],
    ok: "Account succesfsfully found"
  )

  def get_account_by_id(conn, _params) do
    account_id = conn.path_params["id"]

    account =
      account_id
      |> Accounts.get_account_by_id!()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, account)
  end

  def create(conn, params) do
    case Accounts.create_account(params) do
      {:ok, account} ->
        {:ok, token, _claims} = BookMyGigs.Guardian.encode_and_sign(account)

        response = %{
          account: account,
          token: token
        }

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(response))

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: reason}))
    end
  end

  operation(:update,
    summary: "Update an account",
    parameters: [
      account_id: [
        in: :path,
        description: "Account id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    request_body: {"Update account input", "application/json", Schemas.UpdateAccountInput},
    responses: [
      ok: {"Account response", "application/json", Schemas.AccountResponse},
      bad_request: "Invalid input values"
    ],
    ok: "Account successfully updated"
  )

  def update(conn, params) do
    account_id = conn.path_params["id"]

    updated_account =
      params
      |> Accounts.update_account(account_id)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, updated_account)
  end

  operation(:delete,
    summary: "Delete an account",
    parameters: [
      account_id: [
        in: :path,
        description: "Account id",
        schema: %Schema{type: :string, format: :uuid},
        example: "61492a85-3946-4b62-8887-2952af807c26"
      ]
    ],
    responses: [
      ok: "Account successfully deleted"
    ],
    ok: "Account successfully deleted"
  )

  def delete(conn, _params) do
    account_id = conn.path_params["id"]

    response = Accounts.delete_account(account_id)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end

  operation(:sign_in,
    summary: "Sign in",
    request_body: {"Create account input", "application/json", Schemas.CreateAccountInput},
    responses: [
      ok: {"Account response", "application/json", Schemas.AccountResponse},
      bad_request: "Invalid input values"
    ]
  )

  def sign_in(conn, %{"account" => %{"email" => email, "password" => password}}) do
    case BookMyGigs.Guardian.authenticate(email, password) do
      {:ok, account, token} ->
        response = Jason.encode!(%{account: Accounts.to_context_struct(account), token: token})

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, response)

      {:error, _reason} ->
        response = Jason.encode!(%{error: "invalid credentials"})

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, response)
    end
  end

  operation(:sign_out,
    summary: "Sign out",
    parameters: [
      authorization: [
        in: :header,
        description: "Bearer token",
        type: :string,
        required: true
      ]
    ],
    responses: [
      ok: "Successfully signed out",
      unauthorized: "Invalid token"
    ]
  )

  def sign_out(conn, _params) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case BookMyGigs.Guardian.sign_out(token) do
          {:ok, _} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, Jason.encode!(%{message: "Successfully signed out"}))

          {:error, _reason} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(401, Jason.encode!(%{error: "Invalid token"}))
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{error: "No token provided"}))
    end
  end
end
