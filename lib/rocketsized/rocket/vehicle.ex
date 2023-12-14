defmodule Rocketsized.Rocket.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  @states [:planned, :in_development, :operational, :retired, :canceled]

  schema "vehicles" do
    field :name, :string
    field :source, :string
    field :height, :float

    field :state, Ecto.Enum, values: @states

    belongs_to :family, Rocketsized.Rocket.Family
    belongs_to :country, Rocketsized.Creator.Country

    has_many :vehicle_manufacturers, Rocketsized.Rocket.VehicleManufacturer
    has_many :manufacturers, through: [:vehicle_manufacturers, :manufacturer]

    timestamps()
  end

  def states() do
    @states
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:name, :source, :height, :state])
    |> validate_required([:name])
  end
end
