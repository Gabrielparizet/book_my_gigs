defmodule BookMyGigs.Types do
  @moduledoc """
  The Types context
  """

  alias BookMyGigs.Types.Storage

  defmodule Type do
    @moduledoc """
    Module defining the context struct for a type.
    """

    @derive Jason.Encoder

    defstruct [:id, :name]

    @type id :: String.t()
    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t()
          }
  end

  def get_types_names() do
    case Storage.get_types() do
      {:ok, types} ->
        {:ok,
         types
         |> Enum.map(&to_context_struct/1)
         |> Enum.map(& &1.name)}

      {:error, msg} ->
        {:error, msg}
    end
  end

  def get_type_by_name(name) do
    name
    |> Storage.get_type_by_name()
    |> to_context_struct()
  end

  defp to_context_struct(%Storage.Type{} = index_db) do
    struct(Type, Map.from_struct(index_db))
  end
end
