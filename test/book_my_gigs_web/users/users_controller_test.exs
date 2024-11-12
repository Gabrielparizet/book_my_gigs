defmodule BookMyGigsWeb.Users.UsersControllerTest do
  use BookMyGigsWeb.ConnCase, async: true
  doctest BookMyGigsWeb

  alias OpenApiSpex.TestAssertions
  alias BookMyGigs.Accounts
  alias BookMyGigs.Users
  alias BookMyGigs.Repo
  alias BookMyGigsWeb.ApiSpec

  def authenticate_user(conn, account) do
    {:ok, token, _claims} = BookMyGigs.Guardian.encode_and_sign(account)

    put_req_header(conn, "authorization", "Bearer #{token}")
  end

  def create_account() do
    %Accounts.Storage.Account{
      email: "test@gmail.com",
      password: "ThisIsMyPassword123"
    }
    |> Repo.insert!()
  end

  describe "POST /api/users/:user_id/events" do
    test "successfully creates a user with valid params and account", %{conn: conn} do
      api_spec = ApiSpec.spec()

      account = create_account()

      user_payload = %{
        "user" => %{
          "username" => "johndo2000",
          "first_name" => "John",
          "last_name" => "Doe",
          "birthday" => "01/01/2000"
        }
      }

      TestAssertions.assert_schema(user_payload, "Create user input", api_spec)

      conn_out =
        conn
        |> authenticate_user(account)
        |> put_req_header("content-type", "application/json")
        |> post("/api/users", user_payload)

      json_data = json_response(conn_out, 200)

      {:ok, user} = Users.get_user_by_account_id(account.id)

      assert json_data == %{
               "id" => user.id,
               "location" => nil,
               "username" => "johndo2000",
               "account_id" => account.id,
               "genres" => [],
               "first_name" => "John",
               "last_name" => "Doe",
               "birthday" => "2000-01-01"
             }

      TestAssertions.assert_schema(user_payload, "User response", api_spec)
    end

    test "fails to create a user when a username is already taken", %{conn: conn} do
      account_1 =
        %Accounts.Storage.Account{
          email: "test@gmail.com",
          password: "ThisIsMyPassword123"
        }
        |> Repo.insert!()

      _user_1 =
        %Users.Storage.User{
          account_id: account_1.id,
          username: "johndo2000",
          first_name: "John",
          last_name: "Doe",
          birthday: ~D[1969-08-26]
        }
        |> Repo.insert!()

      account_2 =
        %Accounts.Storage.Account{
          email: "test2@gmail.com",
          password: "ThisIsMyPassword123"
        }
        |> Repo.insert!()

      user2_payload = %{
        "user" => %{
          "username" => "johndo2000",
          "first_name" => "John",
          "last_name" => "Doe",
          "birthday" => "01/01/2000"
        }
      }

      conn_out =
        conn
        |> authenticate_user(account_2)
        |> put_req_header("content-type", "application/json")
        |> post("/api/users", user2_payload)

      json_data = json_response(conn_out, 422)

      assert json_data == %{"error" => %{"username" => ["has already been taken"]}}
    end

    test "fails when trying to create a second user for the same account", %{conn: conn} do
      account = create_account()

      _user_1 =
        %Users.Storage.User{
          account_id: account.id,
          username: "johndo2000",
          first_name: "John",
          last_name: "Doe",
          birthday: ~D[1969-08-26]
        }
        |> Repo.insert!()

      user_2_payload = %{
        "user" => %{
          "username" => "petetheman",
          "first_name" => "Pete",
          "last_name" => "Sampras",
          "birthday" => "12/08/1972"
        }
      }

      conn_out =
        conn
        |> authenticate_user(account)
        |> put_req_header("content-type", "application/json")
        |> post("/api/users", user_2_payload)

      json_data = json_response(conn_out, 422)

      assert json_data == %{"error" => %{"account_id" => ["has already been taken"]}}
    end

    test "fails when user is unauthenticated", %{conn: conn} do
      user_payload = %{
        "user" => %{
          "username" => "petetheman",
          "first_name" => "Pete",
          "last_name" => "Sampras",
          "birthday" => "12/08/1972"
        }
      }

      conn_out =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/users", user_payload)

      assert conn_out.status == 401
      assert conn_out.resp_body == "{\"message\":\"unauthenticated\"}"
    end
  end
end
