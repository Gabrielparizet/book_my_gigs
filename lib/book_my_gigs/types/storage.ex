defmodule BookMyGigs.Types.Storage do
  @moduledoc """
  Module providing functionalities to interact with the types table.
  """

  alias BookMyGigs.Types.Storage
  alias BookMyGigs.Repo

  def get_types() do
    case Repo.all(Storage.Type) do
      [] -> {:error, "Failed to fetch types"}
      types -> {:ok, types}
    end
  end

  def get_type_by_name(type_name) do
    Repo.get_by(Storage.Type, name: type_name)
  end
end
