defmodule Rocketsized.Datasource.UpsertPipeline do
  @behaviour Crawly.Pipeline
  alias Rocketsized.Datasource.WikipediaVehicle
  alias Rocketsized.Repo
  alias Rocketsized.Creator.Country
  alias Rocketsized.Creator.Manufacturer
  alias Rocketsized.Rocket.Vehicle
  alias Rocketsized.Rocket.VehicleManufacturer

  require Logger

  @spec run(WikipediaVehicle.t(), map(), list(any())) :: any()
  @impl Crawly.Pipeline
  def run(item, state, _ \\ []) do
    Logger.info("Item #{inspect(item)}")

    country =
      Repo.insert!(%Country{name: item.country, source: item.source},
        on_conflict: {:replace_all_except, [:id]},
        conflict_target: [:name]
      )

    vehicle =
      Repo.insert!(
        %Vehicle{
          name: item.title,
          state: item.status,
          height: item.height,
          country: country,
          source: item.source
        },
        on_conflict: {:replace_all_except, [:id]},
        conflict_target: [:name, :country_id]
      )

    {_modified, manufacturers} =
      Repo.insert_all(
        Manufacturer,
        item.manufacturers
        |> Enum.map(fn name ->
          %{
            name: name,
            source: item.source,
            inserted_at: vehicle.inserted_at,
            updated_at: vehicle.updated_at
          }
        end),
        on_conflict: {:replace_all_except, [:id]},
        conflict_target: [:name],
        returning: true
      )

    Logger.info("Inserted manufacturers #{inspect(manufacturers)}")

    Repo.insert_all(
      VehicleManufacturer,
      manufacturers
      |> Enum.map(fn %{id: id} ->
        %{
          manufacturer_id: id,
          vehicle_id: vehicle.id,
          source: item.source,
          inserted_at: vehicle.inserted_at,
          updated_at: vehicle.updated_at
        }
      end),
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: [:vehicle_id, :manufacturer_id]
    )

    {item, state}
  end
end
