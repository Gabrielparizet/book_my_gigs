defmodule BookMyGigsWeb.Events.EventsControllerTest do
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

  def create_user(account_id) do
    %Users.Storage.User{
      account_id: account_id,
      username: "MyUsername",
      first_name: "John",
      last_name: "Doe",
      birthday: ~D[1969-08-26]
    }
    |> Repo.insert!()
  end

  describe "POST /api/users/:user_id/events" do
    test "successfully creates an event with valid params", %{conn: conn} do
      api_spec = ApiSpec.spec()

      account = create_account()
      user = create_user(account.id)

      event_payload =
        %{
          "event" => %{
            "date_and_time" => %{
              "date" => "30/11/2024",
              "time" => "00:00"
            },
            "venue" => "La Gaité Lyrique",
            "title" => "Minor Science: Live at La Gaité Lyrique",
            "description" =>
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            "address" => "3bis Rue Papin, 75003 Paris",
            "url" => "https://www.gaite-lyrique.net/evenement/theodora",
            "location" => "Paris",
            "type" => "Club",
            "genres" => ["Techno", "Electronic"]
          }
        }

      TestAssertions.assert_schema(event_payload, "Create event input", api_spec)

      conn_out =
        conn
        |> authenticate_user(account)
        |> put_req_header("content-type", "application/json")
        |> post("/api/users/#{user.id}/events", event_payload)

      json_data = json_response(conn_out, 200)

      assert json_data == %{
               "address" => "3bis Rue Papin, 75003 Paris",
               "date_and_time" => "2024-11-30T00:00:00Z",
               "description" =>
                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
               "genres" => ["Techno", "Electronic"],
               "id" => json_data["id"],
               "location" => "Paris",
               "title" => "Minor Science: Live at La Gaité Lyrique",
               "type" => "Club",
               "url" => "https://www.gaite-lyrique.net/evenement/theodora",
               "user" => "MyUsername",
               "user_id" => user.id,
               "venue" => "La Gaité Lyrique"
             }

      TestAssertions.assert_schema(json_data, "Event response", api_spec)
    end

    test "fails to create an event with invalid valid params", %{conn: conn} do
      account = create_account()
      user = create_user(account.id)

      event_payload =
        %{
          "event" => %{
            "date_and_time" => %{
              "date" => "30/11/2024",
              "time" => "00:00"
            },
            "title" => nil,
            "location" => "Paris",
            "description" =>
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            "address" => "3bis Rue Papin, 75003 Paris",
            "url" => "https://www.gaite-lyrique.net/evenement/theodora",
            "type" => "Club",
            "genres" => ["Techno", "Electronic"]
          }
        }

      conn_out =
        conn
        |> authenticate_user(account)
        |> put_req_header("content-type", "application/json")
        |> post("/api/users/#{user.id}/events", event_payload)

      json_data = json_response(conn_out, 422)

      assert json_data == %{
               "error" => %{"title" => ["can't be blank"], "venue" => ["can't be blank"]}
             }
    end
  end
end