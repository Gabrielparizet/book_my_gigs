defmodule BookMyGigs.Genres.Storage do
  @moduledoc """
  Module providing functionalities to interact with the genres table.
  """

  alias BookMyGigs.Genres.Storage
  alias BookMyGigs.Repo

  def get_genres() do
    case Repo.all(Storage.Genre) do
      [] -> {:error, "Failed to fetch genres"}
      genres -> {:ok, genres}
    end
  end

  def get_genre_by_name(genre_name) do
    Repo.get_by(Storage.Genre, name: genre_name)
  end
end
