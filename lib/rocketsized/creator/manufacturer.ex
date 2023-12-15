defmodule Rocketsized.Creator.Manufacturer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "manufacturers" do
    field :name, :string
    field :logo, :string
    field :source, :string

    has_many :vehicle_manufacturers, Rocketsized.Rocket.VehicleManufacturer
    has_many :vehicles, through: [:vehicle_manufacturers, :vehicle]

    timestamps()
  end

  @doc false
  def changeset(manufacturer, attrs) do
    manufacturer
    |> cast(attrs, [:name, :flag, :source])
    |> validate_required([:name])
  end
end
