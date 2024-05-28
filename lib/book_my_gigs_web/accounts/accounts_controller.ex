defmodule BookMyGigsWeb.AccountsController do
  @moduledoc """
  The Accounts Controller
  """
  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Accounts
  alias BookMyGigsWeb.Accounts.Schemas

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
    request_body: {"Create account input", "application/json", Schemas.CreateAccountParams},
    responses: [
      ok: {"Create account response", "application/json", Schemas.CreateAccountResponse},
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
end
