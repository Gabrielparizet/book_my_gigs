defmodule BookMyGigsWeb.AccountsController do
  @moduledoc """
  The Accounts Controller
  """
  use BookMyGigsWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias BookMyGigs.Accounts
  alias BookMyGigsWeb.Accounts.Schemas

  operation(:create,
    summary: "Create account input",
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
