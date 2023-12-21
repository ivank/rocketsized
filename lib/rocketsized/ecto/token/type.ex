defmodule Rocketsized.Ecto.Token.Type do
  alias Rocketsized.Ecto.Token.Item

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    {:ok, value}
  end

  def load(value) do
    with [item_type_string, id_string] <- value |> String.split("|"),
         {:ok, item_type} <- Item.to_item_type(item_type_string),
         {id, _remaining} <- Integer.parse(id_string) do
      {:ok, %Item{type: item_type, id: id}}
    end
  end

  def dump(value) when is_struct(value, Item) do
    {:ok, "#{value.type}|#{value.id}"}
  end

  def dump(_), do: :error

  def equal?(a, b) do
    a == b
  end

  def embed_as(_format), do: :self
end
