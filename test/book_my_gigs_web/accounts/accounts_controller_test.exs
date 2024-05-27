defmodule BookMyGigsWeb.Accounts.AccountsControllerTest do
  use BookMyGigsWeb.ConnCase, async: true
  doctest BookMyGigsWeb

  alias BookMyGigsWeb.ApiSpec
  alias OpenApiSpex.TestAssertions

  test "Create an account", %{conn: conn} do
    api_spec = ApiSpec.spec()

    account_payload = %{
      "account" => %{
        "email" => "test@email.com",
        "hash_password" => "ThisIsMyPassword123",
      }
    }

    TestAssertions.assert_schema(account_payload, "Create account params", api_spec)

    conn_out =
      conn
      |> put_req_header("content-type", "application/json")
      |> post("/accounts/register", account_payload)

    json_data = json_response(conn_out, 201)
    assert json_data == %{
      "email" => "test@email.com",
      "hash_password" => "ThisIsMyPassword123",
    }

    TestAssertions.assert_schema(json_data, "Create account response", api_spec)
  end

end
