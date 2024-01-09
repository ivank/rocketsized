defmodule RocketsizedWeb.FilterParams do
  alias Rocketsized.Rocket.SearchSlug.Type
  alias Rocketsized.Rocket.SearchSlug

  def add(%Flop{} = flop, %SearchSlug{} = search_slug) do
    Map.update!(flop, :filters, fn filters ->
      search = Flop.Filter.get_value(filters, :search) || []
      Flop.Filter.put_value(filters, :search, [Type.dump!(search_slug) | search])
    end)
  end

  def remove(%Flop{} = flop, %SearchSlug{} = search_slug) do
    Map.update!(flop, :filters, fn filters ->
      search = Flop.Filter.get_value(filters, :search) || []
      Flop.Filter.put_value(filters, :search, List.delete(search, Type.dump!(search_slug)))
    end)
  end

  def dump_params(params) do
    {search, params} =
      Keyword.get_and_update(params, :filters, &Flop.Filter.pop_value(&1, :search))

    (params ++
       (search
        |> Enum.map(&Type.load!(&1))
        |> Enum.group_by(& &1.type, & &1.slug)
        |> Map.to_list()))
    |> Enum.sort_by(fn {group, _slugs} -> group end)
  end

  def load_params(params) do
    countries = Map.get(params, "country", []) |> Enum.map(&%SearchSlug{type: :country, slug: &1})
    rockets = Map.get(params, "rocket", []) |> Enum.map(&%SearchSlug{type: :rocket, slug: &1})
    orgs = Map.get(params, "org", []) |> Enum.map(&%SearchSlug{type: :org, slug: &1})
    value = (countries ++ rockets ++ orgs) |> Enum.map(&Type.dump!(&1))

    Map.put(params, "filters", [%{"field" => "search", "op" => "in", "value" => value}])
  end
end
