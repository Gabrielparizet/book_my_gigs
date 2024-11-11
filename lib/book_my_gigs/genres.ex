defmodule BookMyGigs.Genres do
  @moduledoc """
  The genres context
  """

  alias BookMyGigs.Genres.Storage

  defmodule Genre do
    @moduledoc """
    Module defining the context struct for a genre
    """

    @derive Jason.Encoder

    defstruct [:id, :name]

    @type id :: String.t()
    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t()
          }
  end

  def get_genres() do
    case Storage.get_genres() do
      {:ok, genres} ->
        {:ok, Enum.map(genres, &to_context_struct/1)}

      {:error, msg} ->
        {:error, msg}
    end
  end

  def get_genre_by_name(genre_name) do
    genre_name
    |> Storage.get_genre_by_name()
    |> to_context_struct()
  end

  defp to_context_struct(%Storage.Genre{} = index_db) do
    struct(Genre, Map.from_struct(index_db))
  end
end
