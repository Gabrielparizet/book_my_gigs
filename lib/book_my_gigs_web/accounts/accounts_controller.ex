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

  def create(conn, params) do
    account =
      params
      |> Accounts.create_account()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, account)
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
    ok: "Accounts successfully updated"
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
end
