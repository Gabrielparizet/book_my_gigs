defmodule BookMyGigsWeb.Accounts.AccountsControllerTest do
  use BookMyGigsWeb.ConnCase, async: true
  doctest BookMyGigsWeb

  import Ecto.Query

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

    TestAssertions.assert_schema(account_payload, "Create account input", api_spec)

    conn_out =
      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/accounts", account_payload)

    json_data = json_response(conn_out, 201)

    assert json_data == %{
             "email" => "test@email.com",
             "hash_password" => "ThisIsMyPassword123?"
           }

    TestAssertions.assert_schema(json_data, "Account response", api_spec)
  end

  test "Update an account", %{conn: conn} do
    api_spec = ApiSpec.spec()

    %Storage.Account{
      email: "test@gmail.com",
      hash_password: "ThisIsMyPassword123?"
    }
    |> Repo.insert!()

    query =
      from(
        a in Storage.Account,
        where: a.email == "test@gmail.com",
        select: a.id
      )

    account_id = Repo.one(query)

    account_payload = %{
      "account" => %{
        "email" => "modified_email@gmail.com",
        "hash_password" => "MyModifiedPassword123?"
      }
    }

    conn_out =
      conn
      |> put_req_header("content-type", "application/json")
      |> put("/api/accounts/#{account_id}", account_payload)

    json_data = json_response(conn_out, 200)

    assert json_data == %{
             "email" => "modified_email@gmail.com",
             "hash_password" => "MyModifiedPassword123?"
           }

    TestAssertions.assert_schema(json_data, "Account response", api_spec)
  end

end
