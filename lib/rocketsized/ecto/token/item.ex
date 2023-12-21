defmodule Rocketsized.Ecto.Token.Item do
  defstruct type: :vehicle, id: 1

  @type item_type() :: :vehicle | :country | :manufacturer

  @type t() :: %__MODULE__{:id => Integer.t(), :type => item_type()}

  @spec to_item_type(any()) :: :error | {:ok, item_type()}
  def to_item_type("vehicle"), do: {:ok, :vehicle}
  def to_item_type("country"), do: {:ok, :country}
  def to_item_type("manufacturer"), do: {:ok, :manufacturer}
  def to_item_type(_type), do: :error

  def to_valid_list(items) do
    Enum.flat_map(items, fn
      {:ok, token_id} -> [token_id]
      {:error} -> []
    end)
  end

  def to_group_ids(items) do
    Enum.group_by(
      items,
      fn %{type: type} -> type end,
      fn %{id: id} -> id end
    )
  end
end
