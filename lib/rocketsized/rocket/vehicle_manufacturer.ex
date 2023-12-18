defmodule Rocketsized.Rocket.VehicleManufacturer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_manufacturers" do
    field :source, :string

    belongs_to :manufacturer, Rocketsized.Creator.Manufacturer
    belongs_to :vehicle, Rocketsized.Rocket.Vehicle

    timestamps()
  end

  @doc false
  def changeset(stage, attrs) do
    stage
    |> cast(attrs, [:source])
    |> unique_constraint([:vehicle_id, :manufacturer_id],
      name: "vehicle_manufacturers_vehicle_id_manufacturer_id_index"
    )
    |> validate_required([:vehicle_id, :manufacturer_id])
  end
end
