defmodule BookMyGigsWeb.Accounts.AccountsControllerTest do
  use BookMyGigsWeb.ConnCase, async: true
  doctest BookMyGigsWeb

  alias BookMyGigsWeb.ApiSpec
  alias BookMyGigs.Repo
  alias BookMyGigs.Accounts.Storage
  alias OpenApiSpex.TestAssertions

  test "Get all accounts", %{conn: conn} do
    api_spec = ApiSpec.spec()

    %Storage.Account{
      email: "test@gmail.com",
      hash_password: "ThisIsMyPassword123"
    }
    |> Repo.insert!()

    conn_out = get(conn, "/api/accounts")

    json_data =
      json_response(conn_out, 200)

    assert json_data == [
             %{
               "email" => "test@gmail.com",
               "hash_password" => "ThisIsMyPassword123"
             }
           ]

    TestAssertions.assert_schema(json_data, "Get accounts response", api_spec)
  end

  test "Create an account", %{conn: conn} do
    api_spec = ApiSpec.spec()

    account_payload = %{
      "account" => %{
        "email" => "test@email.com",
        "hash_password" => "ThisIsMyPassword123?"
      }
    }

    TestAssertions.assert_schema(account_payload, "Create account params", api_spec)

    conn_out =
      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/accounts", account_payload)

    json_data = json_response(conn_out, 201)

    assert json_data == %{
             "email" => "test@email.com",
             "hash_password" => "ThisIsMyPassword123?"
           }

    TestAssertions.assert_schema(json_data, "Create account response", api_spec)
  end
end
