defmodule BookMyGigs.Genres.Storage do
  @moduledoc """
  Module providing functionalities to interact with the genres table.
  """

  alias BookMyGigs.Genres.Storage
  alias BookMyGigs.Repo

  def get_genre_by_name(genre_name) do
    Repo.get_by(Storage.Genre, name: genre_name)
  end
end
