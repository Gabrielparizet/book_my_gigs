defmodule BookMyGigsWeb.Events.EventsControllerTest do
  use BookMyGigsWeb.ConnCase, async: true
  doctest BookMyGigsWeb

  alias OpenApiSpex.TestAssertions
  alias BookMyGigs.Accounts
  alias BookMyGigs.Events
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
               "genres" => json_data["genres"],
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
            "genres" => ["Electronic", "Techno"]
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

  describe "GET /api/events/location/:name" do
    test "successfully fetches events for a location", %{conn: conn} do
      api_spec = ApiSpec.spec()
      account = create_account()
      user = create_user(account.id)

      events_params = [
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
        },
        %{
          "event" => %{
            "date_and_time" => %{
              "date" => "24/12/2024",
              "time" => "12:00"
            },
            "venue" => "Other event",
            "title" => "Other title",
            "description" =>
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            "address" => "Other address",
            "url" => "https://www.otherevents.com",
            "location" => "Paris",
            "type" => "Concert",
            "genres" => ["Techno"]
          }
        }
      ]

      Enum.map(events_params, &Events.create_event(&1, user.id))

      conn_out =
        conn
        |> authenticate_user(account)
        |> put_req_header("content-type", "application/json")
        |> get("/api/events/location/Paris")

      json_data =
        conn_out
        |> json_response(200)

      [event_1 | event_2] = json_data
      event_2 = List.first(event_2)

      assert json_data == [
               %{
                 "address" => "3bis Rue Papin, 75003 Paris",
                 "date_and_time" => "2024-11-30T00:00:00Z",
                 "description" =>
                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                 "genres" => ["Electronic", "Techno"],
                 "id" => Map.get(event_1, "id"),
                 "location" => "Paris",
                 "title" => "Minor Science: Live at La Gaité Lyrique",
                 "type" => "Club",
                 "url" => "https://www.gaite-lyrique.net/evenement/theodora",
                 "user" => "MyUsername",
                 "user_id" => user.id,
                 "venue" => "La Gaité Lyrique"
               },
               %{
                 "address" => "Other address",
                 "date_and_time" => "2024-12-24T12:00:00Z",
                 "description" =>
                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                 "genres" => ["Techno"],
                 "id" => Map.get(event_2, "id"),
                 "location" => "Paris",
                 "title" => "Other title",
                 "type" => "Concert",
                 "url" => "https://www.otherevents.com",
                 "user" => "MyUsername",
                 "user_id" => user.id,
                 "venue" => "Other event"
               }
             ]

      TestAssertions.assert_schema(json_data, "Events response", api_spec)
    end
  end
end
