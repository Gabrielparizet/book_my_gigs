defmodule BookMyGigs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BookMyGigsWeb.Telemetry,
      BookMyGigs.Repo,
      {DNSCluster, query: Application.get_env(:book_my_gigs, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BookMyGigs.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BookMyGigs.Finch},
      # Start a worker by calling: BookMyGigs.Worker.start_link(arg)
      # {BookMyGigs.Worker, arg},
      # Start to serve requests, typically the last entry
      BookMyGigsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BookMyGigs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BookMyGigsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
