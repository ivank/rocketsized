defmodule Rocketsized.Rocket.Vehicle.Filter do
  import Ecto.Query

  def search(query, %Flop.Filter{value: value, op: _op}, _opts) do
    groups =
      value
      |> Enum.map(&Rocketsized.Ecto.Token.Type.load(&1))
      |> Rocketsized.Ecto.Token.Item.to_valid_list()
      |> Rocketsized.Ecto.Token.Item.to_group_ids()
      |> Enum.map(fn
        {:vehicle, ids} -> dynamic([v], v.id in ^ids)
        {:country, ids} -> dynamic([v], v.country_id in ^ids)
        {:manufacturer, ids} -> dynamic([vehicle_manufacturers: vm], vm.manufacturer_id in ^ids)
      end)
      |> Enum.reduce(&dynamic([_], ^&1 or ^&2))

    where(query, [_], ^groups)
  end
end
