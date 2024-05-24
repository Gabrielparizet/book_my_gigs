defmodule BookMyGigsWeb.Accounts.AccountsController do
  @moduledoc """
  The Accounts Controller
  """

  alias BookMyGigsWeb.Accounts.Storage

  use BookMyGigsWeb, :controller

  def create(conn, %{"account" => account_params}) do
    with  {:ok, %Storage.Account{} = account} <- Accounts.create_account(account_params),
          {:ok, token, _full_claims} <- Guardian.encode_and_sign(account) do

      conn
      |> put_status(:created)
      |> send_resp(200, "Account successfully created")
    end
  end
end
