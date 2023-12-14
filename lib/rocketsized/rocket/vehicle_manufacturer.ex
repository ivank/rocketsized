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
    |> validate_required([:propellant])
  end
end
