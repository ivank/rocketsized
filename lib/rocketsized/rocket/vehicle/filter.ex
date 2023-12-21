defmodule Rocketsized.Rocket.Vehicle.Filter do
  import Ecto.Query

  def search(query, %Flop.Filter{value: value, op: _op}, _opts) do
    groups =
      value
      |> Enum.map(&Rocketsized.Ecto.Token.Type.load(&1))
      |> Rocketsized.Ecto.Token.Item.to_valid_list()
      |> Rocketsized.Ecto.Token.Item.to_group_ids()
      |> Enum.with_index()

    Enum.reduce(groups, query, fn
      {{:vehicle, ids}, index}, acc ->
        if(index == 0,
          do: where(acc, [v], v.id in ^ids),
          else: or_where(acc, [v], v.id in ^ids)
        )

      {{:country, ids}, index}, acc ->
        if(index == 0,
          do: where(acc, [v], v.country_id in ^ids),
          else: or_where(acc, [v], v.country_id in ^ids)
        )

      {{:manufacturer, ids}, index}, acc ->
        if(index == 0,
          do: where(acc, [vehicle_manufacturers: vm], vm.manufacturer_id in ^ids),
          else: or_where(acc, [vehicle_manufacturers: vm], vm.manufacturer_id in ^ids)
        )
    end)
  end
end
