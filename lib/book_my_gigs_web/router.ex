defmodule BookMyGigsWeb.Router do
  use BookMyGigsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BookMyGigsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.Plug.Pipeline,
      otp_app: :book_my_gigs,
      module: BookMyGigs.Guardian,
      error_handler: BookMyGigs.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  scope "/", BookMyGigsWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", BookMyGigsWeb do
    pipe_through [:api]

    # CREATE ACCOUNT
    post "/accounts", AccountsController, :create

    # SIGN IN TO SESSION
    post "/accounts/sign_in", AccountsController, :sign_in

    # SIGN OUT OF SESSION
    post "/accounts/sign_out", AccountsController, :sign_out

    # LOCATIONS PUBLIC ROUTES
    get "/locations", LocationsController, :get_locations_names

    # GENRES PUBLIC ROUTES
    get "/genres", GenresController, :get_genres_names

    # TYPES PUBLIC ROUTES
    get "/types", TypesController, :get_types_names

    # EVENTS PUBLIC ROUTES
    get "/events", EventsController, :get_public_events
    get "/events/:id", EventsController, :get_public_event_by_id
  end

  scope "/api", BookMyGigsWeb do
    pipe_through [:api, :auth]

    # ACCOUNTS ROUTES
    get "/accounts", AccountsController, :get
    get "/accounts/:id", AccountsController, :get_account_by_id
    put "/accounts/:id", AccountsController, :update
    delete "/accounts/:id", AccountsController, :delete

    # USERS ROUTES
    get "/accounts/:id/users", UsersController, :get_user_by_account_id
    get "/users", UsersController, :get
    get "/users/:id", UsersController, :get_user_by_id
    post "/users", UsersController, :create
    put "/users/:id", UsersController, :update
    delete "/users/:id", UsersController, :delete

    # USERS LOCATIONS ROUTES
    put "/users/:id/locations", UsersController, :update_user_location

    # USERS GENRES ROUTES
    put "/users/:id/genres", UsersController, :update_user_genres
    delete "/users/:id/genres", UsersController, :delete_user_genres

    # USERS EVENTS ROUTES
    get "/users/:id/events", EventsController, :get_events_by_user
    get "/users/:user_id/events/:event_id", EventsController, :get_user_event_by_id
    post "/users/:id/events", EventsController, :create
    put "/users/:user_id/events/:event_id", EventsController, :update_event
    delete "/users/:user_id/events/:event_id", EventsController, :delete_event

    # EVENTS ROUTES
    get "/events/location/:name", EventsController, :get_events_by_location
    get "/events", EventsController, :get_public_events
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookMyGigsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:book_my_gigs, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BookMyGigsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
