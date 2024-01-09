defmodule Rocketsized.Rocket.SearchSlug.Type do
  @behaviour Ecto.Type
  import Ecto.Query
  alias Rocketsized.Rocket.SearchSlug

  def type, do: :string

  def cast(value) do
    {:ok, value}
  end

  def load("o_" <> slug), do: {:ok, %SearchSlug{type: :org, slug: slug}}
  def load("c_" <> slug), do: {:ok, %SearchSlug{type: :country, slug: slug}}
  def load("r_" <> slug), do: {:ok, %SearchSlug{type: :rocket, slug: slug}}
  def load(_value), do: :error

  def load!(value) do
    {:ok, load} = load(value)
    load
  end

  def dump(%{type: :org, slug: slug}), do: {:ok, "o_#{slug}"}
  def dump(%{type: :country, slug: slug}), do: {:ok, "c_#{slug}"}
  def dump(%{type: :rocket, slug: slug}), do: {:ok, "r_#{slug}"}
  def dump(_), do: :error

  def dump!(value) do
    {:ok, dump} = dump(value)
    dump
  end

  def equal?(a, b) do
    a == b
  end

  def embed_as(_format), do: :self

  def apply(query, %Flop.Filter{value: value, op: _op}, _opts) when length(value) > 0 do
    groups =
      value
      |> Enum.map(&load!(&1))
      |> Enum.group_by(& &1.type, & &1.slug)
      |> Enum.map(fn
        {:rocket, slugs} -> dynamic([v], v.slug in ^slugs)
        {:country, slugs} -> dynamic([country: c], c.code in ^slugs)
        {:org, slugs} -> dynamic([manufacturers: m], m.slug in ^slugs)
      end)
      |> Enum.reduce(&dynamic([_], ^&1 or ^&2))

    where(query, [_], ^groups)
  end

  def apply(query, _flop, _opts) do
    query
  end
end
