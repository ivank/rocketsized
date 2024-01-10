defmodule RocketsizedWeb.FilterParams do
  @moduledoc """
  This module handles simplifying the params used by `Flop`.
  Since `Flop` produces the equivalent of
  ```elixir
  %{"filters", [%{"field" => "search", "op" => "in", "value" => ["r_1", "r2"]}])}
  ```
  we want to compress it so its a bit more user friendly when used in filtering or render endpoints
  """
  alias Rocketsized.Rocket.SearchSlug.Type
  alias Rocketsized.Rocket.SearchSlug

  @doc """
  Modify a flop by adding a slug item to its search filter.
  This is used to modify the flop on the fly to construct addition links
  """
  def add(%Flop{} = flop, %SearchSlug{} = search_slug) do
    Map.update!(flop, :filters, fn filters ->
      search = Flop.Filter.get_value(filters, :search) || []
      Flop.Filter.put_value(filters, :search, [Type.dump!(search_slug) | search])
    end)
  end

  @doc """
  Modify a flop by adding a slug item to its search filter.
  This is used to modify the flop on the fly to construct removal links
  """
  def remove(%Flop{} = flop, %SearchSlug{} = search_slug) do
    Map.update!(flop, :filters, fn filters ->
      search = Flop.Filter.get_value(filters, :search) || []
      Flop.Filter.put_value(filters, :search, List.delete(search, Type.dump!(search_slug)))
    end)
  end

  @doc """
  Convert the :search `Flop.Filter` into a user friendly form, simplifying the information as much as possible for the url
  """
  def dump_params(params) do
    {filters, params} = Keyword.pop(params, :filters, [])
    {search, _other_filters} = Flop.Filter.pop_value(filters, :search)

    (params ++
       (search
        |> Enum.map(&Type.load!(&1))
        |> Enum.group_by(& &1.type, & &1.slug)
        |> Map.to_list()))
    |> Enum.sort_by(fn {group, _slugs} -> group end)
  end

  @doc """
  Convert the simplified version from `dump_params` into the standard `Flop` filters
  """
  def load_params(params) do
    countries = Map.get(params, "country", []) |> Enum.map(&%SearchSlug{type: :country, slug: &1})
    rockets = Map.get(params, "rocket", []) |> Enum.map(&%SearchSlug{type: :rocket, slug: &1})
    orgs = Map.get(params, "org", []) |> Enum.map(&%SearchSlug{type: :org, slug: &1})
    value = (countries ++ rockets ++ orgs) |> Enum.map(&Type.dump!(&1))

    Map.put(params, "filters", [%{"field" => "search", "op" => "in", "value" => value}])
  end
end
