defmodule BookMyGigs.Repo do
  use Ecto.Repo,
    otp_app: :book_my_gigs,
    adapter: Ecto.Adapters.Postgres
end
