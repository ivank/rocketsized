defmodule Rocketsized.Rocket.VehicleFilter.Type do
  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    {:ok, value}
  end

  def load(value) do
    with [item_type_string, id_string] <- value |> String.split("_"),
         {:ok, item_type} <- to_type(item_type_string),
         {id, _remaining} <- Integer.parse(id_string) do
      {:ok, %Rocketsized.Rocket.VehicleFilter{type: item_type, id: id}}
    end
  end

  def dump(value) when is_struct(value, Rocketsized.Rocket.VehicleFilter) do
    {:ok, "#{value.type}_#{value.id}"}
  end

  def dump(_), do: :error

  def equal?(a, b) do
    a == b
  end

  def embed_as(_format), do: :self

  def to_type("vehicle"), do: {:ok, :vehicle}
  def to_type("country"), do: {:ok, :country}
  def to_type("manufacturer"), do: {:ok, :manufacturer}
  def to_type(_type), do: :error

  def to_valid_list(items) do
    Enum.flat_map(items, fn
      {:ok, filter} -> [filter]
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
