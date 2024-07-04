defmodule BookMyGigs.Users.Storage do
  @moduledoc """
  Module providing functionalities to interact with the users table.
  """

  alias BookMyGigs.Users
  alias BookMyGigs.Users.Storage
  alias BookMyGigs.Repo

  def create_user(attrs \\ %{}) do
    %Storage.User{}
    |> Storage.User.changeset(attrs)
    |> Repo.insert!()
    |> Users.to_context_struct()
  end
end
